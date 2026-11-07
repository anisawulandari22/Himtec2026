# Modul Fitur (Feature Modules)

Direktori ini dirancang untuk menampung fitur-fitur baru secara modular dengan prinsip Clean Architecture atau Feature-First Structure:

```
lib/features/
├── attendance/          (Modul Presensi Kehadiran)
│   ├── data/            (datasources, models, repositories)
│   ├── domain/          (entities, usecases, repository interfaces)
│   └── presentation/    (controllers/bloc/providers, screens, widgets)
├── documents/           (Modul Berkas & Modul Pembelajaran)
├── finance/             (Modul Kas & Anggaran)
└── recruitment/         (Modul Pendaftaran & Seleksi)
```

Setiap fitur bersifat mandiri (*loosely coupled*) dan hanya mengimpor modul bersama dari `lib/core/`.

