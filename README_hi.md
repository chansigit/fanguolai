<p align="center">
  <img src="logo.svg" width="100" height="100" alt="fanguolai">
</p>

<h1 align="center">fanguolai</h1>

<p align="center">
  macOS पर माउस और ट्रैकपैड की स्क्रॉल दिशाओं को अलग-अलग नियंत्रित करें।
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

## समस्या

macOS में "नैचुरल स्क्रॉलिंग" का एक ही वैश्विक टॉगल है। इसे चालू करें तो ट्रैकपैड सही लगता है, लेकिन माउस व्हील उल्टी दिशा में चलती है। बंद करें तो उल्टा होता है। दोनों को अलग-अलग सेट करने का कोई बिल्ट-इन तरीका नहीं है।

**fanguolai** (翻过来, "पलट दो") यही ठीक करता है। यह आपके माउस और macOS के बीच बैठता है, केवल माउस स्क्रॉल इवेंट को पलटता है और ट्रैकपैड जेस्चर को बिल्कुल अछूता छोड़ता है।

- ~150 KB एकल बाइनरी, कोई डिपेंडेंसी नहीं
- प्रति-अक्ष नियंत्रण (वर्टिकल / हॉरिज़ॉन्टल)
- Daemon मोड + ऑटोस्टार्ट के लिए LaunchAgent
- अंदर से `CGEventTap` का उपयोग करता है

## त्वरित शुरुआत

```bash
# GitHub Releases से डाउनलोड करें, या सोर्स से बिल्ड करें:
git clone https://github.com/chansigit/fanguolai.git
cd fanguolai && make build
sudo make install

# चलाएं
fanguolai start
```

> **पहली बार चलाने पर:** macOS Accessibility अनुमति माँगेगा।
> **System Settings → Privacy & Security → Accessibility** में अनुमति दें।

## उपयोग

```bash
fanguolai start              # फोरग्राउंड
fanguolai start --daemon     # बैकग्राउंड
fanguolai stop               # daemon रोकें
fanguolai status             # स्थिति और कॉन्फ़िग दिखाएं
```

### कॉन्फ़िगरेशन

```bash
fanguolai config                        # वर्तमान सेटिंग्स दिखाएं
fanguolai config --vertical reverse     # वर्टिकल पलटें (डिफ़ॉल्ट)
fanguolai config --horizontal reverse   # हॉरिज़ॉन्टल भी पलटें
fanguolai config --lang zh              # CLI भाषा बदलें
```

### लॉगिन पर ऑटोस्टार्ट

```bash
fanguolai install     # LaunchAgent जोड़ें
fanguolai uninstall   # LaunchAgent हटाएं
```

### समस्या निवारण

```bash
fanguolai start --debug   # डायग्नोसिस के लिए कच्चे स्क्रॉल इवेंट प्रिंट करें
```

## यह कैसे काम करता है

macOS स्क्रॉल इवेंट में एक `scrollWheelEventIsContinuous` फ्लैग होता है:

| मान | स्रोत | fanguolai की कार्रवाई |
|-----|-------|----------------------|
| `0` | माउस व्हील (असतत) | Delta पलटें |
| `!= 0` | ट्रैकपैड (सतत) | आगे जाने दें |

इवेंट को `CGEventTap` के ज़रिए सेशन स्तर पर इंटरसेप्ट किया जाता है, स्क्रॉल डेल्टा को नकारात्मक करके कॉपी बनाई जाती है, और संशोधित कॉपी वापस की जाती है। ट्रैकपैड इवेंट कभी नहीं छुए जाते।

## कॉन्फ़िग फ़ाइल

`~/.config/fanguolai/config.json`

```json
{
  "horizontal": "normal",
  "lang": "en",
  "vertical": "reverse"
}
```

## परिवर्तन लॉग

**v1.0.1** — स्क्रॉल रिवर्सल के लिए दो इंस्टेंस की ज़रूरत ठीक की। `--debug` फ्लैग जोड़ा।
**v1.0.0** — प्रारंभिक रिलीज़।

विवरण के लिए [CHANGELOG.md](CHANGELOG.md) देखें।

## लाइसेंस

[MIT](LICENSE)
