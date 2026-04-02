# PROJECT BRIEF — JBR Mimpo

> ISP Mobile App · Informasi, Promosi & Reward  
> Version: 1.1.0 · Status: Draft Final (Disempurnakan)

---

## PANDUAN PENGGUNAAN BRIEF INI

Brief ini adalah **blueprint resmi** proyek JBR Mimpo sebelum development dimulai.  
Setiap keputusan di dokumen ini telah didiskusikan dan disetujui.  
AI yang digunakan untuk development **wajib membaca seluruh brief ini** sebelum menghasilkan kode apapun.

### Wajib Gunakan MCP & Skills Berikut

Setiap sesi development dengan AI (Cursor / Windsurf / IDE Antigravity) wajib mengaktifkan MCP dan Skills yang relevan sesuai konteks pekerjaan:

#### MCP Servers

| MCP                   | Kapan Digunakan                                              |
| --------------------- | ------------------------------------------------------------ |
| `context7`            | Selalu aktif — untuk dokumentasi library & framework terkini |
| `github`              | Saat push, PR, review kode, atau cari referensi kode         |
| `sequential-thinking` | Saat memecahkan masalah kompleks atau debug                  |
| `memory`              | Untuk menyimpan konteks sesi agar konsisten antar sesi       |
| `search-tavily`       | Riset solusi teknis, library baru, atau referensi arsitektur |
| `linear`              | Untuk manajemen task dan tracking progress development       |
| `StitchMCP`           | Saat generate UI/UX screen atau desain komponen              |

#### Skills

| Skill                    | Kapan Digunakan                                             |
| ------------------------ | ----------------------------------------------------------- |
| `golang-pro`             | Semua development backend — modul, API, WebSocket, queue    |
| `flutter-expert`         | Semua development mobile app                                |
| `nextjs-developer`       | Semua development dashboard web admin                       |
| `postgres-pro`           | Schema database, query optimization, migration              |
| `redis-best-practices`   | Implementasi caching, session, OTP di Redis                 |
| `docker-expert`          | Konfigurasi Docker Compose, container security              |
| `backend-patterns`       | API design, struktur modul, best practices server           |
| `architecture-patterns`  | Saat menyusun atau mereview arsitektur sistem               |
| `database-migration`     | Saat membuat atau mengubah schema database                  |
| `security-requirement`   | Implementasi auth, enkripsi, dan proteksi API               |
| `frontend-design`        | UI component, layout, dan design system                     |
| `tailwind-design-system` | Styling dashboard Next.js                                   |
| `ui-ux-pro-max`          | Desain screen mobile dan dashboard                          |
| `whatsapp-automation`    | Integrasi Fonnte untuk OTP dan notifikasi WA                |
| `testing-patterns`       | Unit test dan integrasi test backend                        |
| `e2e-testing-patterns`   | End-to-end test dashboard web                               |
| `systematic-debugging`   | Debugging bug kompleks                                      |
| `project-workflow`       | Gunakan slash command `/plan-feature`, `/wrap-session`, dll |
| `requesting-code-review` | Sebelum merge kode ke main branch                           |
| `app-store-optimization` | Saat persiapan publish ke Play Store & App Store            |

---

## DAFTAR ISI

1. [Project Overview](#1-project-overview)
2. [User & Roles](#2-user--roles)
3. [Product Structure](#3-product-structure)
4. [Features](#4-features)
5. [Flow](#5-flow)
6. [System Design](#6-system-design)
7. [Tech Stack](#7-tech-stack)
8. [UI / UX](#8-ui--ux)
9. [Security](#9-security)
10. [Rules](#10-rules)
11. [Mind Map](#11-mind-map)

---

## 1. Project Overview

### Identitas Produk

| Atribut       | Detail                         |
| ------------- | ------------------------------ |
| Nama Aplikasi | JBR Mimpo                       |
| Platform      | Android (APK) + iOS (IPA)      |
| Versi         | 1.0.0 (MVP)                    |
| Coverage      | Beberapa kota dalam 1 provinsi |
| Target User   | Pelanggan aktif ISP JBR Mimpo   |
| Estimasi User | 10.000+                        |

### Problem Statement

Tidak ada channel komunikasi resmi antara ISP JBR Mimpo dan pelanggan, menyebabkan:

- Pelanggan lambat mendapat informasi gangguan & maintenance
- Promo tidak sampai ke pelanggan secara efektif
- Tidak ada media resmi untuk laporan gangguan & CS online

### Solusi

JBR Mimpo hadir sebagai **satu-satunya media komunikasi resmi** antara ISP dan pelanggan — menyampaikan informasi, menjalankan promosi, mengelola reward, dan menyediakan CS online dalam satu aplikasi.

### Tujuan Produk (Prioritas)

1. Sampaikan info & pengumuman dengan cepat
2. Jalankan promo & reward secara efektif
3. Tingkatkan loyalitas pelanggan
4. Kurangi beban CS manual

### Scope v1.0

| Dalam Scope                        | Di Luar Scope                 |
| ---------------------------------- | ----------------------------- |
| Info & pengumuman                  | Pembayaran online             |
| Promo, reward, undian              | Integrasi billing system      |
| Lapor gangguan & tracking tiket    | Ganti paket mandiri           |
| CS Online (Chatbot Tombol + Admin) | Video call support            |
| Push notification                  | Status jaringan area otomatis |
| Dashboard web admin                | AI generatif (OpenAI/Gemini)  |
| Export data & backup manual        |                               |
| Rating tiket & sesi chat           |                               |

---

## 2. User & Roles

### Daftar Role

| Role            | Akses                                                 | Login                           |
| --------------- | ----------------------------------------------------- | ------------------------------- |
| **Guest**       | Promo publik + info umum                              | Tidak perlu login               |
| **Pelanggan**   | Full mobile app (data diri sendiri)                   | No. WA + Sandi + OTP WA         |
| **Super Admin** | Full access semua fitur dashboard                     | Email + Password + OTP WA (2FA) |
| **CS Agent**    | Tiket, chat, FAQ, data dasar pelanggan yang ditangani | Email + Password + OTP WA (2FA) |
| **Bot CS**      | Handle CS otomatis berbasis tombol & FAQ              | Sistem otomatis                 |

### Detail Role

**Super Admin:**

- Akses penuh semua fitur dashboard
- Kelola akun CS Agent (tambah, nonaktifkan)
- Pengaturan sistem (poin, kategori, tema, konfigurasi bot)
- Lihat & kelola semua data pelanggan
- Export data & trigger backup manual
- Lihat rating & analisis performa CS
- Semua aksi tercatat di activity log
- Hanya bisa aktif di **1 device** dalam satu waktu
- Login baru otomatis logout device lama

**CS Agent:**

- Kelola tiket: lihat list, update status, assign, balas
- Kelola chat: takeover dari bot, balas manual
- Kelola FAQ
- Lihat data dasar pelanggan yang **sedang ditangani** saja (nama, WA, paket aktif)
- Tidak bisa akses konten, promo, notifikasi, pengaturan sistem
- Tidak bisa lihat data pelanggan lain yang tidak sedang ditangani
- Hanya bisa aktif di **1 device** dalam satu waktu

**Pelanggan:**

- Full akses mobile app
- Lihat data diri sendiri only
- Bisa login di **lebih dari 1 device** sekaligus
- Setiap device baru wajib OTP WA ulang
- Bisa lihat & logout semua device aktif dari menu Keamanan Akun

**Bot CS:**

- Aktif 24 jam otomatis
- Berbasis tombol pilihan & FAQ — bukan AI generatif
- Nonaktif otomatis di sesi yang sama setelah CS Agent takeover

### Detail Login

**Pelanggan:**

- Login: Nomor WhatsApp + Sandi + OTP via WA (Fonnte)
- Persistent login (tidak logout kecuali manual)
- Beda device → wajib OTP WA ulang
- Multi-device diperbolehkan

**Super Admin & CS Agent:**

- Login: Email + Password + OTP via WA (2FA wajib)
- Persistent session (tidak logout kecuali manual)
- Beda device → wajib OTP WA ulang
- Login di device baru → device lama otomatis logout
- Notif WA jika login dari device baru

---

## 3. Product Structure

### Sitemap

```
JBR Mimpo
├── Mobile App (Flutter — APK + IPA)
│   ├── Auth Pages
│   │   ├── Splash Screen
│   │   ├── Onboarding (3 slide — tampil hanya saat pertama install / clear data)
│   │   ├── Login
│   │   ├── Register
│   │   ├── Verifikasi OTP
│   │   └── Lupa Sandi
│   │
│   └── Main App (Bottom Navigation)
│       ├── 🏠 Home
│       ├── 📢 Informasi
│       ├── 🎁 Promo & Reward
│       ├── 🎧 Support / CS
│       └── 👤 Akun
│           (+ 🔔 Notifikasi di header)
│
└── Dashboard Web Admin (Next.js)
    ├── Login (Super Admin & CS Agent)
    ├── 📊 Overview
    ├── 📢 Kelola Informasi
    ├── 🎁 Kelola Promo & Reward
    ├── 🎧 Kelola Tiket & CS
    ├── 👥 Data Pelanggan
    ├── 🔔 Push Notification
    └── ⚙️ Pengaturan
```

### Navigasi Mobile App

```
Bottom Nav  : Home | Info | Promo | Support | Akun
Header      : Logo + Greeting + 🔔 Notifikasi
Dalam Promo : Tab Promo | Tab Reward | Tab Undian | Tab Referral
```

### Halaman Mobile App

**Auth:**

- Splash Screen
- Onboarding (3 slide — hanya muncul saat pertama install atau setelah clear data)
- Login
- Register
- Verifikasi OTP
- Lupa Sandi

**Home:**

- Header: Logo + Greeting + Notif Bell
- Banner Promo (slideshow, maks 5 banner)
- Status Paket Aktif
- Pengumuman Terbaru (maks 2)
- Quick Action: Lapor Gangguan | Lihat Promo

**Informasi:**

- List Pengumuman (filter + search + sort + pagination)
- Detail Pengumuman

**Promo & Reward:**

- Tab Promo Aktif (filter + search + pagination)
- Tab Reward Saya (filter + pagination)
- Tab Undian (filter + pagination)
- Tab Referral

**Support / CS:**

- Form Lapor Gangguan
- Tracking Tiket (filter + pagination)
- Chat CS / Bot Chatbot
- FAQ (filter + search)

**Akun:**

- Profil Pelanggan
- Status Paket Aktif
- Pengaturan Notifikasi
- Riwayat Notifikasi (filter + pagination)
- Keamanan Akun (riwayat device + logout semua device)
- Ganti Bahasa
- Info Versi App
- Logout

### Halaman Dashboard Admin

Semua halaman list di dashboard wajib memiliki: **filter + search + sort + pagination**

- Login (Super Admin & CS Agent — tampilan sama, akses berbeda)
- Overview — statistik + alert + ringkasan rating
- Kelola Informasi — CRUD + jadwal + pin + arsip
- Kelola Promo & Reward — promo + undian + poin + reward + referral
- Kelola Tiket & CS — tiket + chat + assign + FAQ + konfigurasi bot
- Data Pelanggan — list + detail + export Excel
- Push Notification — broadcast + targeted + template + jadwal
- Pengaturan — akun admin, poin, kategori, konfigurasi bot, tema, log, backup

---

## 4. Features

### Global Features

| Fitur                               | Detail                                         |
| ----------------------------------- | ---------------------------------------------- |
| Autentikasi                         | No. WA + OTP via WA (Fonnte — nomor dedicated) |
| Push Notification                   | Deep link dinamis per konten (FCM)             |
| Offline Mode                        | Semua konten terakhir tersimpan di cache       |
| Skeleton Loading                    | Tidak ada blank screen                         |
| Multi Bahasa                        | Indonesia + Inggris                            |
| Dark / Light Mode                   | Ikut setting HP user                           |
| Force Update                        | Wajib update sebelum bisa pakai app            |
| Filter + Search + Sort + Pagination | Wajib di semua halaman list                    |

### Features per Menu — Mobile App

**🏠 Home:**

- Greeting dinamis (nama pelanggan)
- Banner promo slideshow (auto-play + swipe manual, maks 5 banner)
- Status paket aktif (real-time)
- Pengumuman terbaru (maks 2, tap → detail)
- Quick action: Lapor Gangguan + Lihat Promo

**📢 Informasi:**

- List pengumuman dengan filter kategori + area + search + sort + pagination
- Badge unread (dot merah belum dibaca)
- Pin pengumuman penting (tampil paling atas)
- Detail pengumuman (judul, isi, gambar, tanggal)
- Share pengumuman (via WA / media lain)

**🎁 Promo & Reward:**

- Tab Promo: list + filter + pagination + countdown timer + detail
- Tab Reward: saldo poin + leaderboard + history (filter + pagination) + tukar
- Tab Undian: info aktif + syarat + status + pemenang (filter + pagination)
- Tab Referral: kode unik + share WA + status + reward

**Mekanisme Poin:**

- Login harian ke app
- Durasi berlangganan (loyalty)
- Ikut program referral
- Ikut undian / event
- Manual oleh admin

**Perbedaan Promo & Reward:**

- **Promo** — konten informatif. Admin buat, user lihat. Tidak ada aksi klaim. Sifatnya seperti pengumuman menarik (diskon, penawaran paket, event). User cukup tahu, hubungi CS jika tertarik.
- **Reward** — berbasis poin. User kumpulkan poin, tukar dengan reward yang tersedia. Ada mekanisme klaim, ada syarat poin, setiap reward hanya bisa diklaim 1x per user.

**Bentuk Reward:**

- Gratis 1 bulan internet
- Diskon tagihan
- Tukar poin dengan hadiah lain

**🎧 Support / CS:**

- Form lapor gangguan (jenis + deskripsi + foto + GPS + waktu)
- Tracking tiket (5 status + notif update + rating + feedback)
- Chat CS / Bot Chatbot (sistem tombol + FAQ — bukan AI generatif)
- FAQ (filter + search)

**Bot CS — Sistem Tombol:**

- Bot menyapa otomatis saat user buka chat
- Tampil tombol pilihan kategori (dikelola admin)
- User tap → muncul sub-pilihan atau langsung jawaban
- Jika tidak ada yang cocok → "Lainnya" → eskalasi ke CS Agent
- Setelah CS Agent takeover → bot nonaktif di sesi yang sama
- Sesi selesai → user bisa rating percakapan

**👤 Akun:**

- Profil (nama, no WA, alamat)
- Status & info paket aktif
- Pengaturan notifikasi (on/off per kategori)
- Riwayat notifikasi (filter + pagination)
- Keamanan akun (riwayat device aktif + logout semua device)
- Ganti bahasa (Indonesia / Inggris)
- Info versi app
- Logout

### Features — Dashboard Admin

**Prinsip:** Semua konten yang dilihat pelanggan di mobile app dapat dikelola penuh oleh admin dari dashboard. Tidak ada konten hardcoded.

**📊 Overview (Super Admin only):**

- Kartu statistik: total pelanggan, tiket hari ini, promo aktif, chat pending
- Grafik aktivitas login user (7 hari)
- Alert prioritas (tiket urgent, chat pending lama)
- Ringkasan rating: rata-rata rating tiket & sesi chat (7 hari + tren)

**📢 Kelola Informasi:**

- CRUD pengumuman (judul, isi, kategori, gambar, area)
- Jadwalkan publish otomatis
- Pin pengumuman penting
- Arsip pengumuman lama
- Filter + search + sort + pagination

**🎁 Kelola Promo & Reward:**

- Buat & kelola promo (banner, periode, syarat)
- Buat & setting undian (peserta, hadiah, periode, cara undian)
- Proses pengundian & umumkan pemenang
- Kelola poin pelanggan (tambah / kurangi manual)
- Approve & distribusi reward
- Laporan & history
- Filter + search + sort + pagination

**🎧 Kelola Tiket & CS:**

- List tiket + filter status + search + pagination
- Update status tiket
- Assign tiket ke CS Agent
- Detail rating per tiket (Super Admin bisa lihat)
- Balas chat & takeover dari bot
- History percakapan CS + rating sesi (Super Admin bisa lihat)
- Kelola FAQ (CRUD + urutan tampil)
- Konfigurasi bot: kelola tombol kategori, sub-pilihan, jawaban per pilihan

**👥 Data Pelanggan (Super Admin only):**

- List + filter + search + sort + pagination
- Detail profil (nama, WA, paket, poin)
- Tambah & edit manual
- History tiket & chat per pelanggan
- History reward & poin per pelanggan
- Export Excel multi-sheet (sheet per kategori data)
- Setiap export tercatat di activity log

**🔔 Push Notification (Super Admin only):**

- Broadcast ke semua pelanggan
- Targeted ke pelanggan tertentu
- Grup per area / paket
- Jadwalkan notif otomatis
- History + statistik notif
- Template notif

**⚙️ Pengaturan (Super Admin only):**

- Kelola akun admin (tambah CS Agent, nonaktifkan)
- Setting nilai poin per aktivitas
- Konfigurasi bot CS (knowledge base tombol, respon default)
- Kelola kategori pengumuman & gangguan
- Pengaturan umum app (logo, nama, warna tema)
- Log aktivitas admin (filter + search + pagination)
- Backup database manual (trigger + download + simpan ke cloud)

---

## 5. Flow

### User Flow

**Flow Register:**

```
User buka app → Splash Screen → Onboarding (pertama install / clear data)
    ↓
Halaman Login → tap "Daftar"
    ↓
Input: Nama lengkap + No WA + Alamat/Area + Sandi
    ↓
Tap "Daftar & Kirim OTP"
    ↓
Sistem kirim OTP 6 digit via WA (Fonnte)
    ↓
Input OTP (timer 60 detik, bisa resend maks 3x)
    ↓
OTP valid → akun dibuat → JWT token generated
    ↓
Otomatis masuk app → redirect ke Home
```

**Flow Login:**

```
User buka app → Halaman Login
    ↓
Input: No WA + Sandi → tap "Masuk"
    ↓
Backend validasi → kirim OTP via WA (Fonnte)
    ↓
Input OTP 6 digit
    ↓
OTP valid → generate JWT + refresh token
    ↓
Simpan token di secure storage → redirect ke Home
    ↓
[Lupa Sandi] → Input No WA → OTP via WA
→ Input sandi baru → Auto login
```

**Flow Login Beda Device — Pelanggan:**

```
User login di device baru
    ↓
Wajib OTP WA ulang
    ↓
OTP valid → token baru di-generate untuk device baru
    ↓
Device lama TETAP aktif (multi-device diperbolehkan)
    ↓
User bisa lihat semua device aktif di menu Keamanan Akun
    ↓
User bisa logout semua device sekaligus jika mau
```

**Flow Login Beda Device — Admin & CS Agent:**

```
Admin / CS login di device baru
    ↓
Wajib OTP WA ulang
    ↓
OTP valid → token baru di-generate
    ↓
Device lama OTOMATIS logout (hanya 1 device aktif)
    ↓
Notif WA dikirim ke nomor admin: "Login dari device baru terdeteksi"
```

**Flow Lapor Gangguan:**

```
Menu Support → tap "Lapor Gangguan"
    ↓
Isi form: jenis + deskripsi + foto (opsional)
         + lokasi GPS + waktu gangguan
    ↓
Tap "Kirim Laporan"
    ↓
Tiket dibuat → nomor tiket muncul
    ↓
Push notif ke pelanggan: "Tiket #XXXX diterima"
Push notif ke admin: "Tiket baru masuk"
    ↓
Admin update status → notif otomatis ke pelanggan
    ↓
Status: MENUNGGU → DIPROSES → DALAM PERJALANAN
       → SELESAI → sistem minta rating & feedback
```

**Flow Klaim Reward & Tukar Poin:**

```
Menu Promo → Tab Reward Saya
    ↓
Lihat saldo poin + list reward
    ↓
Tap reward → lihat detail + poin dibutuhkan
    ↓
Tap "Tukar Sekarang" → konfirmasi dialog
    ↓
Konfirmasi → poin terpotong → reward tercatat
    ↓
Push notif: "Reward diklaim! Admin akan hubungi via WA"
Notif ke admin: ada klaim reward + no WA pelanggan
    ↓
Admin proses → hubungi via WA → update status SELESAI
Notif ke pelanggan: "Reward sudah diproses"
```

**Flow Undian:**

```
[Admin] Buat undian di dashboard
(setting: periode, syarat, hadiah, cara undian)
    ↓
Undian publish → tampil di Tab Undian mobile app
    ↓
[Pelanggan] Tap "Ikut Undian"
    ↓
Sistem cek syarat → lolos → terdaftar sebagai peserta
Konfirmasi: "Kamu sudah terdaftar!"
    ↓
Tanggal draw tiba:
  [Auto] → sistem random pilih pemenang
  [Manual] → admin proses dari dashboard
    ↓
Pemenang terpilih → sistem:
  - Push notif ke pemenang
  - Update halaman undian (nama pemenang)
  - Pasang banner di Home
  - Notif ke admin (no WA pemenang)
    ↓
Admin hubungi pemenang via WA untuk proses hadiah
```

**Flow Chat CS & Bot Chatbot:**

```
Menu Support → tap "Chat CS"
    ↓
Masuk ruang chat → Bot menyapa otomatis
    ↓
Tampil tombol pilihan kategori (dikelola admin)
    ↓
User tap kategori → muncul sub-pilihan atau langsung jawaban
    ↓
[Jawaban ditemukan] → Bot balas otomatis
[User tap "Lainnya" / tidak ada yang cocok] → eskalasi:
  "Sedang menghubungkan ke CS kami..."
  → Notif ke semua CS Agent aktif
  → CS Agent takeover → balas manual (WebSocket real-time)
  → Bot nonaktif di sesi yang sama
    ↓
[User tap "Hubungi via WA"] →
Deep link ke WA CS + pesan terisi otomatis:
"Halo, saya [Nama] - [No WA] ingin bertanya..."
    ↓
Sesi selesai → user bisa rating percakapan
```

**Flow Push Notification (Admin):**

```
Dashboard → menu Push Notification → "Buat Notifikasi"
    ↓
Isi: judul + isi pesan + target penerima
    + deep link tujuan + waktu kirim
    ↓
Preview notifikasi di phone mockup
    ↓
[Kirim sekarang] → API → FCM → deliver ke device
[Jadwalkan] → simpan di queue → kirim otomatis saat waktu tiba
    ↓
Sistem catat status: Terkirim / Dibaca / Gagal
Admin bisa lihat laporan di history notifikasi
```

### System Flow

**Flow OTP (Fonnte):**

```
Request OTP masuk ke backend
    ↓
Backend generate OTP 6 digit → hash → simpan di Redis (TTL 5 menit)
    ↓
Backend kirim request ke Fonnte API → Fonnte kirim pesan WA ke user
    ↓
User input OTP → backend verifikasi hash
    ↓
[Valid] → proses lanjut (login / register / reset)
[Tidak valid] → counter error + 1 (maks 5x → blocked 30 menit)
[Expired] → minta kirim OTP ulang
```

**Flow Token & Session:**

```
Login berhasil → backend generate:
  - Access Token (JWT, 24 jam)
  - Refresh Token (365 hari)
    ↓
Mobile: simpan di Flutter Secure Storage
Dashboard: simpan di httpOnly cookie
    ↓
Setiap request → kirim Access Token di header
Backend verifikasi JWT setiap request
    ↓
Access Token expired → app otomatis request Refresh Token di background
Refresh Token valid → Access Token baru di-generate
    ↓
Logout manual → invalidasi semua token
"Logout semua device" → invalidasi semua session user tersebut
```

**Flow Backup Database:**

```
[Otomatis — setiap hari 01.00 WIB]
pg_dump → compress → upload ke cloud storage
    ↓
[Manual — Super Admin trigger dari dashboard]
Tap "Backup Sekarang" → konfirmasi
    ↓
Backend jalankan pg_dump → compress
    ↓
Upload ke cloud storage + generate download link
    ↓
Super Admin bisa download file backup langsung
Aksi tercatat di activity log (siapa trigger, kapan, ukuran file)
```

**Flow Switch VPS (Disaster Recovery):**

```
VPS utama terdeteksi down
    ↓
Super Admin akses VPS cadangan manual
    ↓
Restore backup database terbaru dari cloud storage
    ↓
Update DNS / environment config ke VPS cadangan
    ↓
Sistem kembali online dari VPS cadangan
```

---

## 6. System Design

### Architecture

```
ARSITEKTUR JBR Mimpo — Monolith Modular

Mobile App (Flutter)
        ↓ HTTPS + JWT
    Nginx (Reverse Proxy + SSL + Rate Limit + Gzip)
        ↓
   Golang Backend (Monolith Modular)
   ┌─────────────────────────────────────┐
   │ Module: Auth      │ Module: Info    │
   │ Module: Promo     │ Module: Reward  │
   │ Module: Undian    │ Module: Referral│
   │ Module: Ticket    │ Module: Chat    │
   │ Module: Notif     │ Module: User    │
   │ Module: Bot CS    │ Module: Backup  │
   └─────────────────────────────────────┘
        ↓                    ↓
   PostgreSQL 16          Redis 7
   (data utama)      (cache + session + OTP)
        ↓
   RabbitMQ (async: notif, reward, undian, backup)
        ↓
   MinIO (file storage: foto tiket, banner promo)

External Services:
   Fonnte (WA unofficial)  → OTP + notif WA (nomor dedicated)
   FCM (Firebase)          → push notification
   Cloud Storage           → backup database otomatis & manual

DevOps:
   VPS Utama + VPS Cadangan (Ubuntu 22.04) — switch manual
   Docker Compose
   GitHub Actions (CI/CD)
     - Backend & Dashboard → auto build + deploy ke VPS
     - Mobile App → auto build APK/IPA saja (tidak deploy ke VPS)
   Prometheus + Grafana + Loki (monitoring)
   Sentry (error tracking)
   Watchtower (auto-update container)
   pg_dump harian → cloud storage (backup otomatis)
```

**Pendekatan:** Monolith Modular dipilih karena:

- Cukup untuk skala 10k+ user
- Mudah di-maintain oleh solo developer
- Tidak over-engineering di tahap MVP
- Siap di-split jadi microservices jika dibutuhkan

**Real-time Chat:** WebSocket (Gorilla WebSocket)

**Backup Strategy:**

- Otomatis harian 01.00 WIB → cloud storage
- Manual oleh Super Admin kapan saja → cloud storage + bisa download

**CI/CD Strategy:**

- Backend (Go) + Dashboard (Next.js) → GitHub Actions → build → deploy ke VPS
- Mobile App (Flutter) → GitHub Actions → build APK/IPA → artifact (tidak push ke VPS)

### Database

#### Users & Auth

```sql
users
├── id            UUID PRIMARY KEY
├── name          VARCHAR(100) NOT NULL
├── phone_wa      VARCHAR(20) UNIQUE NOT NULL
├── password      VARCHAR(255) NOT NULL          -- bcrypt
├── address       TEXT NOT NULL
├── area          VARCHAR(100) NOT NULL
├── package_name  VARCHAR(100)
├── status        ENUM(active, inactive) DEFAULT active
├── points        INTEGER DEFAULT 0
├── referral_code VARCHAR(20) UNIQUE NOT NULL
├── language      ENUM(id, en) DEFAULT id
├── created_at    TIMESTAMP DEFAULT NOW()
└── updated_at    TIMESTAMP

otp_logs
├── id         UUID PRIMARY KEY
├── phone_wa   VARCHAR(20) NOT NULL
├── otp_code   VARCHAR(255) NOT NULL              -- hashed
├── type       ENUM(register, login, reset_password, admin_login)
├── expired_at TIMESTAMP NOT NULL
├── used_at    TIMESTAMP
└── created_at TIMESTAMP DEFAULT NOW()

user_sessions
├── id            UUID PRIMARY KEY
├── user_id       UUID FK → users
├── device_info   TEXT
├── ip_address    VARCHAR(50)
├── last_active   TIMESTAMP
├── is_active     BOOLEAN DEFAULT true
└── created_at    TIMESTAMP DEFAULT NOW()
-- Catatan: user bisa punya multiple session aktif (multi-device)
```

#### Admin & CS Agent

```sql
admins
├── id            UUID PRIMARY KEY
├── name          VARCHAR(100) NOT NULL
├── email         VARCHAR(200) UNIQUE NOT NULL
├── phone_wa      VARCHAR(20) NOT NULL
├── password      VARCHAR(255) NOT NULL           -- bcrypt
├── role          ENUM(super_admin, cs_agent) NOT NULL
├── is_active     BOOLEAN DEFAULT true
├── last_login    TIMESTAMP
├── created_at    TIMESTAMP DEFAULT NOW()
└── updated_at    TIMESTAMP

admin_sessions
├── id            UUID PRIMARY KEY
├── admin_id      UUID FK → admins NOT NULL
├── device_info   TEXT
├── ip_address    VARCHAR(50)
├── is_active     BOOLEAN DEFAULT true
├── last_active   TIMESTAMP
└── created_at    TIMESTAMP DEFAULT NOW()
-- Catatan: admin hanya boleh 1 session aktif — login baru invalidasi session lama

admin_activity_logs
├── id          UUID PRIMARY KEY
├── admin_id    UUID FK → admins NOT NULL
├── action      VARCHAR(200) NOT NULL
├── target      VARCHAR(200)
├── target_id   UUID
├── ip_address  VARCHAR(50)
├── description TEXT
└── created_at  TIMESTAMP DEFAULT NOW()

system_settings
├── id          UUID PRIMARY KEY
├── key         VARCHAR(100) UNIQUE NOT NULL
├── value       TEXT NOT NULL
├── description TEXT
├── updated_by  UUID FK → admins
└── updated_at  TIMESTAMP
```

#### Informasi & Pengumuman

```sql
announcements
├── id            UUID PRIMARY KEY
├── title         VARCHAR(200) NOT NULL
├── content       TEXT NOT NULL
├── category      ENUM(gangguan, maintenance, info_umum)
├── area          VARCHAR(100)                    -- null = semua area
├── thumbnail_url VARCHAR(500)
├── is_pinned     BOOLEAN DEFAULT false
├── is_published  BOOLEAN DEFAULT false
├── published_at  TIMESTAMP
├── archived_at   TIMESTAMP
├── created_by    UUID FK → admins NOT NULL
├── created_at    TIMESTAMP DEFAULT NOW()
└── updated_at    TIMESTAMP

announcement_reads
├── id              UUID PRIMARY KEY
├── announcement_id UUID FK → announcements NOT NULL
├── user_id         UUID FK → users NOT NULL
└── read_at         TIMESTAMP DEFAULT NOW()
```

#### Promo & Reward

```sql
promos
├── id            UUID PRIMARY KEY
├── title         VARCHAR(200) NOT NULL
├── description   TEXT
├── banner_url    VARCHAR(500)
├── start_date    TIMESTAMP NOT NULL
├── end_date      TIMESTAMP NOT NULL
├── is_published  BOOLEAN DEFAULT false
├── created_by    UUID FK → admins NOT NULL
├── created_at    TIMESTAMP DEFAULT NOW()
└── updated_at    TIMESTAMP

rewards
├── id            UUID PRIMARY KEY
├── name          VARCHAR(200) NOT NULL
├── description   TEXT
├── type          ENUM(free_month, discount, points)
├── points_cost   INTEGER NOT NULL
├── stock         INTEGER                         -- null = unlimited
├── is_active     BOOLEAN DEFAULT true
├── created_by    UUID FK → admins NOT NULL
├── created_at    TIMESTAMP DEFAULT NOW()
└── updated_at    TIMESTAMP

point_transactions
├── id            UUID PRIMARY KEY
├── user_id       UUID FK → users NOT NULL
├── points        INTEGER NOT NULL                -- + dapat, - kurang
├── type          ENUM(login_daily, loyalty, referral, event, redeem, manual)
├── description   TEXT
├── ref_id        UUID
└── created_at    TIMESTAMP DEFAULT NOW()

reward_claims
├── id            UUID PRIMARY KEY
├── user_id       UUID FK → users NOT NULL
├── reward_id     UUID FK → rewards NOT NULL
├── points_used   INTEGER NOT NULL
├── status        ENUM(pending, processed, done) DEFAULT pending
├── processed_by  UUID FK → admins
├── processed_at  TIMESTAMP
├── notes         TEXT
└── created_at    TIMESTAMP DEFAULT NOW()
```

#### Undian & Referral

```sql
lotteries
├── id              UUID PRIMARY KEY
├── title           VARCHAR(200) NOT NULL
├── description     TEXT
├── prize           TEXT NOT NULL
├── join_type       ENUM(auto, points, ticket) NOT NULL
├── points_required INTEGER
├── eligibility     ENUM(all, active, package) DEFAULT all
├── package_filter  VARCHAR(100)
├── draw_type       ENUM(auto, manual) NOT NULL
├── start_date      TIMESTAMP NOT NULL
├── end_date        TIMESTAMP NOT NULL
├── draw_date       TIMESTAMP NOT NULL
├── is_published    BOOLEAN DEFAULT false
├── status          ENUM(upcoming, active, done) DEFAULT upcoming
├── created_by      UUID FK → admins NOT NULL
├── created_at      TIMESTAMP DEFAULT NOW()
└── updated_at      TIMESTAMP

lottery_participants
├── id            UUID PRIMARY KEY
├── lottery_id    UUID FK → lotteries NOT NULL
├── user_id       UUID FK → users NOT NULL
├── is_winner     BOOLEAN DEFAULT false
├── joined_at     TIMESTAMP DEFAULT NOW()
└── notified_at   TIMESTAMP

referral_logs
├── id              UUID PRIMARY KEY
├── referrer_id     UUID FK → users NOT NULL
├── referred_id     UUID FK → users NOT NULL
├── referral_code   VARCHAR(20) NOT NULL
├── status          ENUM(pending, rewarded) DEFAULT pending
├── rewarded_at     TIMESTAMP
└── created_at      TIMESTAMP DEFAULT NOW()
```

#### Tiket & Support

```sql
tickets
├── id              UUID PRIMARY KEY
├── ticket_number   VARCHAR(20) UNIQUE NOT NULL
├── user_id         UUID FK → users NOT NULL
├── type            ENUM(internet_mati, lambat, gangguan_lain)
├── description     TEXT NOT NULL
├── photo_url       VARCHAR(500)
├── latitude        DECIMAL(10,8)
├── longitude       DECIMAL(11,8)
├── incident_time   TIMESTAMP NOT NULL
├── status          ENUM(menunggu, diproses, dalam_perjalanan, selesai, ditutup)
├── assigned_to     UUID FK → admins
├── rating          SMALLINT                      -- 1-5, diisi user setelah selesai
├── feedback        TEXT
├── rated_at        TIMESTAMP
├── closed_at       TIMESTAMP
├── created_at      TIMESTAMP DEFAULT NOW()
└── updated_at      TIMESTAMP

ticket_status_logs
├── id          UUID PRIMARY KEY
├── ticket_id   UUID FK → tickets NOT NULL
├── old_status  VARCHAR(50)
├── new_status  VARCHAR(50) NOT NULL
├── changed_by  UUID FK → admins NOT NULL
├── notes       TEXT
└── created_at  TIMESTAMP DEFAULT NOW()

faqs
├── id          UUID PRIMARY KEY
├── question    TEXT NOT NULL
├── answer      TEXT NOT NULL
├── category    VARCHAR(100)
├── is_active   BOOLEAN DEFAULT true
├── order_index INTEGER DEFAULT 0
├── created_by  UUID FK → admins
├── created_at  TIMESTAMP DEFAULT NOW()
└── updated_at  TIMESTAMP
```

#### Bot CS

```sql
bot_categories
├── id          UUID PRIMARY KEY
├── label       VARCHAR(200) NOT NULL             -- teks tombol yang tampil ke user
├── order_index INTEGER DEFAULT 0
├── is_active   BOOLEAN DEFAULT true
├── created_by  UUID FK → admins NOT NULL
├── created_at  TIMESTAMP DEFAULT NOW()
└── updated_at  TIMESTAMP

bot_options
├── id           UUID PRIMARY KEY
├── category_id  UUID FK → bot_categories NOT NULL
├── label        VARCHAR(200) NOT NULL            -- teks sub-pilihan
├── answer       TEXT NOT NULL                    -- jawaban yang dikirim ke user
├── order_index  INTEGER DEFAULT 0
├── is_active    BOOLEAN DEFAULT true
├── created_by   UUID FK → admins NOT NULL
├── created_at   TIMESTAMP DEFAULT NOW()
└── updated_at   TIMESTAMP
```

#### Chat CS

```sql
chat_sessions
├── id            UUID PRIMARY KEY
├── user_id       UUID FK → users NOT NULL
├── status        ENUM(bot, human, closed) DEFAULT bot
├── handled_by    UUID FK → admins
├── taken_over_at TIMESTAMP
├── rating        SMALLINT                        -- 1-5, diisi user setelah sesi selesai
├── feedback      TEXT
├── rated_at      TIMESTAMP
├── closed_at     TIMESTAMP
├── created_at    TIMESTAMP DEFAULT NOW()
└── updated_at    TIMESTAMP

chat_messages
├── id            UUID PRIMARY KEY
├── session_id    UUID FK → chat_sessions NOT NULL
├── sender_type   ENUM(user, admin, bot) NOT NULL
├── sender_id     UUID
├── message       TEXT NOT NULL
├── attachments   JSONB                           -- array URL file jika ada
├── is_read       BOOLEAN DEFAULT false
├── read_at       TIMESTAMP
└── created_at    TIMESTAMP DEFAULT NOW()
```

#### Notifikasi

```sql
notifications
├── id              UUID PRIMARY KEY
├── title           VARCHAR(200) NOT NULL
├── body            TEXT NOT NULL
├── target_type     ENUM(all, specific, group) NOT NULL
├── target_area     VARCHAR(100)
├── target_package  VARCHAR(100)
├── deep_link       VARCHAR(500)
├── status          ENUM(draft, scheduled, sent) DEFAULT draft
├── scheduled_at    TIMESTAMP
├── sent_at         TIMESTAMP
├── created_by      UUID FK → admins NOT NULL
├── created_at      TIMESTAMP DEFAULT NOW()
└── updated_at      TIMESTAMP

notification_logs
├── id               UUID PRIMARY KEY
├── notification_id  UUID FK → notifications NOT NULL
├── user_id          UUID FK → users NOT NULL
├── status           ENUM(sent, delivered, opened, failed) DEFAULT sent
├── delivered_at     TIMESTAMP
├── opened_at        TIMESTAMP
└── created_at       TIMESTAMP DEFAULT NOW()

notification_templates
├── id          UUID PRIMARY KEY
├── name        VARCHAR(200) NOT NULL
├── title       VARCHAR(200) NOT NULL
├── body        TEXT NOT NULL
├── deep_link   VARCHAR(500)
├── created_by  UUID FK → admins NOT NULL
├── created_at  TIMESTAMP DEFAULT NOW()
└── updated_at  TIMESTAMP
```

#### Backup Log

```sql
backup_logs
├── id            UUID PRIMARY KEY
├── type          ENUM(auto, manual) NOT NULL
├── triggered_by  UUID FK → admins             -- null jika auto
├── file_name     VARCHAR(500) NOT NULL
├── file_size     BIGINT                        -- bytes
├── storage_url   VARCHAR(500) NOT NULL         -- URL di cloud storage
├── status        ENUM(success, failed) NOT NULL
├── notes         TEXT
└── created_at    TIMESTAMP DEFAULT NOW()
```

### API

**Base URL:** `https://api.JBR Mimpo.id/v1`  
**Auth:** Bearer JWT Token  
**Format:** REST + JSON  
**Kompresi:** GZIP enabled  
**Pagination:** Semua endpoint list wajib support query params: `?page=1&limit=20&sort=created_at&order=desc&search=...`

**Format Response Standar:**

```json
{
  "success": true,
  "message": "OK",
  "data": {},
  "meta": {
    "page": 1,
    "limit": 20,
    "total": 150,
    "total_pages": 8
  }
}
```

`meta` hanya muncul di endpoint yang mengembalikan list/pagination.

**Format Error Response:**

```json
{
  "success": false,
  "message": "Pesan error yang jelas untuk user",
  "errors": {}
}
```

#### Auth Endpoints

```
POST   /auth/register
POST   /auth/send-otp
POST   /auth/verify-otp
POST   /auth/login
POST   /auth/logout
POST   /auth/logout-all
POST   /auth/forgot-password
POST   /auth/reset-password
POST   /auth/refresh-token
```

#### User & Akun

```
GET    /user/profile
PUT    /user/profile
PUT    /user/password
GET    /user/sessions
DELETE /user/sessions/:id
DELETE /user/sessions            -- logout semua device
GET    /user/notifications
GET    /user/notifications/settings
PUT    /user/notifications/settings
```

#### Informasi & Pengumuman

```
GET    /announcements            -- support filter: category, area, search, sort, pagination
GET    /announcements/:id
POST   /announcements/:id/read

POST   /admin/announcements
PUT    /admin/announcements/:id
PUT    /admin/announcements/:id/pin
PUT    /admin/announcements/:id/archive
DELETE /admin/announcements/:id
```

#### Promo & Reward

```
GET    /promos                   -- support filter + search + pagination
GET    /promos/:id
GET    /rewards                  -- support filter + pagination
GET    /user/points
GET    /user/points/history      -- support filter + pagination
GET    /user/rewards/history     -- support filter + pagination
POST   /rewards/:id/redeem
GET    /leaderboard

POST   /admin/promos
PUT    /admin/promos/:id
DELETE /admin/promos/:id
POST   /admin/rewards
PUT    /admin/rewards/:id
POST   /admin/users/:id/points
PUT    /admin/claims/:id
GET    /admin/claims             -- support filter + pagination
```

#### Undian & Referral

```
GET    /lotteries                -- support filter + pagination
GET    /lotteries/:id
POST   /lotteries/:id/join
GET    /user/lottery/history     -- support pagination
GET    /user/referral
GET    /user/referral/history    -- support pagination

POST   /admin/lotteries
PUT    /admin/lotteries/:id
POST   /admin/lotteries/:id/draw
POST   /admin/lotteries/:id/announce
GET    /admin/lotteries          -- support filter + pagination
```

#### Tiket & Support

```
POST   /tickets
GET    /tickets                  -- support filter + pagination
GET    /tickets/:id
POST   /tickets/:id/rating
GET    /faqs                     -- support filter: category, search, pagination
GET    /faqs/:id

GET    /admin/tickets            -- support filter: status, area, search, pagination
PUT    /admin/tickets/:id/status
PUT    /admin/tickets/:id/assign
GET    /admin/tickets/:id/logs
POST   /admin/faqs
PUT    /admin/faqs/:id
DELETE /admin/faqs/:id
GET    /admin/tickets/ratings    -- Super Admin: list rating tiket
```

#### Bot CS

```
GET    /bot/categories           -- kategori & sub-pilihan untuk tampil di chat
GET    /bot/categories/:id/options

POST   /admin/bot/categories
PUT    /admin/bot/categories/:id
DELETE /admin/bot/categories/:id
POST   /admin/bot/categories/:id/options
PUT    /admin/bot/options/:id
DELETE /admin/bot/options/:id
```

#### Chat CS (WebSocket)

```
POST   /chat/sessions            -- buat sesi chat baru
GET    /chat/sessions
GET    /chat/sessions/:id
POST   /chat/sessions/:id/rating
WS     /ws/chat/:session_id

GET    /admin/chat/sessions      -- support filter: status, search, pagination
POST   /admin/chat/:id/takeover
POST   /admin/chat/:id/close
GET    /admin/chat/ratings       -- Super Admin: list rating sesi chat
```

#### Push Notification

```
POST   /admin/notifications
POST   /admin/notifications/schedule
GET    /admin/notifications      -- support filter + pagination
GET    /admin/notifications/:id/stats
POST   /admin/notification-templates
GET    /admin/notification-templates
PUT    /admin/notification-templates/:id
DELETE /admin/notification-templates/:id
```

#### Admin & Pengaturan

```
POST   /admin/auth/login
POST   /admin/auth/logout
GET    /admin/overview           -- Super Admin only
GET    /admin/users              -- support filter + search + sort + pagination
GET    /admin/users/:id
PUT    /admin/users/:id
GET    /admin/users/:id/history
GET    /admin/users/export       -- Super Admin only: trigger export Excel
GET    /admin/settings           -- Super Admin only
PUT    /admin/settings/:key      -- Super Admin only
GET    /admin/logs               -- Super Admin only: support filter + pagination
GET    /admin/admins             -- Super Admin only: list CS Agent
POST   /admin/admins             -- Super Admin only: tambah CS Agent
PUT    /admin/admins/:id         -- Super Admin only
```

#### Backup

```
POST   /admin/backup             -- Super Admin only: trigger backup manual
GET    /admin/backup/download/:id -- Super Admin only: download file backup
GET    /admin/backup/logs        -- Super Admin only: history backup + pagination
```

**Total:** ~100 endpoint + 1 WebSocket

---

## 7. Tech Stack

### Frontend — Mobile App

| Komponen          | Teknologi                |
| ----------------- | ------------------------ |
| Framework         | Flutter 3.x (stable)     |
| Language          | Dart 3.x                 |
| State Management  | Riverpod                 |
| Navigation        | go_router                |
| HTTP Client       | Dio + interceptor        |
| WebSocket         | web_socket_channel       |
| Local Cache       | Hive                     |
| Push Notification | firebase_messaging (FCM) |
| Image             | cached_network_image     |
| File Upload       | image_picker + dio       |
| Location/GPS      | geolocator               |
| Deep Link         | app_links                |
| Crash Report      | sentry_flutter           |
| OTP Input         | pinput                   |
| Multi Bahasa      | flutter_localizations    |

### Frontend — Dashboard Web Admin

| Komponen         | Teknologi                |
| ---------------- | ------------------------ |
| Framework        | Next.js 14+ App Router   |
| Language         | TypeScript               |
| UI Library       | shadcn/ui + Tailwind CSS |
| State Management | Zustand                  |
| HTTP Client      | Axios                    |
| WebSocket        | socket.io-client         |
| Tabel Data       | TanStack Table           |
| Chart/Grafik     | Recharts                 |
| Form             | React Hook Form + Zod    |
| Rich Text Editor | Tiptap                   |
| File Upload      | React Dropzone           |
| Notifikasi UI    | react-hot-toast          |
| Auth             | JWT (httpOnly cookie)    |

### Backend

| Komponen     | Teknologi                    |
| ------------ | ---------------------------- |
| Language     | Go 1.22+                     |
| Framework    | Gin                          |
| ORM          | GORM                         |
| Auth         | golang-jwt/jwt v5            |
| Password     | bcrypt (cost factor 12)      |
| WebSocket    | Gorilla WebSocket            |
| Config       | Viper (.env)                 |
| Logging      | Uber Zap                     |
| Validation   | go-playground/validator      |
| Migration    | golang-migrate               |
| Queue        | RabbitMQ (amqp091-go)        |
| Cache        | go-redis                     |
| File Storage | MinIO Go SDK                 |
| WhatsApp OTP | Fonnte API (nomor dedicated) |
| Push Notif   | FCM (firebase-admin-go)      |
| Crash Report | Sentry Go SDK                |

### Infrastructure

| Komponen        | Teknologi                                         |
| --------------- | ------------------------------------------------- |
| VPS             | IDCloudHost / Biznet — Ubuntu 22.04 LTS           |
| VPS Cadangan    | Tersedia — switch manual oleh Super Admin         |
| Spesifikasi     | 4 Core CPU, 8GB RAM, 100GB SSD                    |
| Reverse Proxy   | Nginx                                             |
| SSL             | Let's Encrypt (auto-renew)                        |
| Container       | Docker + Docker Compose                           |
| CI/CD           | GitHub Actions                                    |
| Database        | PostgreSQL 16                                     |
| Cache           | Redis 7                                           |
| Queue           | RabbitMQ 3                                        |
| File Storage    | MinIO                                             |
| Monitoring      | Prometheus + Grafana                              |
| Log Management  | Grafana Loki                                      |
| Error Tracking  | Sentry                                            |
| Auto Deploy     | Watchtower                                        |
| Backup Otomatis | pg_dump harian 01.00 WIB → cloud storage          |
| Backup Manual   | Trigger dari dashboard → cloud storage + download |

---

## 8. UI / UX

### Design Direction

| Atribut   | Detail                                               |
| --------- | ---------------------------------------------------- |
| Gaya      | Modern minimalis, premium, estetik — nuansa tech ISP |
| Inspirasi | Fintech & tech startup Indonesia                     |
| Feel      | Clean, confident, tidak jadul                        |

### Color Palette

| Token             | Hex       | Penggunaan                    |
| ----------------- | --------- | ----------------------------- |
| Primary           | `#10B981` | Warna utama, CTA, icon aktif  |
| Primary Dark      | `#059669` | Hover, active state           |
| Accent            | `#34D399` | Highlight, dark mode primary  |
| Deep              | `#065F46` | Dark mode border, deep accent |
| Background Light  | `#F8FAFB` | Background utama light mode   |
| Background Dark   | `#111827` | Background utama dark mode    |
| Text Primary      | `#111827` | Teks utama light mode         |
| Text Primary Dark | `#F9FAFB` | Teks utama dark mode          |
| Text Secondary    | `#6B7280` | Teks sekunder                 |
| Error             | `#EF4444` | Error state                   |
| Warning           | `#F59E0B` | Warning state                 |
| Success           | `#10B981` | Success state                 |

### Tipografi

| Peran             | Font               | Penggunaan                             |
| ----------------- | ------------------ | -------------------------------------- |
| Display / Heading | **Sora**           | Judul layar, heading section, nama app |
| Body / Text       | **DM Sans**        | Konten, deskripsi, label, tombol       |
| Code / ID         | **JetBrains Mono** | Kode referral, nomor tiket, ID         |

### Design System

| Atribut             | Nilai                                         |
| ------------------- | --------------------------------------------- |
| Border Radius Cards | 12–16px                                       |
| Border Radius Modal | 20px                                          |
| Shadow              | Subtle soft only                              |
| Icon Style          | Outline modern                                |
| Theme               | Light + Dark mode (ikut setting HP)           |
| Bottom Nav          | 5 menu (Home / Info / Promo / Support / Akun) |
| Header              | Logo + Greeting + 🔔 Notifikasi               |

### AI Design Prompt (Master)

```
"Design a screen for JBR Mimpo — a modern premium ISP
mobile app from Indonesia.

Design system:
- Style: Clean minimalist, premium, modern tech ISP
- Primary color: Emerald Green #10B981
- Dark accent: #059669 | Light accent: #34D399
- Background light: #F8FAFB | Background dark: #111827
- Heading font: Sora (bold, futuristik)
- Body font: DM Sans (clean, readable)
- Code font: JetBrains Mono (referral code, ticket number)
- Border radius: 12–16px cards, 20px modals
- Shadow: soft subtle only
- Icon style: outline modern
- Support light AND dark mode
- Bottom navigation: Home | Info | Promo | Support | Akun
- Notification bell icon at top right header"
```

### Design Prompts Per Halaman — Mobile App

**1. Splash Screen**

```
[MASTER PROMPT]
Screen: Splash Screen
- Full screen background: Emerald gradient (#10B981 → #059669)
- Center: JBR Mimpo logo (Sora font, white, bold)
- Tagline: "Internet Cepat, Hidup Mudah" (DM Sans, white, 14px)
- Bottom: loading indicator (thin white line animation)
- Feel: premium, clean, confident
```

**2. Onboarding (3 slide)**

```
[MASTER PROMPT]
Screen: Onboarding — 3 slides with dot indicator
Slide 1: Illustration network icon | "Info Gangguan Real-Time"
Slide 2: Illustration gift icon | "Promo & Reward Eksklusif"
Slide 3: Illustration headset icon | "CS Online 24 Jam"
Bottom: dot indicator + "Mulai Sekarang" button (emerald)
Skip button top right
```

**3. Login**

```
[MASTER PROMPT]
Screen: Login
- JBR Mimpo logo + tagline (small, top)
- Title (Sora): "Masuk ke Akun"
- Input: Nomor WhatsApp (WA icon) + Sandi (eye toggle)
- "Lupa Sandi?" link (emerald, right aligned)
- CTA: "Masuk" (full width, emerald)
- "Belum punya akun? Daftar" link
- Input style: rounded 12px, emerald focus state
```

**4. Register**

```
[MASTER PROMPT]
Screen: Register
- Back button + title "Buat Akun Baru"
- Step indicator (1 of 2)
- Inputs: Nama Lengkap | No WA | Alamat/Area | Sandi | Konfirmasi Sandi
- Password strength indicator
- CTA: "Daftar & Kirim OTP" (full width, emerald)
```

**5. Verifikasi OTP**

```
[MASTER PROMPT]
Screen: Verifikasi OTP
- WA icon illustration (green themed)
- Title: "Cek WhatsApp Kamu"
- Subtitle: nomor WA yang digunakan
- 6 OTP boxes (large, JetBrains Mono, emerald focus)
- Countdown timer + "Kirim Ulang OTP" link
- CTA: "Verifikasi" (full width, emerald)
```

**6. Home**

```
[MASTER PROMPT]
Screen: Home — layout top to bottom:
1. Header: Logo + "Halo, [Nama] 👋" + 🔔 bell
2. Banner Promo slideshow (emerald gradient, white text, dot indicator)
3. Status Paket Card (light emerald bg, green dot, paket name + Aktif badge)
4. Section "Pengumuman Terbaru" (2 cards: icon + title + date + arrow)
5. Quick Action: "Lapor Gangguan" (filled) + "Lihat Promo" (outline)
6. Bottom navigation bar
```

**7. Informasi**

```
[MASTER PROMPT]
Screen: Informasi
- Header: "Informasi" + search icon
- Search bar (expandable)
- Filter chips: Semua | Gangguan | Maintenance | Info Umum
- List cards: thumbnail + category badge + title + preview + date + unread dot
- Pinned items: pin icon + highlight bg
- Pagination / infinite scroll
```

**8. Detail Pengumuman**

```
[MASTER PROMPT]
Screen: Detail Pengumuman
- Back button + share icon
- Hero image (full width, rounded bottom)
- Category badge + title (Sora bold) + date
- Content body (DM Sans, line height 1.7)
```

**9. Promo & Reward**

```
[MASTER PROMPT]
Screen: Promo & Reward — 4 tabs (emerald underline active)
Tab Promo: cards dengan banner + countdown timer (JetBrains Mono) + filter + pagination
Tab Reward: poin balance card (emerald gradient) + reward grid + leaderboard + filter + pagination
Tab Undian: lottery card premium + hadiah + countdown + "Ikut Undian" CTA + filter + pagination
Tab Referral: kode box (JetBrains Mono, dashed border) + share WA + stats
```

**10. Support / CS**

```
[MASTER PROMPT]
Screen: Support
- 4 action cards (2x2): Lapor Gangguan | Cek Tiket | Chat CS | FAQ
- Recent ticket section (ticket card + status badge)
- Chat CS floating button bottom right (emerald + bot icon)
```

**11. Form Lapor Gangguan**

```
[MASTER PROMPT]
Screen: Lapor Gangguan
- Back + title
- Dropdown: jenis gangguan
- Textarea: deskripsi masalah
- Image upload box (dashed, camera icon)
- GPS card: map thumbnail + alamat + "Gunakan Lokasi" button
- Date time picker: waktu gangguan
- Bottom fixed: "Kirim Laporan" (emerald, full width)
```

**12. Tracking Tiket**

```
[MASTER PROMPT]
Screen: Tracking Tiket — Tab: Aktif | Selesai
- Filter + search + pagination
- Ticket cards: number (JetBrains Mono) + type + date + status badge
- Progress stepper horizontal (5 steps, emerald active)
- Rating bottom sheet (5 stars + feedback + submit)
```

**13. Chat CS / Bot Chatbot**

```
[MASTER PROMPT]
Screen: Chat CS
- Header: "CS JBR Mimpo" + "Bot Online" green badge + WA icon
- User bubble: right, emerald bg, white text
- Bot/CS bubble: left, white card, gray text
- Tombol pilihan kategori: row chips di atas input (emerald outline)
- Sub-pilihan muncul setelah user tap kategori
- Input bar: rounded + send button (emerald) — aktif setelah bot eskalasi ke CS
- Admin takeover: system message "CS bergabung" (gray pill, center)
- Rating bottom sheet setelah sesi selesai
```

**14. FAQ**

```
[MASTER PROMPT]
Screen: FAQ
- Header + search bar
- Category filter chips
- FAQ accordion: question bold + answer expands + chevron rotate
- Emerald left border on expanded item
- Pagination
```

**15. Akun**

```
[MASTER PROMPT]
Screen: Akun
- Profile header card (emerald gradient): avatar + nama + WA + paket badge
- Menu sections: Akun | Preferensi | Lainnya
- Each item: icon + label + chevron right
- Bottom: "Keluar" button (red outline, full width)
```

### Design Prompts Per Halaman — Dashboard Admin

**Master Prompt Dashboard:**

```
"Design a web dashboard screen for JBR Mimpo Admin —
a modern premium ISP management dashboard.
- Style: Clean professional SaaS dashboard
- Primary: Emerald Green #10B981
- Sidebar: dark (#111827) with emerald accents, width 240px
- Content bg: #F8FAFB | Card bg: #FFFFFF
- Fonts: Sora (heading) + DM Sans (body) + JetBrains Mono (ID/code)
- Border radius: 8–12px | Shadow: subtle
- Layout: fixed left sidebar + top header + content area
- Desktop first (1280px+)
- Setiap halaman list: wajib ada filter bar + search + sort + pagination"
```

**1. Login Admin** — Split layout: emerald panel kiri + form putih kanan  
**2. Overview** — 4 stat cards + rating summary card + line chart + donut chart + tiket terbaru + chat pending  
**3. Kelola Informasi** — Table + filter bar + search + pagination + create/edit side panel (rich text editor)  
**4. Kelola Promo & Reward** — Tab: Promo | Reward | Poin Pelanggan — semua dengan filter + pagination  
**5. Kelola Undian & Referral** — Tab: Undian | Referral + proses undian modal  
**6. Kelola Tiket & CS** — Tab: Tiket | Chat CS (split view) | FAQ | Konfigurasi Bot  
**7. Data Pelanggan** — Table + search/filter + sort + pagination + detail side panel + export button  
**8. Push Notification** — Form + phone mockup preview + Tab: History | Template  
**9. Pengaturan** — Sub-menu: Akun Admin | CS Agent | Poin | Bot CS | Tampilan App | Log | Backup

---

## 9. Security

### Autentikasi & Token

| Atribut                | Detail                                              |
| ---------------------- | --------------------------------------------------- |
| Metode Login Pelanggan | No WA + Sandi + OTP via WA (Fonnte)                 |
| Metode Login Admin     | Email + Password + OTP via WA (2FA wajib)           |
| Token Strategy         | Persistent login — auto refresh token               |
| Access Token           | 24 jam                                              |
| Refresh Token          | 365 hari, auto refresh background                   |
| Invalidasi             | Hanya saat manual logout atau "logout semua device" |
| Beda Device Pelanggan  | Wajib OTP WA ulang — multi-device diperbolehkan     |
| Beda Device Admin      | Wajib OTP WA ulang — device lama otomatis logout    |
| Mobile Storage         | Flutter Secure Storage                              |
| Dashboard Storage      | httpOnly cookie (tidak bisa diakses JavaScript)     |

### Enkripsi Data

| Data                    | Metode                          |
| ----------------------- | ------------------------------- |
| Sandi pelanggan & admin | bcrypt hashing (cost factor 12) |
| OTP code                | Hash sebelum disimpan di Redis  |
| Semua komunikasi API    | HTTPS / TLS 1.3                 |
| Refresh token mobile    | Flutter Secure Storage          |
| Refresh token dashboard | httpOnly cookie                 |

### API Protection

| Proteksi         | Detail                                          |
| ---------------- | ----------------------------------------------- |
| Rate Limiting    | 100 request/menit per user                      |
| OTP Brute Force  | Maks 5x salah → blocked 30 menit                |
| JWT Verification | Verifikasi setiap request                       |
| Input Validation | Sanitasi semua input, cegah XSS & SQL injection |
| CORS Policy      | Hanya domain resmi yang bisa akses API          |

### Admin Security

| Proteksi      | Detail                                      |
| ------------- | ------------------------------------------- |
| 2FA           | Wajib setiap login (Email + Sandi + OTP WA) |
| Single Device | Login baru otomatis logout device lama      |
| Session       | Persistent, logout manual only              |
| Activity Log  | Semua aksi tercatat otomatis                |
| Notifikasi    | WA alert jika login dari device baru        |

### Infrastructure Security

| Proteksi    | Detail                                           |
| ----------- | ------------------------------------------------ |
| Firewall    | Hanya port 80, 443, 22 terbuka                   |
| SSH         | Key only — tidak pakai password                  |
| Auto Update | Ubuntu auto security update                      |
| Fail2ban    | Auto block IP brute force SSH                    |
| Database    | Internal only — tidak exposed ke internet        |
| Docker      | Non-root user di dalam container                 |
| Secrets     | Disimpan di environment variables, tidak di kode |

---

## 10. Rules

### Business Rules

**Poin & Reward:**

- Poin login harian: 1x per hari per akun
- Poin tidak punya expired date
- Poin tidak bisa dipindah antar akun
- Poin referral diberikan otomatis saat kode dipakai saat register
- Saldo poin harus cukup sebelum bisa tukar reward
- Reward hanya bisa diklaim 1x per user

**Promo:**

- Promo bersifat informatif — tidak ada mekanisme klaim
- Promo otomatis nonaktif setelah end_date terlewat
- User yang tertarik menghubungi CS

**Undian:**

- 1 pelanggan hanya bisa ikut 1x per undian
- Pelanggan nonaktif tidak bisa ikut undian
- Admin tidak bisa ikut undian
- Pemenang diumumkan sesuai tanggal draw

**Tiket:**

- 1 pelanggan hanya bisa punya 1 tiket aktif bersamaan
- Tiket otomatis ditutup setelah 7 hari tidak ada update
- Rating hanya bisa diberikan setelah tiket berstatus SELESAI

**Referral:**

- Tidak bisa pakai kode referral sendiri
- 1 nomor WA hanya bisa menjadi referred 1x

**Akun:**

- 1 nomor WA hanya bisa untuk 1 akun
- Akun nonaktif tidak bisa login
- Pelanggan tidak bisa ubah nomor WA sendiri (harus minta admin)

**Notifikasi:**

- Maks 3 push notif per hari per user (anti spam)
- Notif hanya dikirim ke pelanggan aktif
- Jam tenang: 22.00–07.00 WIB (kecuali notif gangguan darurat)

**Chat CS:**

- Bot aktif 24 jam
- Setelah CS Agent takeover, bot tidak bisa balas di sesi yang sama
- Rating sesi chat hanya bisa diberikan setelah sesi ditutup

**Bot CS:**

- Semua tombol kategori dan jawaban dikelola penuh oleh admin
- Tidak ada konten bot yang hardcoded di kode
- Perubahan konfigurasi bot langsung berlaku tanpa perlu update app

**Export Data:**

- Setiap export Excel tercatat di activity log (siapa, kapan)
- Hanya Super Admin yang bisa export

**Backup:**

- Backup otomatis: harian 01.00 WIB
- Backup manual: hanya bisa di-trigger oleh Super Admin
- Setiap backup manual tercatat di activity log

### Validation Rules

**Auth:**

- Nomor WA: wajib, format +62/08xx, 10–15 digit
- Sandi: wajib, min 8 karakter, kombinasi huruf & angka
- OTP: 6 digit angka, expire 5 menit, maks 5x salah → blocked 30 menit
- Nama: wajib, min 3 karakter, maks 100 karakter
- Alamat: wajib, min 10 karakter

**Input Global:**

- Semua input di-trim (hapus spasi awal & akhir otomatis)
- Tidak boleh input HTML/script tag (cegah XSS)
- Emoji diperbolehkan di deskripsi & chat, tidak di judul

**Pengumuman:**

- Judul: wajib, maks 200 karakter
- Konten: wajib, min 10 karakter
- Gambar: maks 5MB, format JPG/PNG/WebP
- Jadwal publish: tidak boleh masa lalu

**Tiket Gangguan:**

- Jenis gangguan: wajib dipilih
- Deskripsi: wajib, min 10 karakter
- Foto: opsional, maks 5MB, JPG/PNG
- GPS: wajib aktif saat lapor

**Chat:**

- Pesan: maks 1000 karakter, tidak boleh kosong
- File upload di chat: maks 5MB, format JPG/PNG/PDF

**Bot CS:**

- Label tombol kategori: wajib, maks 200 karakter
- Jawaban: wajib, min 10 karakter

**Promo & Undian:**

- Tanggal end tidak boleh sebelum tanggal start
- Hadiah undian: wajib diisi, maks 500 karakter
- Poin reward: min 1, tidak boleh negatif

**File Upload Global:**

- Maks 5MB per file
- Format: JPG, PNG, WebP only (kecuali chat: tambah PDF)
- Auto compress sebelum upload (maks 1MB setelah compress)

**Notifikasi:**

- Judul: wajib, maks 100 karakter
- Pesan: wajib, maks 300 karakter
- Target: wajib dipilih minimal 1

**Pagination Global:**

- Default limit: 20 item per halaman
- Maks limit: 100 item per halaman

### Permission Rules

**Guest (belum login):**

- ✅ Lihat promo publik
- ✅ Lihat info & pengumuman umum
- ❌ Semua fitur lain → redirect ke login

**Pelanggan (sudah login):**

- ✅ Semua fitur mobile app
- ✅ Lihat data diri sendiri only
- ✅ Lihat tiket milik sendiri only
- ✅ Lihat history poin & reward sendiri
- ✅ Multi-device login
- ❌ Lihat data pelanggan lain
- ❌ Edit nomor WA sendiri (harus minta admin)
- ❌ Hapus tiket yang sudah dibuat
- ❌ Ikut undian jika status akun nonaktif
- ❌ Tukar poin jika saldo tidak cukup
- ❌ Buat tiket baru jika sudah ada tiket aktif
- ❌ Akses dashboard admin

**CS Agent:**

- ✅ Lihat & update tiket
- ✅ Assign tiket
- ✅ Balas chat & takeover dari bot
- ✅ Kelola FAQ
- ✅ Lihat data dasar pelanggan yang sedang ditangani (nama, WA, paket aktif)
- ✅ Hanya 1 device aktif
- ❌ Lihat data pelanggan yang tidak sedang ditangani
- ❌ Kelola konten, promo, notifikasi
- ❌ Akses pengaturan sistem
- ❌ Export data atau trigger backup
- ❌ Lihat activity log
- ❌ Lihat rating & analisis

**Super Admin:**

- ✅ Full access semua fitur dashboard
- ✅ Lihat & kelola semua data pelanggan
- ✅ Kelola akun CS Agent
- ✅ Export data & trigger backup manual
- ✅ Lihat rating & analisis performa CS
- ✅ Semua aksi tercatat di activity log
- ✅ Hanya 1 device aktif
- ❌ Hapus data pelanggan (hanya bisa nonaktifkan)
- ❌ Ubah history poin yang sudah tercatat
- ❌ Hapus activity log
- ❌ Hapus pengumuman yang sudah published (hanya arsipkan)

**Bot CS:**

- ✅ Baca konfigurasi tombol & jawaban dari database
- ✅ Balas pesan user sesuai pilihan tombol
- ✅ Eskalasi ke CS Agent jika user pilih "Lainnya"
- ❌ Ubah data apapun di sistem
- ❌ Akses data personal user selain nama & paket aktif
- ❌ Proses klaim reward
- ❌ Balas setelah CS Agent takeover sesi yang sama

### System Constraints

**Performa:**

- API response time: maks 3 detik
- Home screen load: maks 2 detik
- Push notif terkirim: maks 30 detik setelah admin kirim
- Timeout API: maks 10 detik
- Retry otomatis: 3x dengan exponential backoff

**Kapasitas:**

- Maks concurrent user: 10.000+
- Maks ukuran file upload: 5MB
- Maks pesan chat per sesi: 500 pesan
- Maks pengumuman di Home: 2 item
- Maks banner promo slideshow: 5 banner
- Database connection pool: maks 100
- Queue worker: maks 10 concurrent
- Pagination default: 20 item, maks 100 item

**Availability:**

- Uptime target: 99.5%
- Maintenance window: 00.00–04.00 WIB
- Backup harian: 01.00 WIB otomatis
- VPS cadangan: tersedia, switch manual oleh Super Admin
- Auto restart container jika crash (Docker restart policy: always)

**Jaringan:**

- App tetap usable di jaringan 3G
- Offline mode: tampilkan semua data cache terakhir
- Redis cache TTL default: 5 menit

**Keamanan:**

- OTP expired: 5 menit
- Akun blocked: 5x salah OTP → 30 menit
- Rate limit: 100 request/menit per user
- Session admin: persistent, logout manual only, single device

**Data Retention:**

- Log aktivitas admin: disimpan min 1 tahun
- History chat CS: disimpan min 6 bulan
- Notifikasi di app: maks 90 hari
- File foto tiket: maks 1 tahun
- Backup database: disimpan min 3 bulan di cloud storage

**Notifikasi:**

- Maks 3 push notif per hari per user
- Jam tenang: 22.00–07.00 WIB (kecuali notif gangguan darurat)
- Notif gangguan darurat: boleh dikirim kapan saja

---

## 11. Mind Map

```
JBR Minpo
│
├── 👥 USERS
│   ├── Guest → lihat promo & info publik
│   ├── Pelanggan → full mobile app, multi-device
│   ├── CS Agent → tiket, chat, FAQ, data dasar pelanggan
│   ├── Super Admin → full dashboard access, single device
│   └── Bot CS → sistem tombol, bukan AI generatif
│
├── 📱 MOBILE APP (Flutter)
│   ├── Auth → Login | Register | OTP | Lupa Sandi
│   ├── Home → Banner | Paket | Pengumuman | Quick Action
│   ├── Informasi → List | Filter | Search | Detail | Share
│   ├── Promo & Reward
│   │   ├── Tab Promo → informatif, tidak ada klaim
│   │   ├── Tab Reward → poin, tukar, leaderboard
│   │   ├── Tab Undian → ikut, pemenang
│   │   └── Tab Referral → kode unik, share WA
│   ├── Support
│   │   ├── Lapor Gangguan → form + GPS + foto
│   │   ├── Tracking Tiket → 5 status + rating
│   │   ├── Chat CS → Bot Tombol → eskalasi CS Agent
│   │   └── FAQ → filter + search
│   └── Akun → Profil | Notif | Keamanan | Bahasa | Logout
│
├── 🖥️ DASHBOARD ADMIN (Next.js)
│   ├── Overview → statistik + rating summary + alert
│   ├── Kelola Informasi → CRUD + jadwal + pin + arsip
│   ├── Kelola Promo & Reward → promo + undian + poin + reward
│   ├── Kelola Tiket & CS → tiket + chat + FAQ + konfigurasi bot
│   ├── Data Pelanggan → list + detail + export Excel
│   ├── Push Notification → broadcast + targeted + template
│   └── Pengaturan → admin + CS + poin + bot + backup + log
│
├── ⚙️ SISTEM
│   ├── Backend → Go (Gin) — Monolith Modular
│   ├── Database → PostgreSQL 16
│   ├── Cache → Redis 7 (OTP, session, cache)
│   ├── Queue → RabbitMQ (notif, reward, backup)
│   ├── File → MinIO (foto, banner)
│   ├── WA OTP → Fonnte (nomor dedicated, tanpa fallback)
│   ├── Push Notif → FCM (Firebase)
│   └── Real-time Chat → WebSocket (Gorilla)
│
├── 🏗️ INFRASTRUKTUR
│   ├── VPS Utama + VPS Cadangan (switch manual)
│   ├── Docker Compose
│   ├── CI/CD GitHub Actions
│   │   ├── Backend + Dashboard → build + deploy ke VPS
│   │   └── Mobile → build APK/IPA saja
│   ├── Monitoring → Prometheus + Grafana + Loki
│   ├── Error Tracking → Sentry
│   └── Backup → otomatis harian + manual dari dashboard
│
├── 🔒 SECURITY
│   ├── Auth → OTP WA + JWT + bcrypt
│   ├── Token → Access 24 jam + Refresh 365 hari
│   ├── Admin → 2FA + single device + activity log
│   ├── API → rate limit + input validation + CORS
│   └── Infra → firewall + SSH key + fail2ban + Docker non-root
│
└── 📋 RULES
    ├── Business → poin, promo, undian, tiket, referral, akun
    ├── Validation → semua input tervalidasi + pagination global
    ├── Permission → guest, pelanggan, CS Agent, Super Admin, bot
    └── Constraints → performa, kapasitas, availability, retention
```

---

_PROJECT BRIEF JBR Minpo v1.1.0_  
_Dokumen ini merupakan blueprint resmi sebelum development dimulai._  
_Semua keputusan dalam dokumen ini telah didiskusikan dan disetujui._  
_Setiap sesi development wajib membaca seluruh brief ini dan mengaktifkan MCP & Skills yang relevan._

