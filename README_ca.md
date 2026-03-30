<p align="center">
  <img src="logo.svg" width="100" height="100" alt="fanguolai">
</p>

<h1 align="center">fanguolai</h1>

<p align="center">
  Desacobla les direccions de desplaçament del ratolí i el trackpad a macOS.
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

## El problema

macOS té un únic commutador global de "Desplaçament natural". Si l'actives, el trackpad funciona bé però la roda del ratolí va al revés. Si el desactives, passa el contrari. No hi ha cap manera integrada de configurar-los de manera independent.

**fanguolai** (翻过来, "gira-ho") ho soluciona. S'interposa entre el ratolí i macOS, invertint només els esdeveniments de desplaçament del ratolí i deixant els gestos del trackpad intactes.

- ~150 KB binari únic, sense dependències
- Control per eix (vertical / horitzontal)
- Mode dimoni + LaunchAgent per a l'inici automàtic
- Utilitza `CGEventTap` internament

## Inici ràpid

```bash
# Descarrega des de GitHub Releases, o compila des del codi font:
git clone https://github.com/chansigit/fanguolai.git
cd fanguolai && make build
sudo make install

# Executa'l
fanguolai start
```

> **Primera execució:** macOS demanarà el permís d'Accessibilitat.
> Concedeix-lo a **Configuració del sistema → Privadesa i seguretat → Accessibilitat**.

## Ús

```bash
fanguolai start              # primer pla
fanguolai start --daemon     # segon pla
fanguolai stop               # atura el dimoni
fanguolai status             # mostra l'estat i la configuració
```

### Configuració

```bash
fanguolai config                        # show current settings
fanguolai config --vertical reverse     # reverse vertical (default)
fanguolai config --horizontal reverse   # reverse horizontal too
fanguolai config --lang zh              # switch CLI language
```

### Inici automàtic en iniciar sessió

```bash
fanguolai install     # add LaunchAgent
fanguolai uninstall   # remove LaunchAgent
```

### Resolució de problemes

```bash
fanguolai start --debug   # print raw scroll events for diagnosis
```

## Com funciona

Els esdeveniments de desplaçament de macOS porten un indicador `scrollWheelEventIsContinuous`:

| Valor | Origen | Acció de fanguolai |
|-------|--------|-------------------|
| `0` | Roda del ratolí (discret) | Inverteix el delta |
| `!= 0` | Trackpad (continu) | Deixa passar |

La inversió es fa interceptant esdeveniments via `CGEventTap` a nivell de sessió, copiant l'esdeveniment amb els deltes de desplaçament negats i retornant la còpia modificada. Els esdeveniments del trackpad no es toquen mai.

## Fitxer de configuració

`~/.config/fanguolai/config.json`

```json
{
  "horizontal": "normal",
  "lang": "en",
  "vertical": "reverse"
}
```

## Registre de canvis

**v1.0.1** — Corregida la inversió del desplaçament que requeria dues instàncies. Afegida l'opció `--debug`.
**v1.0.0** — Llançament inicial.

Vegeu [CHANGELOG.md](CHANGELOG.md) per a més detalls.

## Llicència

[MIT](LICENSE)
