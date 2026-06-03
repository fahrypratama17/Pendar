import 'package:supabase_flutter/supabase_flutter.dart';

class ErrorTranslator {
  ErrorTranslator._();

  static String translate(dynamic error) {
    if (error == null) {
      return 'Terjadi kesalahan yang tidak dikenal.';
    }

    String errorMessage = error.toString();

    if (error is AuthException) {
      errorMessage = error.message;
      final String code = error.code ?? '';
      
      if (code == 'otp_expired' || errorMessage.toLowerCase().contains('expired')) {
        return 'Kode verifikasi telah kedaluwarsa. Silakan kirim kode baru.';
      }
      if (code == 'invalid_credentials' || errorMessage.toLowerCase().contains('invalid login credentials')) {
        return 'Email atau kata sandi salah. Silakan periksa kembali.';
      }
      if (code == 'email_not_confirmed' || errorMessage.toLowerCase().contains('not confirmed')) {
        return 'Email Anda belum dikonfirmasi. Silakan verifikasi email Anda terlebih dahulu.';
      }
      if (code == 'user_already_exists' || errorMessage.toLowerCase().contains('already registered') || errorMessage.toLowerCase().contains('already exists')) {
        return 'Email ini sudah terdaftar. Silakan gunakan email lain atau masuk.';
      }
      if (errorMessage.toLowerCase().contains('at least 6 characters') || errorMessage.toLowerCase().contains('password should be')) {
        return 'Kata sandi terlalu pendek. Minimal harus 6 karakter.';
      }
    }

    if (error is PostgrestException) {
      final String code = error.code ?? '';
      if (code == '42501' || error.message.toLowerCase().contains('row-level security') || error.message.toLowerCase().contains('policy')) {
        return 'Akses ditolak. Anda tidak memiliki izin untuk melakukan tindakan ini.';
      }
      if (code == '23505') {
        return 'Data ini sudah terdaftar di database.';
      }
      if (code == '23503') {
        return 'Referensi data tidak ditemukan.';
      }
      errorMessage = error.message;
    }

    final String lowerMsg = errorMessage.toLowerCase();

    if (lowerMsg.contains('socketexception') ||
        lowerMsg.contains('failed host lookup') ||
        lowerMsg.contains('connection failed') ||
        lowerMsg.contains('network') ||
        lowerMsg.contains('internet')) {
      return 'Koneksi internet bermasalah. Silakan periksa jaringan Anda.';
    }

    if (lowerMsg.contains('timeoutexception') || lowerMsg.contains('timeout')) {
      return 'Waktu tunggu habis. Silakan coba kembali.';
    }

    if (lowerMsg.contains('user not authenticated') || lowerMsg.contains('authenticated') || lowerMsg.contains('auth.uid')) {
      return 'Sesi masuk Anda telah berakhir. Silakan masuk kembali.';
    }

    if (lowerMsg.contains('invalid credentials') || lowerMsg.contains('invalid login credentials')) {
      return 'Email atau kata sandi salah. Silakan periksa kembali.';
    }

    if (lowerMsg.contains('user_already_exists') || lowerMsg.contains('already registered') || lowerMsg.contains('already exists')) {
      return 'Email ini sudah terdaftar. Silakan gunakan email lain atau masuk.';
    }

    if (lowerMsg.contains('otp_expired') || lowerMsg.contains('otp expired')) {
      return 'Kode verifikasi telah kedaluwarsa. Silakan kirim kode baru.';
    }

    if (lowerMsg.contains('invalid grant') || lowerMsg.contains('invalid_grant')) {
      return 'Kode verifikasi salah atau tidak sah.';
    }

    return errorMessage;
  }
}
