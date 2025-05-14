# 🌐 WARP Config Generator | تولیدکننده پیکربندی WARP

<div dir="rtl">

![Visitor Count](https://komarev.com/ghpvc/?username=Argh94&repo=Wg-script&label=بازدید)
![Version](https://img.shields.io/badge/نسخه-1.0.0-orange.svg)
![Termux](https://img.shields.io/badge/Termux-سازگار-green.svg)
![License](https://img.shields.io/badge/لایسنس-MIT-blue.svg)
[![GitHub Stars](https://img.shields.io/github/stars/Argh94/Wg-script?style=flat-square)](https://github.com/Argh94/Wg-script/stargazers)


## 📌 معرفی
یک اسکریپت قدرتمند و کاربردی برای تولید خودکار پیکربندی‌های WARP با پشتیبانی از پروتکل WireGuard. این اسکریپت برای استفاده در Termux بهینه‌سازی شده و قابلیت تولید پیکربندی برای کلاینت‌های مختلف VPN را دارد.

## ✨ ویژگی‌های اصلی

### 🔰 پشتیبانی از چندین کلاینت
- AmneziaVPN با تنظیمات بهینه
- WireGuard (فرمت استاندارد)
- Hiddify (با پیکربندی JSON پیشرفته)
- V2RayNG (با قابلیت‌های روتینگ پیشرفته)
- پشتیبانی از URL WireGuard

### 🛠 قابلیت‌های فنی
- پشتیبانی از IPv4 و IPv6
- تنظیم MTU سفارشی
- تولید خودکار حساب WARP
- پیکربندی DNS پیشرفته
- مدیریت Reserved Address
- بهینه‌سازی اتصال

### 💡 ویژگی‌های کاربردی
- رابط کاربری تعاملی و رنگی
- نشانگر پیشرفت عملیات
- نصب دائمی با دستور `Arg`
- ذخیره خودکار پیکربندی‌ها
- مدیریت خطای هوشمند

## ⚙️ پیش‌نیازها
- نصب Termux
- اتصال به اینترنت
- بسته `curl` (نصب خودکار)

## 📥 نصب و راه‌اندازی

### نصب سریع
</div>

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/Argh94/Wg-script/main/Wg.sh)
```

<div dir="rtl">

### نصب دائمی
1. اجرای اسکریپت
2. انتخاب گزینه 5
3. استفاده با دستور `Arg`

## 🚀 نحوه استفاده

### گزینه‌های اصلی
1. دریافت نقطه پایانی IPv4
2. دریافت نقطه پایانی IPv6
3. تولید پیکربندی IPv4
4. تولید پیکربندی IPv6
5. نصب دائمی اسکریپت

### تنظیمات پیکربندی
- MTU قابل تنظیم (پیش‌فرض: 1280)
- نام سفارشی برای پیکربندی
- DNS‌های Cloudflare
  - IPv4: 1.1.1.1, 1.0.0.1
  - IPv6: 2606:4700:4700::1111, 2606:4700:4700::1001

## 📋 خروجی‌ها
- پیکربندی AmneziaVPN
- پیکربندی WireGuard
- پیکربندی JSON برای Hiddify
- پیکربندی JSON برای V2RayNG
- URL WireGuard

## 🔒 ویژگی‌های امنیتی
- تولید کلید امن
- پیاده‌سازی Reserved Address
- پشتیبانی از MTU سفارشی
- مکانیزم‌های ضد شناسایی
- تنظیمات مخفی‌سازی ترافیک

## 🌟 قابلیت‌های پیشرفته

### ویژگی‌های V2RayNG
- روتینگ DNS سفارشی
- مسدودسازی تبلیغات
- قوانین روتینگ ویژه ایران
- پشتیبانی از پروتکل‌های متعدد
- بهینه‌سازی ترافیک

### ویژگی‌های Hiddify
- تولید بسته‌های جعلی
- اندازه‌گذاری سفارشی بسته‌ها
- پیاده‌سازی تأخیر
- پشتیبانی از حالت‌های مختلف

## 📞 ارتباط با ما
- GitHub: [@Argh94](https://github.com/Argh94)
- مخزن پروژه: [Wg-script](https://github.com/Argh94/Wg-script)

## 📄 مجوز
این پروژه تحت مجوز MIT منتشر شده است.

</div>
# 🌐 WARP Config Generator

[![GitHub Stars](https://img.shields.io/github/stars/Argh94/Wg-script?style=flat-square)](https://github.com/Argh94/Wg-script/stargazers)
[![GitHub Forks](https://img.shields.io/github/forks/Argh94/Wg-script?style=flat-square)](https://github.com/Argh94/Wg-script/network/members)
[![GitHub Issues](https://img.shields.io/github/issues/Argh94/Wg-script?style=flat-square)](https://github.com/Argh94/Wg-script/issues)
[![GitHub License](https://img.shields.io/github/license/Argh94/Wg-script?style=flat-square)](https://github.com/Argh94/Wg-script/blob/main/LICENSE)

A powerful and versatile Bash script for generating WARP configurations across multiple platforms. This tool supports various VPN clients including WireGuard, AmneziaVPN, Hiddify, and V2RayNG.

## 🚀 Features

- Multiple Configuration Formats:
  - WireGuard Standard Config
  - AmneziaVPN Config
  - Hiddify JSON Config
  - V2RayNG JSON Config
  - WireGuard URL Format

- Advanced Functionality:
  - IPv4 & IPv6 Endpoint Support
  - Customizable MTU Settings
  - Dynamic WARP Account Generation
  - Reserved Address Management
  - Custom DNS Configuration
  - Automatic Account Registration

- User Experience:
  - Interactive CLI Interface
  - Color-coded Output
  - Progress Indicators
  - Automatic Save Feature
  - Permanent Installation Option

## 📋 Prerequisites

- Termux (Android) or Bash-compatible environment
- Internet connection
- curl package

## 🔧 Installation

### Quick Install
```bash
curl -fsSL https://raw.githubusercontent.com/Argh94/Wg-script/main/Wg.sh -o warp.sh
chmod +x warp.sh
```

### Permanent Installation
Run the script and select option 5 to install permanently. This will:
- Create a ~/.argh94 directory
- Add an 'Arg' command alias to your shell
- Set up auto-completion (if available)

## 💻 Usage

1. **Basic Execution:**
```bash
./warp.sh
```

2. **After Permanent Installation:**
```bash
Arg
```

3. **Available Options:**
   - `1` - Get WARP IPv4 Endpoint
   - `2` - Get WARP IPv6 Endpoint
   - `3` - Generate IPv4 Config
   - `4` - Generate IPv6 Config
   - `5` - Install Script Permanently
   - `q` - Quit

## ⚙️ Configuration Options

- **MTU Size:** Customize the MTU value (default: 1280)
- **Configuration Name:** Set a custom name for your configs
- **DNS Settings:** Uses Cloudflare DNS by default
  - IPv4: 1.1.1.1, 1.0.0.1
  - IPv6: 2606:4700:4700::1111, 2606:4700:4700::1001

## 📝 Output Files

The script generates a comprehensive configuration file containing:
- AmneziaVPN Configuration
- WireGuard Configuration
- Hiddify JSON Configuration
- V2RayNG JSON Configuration
- WireGuard URL

Files are saved as: `warp_config_YYYY-MM-DD_HH-MM-SS.txt`

## 🔒 Security Features

- Secure Key Generation
- Reserved Address Implementation
- Custom MTU Support
- Anti-Detection Mechanisms
- Traffic Obfuscation Settings

## 🌟 Advanced Features

### V2RayNG Specific Features
- Custom DNS Routing
- Ad Blocking Integration
- Iran-specific Routing Rules
- Multiple Protocol Support
- Traffic Optimization

### Hiddify Specific Features
- Fake Packet Generation
- Custom Packet Sizing
- Delay Implementation
- Multiple Mode Support

## 🤝 Contributing

Contributions are welcome! Please feel free to submit pull requests.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Contact

- GitHub: [@Argh94](https://github.com/Argh94)
- Project Link: [https://github.com/Argh94/Wg-script](https://github.com/Argh94/Wg-script)

## 🙏 Acknowledgments

- Cloudflare WARP
- WireGuard Project
- V2Ray Project
- AmneziaVPN Team
- Hiddify Project

---
Made with ❤️ by Argh94
