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

## 3. Uji Coba Menggunakan HP Fisik

1. **Hubungkan ke Wi-Fi yang Sama**:
   Pastikan HP fisik kalian terhubung ke **jaringan Wi-Fi yang sama** dengan laptop yang nge-run Flask backend.
2. **Aktifkan USB Debugging**:
   Colok HP ke laptop lewat kabel USB, lalu pastikan fitur *Developer Options* dan *USB Debugging* di HP sudah aktif.
3. **Mulai Testing**:
   *   **Untuk Debug/Run Langsung**:
       ```bash
       flutter run --release
       ```
   *   **Untuk Build APK**:
       ```bash
       flutter build apk --release
       ```
       Kalian bisa ambil file APK-nya di `build/app/outputs/flutter-apk/app-release.apk` dan install manual di HP.
4. **Tes Alur Mind Check**:
   Masuk ke menu **Check-in** di aplikasi -> Isi semua step -> Tekan **Analyze Result**. Aplikasi bakal ngirim data ke laptop kalian, ngitung prediksi ML, nyimpen hasilnya ke database Supabase, dan tampilin skor fokus & burnout real-time di HP.
