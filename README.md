# 🌐 WARP Config Generator | تولیدکننده پیکربندی WARP

<div dir="rtl">

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
