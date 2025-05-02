import Foundation

public enum AirtableError: Error {
  case invalidURL
  case networkError(Error)
  case invalidResponse
  case csvParsingError
  case recordNotFound(String)
  case decodingError
  case cachingError(Error)
}

public struct AirtableRecord: Codable, Sendable {
  public let id: String
  public let fields: Fields

  public struct Fields: Codable, Sendable {
    public let ID: String
    public var make: String?
    public var model: String?

    /// The obdbID is used as the name of the GitHub repo and the corresponding workspace folder.
    public var obdbID: String?
    public let alternateModels: String?
    public let numberOfDrivers: Int?
    public let numberOfMilesDriven: Int?
    public let engineType: String?

    public var alternateModelIDs: [String] {
      guard let alternateModels,
        let make
      else {
        return []
      }
      return
        alternateModels
        .split(separator: ",")
        .map { $0.trimmingCharacters(in: .whitespaces) }
        .filter { !$0.isEmpty }
        .map { make + "/" + $0.trimmingCharacters(in: .whitespaces) }
    }

    enum CodingKeys: String, CodingKey {
      case ID
      case make = "Make (string)"
      case model = "Model"
      case alternateModels = "Alternate models"
      case obdbID = "OBDb ID"
      case engineType = "Engine type"
      case numberOfDrivers = "Number of drivers"
      case numberOfMilesDriven = "Number of miles driven"
    }
  }
}

struct AirtableResponse: Decodable {
  let records: [AirtableRecord]
  let offset: String?
}

public actor AirtableClient {
  private let baseID: String
  private let apiKey: String
  private let session: URLSession
  private var idMapping: [String: String]?  // Maps string ID to Airtable record ID
  private let cacheURL: URL?

  public init(baseID: String, apiKey: String) {
    self.baseID = baseID
    self.apiKey = apiKey
    let config = URLSessionConfiguration.default
    self.session = URLSession(configuration: config)

    // Configure cache URL from environment if available
    if let cacheDir = ProcessInfo.processInfo.environment["CACHE_DIR"] {
      self.cacheURL = URL(fileURLWithPath: cacheDir)
    } else {
      self.cacheURL = nil
    }
  }

  // Alternative initializer with explicit cache URL
  public init(baseID: String, apiKey: String, cacheURL: URL?) {
    self.baseID = baseID
    self.apiKey = apiKey
    let config = URLSessionConfiguration.default
    self.session = URLSession(configuration: config)
    self.cacheURL = cacheURL
  }

  public func updateDriverCounts(_ data: Data, in tableID: String) async throws {
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

    // Deduplicate records before updating
    let deduplicatedUpdates = deduplicateRecordUpdates(recordUpdates)

    // Update records in batches of 10
    for chunk in deduplicatedUpdates.chunked(into: 10) {
      try await updateBatch(records: chunk, fieldName: "Number of drivers", in: tableID)
    }
  }

  public func updateMilesDriven(_ data: Data, in tableID: String) async throws {
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

    // Deduplicate records before updating
    let deduplicatedUpdates = deduplicateRecordUpdates(recordUpdates)

    // Update records in batches of 10
    for chunk in deduplicatedUpdates.chunked(into: 10) {
      try await updateBatch(records: chunk, fieldName: "Number of miles driven", in: tableID)
    }
  }

  // Fetch all models from the table and print them
  public func fetchModels(from tableID: String) async throws -> [AirtableRecord] {
    // Check cache first if available
    if let cachedRecords = try? await loadFromCache(for: tableID) {
      print("Using cached models data...")
      return cachedRecords
    }

    print("Fetching models from Airtable...")

    // Fetch all records
    var allRecords: [AirtableRecord] = []
    var offset: String?

    repeat {
      let response = try await fetchRecordsPage(from: tableID, offset: offset)
      allRecords.append(contentsOf: response.records)
      offset = response.offset
    } while offset != nil

    // Sort records by ID for consistent output
    let sortedRecords = allRecords.sorted { $0.fields.ID < $1.fields.ID }

    // Save to cache if caching is enabled
    if let cacheURL = self.cacheURL {
      try? await saveToCache(records: sortedRecords, for: tableID)
      print("Models data cached successfully")
    }

    return sortedRecords
  }

  // Helper method to load records from cache
  private func loadFromCache(for tableID: String) async throws -> [AirtableRecord]? {
    guard let cacheURL = self.cacheURL else {
      return nil
    }

    let cacheFileURL = cacheURL.appendingPathComponent("airtable_\(tableID)_cache.json")
    let fileManager = FileManager.default

    // Check if cache exists and is recent (less than 24 hours old)
    guard fileManager.fileExists(atPath: cacheFileURL.path) else {
      return nil
    }

    let attributes = try fileManager.attributesOfItem(atPath: cacheFileURL.path)
    guard let modificationDate = attributes[.modificationDate] as? Date else {
      return nil
    }

    // Check if cache is less than 24 hours old
    let cacheAge = Date().timeIntervalSince(modificationDate)
    if cacheAge > 86400 { // 24 hours in seconds
      return nil
    }

    // Read and decode the cache
    let data = try Data(contentsOf: cacheFileURL)
    return try JSONDecoder().decode([AirtableRecord].self, from: data)
  }

  // Helper method to save records to cache
  private func saveToCache(records: [AirtableRecord], for tableID: String) async throws {
    guard let cacheURL = self.cacheURL else {
      return
    }

    let fileManager = FileManager.default

    // Create cache directory if it doesn't exist
    if !fileManager.fileExists(atPath: cacheURL.path) {
      try fileManager.createDirectory(at: cacheURL, withIntermediateDirectories: true)
    }

    let cacheFileURL = cacheURL.appendingPathComponent("airtable_\(tableID)_cache.json")
    let encoder = JSONEncoder()
    let data = try encoder.encode(records)
    try data.write(to: cacheFileURL)
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
    var mapping: [String: String] = [:]

    // Add primary IDs
    for record in allRecords {
      mapping[record.fields.ID] = record.id

      // Add alternate model IDs
      for alternateID in record.fields.alternateModelIDs {
        mapping[alternateID] = record.id
      }
    }

    idMapping = mapping
  }

  private func deduplicateRecordUpdates(_ updates: [(id: String, count: Int)]) -> [(
    id: String, count: Int
  )] {
    // Group updates by ID and sum their counts
    var groupedCounts: [String: Int] = [:]

    for update in updates {
      groupedCounts[update.id, default: 0] += update.count
    }

    // Convert back to array of tuples
    return groupedCounts.map { (id: $0.key, count: $0.value) }
  }

  private func fetchRecordsPage(from tableID: String, offset: String? = nil) async throws
    -> AirtableResponse
  {
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
      (200...299).contains(httpResponse.statusCode)
    else {
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
      let countIndex = headers.firstIndex(of: "total count")
    else {
      throw AirtableError.csvParsingError
    }

    // Parse each line and aggregate counts
    var counts: [(id: String, count: Int)] = []

    for line in lines.dropFirst() where !line.isEmpty {
      let values = line.components(separatedBy: ",")
      guard makeIndex < values.count, countIndex < values.count,
        let count = Int(values[countIndex])
      else { continue }

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
      let milesIndex = headers.firstIndex(of: "total count")
    else {
      throw AirtableError.csvParsingError
    }

    // Parse each line and aggregate miles
    var miles: [(id: String, count: Int)] = []

    for line in lines.dropFirst() where !line.isEmpty {
      let values = line.components(separatedBy: ",")
      guard makeIndex < values.count, milesIndex < values.count,
        let milesValue = Double(values[milesIndex])
      else { continue }

      let id = values[makeIndex]
      // Convert to integer for storage
      let milesInt = Int(round(milesValue))
      miles.append((id: id, count: milesInt))
    }

    return miles
  }

  private func updateBatch(
    records: [(id: String, count: Int)], fieldName: String, in tableID: String
  ) async throws {
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
        ],
      ]
    }

    let payload = ["records": updates]
    request.httpBody = try JSONSerialization.data(withJSONObject: payload)

    let (_, response) = try await session.data(for: request)
    guard let httpResponse = response as? HTTPURLResponse,
      (200...299).contains(httpResponse.statusCode)
    else {
      throw AirtableError.invalidResponse
    }
  }
}

extension Array {
  public func chunked(into size: Int) -> [[Element]] {
    stride(from: 0, to: count, by: size).map {
      Array(self[$0..<Swift.min($0 + size, count)])
    }
  }
}
