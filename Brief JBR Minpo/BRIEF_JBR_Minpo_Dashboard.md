# PROJECT BRIEF â€” JBR Minpo DASHBOARD
> Jabbar Media Informasi dan Promosi â€” Dashboard Web Admin
> Platform: Web (Next.js) Â· Desktop First
> Version: 1.0.0 Â· Status: Final

---

## DAFTAR ISI
1. [Project Overview](#1-project-overview)
2. [User & Roles Admin](#2-user--roles-admin)
3. [Sitemap & Navigasi](#3-sitemap--navigasi)
4. [Menu, Halaman & Fitur](#4-menu-halaman--fitur)
5. [Flow Admin](#5-flow-admin)
6. [Tech Stack Dashboard](#6-tech-stack-dashboard)
7. [Security Dashboard](#7-security-dashboard)
8. [Rules Dashboard](#8-rules-dashboard)
9. [Koneksi ke Mobile App](#9-koneksi-ke-mobile-app)

---

## 1. Project Overview

### Identitas Produk
| Atribut | Detail |
|---|---|
| Nama | JBR Minpo Dashboard |
| Fungsi | Panel admin untuk kelola semua konten JBR Minpo |
| Platform | Web (browser) |
| Framework | Next.js 14 (React + TypeScript) |
| Target User | Admin / tim internal ISP Jabbar23 |
| Versi | 1.0.0 |

### Prinsip Utama
> Semua konten yang dilihat pelanggan di mobile app JBR Minpo dapat dikelola penuh oleh admin dari dashboard ini. Tidak ada konten hardcoded di app mobile.

### Scope Dashboard
| Dalam Scope |
|---|
| Kelola informasi & pengumuman |
| Kelola promo, reward, undian, referral |
| Kelola tiket gangguan & CS online |
| Kelola data pelanggan |
| Kirim push notification |
| Pengaturan sistem & konfigurasi |
| Monitoring & statistik |

---

## 2. User & Roles Admin

| Atribut | Detail |
|---|---|
| Level admin | 1 level (Admin â€” full access) |
| Login | Email + Password + OTP via WA (2FA wajib) |
| Session | Persistent â€” tidak logout kecuali manual |
| Beda device | Wajib OTP WA ulang |
| Notifikasi | WA alert jika login dari device baru |
| Semua aksi | Tercatat otomatis di activity log |

### Akses Admin
- Full access semua menu & fitur dashboard
- Lihat & kelola semua data pelanggan
- Tidak bisa hapus data pelanggan (hanya nonaktifkan)
- Tidak bisa hapus activity log
- Tidak bisa ubah history poin yang sudah tercatat

---

## 3. Sitemap & Navigasi

### Struktur Layout
```
JBR Minpo DASHBOARD
â”‚
â”œâ”€â”€ Sidebar (fixed kiri, 240px, dark #111827)
â”‚   â”œâ”€â”€ Logo JBR Minpo
â”‚   â”œâ”€â”€ ðŸ“Š Overview
â”‚   â”œâ”€â”€ ðŸ“¢ Kelola Informasi
â”‚   â”œâ”€â”€ ðŸŽ Kelola Promo & Reward
â”‚   â”œâ”€â”€ ðŸŽ§ Kelola Tiket & CS
â”‚   â”œâ”€â”€ ðŸ‘¥ Data Pelanggan
â”‚   â”œâ”€â”€ ðŸ”” Push Notification
â”‚   â””â”€â”€ âš™ï¸ Pengaturan
â”‚
â”œâ”€â”€ Top Header (fixed atas)
â”‚   â”œâ”€â”€ Judul halaman aktif
â”‚   â”œâ”€â”€ Tanggal hari ini
â”‚   â””â”€â”€ Nama admin + avatar dropdown (logout)
â”‚
â””â”€â”€ Content Area (scrollable)
```

---

## 4. Menu, Halaman & Fitur

---

### ðŸ“Š OVERVIEW

**Tujuan:** Tampilan ringkasan kondisi sistem secara real-time.

#### Kartu Statistik (4 kartu)
| Kartu | Isi | Fitur |
|---|---|---|
| Total Pelanggan Aktif | Jumlah pelanggan status aktif | Angka + trend naik/turun + klik ke Data Pelanggan |
| Tiket Masuk Hari Ini | Jumlah tiket belum diproses | Angka + trend + klik ke Kelola Tiket |
| Promo & Undian Aktif | Jumlah promo/undian berjalan | Angka + trend + klik ke Kelola Promo |
| Chat Belum Dibalas | Jumlah sesi chat pending | Angka + trend + klik ke Chat CS |

#### Grafik Aktivitas Login User
- Tipe: Line chart
- Default: 7 hari terakhir
- Bisa ganti periode (filter tanggal bebas)
- Data: jumlah login unik per hari

#### Alert Prioritas
Muncul otomatis jika kondisi berikut terpenuhi:
| Kondisi | Default Threshold |
|---|---|
| Tiket belum diproses | > 2 jam |
| Chat belum dibalas | > 10 menit |
| Klaim reward pending | > 24 jam |
| Undian melewati draw date | Langsung alert |

Threshold bisa diubah di menu Pengaturan â†’ Alert Threshold.

#### Section Tiket Terbaru
- List 5 tiket terbaru yang belum diproses
- Kolom: No. Tiket | Nama | Jenis | Status | Waktu masuk
- Klik â†’ langsung ke detail tiket

#### Section Chat Pending
- List 5 sesi chat yang belum dibalas
- Kolom: Nama pelanggan | Preview pesan | Waktu
- Klik â†’ langsung ke chat window

---

### ðŸ“¢ KELOLA INFORMASI

**Tujuan:** Buat, kelola, dan publish pengumuman ke pelanggan di mobile app.

#### Halaman Utama â€” List Pengumuman

**Tabel Pengumuman:**
| Kolom | Keterangan |
|---|---|
| Thumbnail | Preview gambar (60x60) |
| Judul | Judul pengumuman |
| Kategori | Gangguan / Maintenance / Info Umum |
| Area | Area target (atau "Semua") |
| Status | Draft / Published / Scheduled / Archived |
| Jadwal Publish | Tanggal & jam publish |
| Dibuat Oleh | Nama admin pembuat |
| Total Dibaca | Jumlah pelanggan yang sudah baca |
| Aksi | Tombol aksi per baris |

**Filter & Search:**
- Search keyword (judul)
- Filter kategori
- Filter status (Draft / Published / Scheduled / Archived)
- Filter area
- Filter tanggal range
- Filter pin only (tampilkan yang sedang di-pin saja)

**Aksi Per Baris:**
- Edit pengumuman
- Pin / Unpin (maks 1 yang di-pin tampil di Home mobile)
- Arsipkan (pengumuman published tidak bisa dihapus, hanya diarsipkan)
- Hapus (hanya untuk status Draft)
- Preview tampilan di mobile (simulasi)
- Duplikat (copy sebagai draft baru)
- Lihat statistik baca (siapa saja, dari area mana, kapan)

#### Form Buat / Edit Pengumuman (side panel slide-in)

| Field | Tipe | Keterangan |
|---|---|---|
| Judul | Text input | Wajib, maks 200 karakter |
| Kategori | Dropdown | Gangguan / Maintenance / Info Umum |
| Area | Multi-select | Pilih area atau "Semua Area" |
| Konten | Rich text editor (Tiptap) | Wajib, min 10 karakter |
| Gambar / Thumbnail | Upload | Maks 5MB, JPG/PNG/WebP |
| Tag / Label | Input chips | Opsional, untuk pengelompokan |
| Jadwal Publish | Date time picker | Kosong = publish sekarang |
| Toggle Pin | Toggle | Jadikan pengumuman penting |
| Toggle Publish | Toggle | Draft / Published |
| Toggle Notifikasi | Toggle | Kirim push notif otomatis saat publish |

**Tombol:**
- "Simpan Draft"
- "Publish Sekarang" / "Jadwalkan"

---

### ðŸŽ KELOLA PROMO & REWARD

**Tujuan:** Kelola semua program promosi, reward, undian, referral, dan poin pelanggan.

**Tab:** Promo | Reward & Klaim | Undian | Referral | Poin Pelanggan

---

#### Tab Promo

**Tabel Promo:**
| Kolom | Keterangan |
|---|---|
| Banner | Thumbnail banner promo |
| Judul | Judul promo |
| Periode | Tanggal mulai - selesai |
| Status | Draft / Active / Expired |
| Total Klaim | Jumlah pelanggan yang klaim |
| Dibuat Oleh | Nama admin |
| Sisa Waktu | Countdown berakhir |
| Aksi | Edit / Duplikat / Hapus |

**Filter:** keyword | status | tanggal | target

**Form Buat / Edit Promo:**
| Field | Tipe |
|---|---|
| Judul promo | Text input (wajib) |
| Deskripsi | Textarea |
| Banner | Upload gambar (wajib) |
| Tanggal mulai & selesai | Date picker |
| Syarat & ketentuan | Rich text editor |
| Target pelanggan | Radio: Semua / Area tertentu / Paket tertentu |
| Maks klaim | Number input (opsional, 0 = unlimited) |
| Toggle publish | Draft / Published |
| Toggle notif saat publish | Kirim push notif otomatis |

---

#### Tab Reward & Klaim

**Sub bagian 1 â€” Daftar Reward:**

| Kolom | Keterangan |
|---|---|
| Nama reward | |
| Tipe | Gratis 1 bulan / Diskon / Poin |
| Poin Dibutuhkan | |
| Stok | Tersisa / Total (atau Unlimited) |
| Status | Aktif / Nonaktif |
| Total Diklaim | |
| Tanggal Dibuat | |
| Aksi | Edit / Aktifkan/Nonaktifkan |

**Form Tambah / Edit Reward:**
| Field | Tipe |
|---|---|
| Nama reward | Text input |
| Deskripsi | Textarea |
| Tipe reward | Dropdown |
| Poin dibutuhkan | Number input |
| Stok | Number input (0 = unlimited) |
| Status | Toggle aktif/nonaktif |

**Sub bagian 2 â€” Klaim Masuk:**

| Kolom | Keterangan |
|---|---|
| Nama pelanggan | |
| No. WhatsApp | Tombol shortcut WA |
| Reward diklaim | |
| Poin digunakan | |
| Status | Pending / Diproses / Selesai |
| Tanggal klaim | |
| Diproses oleh | Nama admin |
| Catatan admin | Notes internal |
| Aksi | Proses / Selesai / Tolak |

**Filter klaim:** status | tanggal | nama pelanggan

---

#### Tab Undian

**Tabel Undian:**
| Kolom | Keterangan |
|---|---|
| Judul | |
| Hadiah | Preview singkat |
| Periode | Mulai - selesai |
| Jumlah Peserta | |
| Status | Upcoming / Active / Done |
| Tipe Draw | Auto / Manual |
| Tanggal Draw | |
| Pemenang | Nama pemenang (jika sudah draw) |
| Aksi | |

**Aksi per undian:**
- Edit (jika belum active)
- Lihat peserta (list semua peserta)
- Proses pengundian (jika tipe Manual)
- Umumkan pemenang (setelah draw)
- Duplikat
- Arsipkan

**Form Buat / Edit Undian:**
| Field | Tipe |
|---|---|
| Judul undian | Text input |
| Deskripsi | Textarea |
| Detail hadiah | Rich text editor |
| Gambar hadiah | Upload |
| Tipe join | Dropdown: Auto / Pakai Poin / Pakai Tiket |
| Poin dibutuhkan | Number (muncul jika tipe = poin) |
| Syarat peserta | Dropdown: Semua / Aktif saja / Paket tertentu |
| Filter paket | Multi-select (muncul jika syarat = paket) |
| Tipe draw | Radio: Auto (sistem) / Manual (admin) |
| Tanggal mulai | Date time picker |
| Tanggal selesai | Date time picker |
| Tanggal draw | Date time picker |
| Maks peserta | Number (opsional) |
| Toggle publish | |
| Toggle notif saat publish | |

**Modal Proses Pengundian:**
- List semua peserta (scrollable)
- Tombol "Acak Pemenang" (animasi spin)
- Kartu pemenang terpilih (reveal effect)
- Tombol "Umumkan Pemenang" â†’ trigger:
  - Push notif ke pemenang
  - Update halaman undian mobile (nama pemenang)
  - Banner pemenang di Home mobile
  - Notif ke admin (no WA pemenang)

---

#### Tab Referral

**Tabel Referral:**
| Kolom | Keterangan |
|---|---|
| Nama pengajak (referrer) | |
| No. WA referrer | Shortcut WA |
| Nama yang diajak (referred) | |
| No. WA referred | |
| Kode referral | JetBrains Mono |
| Status | Pending / Rewarded |
| Tanggal daftar | |
| Reward diberikan | Detail reward |
| Aksi | Lihat detail |

**Filter:** status | tanggal | nama

**Statistik Referral (kartu atas):**
- Total referral
- Berhasil
- Pending
- Total reward didistribusikan

---

#### Tab Poin Pelanggan

**Bagian 1 â€” Cari Pelanggan:**
- Search by nama / no WA
- Card pelanggan terpilih:
  - Nama + No WA
  - Saldo poin saat ini
  - Rank leaderboard
  - Paket aktif + status

**Bagian 2 â€” Adjust Poin Manual:**
| Field | Tipe |
|---|---|
| Tipe | Radio: Tambah / Kurangi |
| Jumlah poin | Number input (min 1) |
| Alasan | Dropdown + opsional notes |
| | Tombol "Update Poin" |

**Bagian 3 â€” History Transaksi Poin:**
| Kolom | Keterangan |
|---|---|
| Tanggal | |
| Tipe | Login / Loyalty / Referral / Event / Redeem / Manual |
| Jumlah | + atau - |
| Sumber / Keterangan | |
| Saldo setelah | |
| Dilakukan oleh | Sistem / Nama admin |

---

### ðŸŽ§ KELOLA TIKET & CS

**Tab:** Tiket | Chat CS | FAQ

---

#### Tab Tiket

**Tabel Tiket:**
| Kolom | Keterangan |
|---|---|
| No. Tiket | Format #TKT-YYYYMMDD-XXX (JetBrains Mono) |
| Nama Pelanggan | |
| No. WA | Shortcut tombol WA |
| Jenis Gangguan | Internet Mati / Lambat / Lainnya |
| Area / Lokasi | |
| Status | Menunggu / Diproses / Dalam Perjalanan / Selesai / Ditutup |
| Assigned To | Nama admin/NOC yang handle |
| Waktu Masuk | |
| Durasi | Sudah berapa lama sejak masuk |
| Rating | Bintang (jika sudah dirating pelanggan) |
| Aksi | |

**Filter & Search:**
- Search no. tiket / nama / no WA
- Filter status
- Filter jenis gangguan
- Filter area
- Filter assigned to
- Filter tanggal range
- Filter rating

**Aksi Per Tiket:**
- Lihat detail (side panel)
- Update status
- Assign ke admin/NOC
- Tutup tiket
- Hubungi via WA (shortcut langsung)

**Detail Tiket (side panel kanan):**
```
Section 1 â€” Info Pelanggan:
Nama + No WA + paket aktif
Tombol "Hubungi via WA"

Section 2 â€” Detail Gangguan:
Jenis + deskripsi + foto (bisa diperbesar)
Koordinat GPS + map thumbnail (klik â†’ Google Maps)
Waktu gangguan dilaporkan mulai

Section 3 â€” Timeline Status:
Log semua perubahan status (siapa, kapan, catatan)

Section 4 â€” Update Status:
Dropdown status baru
Input catatan (opsional)
Dropdown assign ke admin/NOC
Tombol "Simpan Perubahan"

Section 5 â€” Rating & Feedback:
Bintang rating dari pelanggan
Teks feedback
(muncul setelah tiket selesai & dirating)
```

---

#### Tab Chat CS

**Layout Split View:**

**Panel Kiri (35%) â€” List Sesi Chat:**
| Elemen | Keterangan |
|---|---|
| Avatar inisial | |
| Nama pelanggan | |
| Preview pesan terakhir | 1 baris |
| Waktu | |
| Badge unread | Jumlah pesan belum dibaca |
| Badge status | AI (hijau) / Human (biru) / Closed (abu) |

Filter sesi: Semua | AI | Human | Closed
Search: nama / no WA

**Panel Kanan (65%) â€” Chat Window:**

Header:
- Foto + nama pelanggan
- Info paket aktif
- No WA + tombol shortcut WA
- Badge: "AI sedang aktif" / "Admin sedang handle"
- Tombol "Ambil Alih" (takeover dari AI)
- Tombol "Kembalikan ke AI"
- Tombol "Tutup Sesi"

Chat history:
- User bubble: kanan
- AI bubble: kiri (label: Mipo / AI)
- Admin bubble: kiri (label: nama admin)
- System message: tengah abu (misal: "Admin bergabung", "Sesi ditutup")

Input bar:
- Textarea (maks 1000 karakter)
- Upload file (foto/PDF, maks 5MB)
- Dropdown quick reply template
- Tombol kirim

---

#### Tab FAQ

**Tabel FAQ:**
| Kolom | Keterangan |
|---|---|
| Pertanyaan | Preview 1 baris |
| Kategori | |
| Sumber | Admin / Auto / Static |
| Status | Aktif / Nonaktif |
| Urutan | Angka urutan tampil di mobile |
| Aksi | Edit / Toggle status / Hapus / Drag reorder |

**Filter:** kategori | status | sumber

**Form Buat / Edit FAQ:**
| Field | Tipe |
|---|---|
| Pertanyaan | Textarea |
| Jawaban | Rich text editor |
| Kategori | Dropdown (bisa tambah kategori baru) |
| Status | Toggle aktif/nonaktif |
| Urutan | Number input |

---

### ðŸ‘¥ DATA PELANGGAN

**Tabel Pelanggan:**
| Kolom | Keterangan |
|---|---|
| Avatar | Inisial nama |
| Nama | |
| No. WhatsApp | |
| Area | |
| Paket Aktif | |
| Saldo Poin | |
| Status | Aktif / Nonaktif |
| Tanggal Bergabung | |
| Total Tiket | Jumlah tiket yang pernah dibuat |
| Aksi | |

**Filter & Search:**
- Search nama / no WA
- Filter area
- Filter paket
- Filter status
- Filter tanggal bergabung (range)
- Filter poin (range min-maks)

**Aksi Per Pelanggan:**
- Lihat detail (side panel)
- Edit data
- Nonaktifkan akun
- Hubungi via WA (shortcut langsung)
- Reset sandi (kirim OTP ke pelanggan)

**Detail Pelanggan (side panel kanan):**
```
Section 1 â€” Profil:
Avatar inisial | Nama | No WA
Alamat | Area | Paket aktif
Status badge | Tanggal bergabung
Tombol: "Hubungi via WA" | "Edit" | "Nonaktifkan"

Section 2 â€” Statistik:
Saldo poin | Rank leaderboard
Total reward diklaim | Total referral berhasil

Section 3 â€” History Tiket:
List tiket compact (no. tiket + jenis + status + tanggal)
Tombol "Lihat semua tiket"

Section 4 â€” History Chat:
List sesi chat (tanggal + preview + status)
Tombol "Lihat semua chat"

Section 5 â€” History Poin:
List transaksi poin terbaru
Tombol "Lihat semua transaksi"
```

**Form Edit Pelanggan:**
| Field | Keterangan |
|---|---|
| Nama | |
| Alamat | |
| Area | Dropdown |
| Paket aktif | |
| Status | Toggle Aktif/Nonaktif |
| Catatan internal | Notes admin, tidak tampil ke pelanggan |

**Export Data:**
- Format: CSV / Excel
- Filter sebelum export (area, paket, status, tanggal)
- Pilih kolom yang diexport
- Tombol "Export"

---

### ðŸ”” PUSH NOTIFICATION

**Tab:** Kirim Notif | History | Template

---

#### Tab Kirim Notif

**Form Kirim Notifikasi:**

**Section 1 â€” Konten:**
| Field | Keterangan |
|---|---|
| Judul | Maks 100 karakter (counter real-time) |
| Isi pesan | Maks 300 karakter (counter real-time) |
| Gambar | Upload opsional |

**Section 2 â€” Target Penerima:**
| Pilihan | Detail |
|---|---|
| Semua pelanggan | Broadcast ke semua pelanggan aktif |
| Spesifik | Search + add pelanggan satu per satu (chips) |
| Grup | Filter area (multi-select) + filter paket (multi-select) |

Counter estimasi: "X pelanggan akan menerima notifikasi ini"

**Section 3 â€” Deep Link Tujuan:**
- Dropdown pilih halaman: Home / Info / Promo / Undian / Tiket / Reward / Referral / Chat CS / FAQ
- Jika konten spesifik: input ID konten

**Section 4 â€” Waktu Kirim:**
- Radio: Sekarang / Jadwalkan
- Jika jadwalkan: date time picker

**Section 5 â€” Preview:**
- Simulasi phone mockup real-time
- Update otomatis saat admin mengetik

**Tombol:**
- "Simpan Draft"
- "Kirim Sekarang" / "Jadwalkan"

---

#### Tab History

**Tabel History Notif:**
| Kolom | Keterangan |
|---|---|
| Judul | |
| Target | Semua / Spesifik / Grup |
| Estimasi Penerima | |
| Terkirim | |
| Dibuka | |
| Gagal | |
| Open Rate | Persentase |
| Status | Draft / Scheduled / Sent |
| Waktu Kirim | |
| Dibuat Oleh | |
| Aksi | |

**Aksi per notif:**
- Lihat statistik detail
- Kirim ulang (ke yang gagal saja)
- Duplikat sebagai notif baru

**Modal Statistik Detail:**
- Donut chart: Terkirim / Dibuka / Gagal
- Total penerima + open rate %
- List penerima dengan status masing-masing
- Tombol "Export laporan"

---

#### Tab Template

**Tabel Template:**
| Kolom | Keterangan |
|---|---|
| Nama template | |
| Preview judul | |
| Preview isi | 1 baris |
| Deep link | Halaman tujuan |
| Dibuat Oleh | |
| Aksi | Gunakan / Edit / Duplikat / Hapus |

**Aksi "Gunakan":** form kirim notif otomatis terisi dari template.

**Form Buat / Edit Template:**
| Field | Tipe |
|---|---|
| Nama template | Text input |
| Judul notif | Text input |
| Isi pesan | Textarea |
| Gambar | Upload opsional |
| Deep link tujuan | Dropdown |

---

### âš™ï¸ PENGATURAN

**Sub Menu:** Akun Admin | Poin & Reward | AI Chatbot | Kategori | Tampilan App | Alert Threshold | Log Aktivitas

---

#### Sub: Akun Admin

**Tabel Admin:**
| Kolom | Keterangan |
|---|---|
| Nama | |
| Email | |
| No. WA | |
| Status | Aktif / Nonaktif |
| Last Login | |
| Tanggal Dibuat | |
| Aksi | Edit / Nonaktifkan / Reset Sandi / Lihat Log |

**Tombol:** "Tambah Admin Baru"

**Form Tambah / Edit Admin:**
| Field | Keterangan |
|---|---|
| Nama | |
| Email | |
| No. WA | |
| Status | Toggle |
| | Sandi dikirim otomatis via WA saat tambah admin baru |

---

#### Sub: Poin & Reward

**Form Setting Nilai Poin:**
| Aktivitas | Default | Input |
|---|---|---|
| Poin login harian | 10 poin | Number input |
| Poin per bulan loyalty | 50 poin | Number input |
| Poin referral berhasil | 100 poin | Number input |
| Poin ikut event/undian | 25 poin | Number input |

**Tombol:** "Simpan Perubahan"

**History Perubahan Setting:**
- Siapa yang ubah, kapan, dari nilai berapa ke berapa

---

#### Sub: AI Chatbot

**Knowledge Base:**
- List Q&A yang diketahui AI
- Tombol "Tambah Pengetahuan"
- Edit / Hapus per item
- Tombol "Import dari FAQ" (sinkronisasi 1 klik)

**Setting Perilaku AI:**
| Setting | Keterangan |
|---|---|
| Nama AI | Default: "Mipo" â€” nama karakter AI di chat |
| Pesan sambutan | Default greeting saat chat dimulai |
| Maks panjang jawaban | Karakter |
| Tone bahasa | Dropdown: Formal / Santai |
| Keyword eskalasi | Kata-kata yang trigger handover ke admin |

**Tombol:**
- "Simpan"
- "Test AI" â€” coba tanya AI langsung dari dashboard tanpa buka mobile

---

#### Sub: Kategori

**Kelola Kategori Pengumuman:**
- List: Gangguan / Maintenance / Info Umum (+ bisa tambah)
- Tambah | Edit | Hapus | Drag reorder urutan

**Kelola Jenis Gangguan:**
- List: Internet Mati / Lambat / Lainnya (+ bisa tambah)
- Tambah | Edit | Hapus | Drag reorder

**Kelola Kategori FAQ:**
- List kategori FAQ
- Tambah | Edit | Hapus | Drag reorder

---

#### Sub: Tampilan App

| Setting | Keterangan |
|---|---|
| Upload logo | Logo JBR Minpo di mobile app |
| Nama app | Display name di mobile |
| Tagline | Tagline di splash screen & login |
| Primary color | Color picker + live preview |

**Tombol:**
- "Preview di Mobile" â€” simulasi tampilan
- "Simpan & Apply" â€” berlaku di mobile tanpa update APK

---

#### Sub: Alert Threshold

| Kondisi | Default | Setting |
|---|---|---|
| Tiket belum diproses | 2 jam | Number input (jam) |
| Chat belum dibalas | 10 menit | Number input (menit) |
| Klaim reward pending | 24 jam | Number input (jam) |
| Draw undian terlewat | Langsung | Tidak bisa diubah |

**Tombol:** "Simpan"

---

#### Sub: Log Aktivitas

**Tabel Log:**
| Kolom | Keterangan |
|---|---|
| Admin | Nama admin yang melakukan aksi |
| Aksi | Jenis aksi (Create, Update, Delete, Login, dll) |
| Target | Objek yang dikenai aksi |
| Detail | Keterangan lengkap |
| IP Address | |
| Waktu | |

**Filter:**
- Filter admin
- Filter jenis aksi
- Filter tanggal range

**Tombol:** "Export Log" (CSV)

Log disimpan min 1 tahun, tidak bisa dihapus oleh siapapun.

---

## 5. Flow Admin

### Flow Login Admin
```
Buka dashboard â†’ halaman login
    â†“
Input Email + Password â†’ "Masuk"
    â†“
Backend validasi â†’ kirim OTP via WA
    â†“
Input OTP 6 digit â†’ valid
    â†“
[Device baru] â†’ notif WA ke admin: "Login dari device baru"
    â†“
Generate JWT + refresh token (httpOnly cookie)
    â†“
Redirect ke Overview
```

### Flow Publish Pengumuman
```
Kelola Informasi â†’ "Buat Pengumuman"
    â†“
Isi form: judul + kategori + area + konten + gambar
         + jadwal + pin + toggle notif
    â†“
[Publish sekarang] â†’ langsung tampil di mobile
[Jadwalkan] â†’ sistem publish otomatis saat waktunya
    â†“
[Toggle notif ON] â†’ push notif otomatis ke target pelanggan
    â†“
Pengumuman tampil di:
- List Informasi mobile (sesuai filter area)
- Home mobile (jika dipinned, maks 2 item)
```

### Flow Proses Undian
```
Kelola Promo â†’ Tab Undian â†’ pilih undian done
    â†“
Tap "Proses Pengundian"
    â†“
Modal: list semua peserta
    â†“
Tap "Acak Pemenang" â†’ animasi spin
    â†“
Pemenang terpilih
    â†“
Tap "Umumkan Pemenang" â†’ sistem otomatis:
  - Push notif ke pemenang
  - Update halaman undian mobile
  - Pasang banner di Home mobile
  - Notif ke admin (no WA pemenang)
    â†“
Admin hubungi pemenang via WA
```

### Flow Takeover Chat dari AI
```
Kelola Tiket â†’ Tab Chat CS
    â†“
Pilih sesi chat (badge: AI aktif)
    â†“
Baca history percakapan AI dengan pelanggan
    â†“
Tap "Ambil Alih"
    â†“
System message muncul di chat: "CS bergabung"
AI nonaktif di sesi ini
    â†“
Admin balas manual (real-time WebSocket)
    â†“
Selesai â†’ Tap "Kembalikan ke AI" atau "Tutup Sesi"
```

### Flow Kirim Push Notification
```
Push Notification â†’ "Buat Notifikasi"
    â†“
Isi: judul + pesan + gambar (opsional)
    â†“
Pilih target: Semua / Spesifik / Grup
    â†“
Pilih deep link tujuan
    â†“
Pilih waktu: Sekarang / Jadwalkan
    â†“
Preview di phone mockup
    â†“
"Kirim" / "Jadwalkan"
    â†“
FCM deliver ke device pelanggan
Sistem catat: Terkirim / Dibuka / Gagal
```

---

## 6. Tech Stack Dashboard

| Komponen | Teknologi | Keterangan |
|---|---|---|
| Framework | Next.js 14 (React) | App Router |
| Language | TypeScript | |
| UI Library | shadcn/ui | Component library |
| Styling | Tailwind CSS | |
| State Management | Zustand | |
| HTTP Client | Axios | |
| WebSocket | socket.io-client | Real-time chat |
| Tabel Data | TanStack Table | Sort, filter, pagination |
| Chart / Grafik | Recharts | Line chart, donut chart |
| Form | React Hook Form + Zod | Validasi form |
| Rich Text Editor | Tiptap | Konten pengumuman & FAQ |
| File Upload | React Dropzone | Upload gambar & file |
| Notifikasi UI | react-hot-toast | Toast notification |
| Date Picker | react-day-picker | |
| Auth | JWT (httpOnly cookie) | Tidak bisa diakses JS |
| Color Picker | react-colorful | Setting tema app |

---

## 7. Security Dashboard

| Layer | Detail |
|---|---|
| Login | Email + Password + OTP WA (2FA wajib) |
| Token | JWT di httpOnly cookie (aman dari XSS) |
| Session | Persistent, logout manual only |
| Beda Device | Wajib OTP WA ulang |
| Notifikasi | WA alert login device baru |
| Activity Log | Semua aksi tercatat otomatis |
| HTTPS | TLS 1.3, semua komunikasi terenkripsi |
| CORS | Hanya domain resmi dashboard |
| Rate Limiting | 100 request/menit per admin |
| Input | Sanitasi semua input, cegah XSS & SQL injection |
| Password | bcrypt hashing (cost factor 12) |

---

## 8. Rules Dashboard

### Permission Rules Admin
- Full access semua menu & fitur dashboard
- Tidak bisa hapus data pelanggan (hanya nonaktifkan)
- Tidak bisa ubah history poin yang sudah tercatat (hanya tambah adjustment baru)
- Tidak bisa hapus activity log
- Tidak bisa akses akun admin lain
- Pengumuman published tidak bisa dihapus (hanya arsipkan)
- Semua aksi tercatat di activity log otomatis

### Validation Rules Dashboard
- Judul pengumuman: maks 200 karakter
- Konten pengumuman: min 10 karakter
- Jadwal publish: tidak boleh masa lalu
- Gambar upload: maks 5MB, JPG/PNG/WebP
- Judul notif: maks 100 karakter
- Isi notif: maks 300 karakter
- Target notif: wajib dipilih min 1
- Poin adjust: min 1, tidak boleh negatif
- Alasan adjust poin: wajib diisi
- Tanggal end undian/promo: tidak boleh sebelum start

### Business Rules Dashboard
- Admin tidak bisa ikut undian
- Notifikasi hanya dikirim ke pelanggan aktif
- Maks 3 push notif per hari per pelanggan (anti spam)
- Notif jam tenang 22.00â€“07.00 WIB (kecuali gangguan darurat)
- Log aktivitas disimpan min 1 tahun

### System Constraints Dashboard
- API response: maks 3 detik
- Uptime target: 99.5%
- Maintenance window: 00.00â€“04.00 WIB
- Session admin: persistent, logout manual only
- Alert threshold: bisa dikonfigurasi di Pengaturan
- Export data: maks 10.000 baris per export

---

## 9. Koneksi ke Mobile App

Semua perubahan di dashboard langsung berdampak ke mobile app JBR Minpo secara real-time atau near real-time.

| Aksi di Dashboard | Dampak di Mobile |
|---|---|
| Publish pengumuman | Muncul di list Informasi + Home (jika pinned) |
| Publish promo | Muncul di Tab Promo + banner Home |
| Adjust poin pelanggan | Saldo poin di Tab Reward update otomatis |
| Update status tiket | Notif otomatis ke pelanggan + timeline update |
| Umumkan pemenang undian | Banner Home + halaman Undian + push notif ke pemenang |
| Kirim push notif | FCM deliver ke device + tersimpan di Riwayat Notif |
| Update FAQ | FAQ di app mobile sync otomatis |
| Takeover chat | Label berubah dari AI ke nama CS di mobile real-time |
| Update tampilan app | Logo/warna/nama berlaku di mobile tanpa update APK |
| Nonaktifkan akun | Pelanggan tidak bisa login di mobile |
| Update kategori | Filter & dropdown di mobile sync otomatis |

---

*JBR Minpo Dashboard Brief v1.0.0*
*Dokumen ini merupakan blueprint resmi dashboard admin JBR Minpo.*
*Perubahan apapun harus melalui diskusi dan update dokumen ini.*

