# AGL - Applied Agriculture & Livestock

AGL (*Applied Agriculture & Livestock*) adalah aplikasi asisten digital modern untuk budidaya pertanian dan peternakan nusantara berbasis Flutter. Aplikasi ini mengintegrasikan pemindaian hama penyakit berbasis AI visi, pemantauan populasi tanaman dan ternak, manajemen ransum pakan dan vitamin, serta kalkulator acuan pasar dan perbandingan laba karkas daging di berbagai wilayah Indonesia.

Aplikasi dirancang dengan standar arsitektur bersih, tata letak Material Design 3, performa tinggi, dan bebas elemen emoji dekoratif demi menjaga kejelasan dan profesionalitas penggunaan di lapangan.

---

## Daftar Isi

1. [Karakteristik Desain & Filosofi](#karakteristik-desain--filosofi)
2. [Teknologi yang Digunakan](#teknologi-yang-digunakan)
3. [Implementasi API & Arsitektur Layanan](#implementasi-api--arsitektur-layanan)
4. [Struktur Direktori Proyek](#struktur-direktori-proyek)
5. [Fitur & Modul Utama](#fitur--modul-utama)
6. [Panduan Instalasi & Menjalankan Aplikasi](#panduan-instalasi--menjalankan-aplikasi)
7. [Build APK & Otomatisasi CI/CD](#build-apk--otomatisasi-cicd)

---

## Karakteristik Desain & Filosofi

- **Material Design 3 Native**: Mengimplementasikan token M3 resmi, termasuk `NavigationBar`, `NavigationDrawer`, `FilterChip`, `Card`, dan dialog interaktif.
- **Palet Warna Hijau Alam Terpadu**:
  - Primary: Deep Forest Green (`#104B36` dan `#196B4A`)
  - Accent / Secondary: Fresh Sage (`#EAF3E7` dan `#526921`)
  - Background & Surface: Nature Off-White (`#FAFBF7`) dan Dark Pine (`#111714`)
- **Tanpa Emoji (Zero Emojis)**: Semua representasi visual murni menggunakan ikon vektor Material Icons resmi (`Icons.*`) dengan hierarki tipografi tegas dan garis pemisah halus (*hairline borders*).
- **Penyimpanan Persisten Permanen**: Seluruh data pengguna, koleksi tanaman, populasi ternak, catatan jurnal foto, dan preferensi tersimpan secara offline di penyimpanan lokal perangkat sehingga tidak hilang saat aplikasi ditutup.

---

## Teknologi yang Digunakan

### 1. Inti Framework & Bahasa
- **Flutter SDK**: `^3.0.0` (Dart SDK `>=3.0.0 <4.0.0`)
- **Arsitektur Perangkat Lunak**: Clean Layered Architecture terbagi atas Core (konstanta, penyedia state, perutean, layanan, tema), Models (skema data), dan Presentation (antarmuka pengguna dan widget modular).

### 2. State Management & Perutean
- **provider (`^6.1.2`)**: Mengelola state reaktif di seluruh aplikasi menggunakan `ChangeNotifier`, `MultiProvider`, dan konsumsi state terarah (`Consumer`, `context.watch`, `context.read`).
- **go_router (`^14.2.0`)**: Manajemen navigasi deklaratif berbasis URL/path, parameter rute dinamis, serta mekanisme *auth redirect guard* untuk melindungi rute yang membutuhkan sesi masuk.

### 3. Kamera & Pemrosesan Gambar
- **camera (`^0.11.0+2`)**: Akses langsung ke sensor kamera perangkat Android untuk antarmuka *live viewfinder*, kontrol lampu kilat (torch/flash), dan pengambilan gambar resolusi tinggi.
- **image_picker (`^1.1.2`)**: Pemilihan gambar dari kamera perangkat (`ImageSource.camera`) maupun impor dari galeri perangkat (`ImageSource.gallery`) untuk input komoditas baru dan dokumentasi perkembangan tanaman serta ternak.

### 4. Jaringan & Komunikasi Data
- **http (`^1.2.2`)**: Klien HTTP untuk komunikasi REST API ke endpoint Google AI Studio dan transfer data payload multimodal.

### 5. Penyimpanan Data Lokal
- **shared_preferences (`^2.2.3`)**: Penyimpanan persisten lokal berbasis pasangan kunci-nilai (key-value) dan serialisasi JSON untuk data akun, koleksi tanaman, ternak, serta riwayat log.

### 6. Otomatisasi & Konfigurasi Sistem
- **Python 3**: Script otomatisasi `.github/scripts/inject_permissions.py` untuk injeksi konfigurasi Android, penyesuaian hak akses (*permissions*), nama aplikasi resmi `AGL`, dan penyusunan aset ikon *mipmap* multi-densitas.
- **GitHub Actions**: Pipeline otomatis untuk analisis kode (`flutter analyze`) dan kompilasi build APK Android.

---

## Implementasi API & Arsitektur Layanan

### 1. Google Gemini Multimodal Vision API (Gemini 2.0 Flash & 1.5 Flash)
Modul pemindai diagnosa penyakit (`GeminiService`) mengintegrasikan API kecerdasan buatan visi multimodal dengan arsitektur dua sektor independen (Tanaman & Hewan Ternak):
- **Model Primer & Sekunder**: `gemini-2.0-flash` (generasi terbaru tercepat dan paling akurat) dengan fallback otomatis ke `gemini-1.5-flash`.
- **Endpoint**: `https://generativelanguage.googleapis.com/v1beta/models/{model}:generateContent`
- **Metode HTTP**: `POST`
- **Format Header**: `Content-Type: application/json`
- **Spesialisasi Dua Mode Sektor**:
  - **Mode Tanaman (Pertanian)**: Prompt fitopatologi agrikultur nusantara untuk mendeteksi jamur, bakteri daun, virus bulai/bule, defisiensi hara, dan hama serangga (lengkap dengan solusi agens hayati nabati Trichoderma, Beauveria, dan PGPR).
  - **Mode Hewan Ternak (Peternakan)**: Prompt kedokteran hewan (veterinarian) untuk mendeteksi PMK (Penyakit Mulut & Kuku), Mastitis radang ambing, Scabies tungau kulit, Bloat kembung rumen, Tetelo/ND, dan Koksidiosis unggas (lengkap dengan protokol karantina, antiseptik povidone/sulfur, dan biosekuriti kandang).
- **Struktur Respon Data**:
  - `sector`: Sektor subjek ('Pertanian' atau 'Peternakan').
  - `cropName`: Nama varietas tanaman atau jenis hewan ternak spesifik.
  - `condition`: Status kondisi kesehatan atau infeksi patogen.
  - `diseaseName`: Nama umum penyakit disertai nama taksonomi ilmiah/patogen latin.
  - `severity`: Tingkat keparahan klinis (Normal, Rendah, Sedang, Kritis).
  - `confidenceScore`: Persentase tingkat keyakinan diagnosa AI (88% - 98%).
  - `visualSymptoms`: Rincian gejala visual klinis yang teramati pada sampel.
  - `organicSolutions`: Protokol penanganan medis veteriner darurat / solusi hayati nabati.
  - `preventionTips`: Tindakan preventif biosekuriti kandang / sanitasi budidaya.
- **AGL Agro-Veterinary AI Vision Engine (Offline Edge Fallback)**:
  Untuk memastikan aplikasi selalu dapat mendiagnosa di area perkebunan/peternakan tanpa koneksi internet atau tanpa API key, sistem dilengkapi mesin visi komputasi agroveteriner lokal yang mengekstraksi spektrum warna, rasio eritema kemerahan lesi, nekrosis, dan tekstur untuk mendiagnosa patologi tanaman maupun hewan ternak secara presisi tanpa mode demo.

### 2. Database Patologi Tanaman (Fitopatologi Pertanian)
Katalog patologi tanaman komprehensif yang telah diprogramkan ke dalam kecerdasan buatan AGL:
- **Antraknosa / Patek Buah & Daun (*Colletotrichum capsici*)**:
  - *Komoditas*: Cabai Merah, Cabai Rawit, Tomat, Terung.
  - *Gejala Visual*: Lesi nekrotik cekung melingkar kehitaman pada buah dan daun, cincin konsentris spora jamur, mati pucuk (*dieback*).
  - *Solusi & Pencegahan*: Eradikasi buah sakit, kocor agens hayati *Trichoderma harzianum*, semprot fungisida nabati daun sirih merah (100 gr/liter air), jaga jarak tanam 50-60 cm, dan kurangi pupuk nitrogen tunggal di musim hujan.
- **Hawar Daun Bakteri / Kresek (*Xanthomonas oryzae pv. oryzae*)**:
  - *Komoditas*: Padi Sawah, Padi Gogo.
  - *Gejala Visual*: Garis basah keabuan memanjang dari tepian daun ke pangkal, daun menggulung mengering pucat terbakar, butiran eksudat embun bakteri di pagi hari.
  - *Solusi & Pencegahan*: Pengairan berselang (*intermittent*), semprot bakterisida rimpang kunyit dan lengkuas, aplikasi agens PGPR (*Pseudomonas fluorescens*), batasi urea, dan gunakan varietas tahan (Inpari 32 HDB / Inpari 42).
- **Virus Mosaik Kuning / Gemini Bule (*Pepper Yellow Leaf Curl Virus - PepYLCV*)**:
  - *Komoditas*: Cabai, Tomat, Terung, Tembakau.
  - *Gejala Visual*: Daun muda mengecil kaku melengkung ke atas (*cupping*), tulang daun menebal dengan belang klorosis kuning terang kontras, tanaman kerdil.
  - *Solusi & Pencegahan*: Kendalikan vektor kutu kebul (*Bemisia tabaci*) dengan minyak nimba (*neem oil*), semprot agens jamur entomopatogen *Beauveria bassiana*, pasang 40 perangkap lekat kuning per hektar, dan tanam barisan jagung/serai wangi sebagai *barrier*.
- **Embun Buluk / Busuk Daun (*Phytophthora infestans*)**:
  - *Komoditas*: Tomat, Kentang, Paprika.
  - *Gejala Visual*: Bercak basah hijau gelap kehitaman tidak beraturan di ujung daun, lapisan jamur keputihan halus di balik daun, batang melunak cokelat basah.
  - *Solusi & Pencegahan*: Pemangkasan sanitasi tajuk bawah (*wiwil*), aplikasi bio-fungisida *Trichoderma viride*, semprot bubur bordeaux tembaga organik, gunakan naungan *rain shelter* saat curah hujan ekstrem.
- **Bercak Ungu / Trotol Daun (*Alternaria porri*)**:
  - *Komoditas*: Bawang Merah, Bawang Putih, Bawang Daun.
  - *Gejala Visual*: Titik melekuk putih keabuan dengan pusat ungu, meluas membentuk cincin konsentris yang mematahkan ujung daun, umbi busuk berair.
  - *Solusi & Pencegahan*: Semprot fungisida ekstrak rimpang lengkuas dan mimba, kocor agens hayati *Gliocladium sp.*, perbaiki parit bedengan bebas genangan air, gunakan benih umbi bersertifikat bebas patogen.
- **Penyakit Bulai Daun (*Peronosclerospora maydis*)**:
  - *Komoditas*: Jagung Hibrida, Jagung Manis.
  - *Gejala Visual*: Garis klorotik putih kekuningan sejajar tulang daun dari pangkal ke ujung, lapisan tepung spora putih di balik daun, tanaman kerdil tanpa tongkol (*mandul*).
  - *Solusi & Pencegahan*: Eradikasi tanaman terinfeksi segera, perlakuan benih (*seed treatment*) fungisida sistemik, semprot agens hayati *Pseudomonas fluorescens*, tanam serempak dalam radius 500 meter.
- **Tanaman Sehat & Segar (Kondisi Prima)**:
  - *Ciri Visual*: Distribusi klorofil hijau merata dan cerah, kutikula dan stomata utuh tanpa luka patogen/hama, turgor daun optimal berfotosintesis aktif.
  - *Perawatan*: Jadwal siram konsisten, aplikasi Pupuk Organik Cair (POC) urin kelinci/azolla berkala, proteksi preventif Trichoderma tiap 2 minggu.

### 3. Database Patologi Hewan Ternak (Veteriner Peternakan)
Katalog patologi hewan ternak komprehensif yang telah diprogramkan ke dalam kecerdasan buatan AGL:
- **Penyakit Mulut dan Kuku / PMK (*Aphthae Epizooticae - Picornaviridae*)**:
  - *Spesies Rentan*: Sapi Potong, Sapi Perah, Kerbau, Kambing, Domba.
  - *Gejala Klinis*: Lesi vesikular (melepuh) pada mukosa lidah, bibir, gusi, puting susu, dan celah antar kuku; hipersalivasi hebat (air liur berbusa menggantung); demam tinggi; kepincangan parah enggan berdiri.
  - *Protokol Darurat & Biosekuriti*: Karantina ternak minimal 100 meter dari kawanan, bersihkan luka lepuh dengan asam sitrat 2% atau povidone iodine, sajikan hijauan lunak cincang dan multivitamin, wajibkan vaksinasi PMK berkala, dan celup alas kaki/ban di bak disinfektan.
- **Scabies / Kudis Sarcoptic (*Sarcoptes scabiei var. caprae/bovis*)**:
  - *Spesies Rentan*: Kambing, Domba, Sapi, Kelinci.
  - *Gejala Klinis*: Kerak keropeng tebal bersisik keabu-abuan pada moncong, telinga, leher, dan mata; kerontokan bulu meluas (*alopesia*); rasa gatal intens hingga ternak menggesekkan tubuh ke tiang kandang.
  - *Protokol Darurat & Biosekuriti*: Mandikan dengan air hangat belerang (sulfur 2%), oleskan salep minyak kelapa + tumbukan sirih + belerang, suntik antiparasit ivermectin subkutan sesuai dosis medik veteriner, semprot disinfektan lantai kandang panggung, dan jemur ternak pagi hari.
- **Mastitis Klinis / Radang Kelenjar Ambing (*Streptococcus agalactiae / Staphylococcus aureus*)**:
  - *Spesies Rentan*: Sapi Perah, Kambing Perah.
  - *Gejala Klinis*: Kuartir ambing membengkak keras teraba panas kemerahan, sapi menendang kesakitan, air susu pecah menggumpal menyerupai endapan nanah/darah.
  - *Protokol Darurat & Biosekuriti*: Perah tuntas seluruh susu rusak ke saluran tertutup, kompres hangat ambing, celup puting (*teat dip*) antiseptik klorheksidin/iodin 0.5%, terapi intramamari dokter hewan, cuci tangan pemerah, kain lap terpisah per ekor, dan uji CMT mingguan.
- **Kembung Rumen Akut / Bloat (*Timpani Rumen*)**:
  - *Spesies Rentan*: Sapi Potong, Sapi Perah, Kambing, Domba.
  - *Gejala Klinis*: Distensi perut kiri (*fossa paralumbalis*) membesar tegang seperti drum, ternak gelisah meregangkan leher, nafas cepat terengah-engah dengan mulut terbuka.
  - *Protokol Darurat & Pakan*: Posisikan kaki depan lebih tinggi, cekoki minyak nabati hangat (minyak kelapa/sawit 200-300 ml) atau obat *dimethicone* pemecah buih gas, pasang kayu pengganjal mulut (*gag*) untuk memicu sendawa (*eruktasi*), hindari legum basah berembun, dan layukan rumput segar sebelum diberikan.
- **Tetelo / Sampar Ayam (*Newcastle Disease - Avian Paramyxovirus*)**:
  - *Spesies Rentan*: Ayam Broiler, Ayam Petelur/Layer, Ayam Kampung, Unggas Air.
  - *Gejala Klinis*: Gangguan saraf leher terpuntir (*tortikolis*), gemetar, sayap terkulai lemas, ngorok batuk (*râles*), kotoran encer hijau keputihan berlendir, jengger kebiruan (*sianosis*).
  - *Protokol Darurat & Biosekuriti*: Isolasi unggas sakit ke ruang tertutup terpisah, berikan multivitamin anti-stres dosis tinggi dan larutan gula aren dalam air minum, semprot antiseptik udara, wajibkan vaksinasi ND berkala (tetes mata & suntik), dan terapkan sistem *all-in all-out*.
- **Koksidiosis / Berak Darah Unggas (*Eimeria tenella / Eimeria necatrix*)**:
  - *Spesies Rentan*: Ayam Broiler, Ayam Layer fase brooding.
  - *Gejala Klinis*: Feses kotoran bercampur darah merah segar/cokelat kental di sekitar sekam kandang, ayam bergerombol mengantuk dengan mata terpejam dan bulu kusut, jengger pucat, nafsu makan anjlok.
  - *Protokol Darurat & Biosekuriti*: Berikan antikoksidia (*toltrazuril* / sulfonamida) via air minum, ganti litter sekam basah dengan sekam kering baru, tambahkan vitamin K untuk menghentikan pendarahan sekum, jaga kelembapan alas kandang (<25%), dan perbaiki nepel minum bocor.
- **Hewan Ternak Sehat & Bugar (Kondisi Prima)**:
  - *Ciri Klinis*: Mata bersinar jernih responsif, cermin hidung lembap basah normal, bulu mengkilap halus tanpa keropeng, memamah biak aktif, kotoran feses berkonsistensi normal.
  - *Pemeliharaan*: Ransum hijauan dan konsentrat seimbang, air minum bersih selalu tersedia (*ad-libitum*), mineral blok jilat, sanitasi kotoran tiap pagi, dan vaksinasi booster tepat waktu.

### 4. Autentikasi Pengguna & Integrasi Akun Google
Layanan otentikasi (`AuthProvider`) menyediakan dua jalur masuk:
- **Email & Kata Sandi**: Validasi format email, verifikasi panjang kata sandi, registrasi profil lengkap dengan pilihan fokus sektor (Pertanian, Peternakan, atau Keduanya), dan identifikasi keanggotaan unik.
- **Akun Google**: Mekanisme masuk cepat akun Google dengan dialog pemilihan akun interaktif, sinkronisasi identitas resmi, avatar profil, dan penyimpanan token sesi.
- **Session Persistence**: Seluruh status autentikasi disimpan di `StorageService` melalui `SharedPreferences` sehingga pengguna tetap dalam status masuk saat membuka kembali aplikasi.

### 5. Bursa Komoditas & Kalkulator Laba Multi-Kota
Layanan kalkulasi pasar (`MarketCityModel` & `MarketScreen`) mengintegrasikan data harga komoditas acuan di 11 kota strategis Indonesia (Jakarta, Bandung, Surabaya, Medan, Makassar, Denpasar, Yogyakarta, Semarang, Palembang, Banjarmasin, Jayapura):
- **Simulasi Hasil Panen**: Menghitung estimasi total tonase panen, omzet kotor, biaya operasional, dan laba bersih berdasarkan jumlah lubang tanam dan persentase tingkat keberhasilan.
- **Kalkulator Timbang Hidup vs Sembelih Daging Karkas**:
  - Rumus Penjualan Hidup: `Bobot (kg) * Harga Hidup per kg`
  - Rumus Penjualan Karkas: `(Bobot * Persentase Rendemen Karkas * Harga Daging per kg) + Nilai Hasil Samping (Jeroan, Kulit, Kaki) - Biaya Jasa RPH`
  - Menghasilkan rekomendasi komparasi margin bersih real-time untuk membantu peternak memilih jalur penjualan paling menguntungkan.

---

## Struktur Direktori Proyek

```
Himtec2026/
├── .github/
│   ├── scripts/
│   │   └── inject_permissions.py      (Script otomatisasi injeksi AndroidManifest, label AGL, dan ikon)
│   └── workflows/
│       └── build-apk.yml              (Workflow CI/CD GitHub Actions untuk kompilasi APK)
├── assets/
│   └── icon/                          (Aset ikon resmi AGL multi-resolusi)
│       ├── app_icon_512.png           (Master ikon resolusi tinggi 512x512)
│       ├── mipmap-mdpi/               (Ikon launcher standar & bundar densitas medium)
│       ├── mipmap-hdpi/               (Ikon launcher densitas tinggi)
│       ├── mipmap-xhdpi/              (Ikon launcher densitas ekstra tinggi)
│       ├── mipmap-xxhdpi/             (Ikon launcher densitas dobel ekstra tinggi)
│       └── mipmap-xxxhdpi/            (Ikon launcher densitas tripel ekstra tinggi)
├── lib/
│   ├── core/
│   │   ├── constants/
│   │   │   └── app_constants.dart     (Konstanta nama aplikasi, versi, dan konfigurasi default)
│   │   ├── providers/
│   │   │   ├── auth_provider.dart     (State autentikasi, registrasi, sesi email & akun Google)
│   │   │   ├── crop_provider.dart     (State manajemen tanaman, catatan perkembangan, dan persistensi)
│   │   │   └── livestock_provider.dart (State hewan ternak, kalkulator ransum, dan riwayat bobot)
│   │   ├── router/
│   │   │   └── app_router.dart        (Konfigurasi GoRouter, routing halaman, dan guard autentikasi)
│   │   ├── services/
│   │   │   ├── gemini_service.dart    (Integrasi Google Gemini Vision API & AI Engine lokal)
│   │   │   └── storage_service.dart   (Layanan penyimpanan data lokal permanen SharedPreferences)
│   │   └── theme/
│   │       ├── app_theme.dart         (Definisi tema Material 3 Forest Green mode terang & gelap)
│   │       └── theme_provider.dart    (Penyedia state pergantian tema aplikasi)
│   ├── models/
│   │   ├── crop_model.dart            (Model entitas tanaman, riwayat siram/pupuk, dan jurnal foto)
│   │   ├── disease_detection_model.dart (Model hasil diagnosa hama dan penyakit AI)
│   │   ├── livestock_model.dart       (Model hewan ternak, takaran pakan, suplemen, dan catatan bobot)
│   │   ├── market_city_model.dart     (Model data pasar 11 kota acuan dan komparasi karkas)
│   │   └── user_model.dart            (Model profil pengguna, identitas anggota, dan sektor usaha)
│   ├── presentation/
│   │   ├── screens/
│   │   │   ├── auth/
│   │   │   │   ├── login_screen.dart       (Halaman masuk email dan tombol masuk akun Google)
│   │   │   │   └── register_screen.dart    (Halaman pendaftaran pengguna baru)
│   │   │   ├── crop/
│   │   │   │   ├── add_crop_bottom_sheet.dart (Form penambahan tanaman dengan input foto)
│   │   │   │   └── detail_crop_screen.dart    (Detail siklus tanaman & pencatatan perkembangan berfoto)
│   │   │   ├── drawer/
│   │   │   │   ├── help_screen.dart        (Panduan penggunaan aplikasi & pusat konsultasi)
│   │   │   │   ├── history_screen.dart     (Riwayat aktivitas perawatan tanaman dan ternak)
│   │   │   │   └── settings_screen.dart    (Pengaturan akun, preferensi tema, dan API key)
│   │   │   ├── home/
│   │   │   │   └── home_screen.dart        (Dasbor utama dengan pemilih sektor Tanaman & Ternak)
│   │   │   ├── livestock/
│   │   │   │   ├── add_livestock_bottom_sheet.dart (Form input ternak baru dengan input foto)
│   │   │   │   └── detail_livestock_screen.dart    (Detail pakan, vitamin, & pencatatan bobot berfoto)
│   │   │   ├── market/
│   │   │   │   └── market_screen.dart      (Bursa komoditas 11 kota, kalkulator terpisah panen & ternak)
│   │   │   ├── pest/
│   │   │   │   └── pest_screen.dart        (Katalog hama dan penyakit tanaman serta hewan ternak)
│   │   │   ├── profile/
│   │   │   │   └── profile_screen.dart     (Informasi profil anggota, statistik, dan tombol keluar)
│   │   │   ├── scan/
│   │   │   │   ├── widgets/
│   │   │   │   │   └── scan_result_sheet.dart (Modal penampil hasil diagnosa AI dan resep obat)
│   │   │   │   └── disease_scan_screen.dart   (Pemindai kamera langsung & pemilih file galeri)
│   │   │   └── main_wrapper.dart           (Kerangka navigasi utama 4 tab dan aksi tombol tengah)
│   │   └── widgets/
│   │       ├── app_drawer.dart             (Menu navigasi samping profil, pengaturan, dan bantuan)
│   │       └── custom_app_bar.dart         (Header aplikasi yang konsisten di berbagai layar)
│   └── main.dart                           (Titik masuk utama aplikasi & inisialisasi MultiProvider)
├── test/
│   └── widget_test.dart                    (Pengujian smoke test widget & integrasi tema)
├── analysis_options.yaml                   (Aturan linting kode Dart resmi Flutter)
├── pubspec.yaml                            (Daftar dependensi, versi paket, dan deklarasi aset)
└── README.md                               (Dokumentasi teknis resmi proyek AGL)
```

---

## Fitur & Modul Utama

### 1. Manajemen Sektor Pertanian (Crops)
- Input komoditas tanaman lengkap dengan varietas, tanggal semai, estimasi panen, dan unggah foto langsung dari kamera atau galeri.
- Pemantauan kebutuhan harian: jadwal penyiraman air dan pemupukan berkala.
- Jurnal Catat Perkembangan Tanaman: pencatatan pertumbuhan tinggi dan kondisi vegetatif disertai dokumentasi foto real-time.

### 2. Manajemen Sektor Peternakan (Livestock)
- Input populasi hewan ternak (sapi potong, sapi perah, kambing, domba, ayam broiler, ayam layer) dengan nomor tag telinga/kandang dan unggah foto.
- Kalkulasi otomatis kebutuhan pakan harian: proporsi ransum hijauan, konsentrat pakan, dan volume kebutuhan air bersih.
- Rekomendasi suplemen vitamin dan mineral penting untuk mengoptimalkan kekebalan dan bobot harian.
- Jurnal Catat Perkembangan Ternak: pencatatan penambahan bobot badan (timbang rutin) dan catatan kesehatan lengkap dengan dokumentasi foto.

### 3. Pemindai Diagnosa Hama & Penyakit AI Terpadu (Dual-Sector Vision AI)
- **Selektor Sektor Dua Ranah**: Pengalih instan pada viewfinder kamera antara mode Tanaman (*Pertanian*) dan mode Hewan Ternak (*Peternakan*).
- **Diagnosa Presisi Berbasis Database Patologi**:
  - *Pertanian*: Mendiagnosa Antraknosa (Patek), Hawar Daun Bakteri (Kresek), Virus Mosaik Kuning (Gemini Bule), Embun Buluk (Phytophthora), Bercak Ungu (Trotol), dan Bulai Jagung.
  - *Peternakan*: Mendiagnosa Penyakit Mulut dan Kuku (PMK), Scabies (Kudis Sarcoptic), Mastitis Klinis Ambing, Bloat Kembung Rumen, Tetelo (Newcastle Disease), dan Koksidiosis Berak Darah.
- **Keluaran Terstandarisasi**: Tingkat keparahan klinis (Normal s/d Kritis), persentase keyakinan (88% - 98%), nama taksonomi latin patogen, protokol medis veteriner darurat / solusi agens hayati nabati, dan langkah biosekuriti kandang.

### 4. Bursa Pasar 11 Kota & Pemisahan Kalkulator Sektor
- **Pemisahan Sektor Bersih**: Memisahkan antarmuka, acuan harga, dan kalkulator antara Hasil Panen (Pertanian) dan Hasil Ternak (Peternakan) agar kalkulasi mandiri dan tidak saling bentrok.
- **Kalkulator Simulasi Panen Pertanian**: Menghitung estimasi total tonase panen, omzet kotor, biaya operasional/pupuk, dan laba bersih berdasarkan populasi lubang tanam dan slider tingkat keberhasilan panen.
- **Kalkulator Komparasi Penjualan Ternak**: Menganalisis komparasi laba bersih antara penjualan timbang hidup langsung vs sembelih daging karkas (bobot hidup, rendemen %, harga daging karkas, nilai hasil samping jeroan/kulit/kaki, dan biaya potong RPH).
- **Pantauan Harga Real-Time 11 Kota**: Data harga komoditas acuan di 11 kota sentra ekonomi Indonesia lengkap dengan indikator tren pergerakan harga.

---

## Panduan Instalasi & Menjalankan Aplikasi

### Prasyarat
- Flutter SDK versi 3.0.0 atau yang lebih baru.
- Android Studio / VS Code dengan ekstensi Flutter & Dart.
- Java JDK 17 (disarankan Eclipse Temurin 17).
- Perangkat Android fisik atau emulator Android (API level 24 atau lebih tinggi).

### Langkah-langkah
1. **Kloning Repositori**:
   ```bash
   git clone https://github.com/anisawulandari22/Himtec2026.git
   cd Himtec2026
   ```

2. **Unduh Dependensi**:
   ```bash
   flutter pub get
   ```

3. **Verifikasi Integritas Kode**:
   ```bash
   flutter analyze --no-fatal-infos
   ```

4. **Jalankan Aplikasi pada Perangkat**:
   ```bash
   flutter run
   ```

---

## Build APK & Otomatisasi CI/CD

Proyek ini telah dilengkapi dengan pipeline CI/CD otomatis berbasis GitHub Actions (`.github/workflows/build-apk.yml`).

### Build Manual via Baris Perintah
Untuk mengompilasi berkas APK secara mandiri:
```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release
```
Berkas APK yang dihasilkan berada pada direktori:
`build/app/outputs/flutter-apk/app-release.apk`

### Unduh APK dari GitHub Actions
Setiap pembaruan (*push*) ke branch `main`, GitHub Actions akan menjalankan proses otomatis:
1. Menyiapkan lingkungan Java 17 dan Flutter SDK stable.
2. Menjalankan skrip `inject_permissions.py` untuk mengonfigurasi label aplikasi `AGL`, hak akses kamera dan penyimpanan, serta ikon resolusi tinggi.
3. Melakukan verifikasi kode melalui `flutter analyze` dan `flutter test`.
4. Mengompilasi APK Android dan mengunggah artefak build yang dapat langsung diunduh pada tab **Actions** di repositori GitHub.
