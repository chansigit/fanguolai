import ApplicationServices
import Foundation

enum AccessibilityPermission {
    static func isTrusted(prompt: Bool) -> Bool {
        let promptKey = kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String
        let options = [promptKey: prompt] as CFDictionary
        return AXIsProcessTrustedWithOptions(options)
    }

    static func executablePath() -> String {
        URL(fileURLWithPath: ProcessInfo.processInfo.arguments[0]).standardizedFileURL.path
    }

    static func permissionTargetPath() -> String {
        let executableURL = URL(fileURLWithPath: executablePath())
        let pathComponents = executableURL.pathComponents

        if let appIndex = pathComponents.lastIndex(where: { $0.hasSuffix(".app") }) {
            let appPath = NSString.path(withComponents: Array(pathComponents.prefix(appIndex + 1)))
            return URL(fileURLWithPath: appPath).standardizedFileURL.path
        }

        return executableURL.path
    }

    static func shouldPromptUser() -> Bool {
        isatty(STDIN_FILENO) != 0 || isatty(STDOUT_FILENO) != 0 || isatty(STDERR_FILENO) != 0
    }
}
