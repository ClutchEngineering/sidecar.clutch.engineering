import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public enum PostHogError: Error {
  case invalidURL
  case networkError(Error)
  case invalidResponse
  case exportNotReady
  case exportFailed(String)
}

public struct PostHogExportResponse: Codable {
  public let id: Int
  public let hasContent: Bool

  enum CodingKeys: String, CodingKey {
    case id
    case hasContent = "has_content"
  }
}

// Stops URLSession from auto-following redirects so we can handle them manually.
// On Linux (FoundationNetworking), redirects forward all headers including Authorization,
// which causes S3 presigned URLs to reject the request (InvalidArgument).
private final class StopRedirectDelegate: NSObject, URLSessionTaskDelegate {
  func urlSession(
    _ session: URLSession,
    task: URLSessionTask,
    willPerformHTTPRedirection response: HTTPURLResponse,
    newRequest request: URLRequest,
    completionHandler: @escaping (URLRequest?) -> Void
  ) {
    completionHandler(nil)
  }
}

public actor PostHogExportClient {
  private let baseURL: String
  private let apiKey: String
  private let session: URLSession
  private let downloadSession: URLSession

  public init(apiKey: String, projectID: Int) {
    self.baseURL = "https://eu.posthog.com/api/environments/\(projectID)"
    self.apiKey = apiKey

    let config = URLSessionConfiguration.default
    config.timeoutIntervalForRequest = 300
    config.timeoutIntervalForResource = 600
    self.session = URLSession(configuration: config)

    // Separate session for the initial download request only.
    // Stops auto-redirects so we can follow the S3 redirect manually without auth headers.
    let downloadConfig = URLSessionConfiguration.default
    downloadConfig.timeoutIntervalForRequest = 300
    downloadConfig.timeoutIntervalForResource = 600
    self.downloadSession = URLSession(
      configuration: downloadConfig,
      delegate: StopRedirectDelegate(),
      delegateQueue: nil
    )
  }

  public func fetchExportedCSV(query: String) async throws -> Data {
    let exportId = try await createExport(query: query)
    try await waitForExport(id: exportId)
    return try await downloadCSV(id: exportId)
  }

  private func createExport(query: String) async throws -> Int {
    guard let url = URL(string: "\(baseURL)/exports/") else {
      throw PostHogError.invalidURL
    }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
    request.httpBody = query.data(using: .utf8)

    let (data, _) = try await session.data(for: request)
    let response = try JSONDecoder().decode(PostHogExportResponse.self, from: data)
    return response.id
  }

  private func waitForExport(id: Int) async throws {
    guard let url = URL(string: "\(baseURL)/exports/\(id)/") else {
      throw PostHogError.invalidURL
    }

    var request = URLRequest(url: url)
    request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")

    for _ in 0..<30 {
      let (data, _) = try await session.data(for: request)
      let response = try JSONDecoder().decode(PostHogExportResponse.self, from: data)

      if response.hasContent {
        return
      }

      try await Task.sleep(nanoseconds: 2_000_000_000)
    }

    throw PostHogError.exportNotReady
  }

  private func downloadCSV(id: Int) async throws -> Data {
    guard let url = URL(string: "\(baseURL)/exports/\(id)/content?download=true") else {
      throw PostHogError.invalidURL
    }

    var request = URLRequest(url: url)
    request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")

    // Use the no-redirect session so we can handle the S3 redirect ourselves.
    var (data, response) = try await downloadSession.data(for: request)

    // PostHog redirects to an S3 presigned URL. Follow it manually without the
    // Authorization header — S3 presigned URLs reject requests that carry both
    // query-string auth (X-Amz-Algorithm) and an Authorization header.
    if let httpResponse = response as? HTTPURLResponse,
       (301...303).contains(httpResponse.statusCode),
       let location = httpResponse.value(forHTTPHeaderField: "Location"),
       let redirectURL = URL(string: location) {
      let s3Request = URLRequest(url: redirectURL)
      (data, response) = try await session.data(for: s3Request)
    }

    if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
      let body = String(data: data, encoding: .utf8) ?? "<non-UTF8 response>"
      throw PostHogError.exportFailed("HTTP \(httpResponse.statusCode): \(body)")
    }

    if let string = String(data: data, encoding: .utf8) {
      if string.hasPrefix("<?xml") || string.hasPrefix("<Error") {
        throw PostHogError.exportFailed(string)
      }
      let filteredData = string
        .components(separatedBy: .newlines)
        .map { $0.trimmingCharacters(in: .whitespaces) }
        .filter {
          !$0.isEmpty
          && !$0.contains("youtube")
          && !$0.contains("google")
          && !$0.contains("http")
          && !$0.contains(":")
          && !$0.contains("EFFECT UP TO THE DATE")
          && $0.allSatisfy { $0.isASCII }
        }
        .joined(separator: "\r\n")
        .data(using: .utf8)
      if let filteredData {
        data = filteredData
      }
    }
    return data
  }
}
