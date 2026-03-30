<p align="center">
  <img src="logo.svg" width="100" height="100" alt="fanguolai">
</p>

<h1 align="center">fanguolai</h1>

<p align="center">
  Разделить направление прокрутки мыши и трекпада в macOS.
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

## Проблема

В macOS есть единственный глобальный переключатель «Естественная прокрутка». Включите его — трекпад работает правильно, но колесо мыши крутится в обратную сторону. Выключите — наоборот. Настроить их независимо встроенными средствами невозможно.

**fanguolai** (翻过来, «перевернуть») решает эту задачу. Программа встаёт между мышью и macOS и переворачивает только события прокрутки колеса мыши, оставляя жесты трекпада нетронутыми.

- ~150 КБ, один файл, без зависимостей
- Раздельное управление по осям (вертикаль / горизонталь)
- Режим демона + LaunchAgent для автозапуска
- Работает через `CGEventTap`

## Быстрый старт

```bash
# Скачайте с GitHub Releases или соберите из исходников:
git clone https://github.com/chansigit/fanguolai.git
cd fanguolai && make build
sudo make install

# Запустите
fanguolai start
```

> **Первый запуск:** macOS запросит разрешение на доступ к специальным возможностям.
> Выдайте его в **Системные настройки → Конфиденциальность и безопасность → Специальные возможности**.

## Использование

```bash
fanguolai start              # на переднем плане
fanguolai start --daemon     # в фоне
fanguolai stop               # остановить демон
fanguolai status             # показать статус и конфигурацию
```

### Настройка

```bash
fanguolai config                        # показать текущие настройки
fanguolai config --vertical reverse     # инвертировать вертикальную прокрутку (по умолчанию)
fanguolai config --horizontal reverse   # инвертировать также горизонтальную прокрутку
fanguolai config --lang zh              # сменить язык интерфейса CLI
```

### Автозапуск при входе

```bash
fanguolai install     # добавить LaunchAgent
fanguolai uninstall   # удалить LaunchAgent
```

### Диагностика

```bash
fanguolai start --debug   # выводить сырые события прокрутки для анализа
```

## Принцип работы

События прокрутки macOS содержат флаг `scrollWheelEventIsContinuous`:

| Значение | Источник | Действие fanguolai |
|----------|----------|--------------------|
| `0` | Колесо мыши (дискретное) | Инвертировать delta |
| `!= 0` | Трекпад (непрерывное) | Пропустить без изменений |

Инверсия выполняется путём перехвата событий через `CGEventTap` на уровне сессии, копирования события с инвертированными значениями прокрутки и возврата изменённой копии. События трекпада никогда не затрагиваются.

## Файл конфигурации

`~/.config/fanguolai/config.json`

```json
{
  "horizontal": "normal",
  "lang": "en",
  "vertical": "reverse"
}
```

## История изменений

**v1.0.1** — Исправлена ошибка, из-за которой для работы инверсии требовалось два экземпляра. Добавлен флаг `--debug`.
**v1.0.0** — Первый выпуск.

Подробности в [CHANGELOG.md](CHANGELOG.md).

## Лицензия

[MIT](LICENSE)
