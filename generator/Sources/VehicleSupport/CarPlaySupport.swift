import Foundation

/// CarPlay support data for a specific model
public struct CarPlayModelSupport: Codable, Sendable {
    public let model: String
    public let years: [Int]
    public let startYear: Int
    public let endYear: Int
    public let supportsCarkey: Bool?
    public let wireless: Bool?
    public let wired: Bool?

    enum CodingKeys: String, CodingKey {
        case model
        case years
        case startYear = "start_year"
        case endYear = "end_year"
        case supportsCarkey = "supports_carkey"
        case wireless
        case wired
    }

    public init(
        model: String,
        years: [Int],
        startYear: Int,
        endYear: Int,
        supportsCarkey: Bool? = nil,
        wireless: Bool? = nil,
        wired: Bool? = nil
    ) {
        self.model = model
        self.years = years
        self.startYear = startYear
        self.endYear = endYear
        self.supportsCarkey = supportsCarkey
        self.wireless = wireless
        self.wired = wired
    }

    /// Get a formatted year range string (e.g., "2017-2024" or "2024")
    public var yearRangeString: String {
        if startYear == endYear {
            return String(startYear)
        }
        return "\(startYear)-\(endYear)"
    }

    /// Check if a specific year is supported
    public func supportsYear(_ year: Int) -> Bool {
        return years.contains(year)
    }
}

/// CarPlay support database loaded from JSON
public final class CarPlaySupportDatabase: Sendable {
    private let data: [String: [CarPlayModelSupport]]

    public init(jsonURL: URL) throws {
        let jsonData = try Data(contentsOf: jsonURL)
        let decoder = JSONDecoder()
        self.data = try decoder.decode([String: [CarPlayModelSupport]].self, from: jsonData)
    }

    /// Get all manufacturers
    public var manufacturers: [String] {
        return Array(data.keys).sorted()
    }

    /// Get CarPlay support for a specific make
    public func models(for make: String) -> [CarPlayModelSupport] {
        // Try exact match first
        if let models = data[make] {
            return models
        }

        // Try case-insensitive match
        for (key, value) in data {
            if key.lowercased() == make.lowercased() {
                return value
            }
        }

        return []
    }

    /// Find CarPlay support for a specific model
    public func support(for make: String, model: String) -> CarPlayModelSupport? {
        let models = self.models(for: make)

        // Try exact match
        if let match = models.first(where: { $0.model == model }) {
            return match
        }

        // Try case-insensitive match
        if let match = models.first(where: { $0.model.lowercased() == model.lowercased() }) {
            return match
        }

        // Try partial match (for variants like "Mustang Mach-E" matching "Mach-E")
        if let match = models.first(where: { $0.model.lowercased().contains(model.lowercased()) }) {
            return match
        }

        return nil
    }

    /// Get all models that support CarPlay in a specific year
    public func modelsSupporting(year: Int) -> [(make: String, model: CarPlayModelSupport)] {
        var result: [(String, CarPlayModelSupport)] = []

        for (make, models) in data {
            for model in models {
                if model.supportsYear(year) {
                    result.append((make, model))
                }
            }
        }

        return result.sorted(by: { $0.0 < $1.0 })
    }

    /// Check if a make/model/year supports CarPlay
    public func supportsCarPlay(make: String, model: String, year: Int) -> Bool {
        guard let modelSupport = support(for: make, model: model) else {
            return false
        }
        return modelSupport.supportsYear(year)
    }
}
