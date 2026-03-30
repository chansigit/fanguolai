<p align="center">
  <img src="logo.svg" width="100" height="100" alt="fanguolai">
</p>

<h1 align="center">fanguolai</h1>

<p align="center">
  Dissocier les directions de défilement de la souris et du trackpad sous macOS.
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

## Le problème

macOS ne dispose que d'un seul bouton global « Défilement naturel ». Activez-le et votre trackpad se comporte correctement, mais la molette de votre souris tourne dans le mauvais sens. Désactivez-le, c'est l'inverse. Il n'existe aucun moyen natif de les configurer indépendamment.

**fanguolai** (翻过来, « retourner ») règle ce problème. Il s'intercale entre votre souris et macOS, n'inversant que les événements de défilement de la molette, sans jamais toucher aux gestes du trackpad.

- ~150 Ko, binaire unique, sans dépendances
- Contrôle par axe (vertical / horizontal)
- Mode démon + LaunchAgent pour le démarrage automatique
- Utilise `CGEventTap` en coulisse

## Démarrage rapide

```bash
# Téléchargez depuis GitHub Releases, ou compilez depuis les sources :
git clone https://github.com/chansigit/fanguolai.git
cd fanguolai && make build
sudo make install

# Lancez-le
fanguolai start
```

> **Premier lancement :** macOS demandera la permission d'Accessibilité.
> Accordez-la dans **Réglages Système → Confidentialité et sécurité → Accessibilité**.

## Utilisation

```bash
fanguolai start              # premier plan
fanguolai start --daemon     # arrière-plan
fanguolai stop               # arrêter le démon
fanguolai status             # afficher le statut et la configuration
```

### Configuration

```bash
fanguolai config                        # afficher les paramètres actuels
fanguolai config --vertical reverse     # inverser le défilement vertical (par défaut)
fanguolai config --horizontal reverse   # inverser aussi le défilement horizontal
fanguolai config --lang zh              # changer la langue de l'interface CLI
```

### Démarrage automatique à la connexion

```bash
fanguolai install     # ajouter le LaunchAgent
fanguolai uninstall   # supprimer le LaunchAgent
```

### Dépannage

```bash
fanguolai start --debug   # afficher les événements de défilement bruts pour le diagnostic
```

## Fonctionnement

Les événements de défilement macOS portent un indicateur `scrollWheelEventIsContinuous` :

| Valeur | Source | Action de fanguolai |
|--------|--------|---------------------|
| `0` | Molette de souris (discrète) | Inverser le delta |
| `!= 0` | Trackpad (continu) | Laisser passer |

L'inversion est réalisée en interceptant les événements via `CGEventTap` au niveau de la session, en copiant l'événement avec des deltas de défilement inversés, puis en retournant la copie modifiée. Les événements du trackpad ne sont jamais touchés.

## Fichier de configuration

`~/.config/fanguolai/config.json`

```json
{
  "horizontal": "normal",
  "lang": "en",
  "vertical": "reverse"
}
```

## Journal des modifications

**v1.0.1** — Correction du bug nécessitant deux instances pour que l'inversion fonctionne. Ajout de l'option `--debug`.
**v1.0.0** — Première version.

Voir [CHANGELOG.md](CHANGELOG.md) pour les détails.

## Licence

[MIT](LICENSE)
