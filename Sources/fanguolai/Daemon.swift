import Foundation

struct DaemonManager {
    static let launchAgentsDir: URL = {
        let home = FileManager.default.homeDirectoryForCurrentUser
        return home.appendingPathComponent("Library/LaunchAgents")
    }()
    static let applicationsDir: URL = {
        let home = FileManager.default.homeDirectoryForCurrentUser
        return home.appendingPathComponent("Applications")
    }()
    static let appBundleURL: URL = {
        applicationsDir.appendingPathComponent("Fanguolai.app")
    }()
    static let appContentsURL: URL = {
        appBundleURL.appendingPathComponent("Contents")
    }()
    static let appMacOSURL: URL = {
        appContentsURL.appendingPathComponent("MacOS")
    }()
    static let appExecutableURL: URL = {
        appMacOSURL.appendingPathComponent("fanguolai")
    }()
    static let appPlistURL: URL = {
        appContentsURL.appendingPathComponent("Info.plist")
    }()

    static let plistName = "com.fanguolai.plist"

    static let plistURL: URL = {
        launchAgentsDir.appendingPathComponent(plistName)
    }()

    // MARK: - Daemon start/stop

    static func startDaemon() throws {
        let executablePath = try resolveExecutable()

        let process = Process()
        process.executableURL = URL(fileURLWithPath: executablePath)
        process.arguments = ["start"]
        process.standardOutput = FileHandle.nullDevice
        process.standardError = FileHandle.nullDevice
        process.environment = ProcessInfo.processInfo.environment
        try process.run()

        let pid = process.processIdentifier
        try savePID(pid)
        print(L10n.daemonStarted(pid))
    }

    static func stopDaemon() {
        guard let pid = loadPID() else {
            print(L10n.daemonNotFound)
            return
        }

        if kill(pid, SIGTERM) == 0 {
            print(L10n.daemonStopped(pid))
        } else {
            print(L10n.daemonStopFailed(pid))
        }
        removePID()
    }

    static func status() {
        let config = ConfigManager.load()

        if let pid = launchAgentPID() {
            print(L10n.statusRunning(pid))
        } else if let pid = loadPID() {
            if kill(pid, 0) == 0 {
                print(L10n.statusRunning(pid))
            } else {
                print(L10n.statusStalePID)
                removePID()
            }
        } else {
            print(L10n.statusNotRunning)
        }

        print(L10n.configLabel)
        print(L10n.verticalLabel(config.vertical.rawValue))
        print(L10n.horizontalLabel(config.horizontal.rawValue))
        print(L10n.languageLabel(config.lang.rawValue))
        print(L10n.autoStartLabel(FileManager.default.fileExists(atPath: plistURL.path)))
        print(L10n.appBundleLabel(FileManager.default.fileExists(atPath: appBundleURL.path), appBundleURL.path))
    }

    // MARK: - LaunchAgent install/uninstall

    static func install() throws {
        let executablePath = try resolveExecutable()
        let bundledExecutablePath = try installAppBundle(from: executablePath)

        let plistContent = """
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
        <dict>
            <key>Label</key>
            <string>com.fanguolai</string>
            <key>ProgramArguments</key>
            <array>
                <string>\(bundledExecutablePath)</string>
                <string>start</string>
            </array>
            <key>RunAtLoad</key>
            <true/>
            <key>KeepAlive</key>
            <true/>
            <key>StandardOutPath</key>
            <string>/tmp/fanguolai.log</string>
            <key>StandardErrorPath</key>
            <string>/tmp/fanguolai.err</string>
        </dict>
        </plist>
        """

        try FileManager.default.createDirectory(at: launchAgentsDir, withIntermediateDirectories: true)
        _ = shell("launchctl unload \(shellQuote(plistURL.path))")
        try plistContent.write(to: plistURL, atomically: true, encoding: .utf8)

        let result = shell("launchctl load \(shellQuote(plistURL.path))")
        if result.status == 0 {
            print(L10n.launchAgentInstalled)
            print(L10n.appBundleInstalled(appBundleURL.path))
            print(L10n.installPlist(plistURL.path))
            print(L10n.installLog("/tmp/fanguolai.log"))
            print(L10n.installAccessibilityHint(appBundleURL.path))
        } else {
            print(L10n.installFailed(result.output))
        }
    }

    static func uninstall() {
        guard FileManager.default.fileExists(atPath: plistURL.path) else {
            print(L10n.launchAgentNotInstalled)
            return
        }

        let result = shell("launchctl unload \(shellQuote(plistURL.path))")
        if result.status != 0 {
            print(L10n.unloadFailed(result.output))
        }

        do {
            try FileManager.default.removeItem(at: plistURL)
            print(L10n.launchAgentUninstalled)
        } catch {
            print(L10n.deletePlistFailed(error.localizedDescription))
        }
    }

    // MARK: - Helpers

    private static func resolveExecutable() throws -> String {
        let execPath = ProcessInfo.processInfo.arguments[0]
        let resolvedPath = URL(fileURLWithPath: execPath).standardizedFileURL.path

        guard FileManager.default.isExecutableFile(atPath: resolvedPath) else {
            throw NSError(domain: "DaemonManager", code: 1,
                          userInfo: [NSLocalizedDescriptionKey: L10n.execNotFound(resolvedPath)])
        }
        return resolvedPath
    }

    private static func installAppBundle(from executablePath: String) throws -> String {
        let fileManager = FileManager.default
        try fileManager.createDirectory(at: appMacOSURL, withIntermediateDirectories: true)

        let plistContent = """
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
        <dict>
            <key>CFBundleDevelopmentRegion</key>
            <string>en</string>
            <key>CFBundleExecutable</key>
            <string>fanguolai</string>
            <key>CFBundleIdentifier</key>
            <string>com.fanguolai.app</string>
            <key>CFBundleInfoDictionaryVersion</key>
            <string>6.0</string>
            <key>CFBundleName</key>
            <string>Fanguolai</string>
            <key>CFBundlePackageType</key>
            <string>APPL</string>
            <key>CFBundleShortVersionString</key>
            <string>1.0.1</string>
            <key>CFBundleVersion</key>
            <string>1</string>
            <key>LSBackgroundOnly</key>
            <true/>
        </dict>
        </plist>
        """

        try plistContent.write(to: appPlistURL, atomically: true, encoding: .utf8)

        if fileManager.fileExists(atPath: appExecutableURL.path) {
            try fileManager.removeItem(at: appExecutableURL)
        }
        try fileManager.copyItem(at: URL(fileURLWithPath: executablePath), to: appExecutableURL)
        try fileManager.setAttributes([.posixPermissions: 0o755], ofItemAtPath: appExecutableURL.path)

        return appExecutableURL.path
    }

    private static func savePID(_ pid: Int32) throws {
        try ConfigManager.ensureConfigDir()
        try "\(pid)".write(to: ConfigManager.pidFile, atomically: true, encoding: .utf8)
    }

    private static func loadPID() -> Int32? {
        guard let content = try? String(contentsOf: ConfigManager.pidFile, encoding: .utf8),
              let pid = Int32(content.trimmingCharacters(in: .whitespacesAndNewlines)) else {
            return nil
        }
        return pid
    }

    private static func removePID() {
        try? FileManager.default.removeItem(at: ConfigManager.pidFile)
    }

    private static func launchAgentPID() -> Int32? {
        let result = shell("launchctl list com.fanguolai")
        guard result.status == 0 else {
            return nil
        }

        for line in result.output.split(separator: "\n") {
            let trimmed = line.trimmingCharacters(in: .whitespacesAndNewlines)
            guard trimmed.hasPrefix("\"PID\"") || trimmed.hasPrefix("PID") else {
                continue
            }

            let digits = trimmed.filter(\.isNumber)
            if let pid = Int32(digits), pid > 0 {
                return pid
            }
        }

        return nil
    }

    private static func shell(_ command: String) -> (status: Int32, output: String) {
        let process = Process()
        let pipe = Pipe()
        process.executableURL = URL(fileURLWithPath: "/bin/sh")
        process.arguments = ["-c", command]
        process.standardOutput = pipe
        process.standardError = pipe
        try? process.run()
        process.waitUntilExit()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8) ?? ""
        return (process.terminationStatus, output)
    }

    private static func shellQuote(_ value: String) -> String {
        "'\(value.replacingOccurrences(of: "'", with: "'\\''"))'"
    }
}
