# HIMTEC Mobile - Android Flutter Architecture

Aplikasi Android resmi untuk himpunan mahasiswa dengan arsitektur bersih, modular, dan gaya visual Material Design 3 hijau industrial minimalis (Forest Green & Muted Sage).

## Karakteristik Desain

- **Material 3 Native**: Menggunakan token dan komponen M3 (`NavigationBar`, `Drawer`, `Card`, `FilterChip`).
- **Skema Warna Hijau Matang**:
  - Primary: Deep Forest Green (`#1B4D3E`)
  - Secondary: Muted Sage (`#567258`)
  - Surface Neutral: Clean off-white (`#F7F9F7`) dan Dark Neutral (`#111513`)
- **Bebas AI Slop & Bebas Emoji**: Tidak menggunakan emoji dekoratif. Semua simbol grafis memanfaatkan vektor resmi `Icons` dari Material Design dengan tata letak berbasis tipografi dan garis pemisah tegas (hairline borders).

## Struktur Direktori

```
lib/
├── core/
│   ├── constants/
│   │   └── app_constants.dart
│   ├── router/
│   │   └── app_router.dart          (Integrasi GoRouter dengan StatefulShellRoute)
│   └── theme/
│       └── app_theme.dart           (ThemeData M3 Light & Dark Mode)
├── presentation/
│   ├── widgets/
│   │   ├── app_drawer.dart          (Slide Menu / Drawer terisolasi)
│   │   └── custom_app_bar.dart      (Reusable AppBar dengan Drawer trigger)
│   └── screens/
│       ├── main_wrapper.dart        (Induk BottomNavigationBar 4 Tab + Drawer)
│       ├── home/
│       │   └── home_screen.dart     (Beranda & Metrik Organisasi)
│       ├── explore/
│       │   └── explore_screen.dart  (Pencarian, Filter Chip, & Daftar Proyek)
│       ├── notifications/
│       │   └── notifications_screen.dart
│       ├── profile/
│       │   └── profile_screen.dart
│       └── drawer/
│           ├── history_screen.dart  (Riwayat Kegiatan)
│           ├── settings_screen.dart (Pengaturan Notifikasi & Cache)
│           └── help_screen.dart     (FAQ & Kontak Sekretariat)
├── features/                        (Siap untuk penambahan modul fitur mandiri)
└── main.dart                        (Titik masuk aplikasi & konfigurasi SystemUI)
```

## Dependensi Utama

- `go_router`: Navigasi deklaratif berbasis URL/path dengan dukungan `StatefulShellRoute.indexedStack` untuk menjaga state halaman saat berpindah tab.
- `provider`: Pengelolaan state yang ringan dan terukur.
- `flutter_lints`: Penegakan standar kode bersih Flutter.

## Menjalankan Proyek

Pastikan Flutter SDK telah terpasang di sistem operasi Anda, kemudian jalankan perintah berikut:

```bash
# Mengunduh dependensi
flutter pub get

# Menjalankan aplikasi pada perangkat Android / emulator
flutter run
```

