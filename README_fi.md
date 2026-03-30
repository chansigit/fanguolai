<p align="center">
  <img src="logo.svg" width="100" height="100" alt="fanguolai">
</p>

<h1 align="center">fanguolai</h1>

<p align="center">
  Erota hiiren ja ohjauslevyn vierityssuunnat macOS:ssa.
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

## Ongelma

macOS:ssa on yksi yhteinen "Luonnollinen vieritys" -asetus. Kun se on päällä, ohjauslevy tuntuu oikealta mutta hiiren vierityspyörä menee väärään suuntaan. Kun se on pois päältä, tilanne on päinvastainen. Järjestelmä ei tarjoa tapaa asettaa niitä erikseen.

**fanguolai** (翻过来, "käännä se") ratkaisee tämän. Se asettuu hiiren ja macOS:n väliin ja kääntää ainoastaan hiiren vieritystapahtumat jättäen ohjauslevyn eleet täysin koskemattomiksi.

- ~150 KB yksittäinen binääri, ei riippuvuuksia
- Akselikohtainen hallinta (pysty / vaaka)
- Taustaprosessitila + LaunchAgent automaattikäynnistykseen
- Käyttää `CGEventTap`-rajapintaa

## Pikaopas

```bash
# Lataa GitHub Releases -sivulta tai käännä lähdekoodista:
git clone https://github.com/chansigit/fanguolai.git
cd fanguolai && make build
sudo make install

# Käynnistä
fanguolai start
```

> **Ensimmäinen käynnistys:** macOS pyytää Helppokäyttöisyys-lupaa.
> Myönnä se kohdassa **Järjestelmäasetukset → Tietoturva ja yksityisyys → Helppokäyttöisyys**.

## Käyttö

```bash
fanguolai start              # etuala
fanguolai start --daemon     # tausta
fanguolai stop               # pysäytä taustaprosessi
fanguolai status             # näytä tila ja asetukset
```

### Asetukset

```bash
fanguolai config                        # show current settings
fanguolai config --vertical reverse     # reverse vertical (default)
fanguolai config --horizontal reverse   # reverse horizontal too
fanguolai config --lang zh              # switch CLI language
```

### Automaattinen käynnistys kirjautumisen yhteydessä

```bash
fanguolai install     # add LaunchAgent
fanguolai uninstall   # remove LaunchAgent
```

### Vianmääritys

```bash
fanguolai start --debug   # print raw scroll events for diagnosis
```

## Toimintaperiaate

macOS:n vieritystapahtumat sisältävät `scrollWheelEventIsContinuous`-lipun:

| Arvo | Lähde | fanguolai-toiminto |
|------|-------|-------------------|
| `0` | Hiiren vierityspyörä (erillinen) | Käännä delta |
| `!= 0` | Ohjauslevy (jatkuva) | Läpäise muuttumattomana |

Kääntäminen tapahtuu sieppaamalla tapahtumat `CGEventTap`-rajapinnan kautta istuntotasolla, kopioimalla tapahtuma negoiduilla vieritysdeltailla ja palauttamalla muokattu kopio. Ohjauslevyn tapahtumiin ei kosketa koskaan.

## Asetustiedosto

`~/.config/fanguolai/config.json`

```json
{
  "horizontal": "normal",
  "lang": "en",
  "vertical": "reverse"
}
```

## Muutosloki

**v1.0.1** — Korjattu vierityksen kääntäminen, joka vaati kaksi instanssia. Lisätty `--debug`-lippu.
**v1.0.0** — Ensimmäinen julkaisu.

Katso [CHANGELOG.md](CHANGELOG.md) lisätietoja varten.

## Lisenssi

[MIT](LICENSE)
