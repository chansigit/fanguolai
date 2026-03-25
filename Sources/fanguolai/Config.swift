import Foundation

enum ScrollDirection: String, Codable, CaseIterable {
    case normal
    case reverse
}

struct ScrollConfig: Codable {
    var vertical: ScrollDirection
    var horizontal: ScrollDirection
    var lang: Language

    static let `default` = ScrollConfig(vertical: .reverse, horizontal: .normal, lang: .en)
}

struct ConfigManager {
    static let configDir: URL = {
        let home = FileManager.default.homeDirectoryForCurrentUser
        return home.appendingPathComponent(".config/fanguolai")
    }()

    static let configFile: URL = {
        configDir.appendingPathComponent("config.json")
    }()

    static let pidFile: URL = {
        configDir.appendingPathComponent("fanguolai.pid")
    }()

    static func ensureConfigDir() throws {
        try FileManager.default.createDirectory(at: configDir, withIntermediateDirectories: true)
    }

    static func load() -> ScrollConfig {
        guard let data = try? Data(contentsOf: configFile),
              let config = try? JSONDecoder().decode(ScrollConfig.self, from: data) else {
            return .default
        }
        return config
    }

    static func save(_ config: ScrollConfig) throws {
        try ensureConfigDir()
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let data = try encoder.encode(config)
        try data.write(to: configFile)
    }
}
