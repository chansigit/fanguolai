<p align="center">
  <img src="logo.svg" width="120" height="120" alt="fanguolai logo">
</p>

<h1 align="center">fanguolai</h1>

<p align="center">
  <strong>Reverse mouse scroll wheel direction on macOS — without affecting your trackpad.</strong>
</p>

<p align="center">
  <a href="README.md">English</a> | <a href="README_zh.md">中文</a>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/platform-macOS-blue" alt="macOS">
  <img src="https://img.shields.io/badge/language-Swift-orange" alt="Swift">
  <img src="https://img.shields.io/badge/license-MIT-green" alt="MIT">
</p>

---

macOS ties "Natural Scrolling" to both trackpad and mouse. If you want your trackpad to scroll naturally but your mouse wheel to scroll traditionally (or vice versa), **fanguolai** fixes that.

It uses macOS `CGEventTap` to intercept scroll events and selectively reverses only mouse wheel events, leaving trackpad gestures untouched.

## Install

**Download binary** from [Releases](https://github.com/chansigit/fanguolai/releases):

```bash
chmod +x fanguolai
sudo mv fanguolai /usr/local/bin/
```

**Or build from source:**

```bash
git clone https://github.com/chansigit/fanguolai.git
cd fanguolai
make build
sudo make install   # installs to /usr/local/bin
```

> Requires Xcode Command Line Tools (`xcode-select --install`).

## Usage

```bash
# Start (foreground)
fanguolai start

# Start as background daemon
fanguolai start --daemon

# Stop daemon
fanguolai stop

# Check status
fanguolai status
```

### Configuration

```bash
# View current config
fanguolai config

# Reverse vertical scroll (default)
fanguolai config --vertical reverse

# Also reverse horizontal scroll
fanguolai config --horizontal reverse

# Switch UI language (en / zh)
fanguolai config --lang zh
```

### Autostart

```bash
# Install LaunchAgent (start on login)
fanguolai install

# Remove LaunchAgent
fanguolai uninstall
```

## Permissions

On first run, macOS will ask for **Accessibility** permission:

**System Settings → Privacy & Security → Accessibility**

Add your terminal app (or the `fanguolai` binary) to the allowed list.

## How It Works

- Hooks into macOS HID event stream via `CGEventTap`
- Distinguishes mouse (discrete scroll, `isContinuous == 0`) from trackpad (continuous scroll, `isContinuous != 0`)
- Only reverses scroll delta for mouse wheel events
- Trackpad behavior stays completely unchanged

## Config File

Stored at `~/.config/fanguolai/config.json`:

```json
{
  "horizontal": "normal",
  "lang": "en",
  "vertical": "reverse"
}
```

## License

MIT
