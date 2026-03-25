import Foundation

struct DaemonManager {
    static let launchAgentsDir: URL = {
        let home = FileManager.default.homeDirectoryForCurrentUser
        return home.appendingPathComponent("Library/LaunchAgents")
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

        if let pid = loadPID() {
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
    }

    // MARK: - LaunchAgent install/uninstall

    static func install() throws {
        let executablePath = try resolveExecutable()

        let plistContent = """
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
        <dict>
            <key>Label</key>
            <string>com.fanguolai</string>
            <key>ProgramArguments</key>
            <array>
                <string>\(executablePath)</string>
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
        try plistContent.write(to: plistURL, atomically: true, encoding: .utf8)

        let result = shell("launchctl load \(plistURL.path)")
        if result.status == 0 {
            print(L10n.launchAgentInstalled)
            print(L10n.installPlist(plistURL.path))
            print(L10n.installLog("/tmp/fanguolai.log"))
        } else {
            print(L10n.installFailed(result.output))
        }
    }

    static func uninstall() {
        guard FileManager.default.fileExists(atPath: plistURL.path) else {
            print(L10n.launchAgentNotInstalled)
            return
        }

        let result = shell("launchctl unload \(plistURL.path)")
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
}
