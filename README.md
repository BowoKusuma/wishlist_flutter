# 🌟 My Bucket List — Flutter App

Aplikasi wishlist / bucket list berbahasa Indonesia, dikonversi dari React JSX ke Flutter.

## Fitur

- ✅ Tambah, edit, hapus wishlist
- 🗂️ Filter berdasarkan kategori (Perjalanan, Pengalaman, Barang, Belajar, Kuliner)
- 💰 Progress bar budget per wishlist
- ➕ Tambah tabungan langsung dari halaman detail
- 🎉 Tandai wishlist sebagai selesai
- 🌙 Dark mode / Light mode toggle
- 💾 Data tersimpan lokal (shared_preferences)
- 📊 Statistik total budget & dana terkumpul

## Struktur Proyek

```
lib/
├── main.dart           # Entry point
├── app.dart            # Root widget + Provider
├── theme.dart          # Warna & tema light/dark
├── models.dart         # Model Wish, kategori, helper
├── state.dart          # WishlistState (ChangeNotifier)
├── screens/
│   ├── list_screen.dart    # Halaman utama daftar wishlist
│   ├── detail_screen.dart  # Halaman detail wishlist
│   └── form_screen.dart    # Form tambah / edit wishlist
└── widgets/
    └── common.dart         # Widget reusable (progress bar, pill, dll)
```

## Cara Menjalankan

### Prasyarat
- Flutter SDK ≥ 3.0.0
- Dart SDK ≥ 3.0.0

### Langkah

```bash
# 1. Masuk ke folder proyek
cd wishlist_flutter

# 2. Install dependencies
flutter pub get

# 3. Jalankan di emulator atau device
flutter run

# 4. Build APK (Android)
flutter build apk --release

# 5. Build IPA (iOS, harus di macOS)
flutter build ipa
```

## Dependencies

| Package | Kegunaan |
|---|---|
| `provider` | State management |
| `shared_preferences` | Simpan data lokal |
| `uuid` | Generate ID unik |

## Desain

- Light mode: warna krem/cokelat hangat
- Dark mode: warna ungu gelap elegan
- Font utama: Georgia (serif) + Nunito (sans-serif)
