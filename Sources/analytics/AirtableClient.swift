import Foundation

enum AirtableError: Error {
  case invalidURL
  case networkError(Error)
  case invalidResponse
  case csvParsingError
  case recordNotFound(String)
  case decodingError
}

struct AirtableRecord: Decodable {
  let id: String
  let fields: Fields

  struct Fields: Decodable {
    let ID: String
  }
}

struct AirtableResponse: Decodable {
  let records: [AirtableRecord]
  let offset: String?
}

actor AirtableClient {
  private let baseID: String
  private let apiKey: String
  private let session: URLSession
  private var idMapping: [String: String]? // Maps string ID to Airtable record ID

  init(baseID: String, apiKey: String) {
    self.baseID = baseID
    self.apiKey = apiKey
    let config = URLSessionConfiguration.default
    self.session = URLSession(configuration: config)
  }

  func updateDriverCounts(_ data: Data, in tableID: String) async throws {
    // First, fetch and cache ID mappings if we haven't already
    if idMapping == nil {
      try await fetchIDMappings(from: tableID)
    }

    // Parse CSV and aggregate driver counts
    let driverCounts = try parseDriverCounts(from: data)

    // Convert to records using internal Airtable IDs
    var recordUpdates: [(id: String, count: Int)] = []
    for count in driverCounts {
      guard let airtableID = idMapping?[count.id] else {
        print("Warning: No matching record found for ID: \(count.id)")
        continue
      }
      recordUpdates.append((id: airtableID, count: count.count))
    }

    // Update records in batches of 10
    for chunk in recordUpdates.chunked(into: 10) {
      try await updateBatch(records: chunk, fieldName: "Number of drivers", in: tableID)
    }
  }

  func updateMilesDriven(_ data: Data, in tableID: String) async throws {
    // First, fetch and cache ID mappings if we haven't already
    if idMapping == nil {
      try await fetchIDMappings(from: tableID)
    }

    // Parse CSV and aggregate miles driven
    let milesDriven = try parseMilesDriven(from: data)

    // Convert to records using internal Airtable IDs
    var recordUpdates: [(id: String, count: Int)] = []
    for miles in milesDriven {
      guard let airtableID = idMapping?[miles.id] else {
        print("Warning: No matching record found for ID: \(miles.id)")
        continue
      }
      recordUpdates.append((id: airtableID, count: miles.count))
    }

    // Update records in batches of 10
    for chunk in recordUpdates.chunked(into: 10) {
      try await updateBatch(records: chunk, fieldName: "Number of miles driven", in: tableID)
    }
  }

  private func fetchIDMappings(from tableID: String) async throws {
    var allRecords: [AirtableRecord] = []
    var offset: String?

    repeat {
      let response = try await fetchRecordsPage(from: tableID, offset: offset)
      allRecords.append(contentsOf: response.records)
      offset = response.offset
    } while offset != nil

    // Create mapping from string ID to Airtable record ID
    idMapping = Dictionary(uniqueKeysWithValues: allRecords.map {
      ($0.fields.ID, $0.id)
    })
  }

  private func fetchRecordsPage(from tableID: String, offset: String? = nil) async throws -> AirtableResponse {
    var urlComponents = URLComponents(string: "https://api.airtable.com/v0/\(baseID)/\(tableID)")

    // Add pagination parameters
    var queryItems = [URLQueryItem]()
    queryItems.append(URLQueryItem(name: "pageSize", value: "100"))
    if let offset = offset {
      queryItems.append(URLQueryItem(name: "offset", value: offset))
    }
    urlComponents?.queryItems = queryItems

    guard let url = urlComponents?.url else {
      throw AirtableError.invalidURL
    }

    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    let (data, response) = try await session.data(for: request)

    guard let httpResponse = response as? HTTPURLResponse,
          (200...299).contains(httpResponse.statusCode) else {
      throw AirtableError.invalidResponse
    }

    return try JSONDecoder().decode(AirtableResponse.self, from: data)
  }

  private func parseDriverCounts(from data: Data) throws -> [(id: String, count: Int)] {
    guard let csvString = String(data: data, encoding: .utf8) else {
      throw AirtableError.csvParsingError
    }

    let lines = csvString.components(separatedBy: .newlines)
    guard lines.count >= 2 else { throw AirtableError.csvParsingError }

    // Find the vehicleMake and value columns
    let headers = lines[0].components(separatedBy: ",")
    guard let makeIndex = headers.firstIndex(of: "series"),
          let countIndex = headers.firstIndex(of: "total count") else {
      throw AirtableError.csvParsingError
    }

    // Parse each line and aggregate counts
    var counts: [(id: String, count: Int)] = []

    for line in lines.dropFirst() where !line.isEmpty {
      let values = line.components(separatedBy: ",")
      guard makeIndex < values.count, countIndex < values.count,
            let count = Int(values[countIndex]) else { continue }

      let id = values[makeIndex]
      counts.append((id: id, count: count))
    }

    return counts
  }

  private func parseMilesDriven(from data: Data) throws -> [(id: String, count: Int)] {
    guard let csvString = String(data: data, encoding: .utf8) else {
      throw AirtableError.csvParsingError
    }

    let lines = csvString.components(separatedBy: .newlines)
    guard lines.count >= 2 else { throw AirtableError.csvParsingError }

    // Find the vehicleMake and miles columns
    let headers = lines[0].components(separatedBy: ",")
    guard let makeIndex = headers.firstIndex(of: "series"),
          let milesIndex = headers.firstIndex(of: "total count") else {
      throw AirtableError.csvParsingError
    }

    // Parse each line and aggregate miles
    var miles: [(id: String, count: Int)] = []

    for line in lines.dropFirst() where !line.isEmpty {
      let values = line.components(separatedBy: ",")
      guard makeIndex < values.count, milesIndex < values.count,
            let milesValue = Double(values[milesIndex]) else { continue }

      let id = values[makeIndex]
      // Convert to integer for storage
      let milesInt = Int(round(milesValue))
      miles.append((id: id, count: milesInt))
    }

    return miles
  }

  private func updateBatch(records: [(id: String, count: Int)], fieldName: String, in tableID: String) async throws {
    guard let url = URL(string: "https://api.airtable.com/v0/\(baseID)/\(tableID)") else {
      throw AirtableError.invalidURL
    }

    var request = URLRequest(url: url)
    request.httpMethod = "PATCH"
    request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    let updates = records.map { record in
      [
        "id": record.id,
        "fields": [
          fieldName: record.count
        ]
      ]
    }

    let payload = ["records": updates]
    request.httpBody = try JSONSerialization.data(withJSONObject: payload)

    let (_, response) = try await session.data(for: request)
    guard let httpResponse = response as? HTTPURLResponse,
          (200...299).contains(httpResponse.statusCode) else {
      throw AirtableError.invalidResponse
    }
  }
}

private extension Array {
  func chunked(into size: Int) -> [[Element]] {
    stride(from: 0, to: count, by: size).map {
      Array(self[$0 ..< Swift.min($0 + size, count)])
    }
  }
}
