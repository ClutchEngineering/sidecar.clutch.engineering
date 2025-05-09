import Foundation

/// Simple utility to load environment variables from a .env file
public struct DotEnv {
  /// Loads environment variables from a .env file if it exists
  /// - Parameter defaultPath: The default path to the .env file (default: ".env")
  public static func load(from defaultPath: String = ".env") {
    // Check if ENV_FILE environment variable is set
    let fileManager = FileManager.default
    let envPath = ProcessInfo.processInfo.environment["ENV_FILE"] ?? defaultPath

    // Skip if file doesn't exist
    guard fileManager.fileExists(atPath: envPath) else {
      return
    }

    do {
      // Read file content
      let content = try String(contentsOfFile: envPath, encoding: .utf8)

      // Process each line
      let lines = content.components(separatedBy: .newlines)
      for line in lines {
        // Skip comments and empty lines
        let trimmedLine = line.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedLine.isEmpty || trimmedLine.hasPrefix("#") {
          continue
        }

        // Split by first equals sign
        let parts = trimmedLine.split(separator: "=", maxSplits: 1)
        if parts.count == 2 {
          let key = String(parts[0]).trimmingCharacters(in: .whitespacesAndNewlines)
          var value = String(parts[1]).trimmingCharacters(in: .whitespacesAndNewlines)

          // Remove quotes if present
          if (value.hasPrefix("\"") && value.hasSuffix("\"")) ||
             (value.hasPrefix("'") && value.hasSuffix("'")) {
            value = String(value.dropFirst().dropLast())
          }

          // Set environment variable if not already set
          if ProcessInfo.processInfo.environment[key] == nil {
            setenv(key, value, 1)
          }
        }
      }
    } catch {
      // Silently fail if .env file can't be read
      // This is intentional as .env file is optional
    }
  }
}