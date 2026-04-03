# PROJECT BRIEF — JBR MIMPO MOBILE
> Jabbar Media Informasi dan Promosi — Mobile App
> Platform: Android (APK) + iOS (IPA) · Flutter / Dart
> Version: 1.0.0 · Status: Final

---

## DAFTAR ISI
1. [Project Overview](#1-project-overview)
2. [User & Roles](#2-user--roles)
3. [Sitemap & Navigasi](#3-sitemap--navigasi)
4. [Halaman & Konten](#4-halaman--konten)
5. [Features](#5-features)
6. [Flow](#6-flow)
7. [Tech Stack Mobile](#7-tech-stack-mobile)
8. [UI / UX](#8-ui--ux)
9. [Security Mobile](#9-security-mobile)
10. [Rules Mobile](#10-rules-mobile)

---

## 1. Project Overview

### Identitas Produk
| Atribut | Detail |
|---|---|
| Nama Aplikasi | JBR Mimpo |
| Kepanjangan | Jabbar Media Informasi dan Promosi |
| Platform | Android (APK) + iOS (IPA) |
| Framework | Flutter / Dart (single codebase) |
| Versi | 1.0.0 (MVP) |
| Target User | Pelanggan aktif ISP Jabbar23 |
| Estimasi User | 10.000+ |
| Coverage | Beberapa kota dalam 1 provinsi |

### Problem Statement
Tidak ada channel komunikasi resmi antara ISP Jabbar23 dan pelanggan:
- Pelanggan lambat dapat info gangguan & maintenance
- Promo tidak sampai ke pelanggan secara efektif
- Tidak ada media resmi untuk laporan gangguan & CS online

### Solusi
JBR Mimpo hadir sebagai satu-satunya media komunikasi resmi antara ISP dan pelanggan — menyampaikan informasi, menjalankan promosi, mengelola reward, dan menyediakan CS online dalam satu aplikasi.

### Tujuan Produk (Prioritas)
1. Sampaikan info & pengumuman dengan cepat
2. Jalankan promo & reward secara efektif
3. Tingkatkan loyalitas pelanggan
4. Kurangi beban CS manual

### Scope v1.0
| Dalam Scope | Di Luar Scope |
|---|---|
| Info & pengumuman | Pembayaran online |
| Promo, reward, undian | Integrasi billing system |
| Lapor gangguan & tracking tiket | Ganti paket mandiri |
| CS Online (AI + Admin takeover) | Video call support |
| Push notification | |
| Program referral | |

---

## 2. User & Roles

| Role | Akses | Login |
|---|---|---|
| Guest | Promo publik + info umum | Tidak perlu login |
| Pelanggan | Full mobile app (data diri sendiri) | No. WA + Sandi + OTP WA |
| AI Chatbot | Handle CS otomatis | Sistem otomatis |

### Detail Login Pelanggan
- Login: Nomor WhatsApp + Sandi + OTP via WA
- Persistent login — tidak logout kecuali manual
- Beda device → wajib OTP WA ulang
- Lupa sandi: No WA → OTP via WA → sandi baru → auto login

### Register Pelanggan
- Nomor WhatsApp (wajib)
- Nama lengkap (wajib)
- Alamat / area (wajib)
- Sandi min 8 karakter (wajib)
- OTP via WA (wajib, pertama kali daftar)

---

## 3. Sitemap & Navigasi

### Struktur Navigasi
```
JBR MIMPO MOBILE
│
├── AUTH (sebelum login)
│   ├── Splash Screen
│   ├── Onboarding (3 slide, pertama install)
│   ├── Login
│   ├── Register
│   ├── Verifikasi OTP
│   └── Lupa Sandi
│
└── MAIN APP (setelah login)
    │
    ├── Header: Logo + "Halo, [Nama]" + 🔔 Notifikasi
    │
    └── Bottom Navigation (5 menu)
        ├── 🏠 Home
        ├── 📢 Informasi
        ├── 🎁 Promo & Reward
        ├── 🎧 Support / CS
        └── 👤 Akun
```

### Catatan Navigasi
- Notifikasi: icon lonceng di header (bukan bottom nav)
- Referral: masuk di dalam menu Promo & Reward (Tab Referral)
- Guest mode: hanya bisa akses promo publik & info umum

---

## 4. Halaman & Konten

### AUTH PAGES

**Splash Screen**
- Logo JBR Mimpo (center)
- Background: Emerald gradient
- Loading indicator (bottom)

**Onboarding (3 slide)**
- Slide 1: Info Gangguan Real-Time
- Slide 2: Promo & Reward Eksklusif
- Slide 3: CS Online 24 Jam
- Dot indicator + tombol "Mulai Sekarang"
- Tombol "Skip" (top right)

**Login**
- Input: Nomor WhatsApp + Sandi
- Toggle show/hide sandi
- Link "Lupa Sandi?"
- Tombol "Masuk"
- Link "Belum punya akun? Daftar"

**Register**
- Input: Nama lengkap
- Input: Nomor WhatsApp
- Input: Alamat / Area (dropdown)
- Input: Sandi (min 8 karakter)
- Input: Konfirmasi Sandi
- Password strength indicator
- Tombol "Daftar & Kirim OTP"
- Link "Sudah punya akun? Masuk"

**Verifikasi OTP**
- Info nomor WA yang digunakan
- 6 kotak input OTP
- Countdown timer 60 detik
- Link "Kirim Ulang OTP" (muncul setelah timer habis)
- Tombol "Verifikasi"
- Link "Ganti nomor?"

**Lupa Sandi**
- Input: Nomor WhatsApp
- Kirim OTP → Input OTP → Input sandi baru → Auto login

---

### 🏠 HOME

**Susunan konten (atas ke bawah):**

1. Header
   - Logo JBR Mimpo (kiri)
   - "Halo, [Nama Pelanggan]" (kiri)
   - Icon lonceng notifikasi + badge unread (kanan)

2. Banner Promo (Slideshow)
   - Auto-play + swipe manual
   - Maks 5 banner
   - Dot indicator
   - Tap → detail promo

3. Status Paket Aktif
   - Dot hijau (aktif) / merah (nonaktif)
   - Nama paket
   - Badge status: Aktif / Nonaktif

4. Pengumuman Terbaru
   - Maks 2 item
   - Card: icon kategori + judul + tanggal
   - Tap → detail pengumuman
   - Link "Lihat Semua" → menu Informasi

5. Quick Action (2 tombol)
   - Lapor Gangguan (filled)
   - Lihat Promo (outline)

6. Bottom Navigation Bar

---

### 📢 INFORMASI

**Halaman List Pengumuman**
- Search bar (keyword)
- Filter chips horizontal: Semua | Gangguan | Maintenance | Info Umum
- Filter area (berdasarkan lokasi pelanggan)
- Badge unread (dot merah) per item belum dibaca
- Card pengumuman:
  - Thumbnail (jika ada)
  - Badge kategori (warna berbeda per kategori)
  - Judul
  - Preview isi (2 baris)
  - Tanggal publish
  - Icon pin (jika dipinned)
- Pinned pengumuman tampil paling atas
- Pull to refresh

**Halaman Detail Pengumuman**
- Tombol back + tombol share (via WA / media lain)
- Gambar hero (jika ada)
- Badge kategori
- Judul (heading)
- Tanggal & area
- Isi lengkap (rich text)
- Gambar inline (jika ada)

---

### 🎁 PROMO & REWARD

**Tab Bar:** Promo | Reward | Undian | Referral

**Tab Promo**
- List card promo:
  - Banner gambar
  - Judul promo
  - Countdown timer (sisa waktu berakhir)
  - Tombol "Lihat Detail"
- Detail promo:
  - Banner
  - Judul + deskripsi
  - Periode (mulai - selesai)
  - Syarat & ketentuan
  - Countdown timer

**Tab Reward Saya**
- Kartu saldo poin:
  - Total poin saya
  - Ranking leaderboard
- Leaderboard (ranking poin semua pelanggan)
- List reward tersedia:
  - Nama reward
  - Tipe reward
  - Poin dibutuhkan
  - Stok (jika terbatas)
  - Tombol "Tukar"
- Konfirmasi tukar: dialog "Yakin tukar X poin untuk [reward]?"
- Riwayat perolehan poin (history)
- Riwayat reward yang pernah diklaim

**Tab Undian**
- Card undian aktif:
  - Gambar hadiah
  - Judul undian
  - Detail hadiah
  - Periode undian
  - Countdown draw date
  - Jumlah peserta saat ini
  - Syarat ikut
  - Status keikutsertaan saya
  - Tombol "Ikut Undian"
- Pengumuman pemenang (jika sudah draw):
  - Nama pemenang
  - Hadiah
  - Tanggal pengundian

**Tab Referral**
- Kode referral unik (JetBrains Mono, kotak dashed)
- Tombol "Bagikan via WA" (pesan terisi otomatis)
- Statistik referral:
  - Total berhasil
  - Total pending
  - Total reward didapat
- List history referral:
  - Nama yang diajak
  - Status (Berhasil/Pending)
  - Reward didapat
  - Tanggal

---

### 🎧 SUPPORT / CS

**Halaman Utama Support**
- Banner status jaringan area (orange jika ada gangguan)
- 4 kartu aksi (2x2 grid):
  - Lapor Gangguan
  - Cek Tiket Saya
  - Chat CS
  - FAQ
- Section tiket aktif terbaru (jika ada)
- Floating button Chat CS (bottom right)

**Form Lapor Gangguan**
- Dropdown: Jenis gangguan (Internet Mati / Lambat / Lainnya)
- Textarea: Deskripsi masalah (min 10 karakter)
- Upload foto (opsional, maks 5MB)
- Lokasi GPS (otomatis + tombol "Gunakan Lokasi Saya")
- Date time picker: Waktu gangguan mulai (default: sekarang)
- Tombol "Kirim Laporan" (fixed bottom)
- Konfirmasi: nomor tiket muncul setelah berhasil

**Tracking Tiket**
- Tab: Aktif | Selesai
- Card tiket:
  - Nomor tiket (JetBrains Mono)
  - Jenis gangguan + tanggal
  - Badge status (warna berbeda per status)
  - Progress stepper horizontal (5 langkah):
    Menunggu → Diproses → Dalam Perjalanan → Selesai → Ditutup
- Detail tiket:
  - Info lengkap laporan
  - Timeline perubahan status
  - Rating & feedback (muncul setelah status Selesai)

**Status Jaringan Area**
- Status real-time jaringan per area
- Informasi gangguan yang sedang berlangsung
- ETA perbaikan (jika ada)

**Chat CS / AI Chatbot**
- Header: "CS JBR Mimpo" + badge "AI Online" / "CS Online"
- Tombol WA (redirect ke WA CS)
- Bubble chat:
  - User: kanan (warna emerald)
  - AI: kiri (label: AI / nama AI "Mipo")
  - Admin: kiri (label: nama CS)
  - System message: tengah (misal "CS bergabung")
- Quick reply chips: Info Promo | Cek Gangguan | Hubungi CS
- Input bar + tombol kirim
- Typing indicator (3 titik animasi)

**FAQ**
- Search bar
- Filter kategori chips
- Accordion list:
  - Pertanyaan (bold)
  - Jawaban expand/collapse
  - Emerald left border saat expand

---

### 👤 AKUN

**Halaman Utama Akun**
- Header profil (emerald gradient):
  - Avatar inisial nama
  - Nama lengkap
  - Nomor WhatsApp
  - Badge paket aktif

- Section Akun:
  - Edit Profil (nama, alamat, area)
  - Ganti Sandi
  - Keamanan Akun

- Section Preferensi:
  - Pengaturan Notifikasi (on/off per kategori)
  - Bahasa (Indonesia / English)
  - Tema (Light / Dark / Otomatis)

- Section Lainnya:
  - Riwayat Notifikasi
  - Info Versi App
  - Kebijakan Privasi
  - Hubungi Kami

- Tombol "Keluar" (merah, outline, full width)

**Halaman Keamanan Akun**
- Riwayat login (device, waktu, IP)
- Tombol "Logout Semua Perangkat"

**Halaman Riwayat Notifikasi**
- List semua notifikasi yang pernah diterima (90 hari terakhir)
- Tap → buka halaman tujuan (deep link)

---

### 🔔 NOTIFIKASI

**Halaman Riwayat Notifikasi** (akses dari icon lonceng header)
- List notifikasi (terbaru di atas)
- Badge unread per item
- Tap → deep link ke halaman tujuan
- Tandai semua sudah dibaca
- Notifikasi tersimpan maks 90 hari

---

## 5. Features

### Global Features
| Fitur | Detail |
|---|---|
| Autentikasi | No. WA + Sandi + OTP via WA |
| Push Notification | Deep link dinamis, ditentukan admin |
| Offline Mode | Semua konten terakhir tersimpan di cache (Hive) |
| Skeleton Loading | Tidak ada blank screen, selalu ada placeholder |
| Multi Bahasa | Indonesia + Inggris |
| Dark / Light Mode | Ikut setting HP user |
| Force Update | Wajib update sebelum bisa pakai app |
| Auto Refresh Token | Background refresh, user tidak sadar |

### Features Per Menu

**Home:**
- Greeting dinamis (nama pelanggan dari data akun)
- Banner promo slideshow (auto-play 5 detik, swipe manual, maks 5 banner)
- Status paket aktif real-time (sync dari backend)
- Pengumuman terbaru (maks 2 item, badge unread)
- Quick action (Lapor Gangguan + Lihat Promo)

**Informasi:**
- List pengumuman dengan filter kategori + area + search keyword
- Badge unread (dot merah) per item yang belum dibaca
- Pin pengumuman penting (tampil paling atas)
- Share pengumuman via WA / media lain
- Pull to refresh

**Promo & Reward:**
- Countdown timer promo (hitung mundur real-time)
- Tukar poin dengan reward (konfirmasi dialog)
- Leaderboard poin (ranking semua pelanggan)
- Riwayat perolehan poin + riwayat klaim reward
- Kode referral unik per pelanggan
- Share kode referral via WA (pesan otomatis terisi)
- Ikut undian (cek syarat otomatis)
- Pengumuman pemenang undian

**Support / CS:**
- Form lapor gangguan (jenis + deskripsi + foto + GPS + waktu)
- Tracking tiket dengan progress stepper 5 langkah
- Notifikasi otomatis setiap perubahan status tiket
- Rating & feedback setelah tiket selesai
- Status jaringan area real-time
- AI Chatbot aktif 24 jam ("Mipo")
- Admin takeover real-time (WebSocket)
- Redirect ke WA CS dengan pesan otomatis terisi
- FAQ dengan search + kategori + accordion

**Akun:**
- Edit profil (nama, alamat, area)
- Ganti sandi
- Riwayat login + logout semua perangkat
- Pengaturan notifikasi per kategori
- Ganti bahasa (Indonesia/Inggris)
- Pilih tema (Light/Dark/Otomatis)
- Riwayat notifikasi (90 hari)
- Info versi app

---

## 6. Flow

### Flow Register
```
Buka app → Splash → Onboarding (pertama install)
    ↓
Login page → tap "Daftar"
    ↓
Isi: Nama + No WA + Alamat + Sandi
    ↓
Tap "Daftar & Kirim OTP"
    ↓
OTP 6 digit dikirim via WA (timer 60 detik)
    ↓
Input OTP → valid
    ↓
Akun dibuat → JWT token generated
    ↓
Otomatis masuk → redirect ke Home
```

### Flow Login
```
Buka app → Login page
    ↓
Input No WA + Sandi → tap "Masuk"
    ↓
Backend validasi → kirim OTP via WA
    ↓
Input OTP 6 digit → valid
    ↓
Generate JWT + refresh token
    ↓
Simpan di secure storage → Home
    ↓
[Lupa Sandi]
Input No WA → OTP via WA → Sandi baru → Auto login
```

### Flow Lapor Gangguan
```
Support → tap "Lapor Gangguan"
    ↓
Isi form: jenis + deskripsi + foto (opsional)
         + lokasi GPS + waktu gangguan
    ↓
Tap "Kirim Laporan"
    ↓
Tiket dibuat → nomor tiket muncul
Push notif ke pelanggan: "Tiket #XXXX diterima"
Push notif ke admin: "Tiket baru masuk"
    ↓
Admin update status → notif otomatis ke pelanggan
    ↓
MENUNGGU → DIPROSES → DALAM PERJALANAN
→ SELESAI → minta rating & feedback
```

### Flow Tukar Reward
```
Promo → Tab Reward → pilih reward
    ↓
Lihat detail + poin dibutuhkan
    ↓
Tap "Tukar Sekarang" → dialog konfirmasi
    ↓
Konfirmasi → poin terpotong → reward tercatat
    ↓
Notif: "Reward diklaim! Admin akan hubungi via WA"
Notif ke admin: klaim baru + no WA pelanggan
    ↓
Admin proses → hubungi via WA → update selesai
Notif ke pelanggan: "Reward sudah diproses"
```

### Flow Undian
```
Promo → Tab Undian → lihat detail undian
    ↓
Tap "Ikut Undian"
    ↓
Sistem cek syarat → lolos → terdaftar
Konfirmasi: "Kamu sudah terdaftar!"
    ↓
Menunggu tanggal draw...
    ↓
[Jika menang]
Push notif ke pemenang
Banner pemenang di Home
Nama pemenang di halaman undian
Admin hubungi via WA
```

### Flow Chat CS & AI Chatbot
```
Support → tap "Chat CS"
    ↓
Masuk ruang chat → AI "Mipo" menyapa
    ↓
User ketik pertanyaan
    ↓
[AI bisa jawab] → AI balas otomatis
[AI tidak bisa jawab] → eskalasi ke admin
  Admin takeover → balas manual (WebSocket real-time)
    ↓
[User tap "Hubungi via WA"]
Deep link ke WA CS + pesan otomatis:
"Halo, saya [Nama] - [No WA] ingin bertanya..."
    ↓
Sesi selesai → user bisa rating percakapan
```

---

## 7. Tech Stack Mobile

| Komponen | Teknologi | Keterangan |
|---|---|---|
| Framework | Flutter 3.x (stable) | Single codebase APK + IPA |
| Language | Dart 3.x | |
| State Management | Riverpod | Predictable, testable |
| Navigation | go_router | Deep link support |
| HTTP Client | Dio + interceptor | Retry, token refresh otomatis |
| WebSocket | web_socket_channel | Real-time chat CS |
| Local Cache | Hive | Offline mode, fast NoSQL |
| Push Notification | firebase_messaging (FCM) | |
| Image | cached_network_image | Lazy load + cache |
| File Upload | image_picker + dio | Foto tiket, avatar |
| Location/GPS | geolocator | Laporan gangguan |
| Deep Link | app_links | Notif → halaman langsung |
| Crash Report | sentry_flutter | |
| OTP Input | pinput | 6 kotak OTP |
| Multi Bahasa | flutter_localizations | ID + EN |
| Secure Storage | flutter_secure_storage | JWT token |
| Image Compress | flutter_image_compress | Auto compress sebelum upload |

### Data Flow
```
API → Local Cache (Hive) → State (Riverpod) → UI

Prinsip:
- Tampilkan cache dulu (instant)
- Fetch API di background
- Update UI + update cache
- User tidak pernah lihat blank screen
```

---

## 8. UI / UX

### Color Palette
| Token | Hex | Penggunaan |
|---|---|---|
| Primary | `#10B981` | CTA, icon aktif, badge |
| Primary Dark | `#059669` | Hover, pressed state |
| Accent | `#34D399` | Highlight, dark mode primary |
| Deep | `#065F46` | Dark mode border |
| BG Light | `#F8FAFB` | Background light mode |
| BG Dark | `#111827` | Background dark mode |
| Text Primary | `#111827` | Teks utama |
| Text Secondary | `#6B7280` | Teks sekunder |
| Error | `#EF4444` | Error, status nonaktif |
| Warning | `#F59E0B` | Alert, status pending |

### Tipografi
| Peran | Font |
|---|---|
| Heading / Display | Sora (Bold 700, ExtraBold 800) |
| Body / Label | DM Sans (Regular 400, Medium 500, SemiBold 600) |
| Kode / ID | JetBrains Mono (kode referral, nomor tiket) |

### Design System
| Atribut | Nilai |
|---|---|
| Border Radius Cards | 12–16px |
| Border Radius Modal | 20px |
| Shadow | Subtle soft only |
| Icon Style | Outline modern |
| Theme | Light + Dark (ikut setting HP) |

### AI Design Prompt Master (Mobile)
```
"Design a screen for JBR Mimpo (Jabbar Media Informasi 
dan Promosi) — a modern premium ISP mobile app from Indonesia.

Design system:
- Style: Clean minimalist, premium, modern tech ISP
- Primary color: Emerald Green #10B981
- Dark accent: #059669 | Light accent: #34D399
- BG light: #F8FAFB | BG dark: #111827
- Heading font: Sora | Body font: DM Sans
- Code font: JetBrains Mono (referral code, ticket number)
- Border radius: 12–16px cards, 20px modals
- Shadow: soft subtle only | Icon: outline modern
- Support light AND dark mode
- Bottom nav: Home | Info | Promo | Support | Akun
- Header: Logo + Greeting + notification bell (top right)"
```

---

## 9. Security Mobile

| Layer | Detail |
|---|---|
| Login | No WA + Sandi + OTP via WA (2FA) |
| Token | Access token 24 jam, Refresh token 365 hari |
| Auto Refresh | Background refresh sebelum expired |
| Token Storage | flutter_secure_storage (bukan SharedPreferences) |
| Beda Device | Wajib OTP WA ulang |
| Sandi | bcrypt hashing di backend |
| OTP | Hash sebelum simpan, expire 5 menit |
| API | HTTPS / TLS 1.3 |
| Input | Sanitasi semua input, cegah XSS |
| File Upload | Validasi tipe + ukuran di client sebelum upload |
| Offline Data | Cache tersimpan di Hive (encrypted) |

---

## 10. Rules Mobile

### Business Rules
- 1 nomor WA = 1 akun (tidak bisa daftar ulang)
- Poin login harian: 1x per hari per akun
- Poin tidak expired, tidak bisa dipindah antar akun
- Tidak bisa pakai kode referral sendiri
- 1 WA hanya bisa menjadi referred 1x
- 1 pelanggan hanya bisa ikut 1x per undian
- Pelanggan nonaktif tidak bisa ikut undian
- 1 tiket aktif bersamaan per pelanggan
- Tidak bisa buat tiket baru jika masih ada tiket aktif
- Promo tidak bisa diklaim dobel

### Validation Rules
- Nomor WA: format +62/08xx, 10–15 digit
- Sandi: min 8 karakter, huruf + angka
- OTP: 6 digit, expire 5 menit, maks 5x salah → blocked 30 menit
- Nama: min 3, maks 100 karakter
- Alamat: min 10 karakter
- Deskripsi tiket: min 10 karakter
- Foto upload: maks 5MB, auto compress ke maks 1MB
- Format foto: JPG, PNG, WebP only
- Pesan chat: maks 1000 karakter
- Semua input di-trim otomatis
- Tidak boleh input HTML/script tag

### Permission Rules
- Guest: hanya promo publik + info umum
- Pelanggan: data diri sendiri only
- Pelanggan: tidak bisa edit nomor WA (harus minta admin)
- Pelanggan: tidak bisa hapus tiket yang dibuat
- Pelanggan: tidak bisa tukar poin jika saldo tidak cukup

### System Constraints
- Home screen load: maks 2 detik
- API timeout: maks 10 detik
- Retry: 3x dengan exponential backoff
- Offline mode: tampilkan cache terakhir
- Push notif jam tenang: 22.00–07.00 WIB
- Notif darurat (gangguan): boleh kapan saja
- Notifikasi tersimpan di app: maks 90 hari
- Force update: wajib sebelum bisa pakai app
- Foto tiket tersimpan di server: maks 1 tahun

---

*JBR Mimpo Mobile Brief v1.0.0*
*Dokumen ini merupakan blueprint resmi mobile app JBR Mimpo.*
*Perubahan apapun harus melalui diskusi dan update dokumen ini.*
