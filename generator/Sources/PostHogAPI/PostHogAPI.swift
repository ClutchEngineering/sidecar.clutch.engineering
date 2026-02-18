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

public actor PostHogExportClient {
  private let baseURL: String
  private let apiKey: String
  private let session: URLSession

  public init(apiKey: String, projectID: Int) {
    self.baseURL = "https://eu.posthog.com/api/environments/\(projectID)"
    self.apiKey = apiKey
    let config = URLSessionConfiguration.default
    config.timeoutIntervalForRequest = 300
    config.timeoutIntervalForResource = 600
    self.session = URLSession(configuration: config)
  }

  public func fetchExportedCSV(query: String) async throws -> Data {
    // 1. Create export request
    let exportId = try await createExport(query: query)

    // 2. Poll until export is ready
    try await waitForExport(id: exportId)

    // 3. Download CSV
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

    // Poll every 2 seconds for up to 1 minute
    for _ in 0..<30 {
      let (data, _) = try await session.data(for: request)
      let response = try JSONDecoder().decode(PostHogExportResponse.self, from: data)

      if response.hasContent {
        return
      }

      try await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds
    }

    throw PostHogError.exportNotReady
  }

  private func downloadCSV(id: Int) async throws -> Data {
    guard let url = URL(string: "\(baseURL)/exports/\(id)/content?download=true") else {
      throw PostHogError.invalidURL
    }

    var request = URLRequest(url: url)
    request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")

    var (data, response) = try await session.data(for: request)

    // On Linux (FoundationNetworking), redirects are not followed automatically.
    // PostHog redirects the content download to S3, so we must follow it manually.
    if let httpResponse = response as? HTTPURLResponse,
       (301...303).contains(httpResponse.statusCode),
       let location = httpResponse.value(forHTTPHeaderField: "Location"),
       let redirectURL = URL(string: location) {
      let redirectRequest = URLRequest(url: redirectURL)
      (data, response) = try await session.data(for: redirectRequest)
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
