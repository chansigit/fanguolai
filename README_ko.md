<p align="center">
  <img src="logo.svg" width="100" height="100" alt="fanguolai">
</p>

<h1 align="center">fanguolai（翻过来）</h1>

<p align="center">
  마우스와 트랙패드의 스크롤 방향을 따로 설정하세요.
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

## 문제점

macOS에는 「자연스러운 스크롤」 토글이 하나뿐입니다. 켜면 트랙패드는 편하지만 마우스 휠이 반대로 돌아가고, 끄면 휠은 정상이지만 트랙패드가 어색해집니다. 시스템에서 따로 설정하는 방법이 없습니다.

**fanguolai** 가 이 문제를 해결합니다 — 마우스 스크롤 이벤트를 가로채 방향을 반전하고, 트랙패드는 전혀 건드리지 않습니다.

- 단일 바이너리 ~150 KB, 의존성 없음
- 수직/수평 방향 독립 제어
- 백그라운드 실행 + 로그인 자동 시작 지원
- 내부적으로 `CGEventTap` 사용

## 빠른 시작

```bash
# GitHub Releases에서 다운로드하거나 소스에서 빌드:
git clone https://github.com/chansigit/fanguolai.git
cd fanguolai && make build
sudo make install

# 실행
fanguolai start
```

> **첫 실행 시:** macOS가 손쉬운 사용 권한을 요청합니다.
> **시스템 설정 → 개인 정보 보호 및 보안 → 손쉬운 사용**에서 허용하세요.

## 사용법

```bash
fanguolai start              # 포그라운드 실행
fanguolai start --daemon     # 백그라운드 실행
fanguolai stop               # 데몬 중지
fanguolai status             # 상태 및 설정 확인
```

### 설정

```bash
fanguolai config                        # 현재 설정 보기
fanguolai config --vertical reverse     # 수직 반전（기본값）
fanguolai config --horizontal reverse   # 수평도 반전
fanguolai config --lang zh              # CLI 언어 변경
```

### 로그인 자동 시작

```bash
fanguolai install     # LaunchAgent 추가
fanguolai uninstall   # LaunchAgent 제거
```

### 문제 해결

```bash
fanguolai start --debug   # 원시 스크롤 이벤트 출력으로 진단
```

## 작동 원리

macOS 스크롤 이벤트에는 `scrollWheelEventIsContinuous` 플래그가 있습니다:

| 값 | 소스 | fanguolai 처리 |
|-------|--------|-----------------|
| `0` | 마우스 휠（이산） | delta 반전 |
| `!= 0` | 트랙패드（연속） | 그대로 통과 |

`CGEventTap`을 통해 세션 수준에서 이벤트를 가로채고, 스크롤 delta를 반전한 복사본을 반환합니다. 트랙패드 이벤트는 절대 수정하지 않습니다.

## 설정 파일

`~/.config/fanguolai/config.json`

```json
{
  "horizontal": "normal",
  "lang": "en",
  "vertical": "reverse"
}
```

## 변경 이력

**v1.0.1** — 두 개의 인스턴스가 필요하던 스크롤 반전 버그 수정. `--debug` 플래그 추가.
**v1.0.0** — 최초 릴리스.

전체 변경 이력: [CHANGELOG.md](CHANGELOG.md)

## 라이선스

[MIT](LICENSE)
