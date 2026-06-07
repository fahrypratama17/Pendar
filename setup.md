# Panduan Setup & Uji Coba Integrasi Pendar (Frontend & ML Backend)

Dokumen ini dibuat buat bantu kalian nge-setup dan ngetes alur integrasi antara Flutter Pendar dan Flask ML Backend secara lokal menggunakan HP fisik.

---

## 1. Setup Backend (pendar-backend)

Karena Flask backend Sulthan yang ngurusin prediksi ML dan nyimpen data ke Supabase, kalian perlu jalanin ini dulu di laptop.

### Langkah-langkah:
1. **Clone Repository Backend** (kalau belum ada):
   ```bash
   git clone https://github.com/sulthanrps/pendar-backend.git
   cd pendar-backend
   ```
2. **Buat Virtual Environment & Install Library**:
   ```bash
   python -m venv venv
   
   # Untuk Windows (PowerShell/CMD):
   venv\Scripts\activate
   
   # Untuk macOS/Linux:
   source venv/bin/activate
   
   # Install semua library python yang dibutuhin:
   pip install -r requirements.txt
   ```
3. **Setup File `.env`**:
   Buat file bernama `.env` di root folder `pendar-backend`, lalu isi pake kredensial Supabase berikut:
   ```env
   SUPABASE_URL=https://qeipqnzsqefebevgucgb.supabase.co
   SUPABASE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFlaXBxbnpzcWVmZWJldmd1Y2diIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc4MDQ2NzE3NSwiZXhwIjoyMDk2MDQzMTc1fQ.3rakObE-Tg_4SeuGyTK1pOWYQYlja_SaU0LePy1fPxs
   ```
4. **Jalankan Server**:
   ```bash
   python app.py
   ```
   *Catatan: Server Flask udah diset biar dengerin host `0.0.0.0`, jadi HP fisik di jaringan Wi-Fi yang sama bakal bisa ngakses.*

---

## 2. Setup Frontend (Flutter Pendar)

Sekarang kalian perlu nge-pull branch terbaru dan nyambungin Flutter ke IP laptop masing-masing.

### Langkah-langkah:
1. **Pull Branch Terbaru**:
   Pindah ke branch `main` (setelah branch `zuhdi` di-merge) dan tarik update paling baru:
   ```bash
   git checkout main
   git pull origin main
   ```
2. **Cari Tahu IP Wi-Fi Laptop Kalian**:
   *   **Windows**: Buka CMD, ketik `ipconfig`. Cari bagian **Wireless LAN adapter Wi-Fi**, lalu catat **IPv4 Address** kalian (misal: `192.168.1.15`).
   *   **macOS/Linux**: Buka Terminal, ketik `ifconfig` atau cek di pengaturan Network Wi-Fi kalian.
3. **Ubah URL API di Flutter**:
   Buka file `lib/config/constants.dart`. Ganti value `mlApiUrl` pake IP Wi-Fi laptop kalian:
   ```dart
   // Ganti dengan IP laptop kalian masing-masing
   static const String mlApiUrl = 'http://<IP_LAPTOP_KALIAN>:5000';
   ```
4. **Install Dependensi & Jalankan**:
   ```bash
   flutter pub get
   ```

---

## 3. Cara Build APK & Test di HP Fisik (Tanpa Kabel / USB Debugging)

Setelah konfigurasi IP selesai, kalian bisa build aplikasinya jadi file APK, lalu install dan pakai di HP biasa secara mandiri tanpa perlu dicolok kabel atau pakai USB Debugging.

### Langkah-langkah:
1. **Build APK Release**:
   Jalankan perintah ini di terminal proyek Flutter:
   ```bash
   flutter build apk --release
   ```
2. **Kirim & Install APK ke HP**:
   * Ambil file APK yang sudah jadi di folder: `build/app/outputs/flutter-apk/app-release.apk`.
   * Kirim file APK tersebut ke HP kalian (bisa lewat WhatsApp, Google Drive, ShareIt, atau copy via kabel data).
   * Buka file APK di HP dan lakukan install.
3. **Hubungkan ke Wi-Fi yang Sama**:
   * Pastikan HP kalian terhubung ke **jaringan Wi-Fi yang sama** dengan laptop yang menjalankan backend Flask.
4. **PENTING: Cek Firewall Laptop**:
   Biar HP kalian bisa ngakses Flask server di laptop, pastikan Firewall Windows/Mac tidak memblokir koneksi masuk ke port `5000`.
   * **Tips Cepat (Windows)**: Jika koneksi gagal, coba ganti profil network Wi-Fi kalian di Windows dari *Public* ke *Private*, atau izinkan Python/Flask melewati Windows Defender Firewall.
5. **Tes Alur Integrasi**:
   Buka aplikasi Pendar di HP -> Masuk ke menu **Check-in** -> Isi kuesioner sampai akhir -> Tekan **Analyze Result**. Aplikasi di HP akan langsung menembak Flask backend di laptop kalian lewat Wi-Fi secara nirkabel, memproses prediksi ML, menyimpannya di Supabase, dan menampilkan hasilnya kembali di HP.
