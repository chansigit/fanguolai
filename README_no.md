<p align="center">
  <img src="logo.svg" width="100" height="100" alt="fanguolai">
</p>

<h1 align="center">fanguolai</h1>

<p align="center">
  Skill mushjulets og styreflatens scrolleretning på macOS.
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

macOS har én global bryter for «Naturlig rulling». Slår du den på, føles styreplaten riktig, men mushjulet går feil vei. Slår du den av, er det motsatt. Det finnes ingen innebygd måte å stille dem inn uavhengig av hverandre.

**fanguolai** (翻过来, "snu det") løser dette. Det plasserer seg mellom musen din og macOS, reverserer kun mushjulhendelser og lar styreflatebevegelser passere uendret.

- ~150 KB enkelt binærprogram, ingen avhengigheter
- Per-akse-kontroll (vertikalt / horisontalt)
- Daemon-modus + LaunchAgent for autostart
- Bruker `CGEventTap` under panseret

## Hurtigstart

```bash
# Last ned fra GitHub Releases, eller bygg fra kildekode:
git clone https://github.com/chansigit/fanguolai.git
cd fanguolai && make build
sudo make install

# Kjør det
fanguolai start
```

> **Første kjøring:** macOS vil be om Tilgjengelighet-tillatelse.
> Gi den under **Systeminnstillinger → Personvern og sikkerhet → Tilgjengelighet**.

## Bruk

```bash
fanguolai start              # forgrunn
fanguolai start --daemon     # bakgrunn
fanguolai stop               # stopp daemon
fanguolai status             # vis status og konfigurasjon
```

### Konfigurasjon

```bash
fanguolai config                        # vis gjeldende innstillinger
fanguolai config --vertical reverse     # reverser vertikalt (standard)
fanguolai config --horizontal reverse   # reverser horisontalt også
fanguolai config --lang zh              # bytt grensesnittspråk
```

### Autostart ved innlogging

```bash
fanguolai install     # legg til LaunchAgent
fanguolai uninstall   # fjern LaunchAgent
```

### Feilsøking

```bash
fanguolai start --debug   # skriv ut rå scrollhendelser for diagnose
```

## Slik fungerer det

macOS scrollhendelser bærer et flagg `scrollWheelEventIsContinuous`:

| Verdi | Kilde | fanguolai-handling |
|-------|--------|-----------------|
| `0` | Mushjul (diskret) | Reverser delta |
| `!= 0` | Styreflate (kontinuerlig) | Slipp gjennom |

Reverseringen gjøres ved å fange opp hendelser via `CGEventTap` på sesjonsnivå, kopiere hendelsen med negerte scroll-deltaer og returnere den modifiserte kopien. Styreflatehendelser berøres aldri.

## Konfigurasjonsfil

`~/.config/fanguolai/config.json`

```json
{
  "horizontal": "normal",
  "lang": "en",
  "vertical": "reverse"
}
```

## Endringslogg

**v1.0.1** — Fikset at scrollreversering krevde doble instanser. La til `--debug`-flagg.
**v1.0.0** — Første utgivelse.

Se [CHANGELOG.md](CHANGELOG.md) for detaljer.

## Lisens

[MIT](LICENSE)
