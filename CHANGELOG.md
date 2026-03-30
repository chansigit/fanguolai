# Changelog

## v1.0.1 (2026-03-30)

### Fixed
- Scroll reversal now works correctly with a single instance (switched from `cghidEventTap` to `cgSessionEventTap`)
- `.gitignore` no longer ignores the `Sources/fanguolai/` directory

### Added
- `--debug` flag for `start` command to inspect scroll events and troubleshoot device detection

## v1.0.0 (2026-03-30)

### Initial Release
- Reverse mouse scroll wheel direction without affecting trackpad
- Independent vertical / horizontal direction control
- Background daemon mode (`start --daemon`)
- LaunchAgent autostart (`install` / `uninstall`)
- Bilingual UI — English and 中文 (`config --lang en|zh`)
- Configuration stored at `~/.config/fanguolai/config.json`
