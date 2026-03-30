<p align="center">
  <img src="logo.svg" width="100" height="100" alt="fanguolai">
</p>

<h1 align="center">fanguolai</h1>

<p align="center">
  Decouple mouse and trackpad scroll directions on macOS.
</p>

<p align="center">
  <a href="https://github.com/chansigit/fanguolai/releases"><img src="https://img.shields.io/github/v/release/chansigit/fanguolai?color=blue" alt="release"></a>
  <img src="https://img.shields.io/badge/macOS-11%2B-black" alt="macOS 11+">
  <img src="https://img.shields.io/badge/Swift-5.4%2B-F05138" alt="Swift">
  <a href="LICENSE"><img src="https://img.shields.io/github/license/chansigit/fanguolai" alt="MIT"></a>
</p>

<p align="center">
  <a href="README.md">English</a> | <a href="README_zh.md">中文</a> | <a href="README_ko.md">한국어</a> | <a href="README_ja.md">日本語</a> | <a href="README_de.md">Deutsch</a> | <a href="README_ru.md">Русский</a> | <a href="README_fr.md">Français</a> | <a href="README_es.md">Español</a> | <a href="README_vi.md">Tiếng Việt</a> | <a href="README_hi.md">हिन्दी</a> | <a href="README_yue.md">粵語</a> | <a href="README_sv.md">Svenska</a> | <a href="README_no.md">Norsk</a> | <a href="README_fi.md">Suomi</a> | <a href="README_ca.md">Català</a>
</p>

---

## The Problem

macOS has one global "Natural Scrolling" toggle. Turn it on and your trackpad feels right, but your mouse wheel goes the wrong way. Turn it off and it's the opposite. There's no built-in way to set them independently.

**fanguolai** (翻过来, "flip it") fixes this. It sits between your mouse and macOS, reversing only mouse scroll events while leaving trackpad gestures alone.

- ~150 KB single binary, no dependencies
- Per-axis control (vertical / horizontal)
- Daemon mode + LaunchAgent for autostart
- Uses `CGEventTap` under the hood

## Quick Start

```bash
# Download from GitHub Releases, or build from source:
git clone https://github.com/chansigit/fanguolai.git
cd fanguolai && make build
sudo make install

# Run it
fanguolai start
```

> **First run:** macOS will prompt for Accessibility permission.
> Grant it in **System Settings → Privacy & Security → Accessibility**.

## Usage

```bash
fanguolai start              # foreground
fanguolai start --daemon     # background
fanguolai stop               # stop daemon
fanguolai status             # show status & config
```

### Configuration

```bash
fanguolai config                        # show current settings
fanguolai config --vertical reverse     # reverse vertical (default)
fanguolai config --horizontal reverse   # reverse horizontal too
fanguolai config --lang zh              # switch CLI language
```

### Autostart on Login

```bash
fanguolai install     # add LaunchAgent
fanguolai uninstall   # remove LaunchAgent
```

### Troubleshooting

```bash
fanguolai start --debug   # print raw scroll events for diagnosis
```

## How It Works

macOS scroll events carry a flag `scrollWheelEventIsContinuous`:

| Value | Source | fanguolai action |
|-------|--------|-----------------|
| `0` | Mouse wheel (discrete) | Reverse delta |
| `!= 0` | Trackpad (continuous) | Pass through |

The reversal is done by intercepting events via `CGEventTap` at the session level, copying the event with negated scroll deltas, and returning the modified copy. Trackpad events are never touched.

## Config File

`~/.config/fanguolai/config.json`

```json
{
  "horizontal": "normal",
  "lang": "en",
  "vertical": "reverse"
}
```

## Changelog

**v1.0.1** — Fixed scroll reversal requiring double instances. Added `--debug` flag.
**v1.0.0** — Initial release.

See [CHANGELOG.md](CHANGELOG.md) for details.

## License

[MIT](LICENSE)
