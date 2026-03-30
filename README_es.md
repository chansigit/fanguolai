<p align="center">
  <img src="logo.svg" width="100" height="100" alt="fanguolai">
</p>

<h1 align="center">fanguolai</h1>

<p align="center">
  Desacopla las direcciones de desplazamiento del ratón y el trackpad en macOS.
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

macOS tiene un único interruptor global de "Desplazamiento Natural". Actívalo y el trackpad se siente bien, pero la rueda del ratón va al revés. Desactívalo y ocurre lo contrario. No hay forma nativa de configurarlos de forma independiente.

**fanguolai** (翻过来, "dale la vuelta") soluciona esto. Se interpone entre tu ratón y macOS, invirtiendo solo los eventos de desplazamiento del ratón sin tocar los gestos del trackpad.

- Binario único de ~150 KB, sin dependencias
- Control por eje (vertical / horizontal)
- Modo daemon + LaunchAgent para inicio automático
- Usa `CGEventTap` internamente

## Inicio rápido

```bash
# Descarga desde GitHub Releases, o compila desde el código fuente:
git clone https://github.com/chansigit/fanguolai.git
cd fanguolai && make build
sudo make install

# Ejecútalo
fanguolai start
```

> **Primera ejecución:** macOS solicitará permiso de Accesibilidad.
> Concédelo en **Ajustes del Sistema → Privacidad y Seguridad → Accesibilidad**.

## Uso

```bash
fanguolai start              # primer plano
fanguolai start --daemon     # segundo plano
fanguolai stop               # detener daemon
fanguolai status             # mostrar estado y configuración
```

### Configuración

```bash
fanguolai config                        # mostrar configuración actual
fanguolai config --vertical reverse     # invertir vertical (por defecto)
fanguolai config --horizontal reverse   # invertir horizontal también
fanguolai config --lang zh              # cambiar idioma de la interfaz
```

### Inicio automático al iniciar sesión

```bash
fanguolai install     # añadir LaunchAgent
fanguolai uninstall   # eliminar LaunchAgent
```

### Solución de problemas

```bash
fanguolai start --debug   # imprimir eventos de desplazamiento en bruto para diagnóstico
```

## Cómo funciona

Los eventos de desplazamiento de macOS llevan un indicador `scrollWheelEventIsContinuous`:

| Valor | Origen | Acción de fanguolai |
|-------|--------|---------------------|
| `0` | Rueda del ratón (discreta) | Invertir delta |
| `!= 0` | Trackpad (continuo) | Dejar pasar |

La inversión se realiza interceptando eventos mediante `CGEventTap` a nivel de sesión, copiando el evento con los deltas de desplazamiento negados y devolviendo la copia modificada. Los eventos del trackpad nunca se tocan.

## Archivo de configuración

`~/.config/fanguolai/config.json`

```json
{
  "horizontal": "normal",
  "lang": "en",
  "vertical": "reverse"
}
```

## Registro de cambios

**v1.0.1** — Corregida la inversión de desplazamiento que requería dos instancias. Añadido el indicador `--debug`.
**v1.0.0** — Versión inicial.

Ver [CHANGELOG.md](CHANGELOG.md) para más detalles.

## Licencia

[MIT](LICENSE)
