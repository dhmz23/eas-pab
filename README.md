# 🛒 Toko Online UNTAG
**Aplikasi E-Commerce Mobile – Ujian Praktikum PAB**
Universitas 17 Agustus 1945 (UNTAG) Surabaya

---

## 📱 Deskripsi Aplikasi

Toko Online UNTAG adalah aplikasi e-commerce mobile berbasis Flutter yang menerapkan materi Modul 1–4 secara komprehensif. Aplikasi mengambil data produk dari REST API publik (Fake Store API) dan menyediakan fitur interaktif lengkap.

---

## 📂 Struktur Project

```
untag_store/
├── lib/
│   ├── main.dart                    # Entry point, MultiProvider setup
│   ├── models/
│   │   ├── product.dart             # Model Product, Rating, CartItem
│   │   └── user.dart                # Model UserModel
│   ├── services/
│   │   ├── api_service.dart         # HTTP GET ke Fake Store API
│   │   └── auth_service.dart        # Auth lokal via SharedPreferences
│   ├── providers/
│   │   └── cart_provider.dart       # State management keranjang
│   ├── utils/
│   │   └── app_theme.dart           # Theme, warna, AppConstants
│   └── screens/
│       ├── splash_screen.dart       # Splash dengan animasi
│       ├── onboarding_screen.dart   # 3 slide PageView onboarding
│       ├── login_screen.dart        # Form login + validasi
│       ├── register_screen.dart     # Form registrasi + validasi
│       ├── main_screen.dart         # BottomNavigationBar (4 tab)
│       ├── home_screen.dart         # Beranda: sapaan, banner, kategori, produk
│       ├── catalog_screen.dart      # Katalog + search + filter chip
│       ├── product_detail_screen.dart  # Detail produk + tombol keranjang
│       ├── cart_screen.dart         # Keranjang + quantity + total
│       ├── profile_screen.dart      # Profil pengguna + logout
│       └── edit_profile_screen.dart # Form edit profil
├── assets/images/                   # Folder untuk aset gambar
└── pubspec.yaml                     # Dependencies
```

---

## ✅ Pemetaan Materi Modul

### Modul 1 – Dasar Flutter & Dart
| Fitur | Implementasi |
|-------|-------------|
| Dart OOP | Class `Product`, `UserModel`, `CartItem`, `CartProvider` |
| Widget dasar | `Text`, `Image`, `Icon`, `Container`, `Column`, `Row` |
| StatelessWidget | `_ProductGridCard`, `_CartSummary`, `_InfoTile`, `_OnboardingPage` |
| StatefulWidget | Semua halaman utama dengan `setState()` |
| Async/Await | `ApiService.fetchProducts()`, `AuthService.login()` |
| Factory constructor | `Product.fromJson()`, `Rating.fromJson()`, `UserModel.fromJson()` |

### Modul 2 – Layout & Navigasi
| Fitur | Implementasi |
|-------|-------------|
| GridView.builder | Katalog produk tampilan grid |
| ListView.builder | Katalog list, keranjang belanja |
| PageView | Onboarding (3 slide), banner promo di Beranda |
| CustomScrollView + Slivers | Beranda & Detail Produk (SliverAppBar) |
| Navigator.push | Katalog → Detail Produk |
| Navigator.pushReplacement | Login → Main, Logout → Login |
| Navigator.pushAndRemoveUntil | Logout menghapus semua history |
| BottomNavigationBar | 4 tab: Beranda, Katalog, Keranjang, Profil |

### Modul 3 – State Management & Data Lokal
| Fitur | Implementasi |
|-------|-------------|
| Provider + ChangeNotifier | `CartProvider` untuk state keranjang |
| Consumer Widget | Badge keranjang di nav bar & detail produk |
| SharedPreferences | Simpan data user registrasi dan status login |
| setState | Pencarian, filter, quantity selector |
| Validasi form | Login, Register, Edit Profil |
| GlobalKey<FormState> | Validasi form dengan `_formKey.currentState!.validate()` |

### Modul 4 – REST API & FutureBuilder
| Fitur | Implementasi |
|-------|-------------|
| HTTP GET Request | `http.get()` ke `fakestoreapi.com` |
| JSON Parsing | `json.decode()` + `Product.fromJson()` |
| FutureBuilder | 3 state: loading (CircularProgressIndicator), error (pesan + retry), done |
| Timeout | `.timeout(Duration(seconds: 15))` |
| Error handling | try-catch dengan pesan error informatif |
| Endpoint yang digunakan | `/products`, `/products/categories`, `/products?limit=8` |

---

## 🎨 Fitur per Halaman

### A. Splash Screen
- Logo aplikasi dengan animasi **FadeTransition + ScaleTransition**
- Nama aplikasi dan tagline
- Auto-redirect ke Onboarding atau Main (jika sudah login)
- `CircularProgressIndicator` saat transisi

### B. Onboarding (3 Slide)
- **PageView** dengan 3 slide informatif
- Indikator halaman animasi
- Tombol "Lewati" dan "Selanjutnya" / "Mulai Belanja"

### C. Login & Register
- **Login**: Validasi email (regex) + password (min 6 karakter), error message
- **Register**: 6 field (nama, NIM, prodi, email, password, konfirmasi), validasi lengkap
- Data disimpan di **SharedPreferences**, bisa langsung login setelah daftar
- Toggle show/hide password

### D. Beranda
- Sapaan "Halo, [Nama]!" dari data user login
- **Banner promo** auto-scroll (PageView 3 slide dengan timer)
- **Kategori horizontal scroll** (dari API)
- **Produk unggulan** dengan FutureBuilder (loading / error / done)

### E. Katalog Produk
- Data dari **Fake Store API** (`fakestoreapi.com/products`)
- **GridView** dan **ListView** (toggle)
- `FutureBuilder` dengan 3 state
- Kartu produk: gambar, nama, harga (IDR), rating, kategori badge

### F. Pencarian & Filter
- **TextField** search bar – filter real-time saat mengetik
- **FilterChip** kategori – filter berdasarkan kategori API
- Search + filter bekerja **bersamaan**
- Counter hasil: "X produk ditemukan"
- Pesan "tidak ada produk" dengan tombol reset filter

### G. Detail Produk
- **Navigator.push** dengan passing objek `Product`
- **Hero animation** pada gambar produk
- Gambar besar, nama, harga (IDR), deskripsi, bintang rating
- **Quantity selector** (+ / -)
- Tombol **"Tambah ke Keranjang"** → SnackBar konfirmasi
- Tombol "Beli Sekarang"

### H. Keranjang Belanja
- Daftar `CartItem` dengan gambar, nama, harga, subtotal
- **Quantity +/-** per item
- **Swipe to delete** (Dismissible) + tombol hapus semua
- Total harga, ongkir GRATIS
- **Badge** jumlah item di BottomNav (update real-time via `Consumer`)
- Tombol checkout dengan dialog konfirmasi

### I. Profil & Edit Profil
- Data pengguna: nama, NIM, prodi, email
- Avatar inisial otomatis
- **Edit Profil**: form dengan validasi, simpan ke SharedPreferences
- Perubahan langsung terlihat saat kembali ke Profil
- **Logout** via `Navigator.pushAndRemoveUntil` → halaman Login

---

## 🚀 Cara Menjalankan

### Prasyarat
- Flutter SDK ≥ 3.0.0
- Dart ≥ 3.0.0
- Android Studio / VS Code dengan Flutter extension
- Perangkat/emulator Android atau iOS

### Langkah
```bash
# 1. Masuk ke folder project
cd untag_store

# 2. Install dependencies
flutter pub get

# 3. Jalankan aplikasi
flutter run

# 4. Build APK (opsional)
flutter build apk --release
```

### Dependencies
```yaml
http: ^1.2.0               # HTTP request ke REST API
shared_preferences: ^2.2.2 # Penyimpanan data lokal
cached_network_image: ^3.3.1 # Cache gambar dari network
provider: ^6.1.1           # State management
intl: ^0.19.0              # Format angka/mata uang
```

---

## 🌐 REST API

**Base URL:** `https://fakestoreapi.com`

| Endpoint | Fungsi |
|----------|--------|
| `GET /products` | Semua produk |
| `GET /products?limit=8&sort=desc` | Produk unggulan (8 terbaru) |
| `GET /products/categories` | Daftar semua kategori |
| `GET /products/category/{name}` | Produk per kategori |

---

## 📝 Catatan Implementasi

1. **Konversi Harga**: Harga dari API dalam USD dikonversi ke IDR (× 15.000)
2. **Autentikasi Lokal**: Data user disimpan di SharedPreferences (JSON encoded list)
3. **State Management**: `CartProvider` menggunakan `ChangeNotifier` + `Consumer`
4. **Error Handling**: Setiap FutureBuilder menangani state error dengan tombol retry
5. **Responsive UI**: Menggunakan `Flexible`, `Expanded`, `MediaQuery` untuk adaptasi layar

---

## 👨‍💻 Dikembangkan untuk

**Ujian Praktikum Pengembangan Aplikasi Bergerak**
Program Studi Teknik Informatika
Universitas 17 Agustus 1945 (UNTAG) Surabaya
#   e a s - p a b  
 