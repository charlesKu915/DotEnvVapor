import Foundation
import Service

#if os(Linux)
    import Glibc
#else
    import Darwin
#endif

public extension Environment {

    static func dotenv(filename: String = ".env") {
        guard let path = getAbsolutePath(for: filename),
            let contents = try? String(contentsOfFile: path, encoding: .utf8) else {
            return
        }

        let lines = contents.split(whereSeparator: { $0 == "\n" || $0 == "\r\n" })

        for line in lines {
            // ignore the comment
            if line.starts(with: "#") {
                continue
            }

            // ignore lines that appear empty
            if line.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                continue
            }

            // extract key and value which are separated by an equals sign
            let parts = line.components(separatedBy: "=")

            let key = parts[0].trimmingCharacters(in: .whitespacesAndNewlines)

            var value = ""
            var restParts = Array(parts)
            restParts.remove(at: 0)
            value = restParts.joined(separator: "=")

            // remove surrounding quotes from value & convert remove escape character before any embedded quotes
            if value[value.startIndex] == "\"" && value[value.index(before: value.endIndex)] == "\"" {
                value.remove(at: value.startIndex)
                value.remove(at: value.index(before: value.endIndex))
                value = value.replacingOccurrences(of: "\\n", with: "\n")
                value = value.replacingOccurrences(of: "\\\"", with: "\"")
            }

            // remove surrounding single quotes from value & convert remove escape character before any embedded quotes
            if value[value.startIndex] == "'" && value[value.index(before: value.endIndex)] == "'" {
                value.remove(at: value.startIndex)
                value.remove(at: value.index(before: value.endIndex))
                value = value.replacingOccurrences(of: "\\n", with: "\n")
                value = value.replacingOccurrences(of: "'", with: "'")
            }

            setenv(key, value, 1)
        }
    }

    private static func getAbsolutePath(for filename: String) -> String? {
        let fileManager = FileManager.default
        let currentPath = DirectoryConfig.detect().workDir.finished(with: "/")
        let filePath = currentPath + filename
        if fileManager.fileExists(atPath: filePath) {
            return filePath
        } else {
            return nil
        }
    }
}

