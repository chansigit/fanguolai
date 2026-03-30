<p align="center">
  <img src="logo.svg" width="100" height="100" alt="fanguolai">
</p>

<h1 align="center">fanguolai（翻過嚟）</h1>

<p align="center">
  喺 macOS 上面將滑鼠同觸控板嘅滾動方向分開設定。
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

## 痛點

macOS 得一個「自然滾動」掣，開咗觸控板舒服但滑鼠滾輪就反晒，關咗滾輪正常但觸控板又唔對勁。系統唔畀你分開設定。

**fanguolai**（翻過嚟，即係「反轉佢」）解決呢個問題。佢坐喺你嘅滑鼠同 macOS 之間，只係反轉滑鼠嘅滾動事件，觸控板手勢完全唔受影響。

- 單一執行檔約 ~150 KB，冇依賴
- 垂直／水平方向獨立控制
- Daemon 模式 + LaunchAgent 開機自啟
- 底層使用 `CGEventTap`

## 快速開始

```bash
# 從 GitHub Releases 下載，或者從源碼編譯：
git clone https://github.com/chansigit/fanguolai.git
cd fanguolai && make build
sudo make install

# 啟動
fanguolai start
```

> **第一次運行：** macOS 會彈出要求輔助使用權限嘅提示。
> 喺 **系統設定 → 私隱與安全性 → 輔助使用** 入面批准佢。

## 用法

```bash
fanguolai start              # 前台運行
fanguolai start --daemon     # 背景運行
fanguolai stop               # 停止 daemon
fanguolai status             # 睇狀態同設定
```

### 設定

```bash
fanguolai config                        # 睇現時設定
fanguolai config --vertical reverse     # 反轉垂直方向（預設）
fanguolai config --horizontal reverse   # 連水平方向都反轉
fanguolai config --lang zh              # 切換介面語言
```

### 開機自動啟動

```bash
fanguolai install     # 加入 LaunchAgent
fanguolai uninstall   # 移除 LaunchAgent
```

### 排查問題

```bash
fanguolai start --debug   # 打印原始滾動事件，方便診斷
```

## 工作原理

macOS 滾動事件帶有一個 `scrollWheelEventIsContinuous` 標誌：

| 值 | 來源 | fanguolai 處理方式 |
|-------|--------|-----------------|
| `0` | 滑鼠滾輪（離散） | 反轉 delta |
| `!= 0` | 觸控板（連續） | 直接放行 |

反轉係透過 `CGEventTap` 喺 session 層攔截事件，複製事件並取反滾動值，然後返回修改後嘅副本。觸控板事件從來唔會被碰到。

## 設定檔

`~/.config/fanguolai/config.json`

```json
{
  "horizontal": "normal",
  "lang": "en",
  "vertical": "reverse"
}
```

## 更新日誌

**v1.0.1** — 修復需要啟動兩個實例先至生效嘅問題，新增 `--debug` 參數。
**v1.0.0** — 首次發佈。

詳見 [CHANGELOG.md](CHANGELOG.md)。

## 授權條款

[MIT](LICENSE)
