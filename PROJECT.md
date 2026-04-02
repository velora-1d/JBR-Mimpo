# JBR Mimpo

## Deskripsi
Aplikasi terintegrasi yang terdiri dari Dashboard Admin dan Aplikasi Mobile. Proyek ini menggunakan 1 Backend (Golang) untuk melayani 2 Frontend (Next.js & Flutter).

## Stack Teknologi
- Frontend: Next.js 14 (Dashboard), Flutter 3 (Mobile)
- Backend: Golang 1.22 (API - Gin)
- Database: PostgreSQL 16 (Main) + Redis 7 (Cache/OTP)
- ORM: GORM (Go)
- Auth: JWT + WhatsApp OTP (Fonnte)
- Hosting: VPS (Ubuntu) + Docker Compose
- Real-time: WebSocket (Gorilla)

## Mode Arsitektur
[x] Golang API + Next.js Frontend + Flutter Mobile
[ ] Lainnya: ___

## Target Platform
[x] Web only (Dashboard)
[x] Mobile only (Flutter)
[x] Web + Mobile

## Multi-tenant
[ ] Ya — strategi: [TBD]
[ ] Tidak

## Skala User
[ ] Kecil (< 100 user)
[x] Menengah (< 10.000 user)
[ ] Besar (> 10.000 user)

## Tim
[x] Solo developer
[ ] Tim — jumlah: ___

## Hosting & Infra
- Development: local
- Staging: TBD
- Production: TBD

## Catatan Khusus
- Menggunakan struktur 1 BE (Golang) dan 2 FE (Next.js & Flutter).
- Folder utama sudah dibuat: `Mimpo Backend`, `mimpo-dashboard`, `mimpo_mobile`.

## Progress Terakhir
- Inisialisasi struktur folder utama.
- Setup PROJECT.md dan project.json.

## Last Updated
2026-04-02
