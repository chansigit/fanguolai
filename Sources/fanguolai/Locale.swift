import Foundation

enum Language: String, Codable, CaseIterable {
    case en
    case zh
}

struct L10n {
    static var lang: Language = .en

    // MARK: - General
    static var started: String {
        lang == .zh ? "fanguolai 已启动" : "fanguolai started"
    }
    static var stopped: String {
        lang == .zh ? "\nfanguolai 已停止" : "\nfanguolai stopped"
    }
    static func verticalHorizontal(_ v: String, _ h: String) -> String {
        lang == .zh ? "  垂直: \(v), 水平: \(h)" : "  vertical: \(v), horizontal: \(h)"
    }
    static var pressCtrlC: String {
        lang == .zh ? "  按 Ctrl+C 停止" : "  press Ctrl+C to stop"
    }
    static var eventTapError: String {
        lang == .zh
            ? "错误: 无法创建 Event Tap。请在「系统设置 → 隐私与安全性 → 辅助功能」中授权此程序。"
            : "Error: Failed to create Event Tap. Please grant accessibility permission in System Settings → Privacy & Security → Accessibility."
    }
    static func configReloaded(_ v: String, _ h: String) -> String {
        lang == .zh ? "配置已重新加载: 垂直=\(v), 水平=\(h)" : "Config reloaded: vertical=\(v), horizontal=\(h)"
    }

    // MARK: - Daemon
    static func daemonStarted(_ pid: Int32) -> String {
        lang == .zh ? "fanguolai daemon 已启动 (PID: \(pid))" : "fanguolai daemon started (PID: \(pid))"
    }
    static var daemonNotFound: String {
        lang == .zh ? "未找到运行中的 daemon" : "No running daemon found"
    }
    static func daemonStopped(_ pid: Int32) -> String {
        lang == .zh ? "已停止 daemon (PID: \(pid))" : "Daemon stopped (PID: \(pid))"
    }
    static func daemonStopFailed(_ pid: Int32) -> String {
        lang == .zh ? "无法停止 PID \(pid)（可能已经退出）" : "Cannot stop PID \(pid) (may have already exited)"
    }

    // MARK: - Status
    static func statusRunning(_ pid: Int32) -> String {
        lang == .zh ? "状态: 运行中 (PID: \(pid))" : "Status: running (PID: \(pid))"
    }
    static var statusStalePID: String {
        lang == .zh ? "状态: 未运行（PID 文件已过期）" : "Status: not running (stale PID file)"
    }
    static var statusNotRunning: String {
        lang == .zh ? "状态: 未运行" : "Status: not running"
    }
    static var configLabel: String {
        lang == .zh ? "配置:" : "Config:"
    }
    static func verticalLabel(_ v: String) -> String {
        lang == .zh ? "  垂直方向: \(v)" : "  vertical: \(v)"
    }
    static func horizontalLabel(_ h: String) -> String {
        lang == .zh ? "  水平方向: \(h)" : "  horizontal: \(h)"
    }
    static func languageLabel(_ l: String) -> String {
        lang == .zh ? "  语言: \(l)" : "  language: \(l)"
    }
    static func autoStartLabel(_ installed: Bool) -> String {
        if lang == .zh {
            return "  开机自启: \(installed ? "已安装" : "未安装")"
        }
        return "  autostart: \(installed ? "installed" : "not installed")"
    }

    // MARK: - Install/Uninstall
    static var launchAgentInstalled: String {
        lang == .zh ? "已安装开机自启 LaunchAgent" : "LaunchAgent installed for autostart"
    }
    static func installPlist(_ path: String) -> String {
        "  plist: \(path)"
    }
    static func installLog(_ path: String) -> String {
        lang == .zh ? "  日志: \(path)" : "  log: \(path)"
    }
    static func installFailed(_ output: String) -> String {
        lang == .zh ? "安装失败: \(output)" : "Install failed: \(output)"
    }
    static var launchAgentNotInstalled: String {
        lang == .zh ? "LaunchAgent 未安装" : "LaunchAgent not installed"
    }
    static func unloadFailed(_ output: String) -> String {
        lang == .zh ? "警告: launchctl unload 失败: \(output)" : "Warning: launchctl unload failed: \(output)"
    }
    static var launchAgentUninstalled: String {
        lang == .zh ? "已卸载开机自启 LaunchAgent" : "LaunchAgent uninstalled"
    }
    static func deletePlistFailed(_ err: String) -> String {
        lang == .zh ? "删除 plist 失败: \(err)" : "Failed to delete plist: \(err)"
    }
    static func execNotFound(_ path: String) -> String {
        lang == .zh
            ? "找不到可执行文件: \(path)。请先运行 make build"
            : "Executable not found: \(path). Please run make build first"
    }

    // MARK: - Config command
    static var configUpdated: String {
        lang == .zh ? "配置已更新:" : "Config updated:"
    }
    static var currentConfig: String {
        lang == .zh ? "当前配置:" : "Current config:"
    }
    static func configFilePath(_ path: String) -> String {
        lang == .zh ? "  配置文件: \(path)" : "  config file: \(path)"
    }
    static var restartHint: String {
        lang == .zh ? "\n提示: 需要重启 fanguolai 才能生效" : "\nNote: restart fanguolai for changes to take effect"
    }
    static func invalidValue(_ name: String) -> String {
        lang == .zh ? "错误: --\(name) 值必须是 normal 或 reverse" : "Error: --\(name) must be normal or reverse"
    }
    static var invalidLang: String {
        lang == .zh ? "错误: --lang 值必须是 en 或 zh" : "Error: --lang must be en or zh"
    }
    static func unknownOption(_ opt: String) -> String {
        lang == .zh ? "未知选项: \(opt)" : "Unknown option: \(opt)"
    }
    static func unknownCommand(_ cmd: String) -> String {
        lang == .zh ? "未知命令: \(cmd)" : "Unknown command: \(cmd)"
    }
    static func errorPrefix(_ msg: String) -> String {
        lang == .zh ? "错误: \(msg)" : "Error: \(msg)"
    }

    // MARK: - Usage
    static var usage: String {
        if lang == .zh {
            return """
            fanguolai - 反转鼠标滚轮方向，不影响触控板

            用法:
              fanguolai <命令> [选项]

            命令:
              start              前台启动滚轮反转
              start --daemon     以后台 daemon 模式运行
              stop               停止后台 daemon
              status             查看运行状态和配置
              config             查看/修改配置
              config --vertical <normal|reverse>    设置垂直方向
              config --horizontal <normal|reverse>  设置水平方向
              config --lang <en|zh>                 设置界面语言
              install            安装开机自启（LaunchAgent）
              uninstall          卸载开机自启（LaunchAgent）
              help               显示此帮助信息

            首次使用需要在「系统设置 → 隐私与安全性 → 辅助功能」中授权。
            """
        }
        return """
        fanguolai - Reverse mouse scroll wheel direction without affecting trackpad

        Usage:
          fanguolai <command> [options]

        Commands:
          start              Start scroll reversal (foreground)
          start --daemon     Start as background daemon
          stop               Stop background daemon
          status             Show current status and config
          config             Show/modify configuration
          config --vertical <normal|reverse>    Set vertical direction
          config --horizontal <normal|reverse>  Set horizontal direction
          config --lang <en|zh>                 Set UI language
          install            Install autostart (LaunchAgent)
          uninstall          Uninstall autostart (LaunchAgent)
          help               Show this help message

        Accessibility permission is required on first run:
          System Settings → Privacy & Security → Accessibility
        """
    }
}
