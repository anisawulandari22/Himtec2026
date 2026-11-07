# AGL - Applied Agriculture & Livestock

Aplikasi Android resmi untuk asisten terapan budidaya pertanian (*Agriculture*) dan peternakan (*Livestock*) modern nusantara dengan arsitektur bersih, modular, dan visual Material Design 3 hijau (*Forest Green* & *Fresh Sage*).

## Karakteristik Desain

- **Material 3 Native**: Menggunakan token dan komponen M3 (`NavigationBar`, `Drawer`, `Card`, `FilterChip`).
- **Skema Warna Hijau Matang**:
  - Primary: Deep Forest Green (`#104B36` / `#196B4A`)
  - Secondary / Accent: Fresh Sage (`#EAF3E7` / `#526921`)
  - Surface Neutral: Clean Nature Off-white (`#FAFBF7`) dan Dark Pine (`#111714`)
- **Bebas AI Slop & Bebas Emoji**: Tidak menggunakan emoji dekoratif. Semua simbol grafis memanfaatkan vektor resmi `Icons` dari Material Design dengan tata letak berbasis tipografi dan garis pemisah tegas (*hairline borders*).
- **Penyimpanan Data Permanen**: Menggunakan `shared_preferences` untuk menyimpan sesi otentikasi pengguna, daftar tanaman, daftar hewan ternak, dan riwayat tugas sehingga data tidak pernah hilang saat aplikasi ditutup.

## Modul & Fitur Utama AGL

### 1. Autentikasi Pengguna & Integrasi Akun Google
- **Halaman Masuk (Login)**: Formulir email dan kata sandi dengan validasi, fitur ingat saya, dan pemulihan kata sandi.
- **Halaman Pendaftaran (Register)**: Input nama lengkap, email, kata sandi, konfirmasi kata sandi, serta pilihan sektor fokus usaha (Pertanian, Peternakan, atau Keduanya).
- **Masuk dengan Akun Google**: Dukungan masuk cepat menggunakan akun Google (Google OAuth) dengan dialog pemilihan akun interaktif dan penandaan identitas resmi.
- **Penyimpanan Sesi**: Pengguna tetap masuk secara persisten dan data tersimpan aman di perangkat.

### 2. Modul Peternakan (Livestock)
- **Manajemen Populasi Kandang**: Input dan pantau sapi potong, sapi perah, kambing/domba, ayam broiler, dan ayam layer.
- **Kebutuhan Ransum Pakan & Vitamin**: Estimasi harian pakan hijauan, konsentrat, kebutuhan air minum bersih, jadwal pemberian ransum, dan katalog suplemen vitamin & mineral esensial.
- **Database Penyakit Hewan Ternak**: Katalog terintegrasi penyakit hewan (PMK, Antraks, Mastitis, Bloat/Kembung, Cacingan, Tetelo/ND, Gumboro/IBD, Scabies) lengkap dengan gejala visual, tingkat keparahan, dan protokol pengobatan.
- **Kalkulator Komparasi Harga: Timbang Hidup vs Sembelih Daging Karkas**: Perhitungan keuntungan komparatif antara menjual langsung (timbang hidup) dengan menjual setelah dipotong (karkas daging + jeroan/kulit dikurangi biaya RPH).

### 3. Pasar & Acuan Harga Real-Time Multi-Kota
- **11 Wilayah Pasar Strategis di Indonesia**: Jakarta (Pasar Induk Kramat Jati), Bandung (Pasar Caringin), Surabaya (Pasar Keputran), Medan, Makassar, Denpasar, Yogyakarta, Semarang, Palembang, Banjarmasin, dan Jayapura.
- **Harga Hasil Panen & Ternak**: Fluktuasi harga komoditas pangan, hortikultura, daging sapi, ayam, dan telur diperbarui secara dinamis berdasarkan kota pilihan.
- **Simulasi Proyeksi Laba**: Estimasi tonase panen, omzet kotor, biaya operasional, dan laba bersih dengan slider persentase keberhasilan.

### 4. Deteksi Penyakit AI Kamera Langsung (Google Gemini Vision)
- **Live Camera Viewfinder**: Bidikan langsung kamera dengan kontrol lampu senter (flash) dan galeri fallback.
- **Gemini 1.5 Flash**: Menganalisis kondisi daun dan gejala penyakit secara instan via REST API gratis Google AI Studio.
- **Hasil Diagnosa**: Nama penyakit, taksonomi latin, tingkat keparahan, skor keyakinan AI, gejala visual, dan resep solusi nabati/organik.

## Struktur Direktori Proyek

```
lib/
├── core/
│   ├── constants/
│   │   └── app_constants.dart          (Konstanta AGL, identitas aplikasi)
│   ├── providers/
│   │   ├── auth_provider.dart          (Manajemen autentikasi email & Google)
│   │   ├── crop_provider.dart          (Manajemen state dan penyimpanan tanaman)
│   │   └── livestock_provider.dart     (Manajemen state dan penyimpanan ternak)
│   ├── router/
│   │   └── app_router.dart             (Integrasi GoRouter, guard login & redirect)
│   ├── services/
│   │   ├── gemini_service.dart         (Integrasi REST API Gemini 1.5 Flash)
│   │   └── storage_service.dart        (Penyimpanan persisten lokal via SharedPreferences)
│   └── theme/
│       ├── app_theme.dart              (ThemeData M3 Light & Dark Mode)
│       └── theme_provider.dart         (State mode tema terang/gelap)
├── models/
│   ├── crop_model.dart                 (Model tanaman & serialisasi JSON)
│   ├── disease_detection_model.dart    (Model hasil diagnosa penyakit AI)
│   ├── livestock_model.dart            (Model ternak, pakan, vitamin, penyakit)
│   ├── market_city_model.dart          (Matriks acuan harga 11 kota pasar)
│   └── user_model.dart                 (Model profil pengguna terotentikasi)
├── presentation/
│   ├── widgets/
│   │   ├── app_drawer.dart             (Slide Drawer dengan info profil & logout)
│   │   └── custom_app_bar.dart         (Reusable AppBar dengan Drawer trigger)
│   └── screens/
│       ├── auth/
│       │   ├── login_screen.dart       (Halaman masuk email & akun Google)
│       │   └── register_screen.dart    (Halaman registrasi akun baru AGL)
│       ├── main_wrapper.dart           (Induk navigasi 4 Tab + Action scanner)
│       ├── home/
│       │   └── home_screen.dart        (Beranda kebun & kandang, switch sektor)
│       ├── crop/
│       │   ├── add_crop_bottom_sheet.dart (Modal tambah tanaman & bibit)
│       │   └── detail_crop_screen.dart    (Detail progres & tugas tanaman)
│       ├── livestock/
│       │   ├── add_livestock_bottom_sheet.dart (Modal input hewan ternak)
│       │   └── detail_livestock_screen.dart    (Detail pakan, vitamin, karkas)
│       ├── scan/
│       │   ├── disease_scan_screen.dart        (Viewfinder kamera & pemindai AI)
│       │   └── widgets/scan_result_sheet.dart  (Sheet hasil diagnosa & resep)
│       ├── pest/
│       │   └── pest_screen.dart        (Katalog penyakit tanaman & ternak)
│       ├── market/
│       │   └── market_screen.dart      (Harga multi-kota & kalkulator karkas)
│       ├── profile/
│       │   └── profile_screen.dart     (Profil pengguna & tombol logout)
│       └── drawer/
│           ├── history_screen.dart     (Riwayat aktivitas pertanian & ternak)
│           ├── settings_screen.dart    (Pengaturan tema & preferensi)
│           └── help_screen.dart        (Pusat bantuan & konsultasi agro)
└── main.dart                           (Titik masuk aplikasi & MultiProvider)
```

## Build APK Android

Proyek ini telah dikonfigurasi dengan workflow otomatis `.github/workflows/build-apk.yml`. Setiap kali Anda melakukan push ke branch `main`, GitHub Actions akan membangun paket APK rilis (`agl-app-apk`).
