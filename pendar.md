# Dokumentasi Pengembangan & Perbaikan Pendar

Dokumen ini mencatat seluruh fitur baru, perbaikan bug, dan penyesuaian visual antarmuka (UI/UX) yang telah diimplementasikan pada aplikasi Pendar.

---

## 1. 📅 Fitur & Penyesuaian Halaman Schedule
- **Penyelarasan Desain Card List**:
  - Menyematkan **vertical stripe berwarna ungu** (`AppColors.primary`) di sisi paling kiri card.
  - Memperbarui checkbox menjadi **custom circular toggle** (lingkaran transparan saat belum selesai, dan terisi warna ungu dengan centang saat selesai).
  - Mengubah ikon jam dan tanggal untuk menggunakan **file asset SVG asli** (`Iconjam.svg` dan `Icondate.svg`), bukan ikon Material standar.
  - Meningkatkan keterbacaan tipografi: Judul Tugas (`18.0`), Catatan (`14.0`), dan Jam/Tanggal (`12.0`).
  - Menghapus padding keras agar catatan (notes) dan informasi jam/tanggal terindentasi sejajar dengan judul tugas.
  - Mengubah teks penanda prioritas dari huruf kapital menjadi Title Case (`High`, `Medium`, `Low`).
- **Perbaikan Form Overflow**:
  - Mengatasi masalah layout `RIGHT OVERFLOWED BY 6.0 PIXELS` pada form Priority & Deadline dengan mempersingkat label opsi dropdown menjadi `"High"`, `"Medium"`, `"Low"` serta menyesuaikan padding horizontal field menjadi `12.0`.

---

## 📝 2. Fitur & Penyesuaian Halaman Journal
- **Premium Seamless Editor**:
  - Input judul dan konten jurnal dibuat tanpa border (`border: InputBorder.none`) pada view editor agar area menulis terasa lapang menyerupai notebook digital premium.
- **Auto-Save & Partial Update**:
  - Menyematkan sistem penyimpanan otomatis berbasis debounce timer (1.5 detik) yang langsung mensinkronisasikan draf jurnal ke database Supabase secara *background/non-blocking*.
  - Menampilkan status visual `"Saving..."` dan `"Saved to cloud"` secara halus tepat di bawah judul AppBar.
- **Penyelarasan Desain Card List**:
  - Mengatur ukuran emoji mood menjadi `18.0` agar lebih proporsional.
  - Menyesuaikan margin, jarak vertikal antar teks (10.0 dan 8.0), serta meningkatkan padding card menjadi `24.0`.
  - Mengubah warna garis tepi (*border*) card jurnal dan schedule dari warna gelap menjadi **kontur warna ungu yang lebih terang** (`Color(0xFF2E284F)`) agar terlihat jelas dan menonjol dari latar belakang gelap sesuai mockup.

---

## 📱 3. Penyelarasan Layout Utama & Header
- **Pembaruan Top Bar/Header**:
  - Mengubah ikon header kiri halaman Journal & Schedule dari ikon otak (`Iconmind.svg`) menjadi ikon **location pin/teardrop** (`Iconstress.svg`) langsung tanpa latar belakang lingkaran.
  - Mengubah tombol profil kanan atas menjadi **bordered circular avatar** berisi ikon orang (`Icons.person_outline`).
- **Bottom Navigation Bar (Flat Design)**:
  - Menghilangkan efek bayangan/cahaya ungu (`boxShadow`) pada ikon tab aktif agar terlihat datar (*flat*) menyerupai mockup asli.
- **Responsivitas Halaman**:
  - Mengamankan `HomeView` dan `OnboardingView` dari bahaya overflow ketika keyboard terbuka dengan menggunakan layout scroll dinamis (`LayoutBuilder` + `SingleChildScrollView` + `ConstrainedBox` + `IntrinsicHeight`).

---

## 🛠️ 4. Konfigurasi Sistem, APK, & Gradle
- **Kustomisasi Aset APK**:
  - Menonaktifkan banner debug di pojok kanan atas aplikasi (`debugShowCheckedModeBanner: false`).
  - Mengubah nama aplikasi menjadi `"Pendar"` di manifes Android.
  - Memperbarui ikon launcher aplikasi Android dan iOS menggunakan aset `pendaricon.png` via generator `flutter_launcher_icons`.
- **Migrasi Kotlin & Upgrade Dependensi**:
  - Bermigrasi ke **Built-in Kotlin** dengan menghapus plugin manual `kotlin-android` di `android/app/build.gradle.kts` agar kompatibel dengan Flutter versi terbaru.
  - Melakukan `flutter pub upgrade` untuk memperbarui dependensi `shared_preferences_android` dan `url_launcher_android`.
- **Penanganan Eror Daemon / Cross-Drive Path (Windows)**:
  - Menyelesaikan kendala build `this and base files have different roots` (karena file proyek di drive `D:\` sedangkan Pub cache di drive `C:\`) dengan menonaktifkan kompilasi inkremental Kotlin (`kotlin.incremental=false`) di `android/gradle.properties`.

---

## 🔒 5. Validasi Keamanan Input & Notifikasi Kustom
- **Keamanan Kredensial**:
  - Validasi format email berbasis Regex di halaman login dan registrasi.
  - Pengetatan kompleksitas password saat registrasi (minimal 8 karakter, wajib memiliki huruf kapital, huruf kecil, dan angka).
- **Pesan Eror Bersahabat**:
  - Membuat `error_translator.dart` untuk menerjemahkan eror database/auth Supabase menjadi pesan bahasa Indonesia yang sopan dan mudah dipahami.
  - Mengintegrasikan translasi ke dalam `custom_snackbar.dart` dengan visual blur kaca (*glassmorphism*).

---

## 🔍 6. Status Verifikasi & Git Commit
1. **Flutter Analyze**: Bersih dari semua eror, warning, dan linting issues (**No issues found!**).
2. **Git Commit & Push**:
   - Seluruh pembaruan di atas telah ditambahkan, dicommit, dan dipush ke cabang `zuhdi` di GitHub Anda.
