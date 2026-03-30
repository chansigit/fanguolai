<p align="center">
  <img src="logo.svg" width="100" height="100" alt="fanguolai">
</p>

<h1 align="center">fanguolai</h1>

<p align="center">
  Separera mushjulets och styrplattans scrollriktning på macOS.
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

## Problemet

macOS har ett enda globalt reglage för "Naturlig scrollning". Slår du på det känns styrplattan rätt men mushjulet går åt fel håll. Stänger du av det är det tvärtom. Det finns inget inbyggt sätt att ställa in dem separat.

**fanguolai** (翻过来, "vänd på det") löser detta. Det sätter sig mellan din mus och macOS och vänder enbart mushjulshändelser, medan styrplattans gester lämnas orörda.

- ~150 KB enkel binär, inga beroenden
- Per-axelkontroll (vertikalt / horisontellt)
- Daemon-läge + LaunchAgent för autostart
- Använder `CGEventTap` under huven

## Snabbstart

```bash
# Ladda ned från GitHub Releases, eller bygg från källkod:
git clone https://github.com/chansigit/fanguolai.git
cd fanguolai && make build
sudo make install

# Kör det
fanguolai start
```

> **Första körningen:** macOS frågar efter behörighet för Tillgänglighet.
> Bevilja den under **Systeminställningar → Sekretess och säkerhet → Tillgänglighet**.

## Användning

```bash
fanguolai start              # förgrund
fanguolai start --daemon     # bakgrund
fanguolai stop               # stoppa daemon
fanguolai status             # visa status och konfiguration
```

### Konfiguration

```bash
fanguolai config                        # visa aktuella inställningar
fanguolai config --vertical reverse     # vänd vertikalt (standard)
fanguolai config --horizontal reverse   # vänd horisontellt också
fanguolai config --lang zh              # byt gränssnittsspråk
```

### Autostart vid inloggning

```bash
fanguolai install     # lägg till LaunchAgent
fanguolai uninstall   # ta bort LaunchAgent
```

### Felsökning

```bash
fanguolai start --debug   # skriv ut råa scrollhändelser för diagnos
```

## Hur det fungerar

macOS scrollhändelser bär en flagga `scrollWheelEventIsContinuous`:

| Värde | Källa | fanguolai-åtgärd |
|-------|--------|-----------------|
| `0` | Mushjul (diskret) | Vänd delta |
| `!= 0` | Styrplatta (kontinuerlig) | Släpp igenom |

Vändningen görs genom att fånga händelser via `CGEventTap` på sessionsnivå, kopiera händelsen med negerade scrolldeltan och returnera den modifierade kopian. Styrplattans händelser rörs aldrig.

## Konfigurationsfil

`~/.config/fanguolai/config.json`

```json
{
  "horizontal": "normal",
  "lang": "en",
  "vertical": "reverse"
}
```

## Ändringslogg

**v1.0.1** — Åtgärdade att scrollvändning krävde dubbla instanser. Lade till `--debug`-flagga.
**v1.0.0** — Första utgåvan.

Se [CHANGELOG.md](CHANGELOG.md) för detaljer.

## Licens

[MIT](LICENSE)
