<p align="center">
  <img src="logo.svg" width="100" height="100" alt="fanguolai">
</p>

<h1 align="center">fanguolai</h1>

<p align="center">
  Maus- und Trackpad-Scrollrichtung unter macOS entkoppeln.
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

## Das Problem

macOS hat einen einzigen globalen Schalter für „Natürliches Scrollen". Aktiviert man ihn, fühlt sich das Trackpad richtig an, aber das Mausrad dreht sich verkehrt herum. Deaktiviert man ihn, ist es umgekehrt. Es gibt keine eingebaute Möglichkeit, beides unabhängig einzustellen.

**fanguolai** (翻过来, „umdrehen") löst dieses Problem. Es sitzt zwischen der Maus und macOS und kehrt nur Mausrad-Scroll-Ereignisse um, während Trackpad-Gesten unberührt bleiben.

- ~150 KB Einzeldatei, keine Abhängigkeiten
- Achsenweise Steuerung (vertikal / horizontal)
- Daemon-Modus + LaunchAgent für Autostart
- Verwendet `CGEventTap` unter der Haube

## Schnellstart

```bash
# Von GitHub Releases herunterladen oder aus dem Quellcode erstellen:
git clone https://github.com/chansigit/fanguolai.git
cd fanguolai && make build
sudo make install

# Starten
fanguolai start
```

> **Erster Start:** macOS fragt nach der Berechtigung für Bedienungshilfen.
> Erteile sie unter **Systemeinstellungen → Datenschutz & Sicherheit → Bedienungshilfen**.

## Verwendung

```bash
fanguolai start              # Vordergrund
fanguolai start --daemon     # Hintergrund
fanguolai stop               # Daemon stoppen
fanguolai status             # Status & Konfiguration anzeigen
```

### Konfiguration

```bash
fanguolai config                        # aktuelle Einstellungen anzeigen
fanguolai config --vertical reverse     # vertikales Scrollen umkehren (Standard)
fanguolai config --horizontal reverse   # auch horizontales Scrollen umkehren
fanguolai config --lang zh              # CLI-Sprache wechseln
```

### Autostart beim Login

```bash
fanguolai install     # LaunchAgent hinzufügen
fanguolai uninstall   # LaunchAgent entfernen
```

### Fehlerbehebung

```bash
fanguolai start --debug   # rohe Scroll-Ereignisse zur Diagnose ausgeben
```

## Funktionsweise

macOS-Scroll-Ereignisse tragen ein Flag `scrollWheelEventIsContinuous`:

| Wert | Quelle | fanguolai-Aktion |
|------|--------|-----------------|
| `0` | Mausrad (diskret) | Delta umkehren |
| `!= 0` | Trackpad (kontinuierlich) | Durchleiten |

Die Umkehrung erfolgt durch Abfangen von Ereignissen via `CGEventTap` auf Session-Ebene, Kopieren des Ereignisses mit negierten Scroll-Deltas und Zurückgeben der geänderten Kopie. Trackpad-Ereignisse werden niemals berührt.

## Konfigurationsdatei

`~/.config/fanguolai/config.json`

```json
{
  "horizontal": "normal",
  "lang": "en",
  "vertical": "reverse"
}
```

## Änderungsprotokoll

**v1.0.1** — Fehler behoben, bei dem die Scroll-Umkehrung zwei Instanzen erforderte. Flag `--debug` hinzugefügt.
**v1.0.0** — Erstveröffentlichung.

Siehe [CHANGELOG.md](CHANGELOG.md) für Details.

## Lizenz

[MIT](LICENSE)
