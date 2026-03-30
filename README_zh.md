<p align="center">
  <img src="logo.svg" width="120" height="120" alt="fanguolai logo">
</p>

<h1 align="center">fanguolai（翻过来）</h1>

<p align="center">
  <strong>在 macOS 上反转鼠标滚轮方向，不影响触控板。</strong>
</p>

<p align="center">
  <a href="README.md">English</a> | <a href="README_zh.md">中文</a>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/平台-macOS-blue" alt="macOS">
  <img src="https://img.shields.io/badge/语言-Swift-orange" alt="Swift">
  <img src="https://img.shields.io/badge/协议-MIT-green" alt="MIT">
</p>

---

macOS 的「自然滚动」设置会同时影响触控板和鼠标。如果你希望触控板保持自然滚动，但鼠标滚轮使用传统方向（或反过来），**fanguolai** 帮你搞定。

它通过 macOS `CGEventTap` 拦截滚动事件，只反转鼠标滚轮事件，触控板完全不受影响。

## 安装

**下载二进制文件**，从 [Releases](https://github.com/chansigit/fanguolai/releases) 页面：

```bash
chmod +x fanguolai
sudo mv fanguolai /usr/local/bin/
```

**或从源码编译：**

```bash
git clone https://github.com/chansigit/fanguolai.git
cd fanguolai
make build
sudo make install   # 安装到 /usr/local/bin
```

> 需要 Xcode Command Line Tools（`xcode-select --install`）。

## 使用

```bash
# 前台启动
fanguolai start

# 后台 daemon 模式
fanguolai start --daemon

# 停止 daemon
fanguolai stop

# 查看状态
fanguolai status
```

### 配置

```bash
# 查看当前配置
fanguolai config

# 反转垂直滚动（默认）
fanguolai config --vertical reverse

# 同时反转水平滚动
fanguolai config --horizontal reverse

# 切换界面语言（en / zh）
fanguolai config --lang zh
```

### 开机自启

```bash
# 安装 LaunchAgent（登录时自动启动）
fanguolai install

# 卸载 LaunchAgent
fanguolai uninstall
```

## 权限

首次运行时，macOS 会要求 **辅助功能** 权限：

**系统设置 → 隐私与安全性 → 辅助功能**

将你的终端应用（或 `fanguolai` 二进制文件）添加到允许列表。

## 工作原理

- 通过 `CGEventTap` 接入 macOS HID 事件流
- 区分鼠标（离散滚动，`isContinuous == 0`）和触控板（连续滚动，`isContinuous != 0`）
- 仅反转鼠标滚轮事件的滚动方向
- 触控板行为完全不变

## 配置文件

存储在 `~/.config/fanguolai/config.json`：

```json
{
  "horizontal": "normal",
  "lang": "zh",
  "vertical": "reverse"
}
```

## 更新日志

### v1.0.1 (2026-03-30)
- **修复**：单实例即可正确反转滚轮方向
- **新增**：`start` 命令支持 `--debug` 参数，用于查看滚动事件排查问题

### v1.0.0 (2026-03-30)
- 首次发布
- 反转鼠标滚轮方向，不影响触控板
- 独立控制垂直/水平方向
- 后台 daemon 模式和开机自启
- 双语界面（English / 中文）

完整日志：[CHANGELOG.md](CHANGELOG.md)

## 许可证

MIT
