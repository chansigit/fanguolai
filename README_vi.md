<p align="center">
  <img src="logo.svg" width="100" height="100" alt="fanguolai">
</p>

<h1 align="center">fanguolai</h1>

<p align="center">
  Tách biệt hướng cuộn của chuột và trackpad trên macOS.
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

## Vấn đề

macOS chỉ có một nút gạt "Cuộn Tự Nhiên" duy nhất. Bật lên thì trackpad dùng được, nhưng bánh xe chuột lại bị ngược. Tắt đi thì ngược lại. Không có cách nào để thiết lập riêng cho từng thiết bị.

**fanguolai** (翻过来, "lật ngược lại") giải quyết điều này. Nó đứng giữa chuột và macOS, chỉ đảo ngược các sự kiện cuộn của chuột mà không chạm đến các cử chỉ trackpad.

- Tệp nhị phân đơn ~150 KB, không phụ thuộc
- Kiểm soát theo trục (dọc / ngang)
- Chế độ daemon + LaunchAgent để tự khởi động
- Sử dụng `CGEventTap` bên dưới

## Bắt đầu nhanh

```bash
# Tải xuống từ GitHub Releases, hoặc tự biên dịch:
git clone https://github.com/chansigit/fanguolai.git
cd fanguolai && make build
sudo make install

# Chạy thử
fanguolai start
```

> **Lần chạy đầu tiên:** macOS sẽ yêu cầu quyền Trợ Năng.
> Cấp quyền tại **Cài đặt Hệ thống → Quyền riêng tư & Bảo mật → Trợ Năng**.

## Sử dụng

```bash
fanguolai start              # chạy nền trước
fanguolai start --daemon     # chạy nền
fanguolai stop               # dừng daemon
fanguolai status             # hiển thị trạng thái & cấu hình
```

### Cấu hình

```bash
fanguolai config                        # xem cấu hình hiện tại
fanguolai config --vertical reverse     # đảo ngược chiều dọc (mặc định)
fanguolai config --horizontal reverse   # đảo ngược chiều ngang
fanguolai config --lang zh              # chuyển ngôn ngữ giao diện
```

### Tự khởi động khi đăng nhập

```bash
fanguolai install     # thêm LaunchAgent
fanguolai uninstall   # xóa LaunchAgent
```

### Xử lý sự cố

```bash
fanguolai start --debug   # in các sự kiện cuộn thô để chẩn đoán
```

## Cách hoạt động

Các sự kiện cuộn của macOS mang một cờ `scrollWheelEventIsContinuous`:

| Giá trị | Nguồn | Hành động của fanguolai |
|---------|-------|------------------------|
| `0` | Bánh xe chuột (rời rạc) | Đảo ngược delta |
| `!= 0` | Trackpad (liên tục) | Cho qua |

Việc đảo ngược được thực hiện bằng cách chặn sự kiện qua `CGEventTap` ở cấp phiên, sao chép sự kiện với các delta cuộn bị phủ định, rồi trả về bản sao đã chỉnh sửa. Sự kiện trackpad không bao giờ bị chạm đến.

## Tệp cấu hình

`~/.config/fanguolai/config.json`

```json
{
  "horizontal": "normal",
  "lang": "en",
  "vertical": "reverse"
}
```

## Nhật ký thay đổi

**v1.0.1** — Sửa lỗi đảo ngược cuộn cần hai phiên bản. Thêm cờ `--debug`.
**v1.0.0** — Phát hành lần đầu.

Xem [CHANGELOG.md](CHANGELOG.md) để biết chi tiết.

## Giấy phép

[MIT](LICENSE)
