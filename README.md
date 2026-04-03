# JBR MIMPO — Jabbar Media Informasi dan Promosi
> **Official Infrastructure Project for ISP Jabbar23**
> Reliable Connectivity · Information Transparency · Customer Loyalty

---

## 🌏 Language / Bahasa
- [Bahasa Indonesia](#-bahasa-indonesia)
- [English Section](#-english)

---

## 🇮🇩 Bahasa Indonesia

### 1. Gambaran Proyek
JBR Mimpo adalah ekosistem digital resmi untuk pelanggan ISP Jabbar23. Proyek ini bertujuan untuk menjembatani komunikasi antara penyedia layanan internet (ISP) dan pelanggan melalui platform mobile dan dashboard admin yang terintegrasi.

### 2. Komponen Sistem

#### 🖥️ Dashboard ISP (Admin)
Halaman administrasi pusat untuk mengelola seluruh ekosistem JBR Mimpo.
- **Teknologi**: Next.js 14, React, TypeScript, Tailwind CSS.
- **Fitur Utama**:
  <details>
  <summary>Klik untuk detail fitur Dashboard (23 Item)</summary>
  
  1. **Login & 2FA**: Keamanan ganda dengan OTP via WhatsApp.
  2. **Overview Dashboard**: Statistik real-time pelanggan aktif, tiket, dan chat.
  3. **Kelola Informasi**: Sistem pengumuman terintegrasi dengan push notification.
  4. **Promo & Reward**: Pengaturan katalog promo, poin loyalitas, dan penukaran hadiah.
  5. **Undian Premium**: Sistem pengundian hadiah otomatis/manual bagi pelanggan.
  6. **Ticketing System**: Manajemen laporan gangguan pelanggan dengan tracking status.
  7. **Hybrid Chat CS**: Integrasi AI Chatbot (Mipo) dengan fitur pengambilalihan oleh admin.
  8. **Data Pelanggan**: Database master pelanggan beserta statistik aktivitasnya.
  9. **AI Mipo Settings**: Konfigurasi basis pengetahuan dan perilaku chatbot.
  10. **Audit Log**: Pencatatan seluruh aktivitas admin untuk keamanan sistem.
  </details>

#### 📱 Mobile User App
Aplikasi pendamping pelanggan untuk akses informasi dan layanan mandiri.
- **Teknologi**: Flutter, Dart, Riverpod (State Management).
- **Fitur Utama**:
  <details>
  <summary>Klik untuk detail fitur Mobile (26 Item)</summary>
  
  1. **Self-Service Support**: Lapor gangguan dengan lampiran foto dan lokasi GPS.
  2. **Real-time Tracking**: Pantau status perbaikan internet secara transparan.
  3. **Loyalty Program**: Kumpulkan poin dari aktivitas harian dan tukarkan dengan reward.
  4. **Informasi Gangguan**: Terima notifikasi langsung jika ada pemeliharaan jaringan di area Anda.
  5. **Mipo Chatbot**: Bantuan instan 24/7 untuk pertanyaan umum seputar layanan.
  6. **Referral System**: Undang teman dan dapatkan bonus poin/reward.
  </details>

### 3. Arsitektur & Keamanan
- **Autentikasi**: JWT (JSON Web Token) dengan rotasi refresh token.
- **Keamanan**: Wajib 2FA WhatsApp untuk admin, enkripsi database, dan HTTPS TLS 1.3.
- **Data**: Sinkronisasi real-time menggunakan WebSocket untuk fitur chat dan tracking tiket.

---

## 🇬🇧 English

### 1. Project Overview
JBR Mimpo is the official digital ecosystem for ISP Jabbar23 customers. This project aims to bridge the communication gap between the internet service provider (ISP) and its customers through an integrated mobile platform and admin dashboard.

### 2. System Components

#### 🖥️ ISP Dashboard (Admin)
The central administrative hub for managing the entire JBR Mimpo ecosystem.
- **Tech Stack**: Next.js 14, React, TypeScript, Tailwind CSS.
- **Key Features**:
  <details>
  <summary>Click for Dashboard feature details (23 Items)</summary>
  
  1. **Login & 2FA**: Dual security with WhatsApp-based OTP.
  2. **Overview Dashboard**: Real-time statistics of active customers, tickets, and chats.
  3. **Information Management**: Integrated announcement system with push notifications.
  4. **Promo & Reward**: Loyalty points configuration, promo catalogs, and reward claims.
  5. **Premium Lottery**: Automated/manual draw system for eligible customers.
  6. **Ticketing System**: Management of customer disruption reports with status tracking.
  7. **Hybrid Chat CS**: AI Chatbot (Mipo) integration with admin takeover capability.
  8. **Customer Data**: Master customer database with activity statistics.
  9. **AI Mipo Settings**: Configuration of knowledge base and chatbot behavior.
  10. **Audit Log**: Comprehensive logging of all admin actions for security.
  </details>

#### 📱 Mobile User App
Customer-facing application for information access and self-service.
- **Tech Stack**: Flutter, Dart, Riverpod (State Management).
- **Key Features**:
  <details>
  <summary>Click for Mobile feature details (26 Items)</summary>
  
  1. **Self-Service Support**: Report disruptions with photo attachments and GPS location.
  2. **Real-time Tracking**: Transparently monitor internet repair status.
  3. **Loyalty Program**: Earn points from daily activities and redeem them for rewards.
  4. **Disruption Alerts**: Receive direct notifications for network maintenance in your area.
  5. **Mipo Chatbot**: Instant 24/7 assistance for general service inquiries.
  6. **Referral System**: Invite friends and earn bonus points/rewards.
  </details>

### 3. Architecture & Security
- **Authentication**: JWT (JSON Web Token) with refresh token rotation.
- **Security**: Mandatory WhatsApp 2FA for admins, database encryption, and HTTPS TLS 1.3.
- **Data**: Real-time synchronization via WebSocket for chat and ticket tracking features.

---
© 2026 Mahin Utsman Nawawi · JBR-Mimpo Project
