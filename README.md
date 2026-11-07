# AGL - Applied Agriculture & Livestock

Aplikasi Android resmi untuk asisten terapan budidaya pertanian (*Agriculture*) & peternakan (*Livestock*) modern nusantara dengan arsitektur bersih, modular, dan gaya visual Material Design 3 hijau (*Forest Green* & *Fresh Sage*).

## Karakteristik Desain

- **Material 3 Native**: Menggunakan token dan komponen M3 (`NavigationBar`, `Drawer`, `Card`, `FilterChip`).
- **Skema Warna Hijau Matang**:
  - Primary: Deep Forest Green (`#104B36` / `#196B4A`)
  - Secondary / Accent: Fresh Sage (`#EAF3E7` / `#526921`)
  - Surface Neutral: Clean Nature Off-white (`#FAFBF7`) dan Dark Pine (`#111714`)
- **Bebas AI Slop & Bebas Emoji**: Tidak menggunakan emoji dekoratif. Semua simbol grafis memanfaatkan vektor resmi `Icons` dari Material Design dengan tata letak berbasis tipografi dan garis pemisah tegas (*hairline borders*).

## Struktur Direktori

```
lib/
├── core/
│   ├── constants/
│   │   └── app_constants.dart       (Konstanta AGL, spacing, identitas aplikasi)
│   ├── providers/
│   │   └── crop_provider.dart       (Manajemen state sentral tanaman via Provider)
│   ├── router/
│   │   └── app_router.dart          (Integrasi GoRouter dengan StatefulShellRoute)
│   ├── services/
│   │   └── gemini_service.dart      (Integrasi multimodal Gemini 1.5 Flash untuk deteksi penyakit)
│   └── theme/
│       ├── app_theme.dart           (ThemeData M3 Light & Dark Mode)
│       └── theme_provider.dart      (State mode tema terang/gelap/sistem)
├── models/
│   ├── crop_model.dart              (Model data Tanaman & Checklist Tugas)
│   ├── disease_detection_model.dart (Model hasil diagnosa penyakit & solusi organik)
│   └── market_city_model.dart       (Data acuan harga komoditas per kota real-time)
├── presentation/
│   ├── widgets/
│   │   ├── app_drawer.dart          (Slide Menu / Drawer navigasi)
│   │   └── custom_app_bar.dart      (Reusable AppBar dengan Drawer trigger)
│   └── screens/
│       ├── main_wrapper.dart        (Induk BottomNavigationBar 4 Tab + Drawer)
│       ├── home/
│       │   └── home_screen.dart     (Beranda, Cuaca, Scanner Card & Tanaman Aktif)
│       ├── crop/
│       │   ├── add_crop_bottom_sheet.dart (Modal tambah tanaman & template bibit)
│       │   └── detail_crop_screen.dart   (Detail progres, tips pakar, & checklist tugas)
│       ├── scan/
│       │   ├── disease_scan_screen.dart  (Live Camera Viewfinder, Scanner, Flash & Galeri)
│       │   └── widgets/scan_result_sheet.dart (Bottom sheet hasil diagnosa & solusi Gemini)
│       ├── pest/
│       │   └── pest_screen.dart     (Katalog hama, tombol scanner AI & solusi nabati)
│       ├── market/
│       │   └── market_screen.dart   (Fitur Harga Real-Time Per Kota & Kalkulator Panen)
│       ├── profile/
│       │   └── profile_screen.dart  (Profil petani, rekap metrik & kartu identitas QR)
│       └── drawer/
│           ├── history_screen.dart  (Riwayat pemupukan, semprot agens, & panen)
│           ├── settings_screen.dart (Pengaturan tema, notifikasi & biometrik)
│           └── help_screen.dart     (FAQ budidaya, konsultasi agronomi & kontak)
├── features/                        (Siap untuk penambahan modul fitur mandiri)
└── main.dart                        (Titik masuk aplikasi, MultiProvider & SystemUI)
```

## Fitur Utama AGL

### 1. Pasar & Acuan Harga Real-Time Per Kota (Pertanian & Peternakan)
- **Pemilihan Kota Dinamis**: Mendukung berbagai kota dan sentra pasar induk di Indonesia (Jakarta, Bandung, Surabaya, Semarang, Medan, Makassar, Denpasar, Yogyakarta, Palembang, Pontianak, Malang).
- **Harga Hasil Panen Nyata**: Harga setiap komoditas pertanian (Cabai, Padi GKP, Bawang, Jagung, Sayuran) dan peternakan (Ayam Broiler, Telur Ras, Daging Sapi, Susu Segar) otomatis menyesuaikan berdasarkan kota yang dipilih.
- **Kalkulator Terintegrasi**: Input harga jual pasar pada simulasi laba/omzet otomatis tersinkronisasi saat kota atau komoditas diubah.
- **Indikator Tren & Fluktuasi**: Memantau tren harga (*Tren Naik*, *Stabil*, *Tren Turun*) dan selisih nominal harian.

### 2. Deteksi Penyakit Tanaman (Live AI Scanner)
- **Live Camera Viewfinder**: Bidikan langsung kamera dengan target frame fokus dan kontrol lampu senter (flash).
- **Integrasi Gemini 1.5 Flash**: Menganalisis daun secara multimodal (kecepatan tinggi, akurasi tinggi, kuota gratis Google AI Studio).
- **Hasil Diagnosa Komprehensif**: Nama penyakit/hama, tingkat keparahan (*Kritis*, *Sedang*, *Rendah*, *Normal*), skor keyakinan AI, gejala visual, dan solusi nabati/organik.
- **Konfigurasi API Key**: Ikon kunci pada pojok atas layar scan memungkinkan pengguna memasukkan Google AI Studio API Key gratis mereka sewaktu-waktu.

## Build APK & Menjalankan Proyek

Proyek ini telah dikonfigurasi dengan GitHub Actions (`.github/workflows/build-apk.yml`) untuk membangun APK Android secara otomatis setiap kali commit di-*push* ke repositori.

Untuk menjalankan secara lokal di Android / emulator:

```bash
# Mengunduh dependensi
flutter pub get

# Menjalankan aplikasi pada perangkat Android / emulator
flutter run
```

