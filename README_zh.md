<p align="center">
  <img src="logo.svg" width="100" height="100" alt="fanguolai">
</p>

<h1 align="center">fanguolai（翻过来）</h1>

<p align="center">
  让鼠标和触控板的滚动方向各走各的。
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

## 痛点

macOS 只有一个「自然滚动」开关，开了触控板舒服但鼠标滚轮就反了，关了滚轮正常触控板又别扭。系统不让你分开设置。

**fanguolai** 解决这个问题 — 拦截鼠标滚轮事件并反转方向，触控板完全不受影响。

- 单文件 ~150 KB，无依赖
- 垂直/水平方向独立控制
- 支持后台运行 + 开机自启
- 底层基于 `CGEventTap`

## 快速开始

```bash
# 从 GitHub Releases 下载，或从源码编译：
git clone https://github.com/chansigit/fanguolai.git
cd fanguolai && make build
sudo make install

# 启动
fanguolai start
```

> **首次运行**需要授予辅助功能权限：**系统设置 → 隐私与安全性 → 辅助功能**

## 用法

```bash
fanguolai start              # 前台运行
fanguolai start --daemon     # 后台运行
fanguolai stop               # 停止
fanguolai status             # 查看状态
```

### 配置

```bash
fanguolai config                        # 查看当前配置
fanguolai config --vertical reverse     # 反转垂直方向（默认）
fanguolai config --horizontal reverse   # 反转水平方向
fanguolai config --lang en              # 切换界面语言
```

### 开机自启

```bash
fanguolai install     # 安装 LaunchAgent
fanguolai uninstall   # 卸载 LaunchAgent
```

### 排查问题

```bash
fanguolai start --debug   # 打印原始滚动事件，方便诊断
```

## 原理

macOS 滚动事件有一个 `scrollWheelEventIsContinuous` 标志位：

| 值 | 来源 | fanguolai 处理 |
|----|------|---------------|
| `0` | 鼠标滚轮（离散） | 反转 delta |
| `!= 0` | 触控板（连续） | 直接放行 |

通过 `CGEventTap` 在 session 层拦截事件，复制后取反滚动值，返回修改后的副本。触控板事件从不修改。

## 配置文件

`~/.config/fanguolai/config.json`

```json
{
  "horizontal": "normal",
  "lang": "zh",
  "vertical": "reverse"
}
```

## 更新日志

**v1.0.1** — 修复需要启动两个实例才能生效的问题，新增 `--debug` 参数。
**v1.0.0** — 首次发布。

详见 [CHANGELOG.md](CHANGELOG.md)。

## 许可证

[MIT](LICENSE)
