import Foundation
import CoreGraphics

// Load config and set language before anything else
let initialConfig = ConfigManager.load()
L10n.lang = initialConfig.lang

// MARK: - CLI Entry Point

let args = CommandLine.arguments.dropFirst()
let command = args.first ?? "help"

switch command {
case "start":
    let isDaemon = args.contains("--daemon")
    let isDebug = args.contains("--debug")
    if isDaemon {
        do {
            try DaemonManager.startDaemon()
        } catch {
            print(L10n.errorPrefix(error.localizedDescription))
            exit(1)
        }
    } else {
        let config = ConfigManager.load()
        let tap = ScrollEventTap(config: config, debug: isDebug)
        if !tap.start() {
            exit(1)
        }
    }

case "stop":
    DaemonManager.stopDaemon()

case "status":
    DaemonManager.status()

case "install":
    do {
        try DaemonManager.install()
    } catch {
        print(L10n.errorPrefix(error.localizedDescription))
        exit(1)
    }

case "uninstall":
    DaemonManager.uninstall()

case "config":
    do {
        try handleConfig(Array(args.dropFirst()))
    } catch {
        print(L10n.errorPrefix(error.localizedDescription))
        exit(1)
    }

case "help", "--help", "-h":
    printUsage()

default:
    print(L10n.unknownCommand(command))
    printUsage()
    exit(1)
}

// MARK: - Config Handler

func handleConfig(_ args: [String]) throws {
    var config = ConfigManager.load()
    L10n.lang = config.lang
    var changed = false
    var i = 0

    while i < args.count {
        switch args[i] {
        case "--vertical":
            i += 1
            guard i < args.count, let dir = ScrollDirection(rawValue: args[i]) else {
                print(L10n.invalidValue("vertical"))
                exit(1)
            }
            config.vertical = dir
            changed = true
        case "--horizontal":
            i += 1
            guard i < args.count, let dir = ScrollDirection(rawValue: args[i]) else {
                print(L10n.invalidValue("horizontal"))
                exit(1)
            }
            config.horizontal = dir
            changed = true
        case "--lang":
            i += 1
            guard i < args.count, let l = Language(rawValue: args[i]) else {
                print(L10n.invalidLang)
                exit(1)
            }
            config.lang = l
            L10n.lang = l
            changed = true
        default:
            print(L10n.unknownOption(args[i]))
            exit(1)
        }
        i += 1
    }

    if changed {
        try ConfigManager.save(config)
        print(L10n.configUpdated)
    } else {
        print(L10n.currentConfig)
    }

    print(L10n.verticalLabel(config.vertical.rawValue))
    print(L10n.horizontalLabel(config.horizontal.rawValue))
    print(L10n.languageLabel(config.lang.rawValue))
    print(L10n.configFilePath(ConfigManager.configFile.path))

    if changed {
        print(L10n.restartHint)
    }
}

// MARK: - Usage

func printUsage() {
    print(L10n.usage)
}
