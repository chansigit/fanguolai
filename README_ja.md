<p align="center">
  <img src="logo.svg" width="100" height="100" alt="fanguolai">
</p>

<h1 align="center">fanguolai（翻过来）</h1>

<p align="center">
  マウスとトラックパッドのスクロール方向を独立して設定。
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

## 問題点

macOS には「ナチュラルスクロール」のトグルがひとつしかありません。オンにするとトラックパッドは快適ですがマウスホイールが逆になり、オフにするとホイールは正常でもトラックパッドが不自然になります。個別に設定する方法はありません。

**fanguolai** がこの問題を解決します — マウスのスクロールイベントだけを横断して方向を反転し、トラックパッドには一切触れません。

- 単一バイナリ ~150 KB、依存なし
- 垂直・水平方向を独立制御
- バックグラウンド実行 + ログイン時の自動起動
- 内部で `CGEventTap` を使用

## クイックスタート

```bash
# GitHub Releases からダウンロード、またはソースからビルド:
git clone https://github.com/chansigit/fanguolai.git
cd fanguolai && make build
sudo make install

# 起動
fanguolai start
```

> **初回起動時:** macOS がアクセシビリティの許可を求めます。
> **システム設定 → プライバシーとセキュリティ → アクセシビリティ** で許可してください。

## 使い方

```bash
fanguolai start              # フォアグラウンド
fanguolai start --daemon     # バックグラウンド
fanguolai stop               # デーモン停止
fanguolai status             # 状態と設定を確認
```

### 設定

```bash
fanguolai config                        # 現在の設定を確認
fanguolai config --vertical reverse     # 垂直を反転（デフォルト）
fanguolai config --horizontal reverse   # 水平も反転
fanguolai config --lang zh              # CLI 言語を切り替え
```

### ログイン時の自動起動

```bash
fanguolai install     # LaunchAgent を追加
fanguolai uninstall   # LaunchAgent を削除
```

### トラブルシューティング

```bash
fanguolai start --debug   # 生のスクロールイベントを出力して診断
```

## 仕組み

macOS のスクロールイベントには `scrollWheelEventIsContinuous` フラグがあります:

| 値 | ソース | fanguolai の処理 |
|-------|--------|-----------------|
| `0` | マウスホイール（離散） | delta を反転 |
| `!= 0` | トラックパッド（連続） | そのまま通過 |

`CGEventTap` を通じてセッションレベルでイベントを横断し、スクロール delta を反転したコピーを返します。トラックパッドのイベントは一切変更しません。

## 設定ファイル

`~/.config/fanguolai/config.json`

```json
{
  "horizontal": "normal",
  "lang": "en",
  "vertical": "reverse"
}
```

## 変更履歴

**v1.0.1** — 2 つのインスタンスが必要だったスクロール反転のバグを修正。`--debug` フラグを追加。
**v1.0.0** — 初回リリース。

完全な変更履歴: [CHANGELOG.md](CHANGELOG.md)

## ライセンス

[MIT](LICENSE)
