import 'dart:async'; // Import untuk Timer
import 'package:flutter/material.dart'; // Import untuk Colors dan Icon di Get.defaultDialog
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart'; // Import untuk font kustom di Get.defaultDialog

class DetailBackhandController extends GetxController {
  RxInt countdown = 5.obs; // Nilai hitung mundur awal (misalnya 5 detik)
  RxBool isCountingDown =
      false.obs; // Untuk mengontrol visibilitas teks hitung mundur
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    _timer
        ?.cancel(); // Batalkan timer ketika controller ditutup untuk mencegah kebocoran memori
    super.onClose();
  }

  // Metode untuk memulai hitung mundur
  void startCountdown() {
    isCountingDown.value = true; // Setel status hitung mundur menjadi aktif
    countdown.value = 5; // Reset nilai hitung mundur ke awal (misalnya 5)
    _timer?.cancel(); // Batalkan timer yang mungkin sedang berjalan

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown.value > 0) {
        countdown.value--; // Kurangi hitung mundur setiap detik
      } else {
        timer.cancel(); // Hentikan timer ketika hitung mundur selesai
        isCountingDown.value =
            false; // Setel status hitung mundur menjadi tidak aktif
        showReadyDialog(); // Tampilkan dialog "Sudah Siap!"
      }
    });
  }

  // Metode untuk menampilkan pop-up notifikasi
  void showReadyDialog() {
    Get.defaultDialog(
      title: '', // Kosongkan title
      middleText: '', // Kosongkan middleText
      backgroundColor: Colors.white,
      radius: 15, // Radius sudut membulat dialog
      contentPadding: const EdgeInsets.fromLTRB(24, 5, 24, 0),
      actions: [], // Kosongkan actions karena semua konten di dalam 'content'

      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 0),

          // Judul "Sudah Siap!"
          Padding(
            padding: const EdgeInsets.only(top: 0.0, bottom: 5.0),
            child: Text(
              'Sudah Siap!',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                // *** MODIFIKASI: Ubah warna judul menjadi biru tua ***
                color:
                    Colors
                        .indigo
                        .shade900, // Menggunakan indigo.shade900 sebagai biru tua
              ),
            ),
          ),
          // Teks penjelasan
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 20),
            child: Text(
              'Anda siap untuk memulai gerakan tenis meja backhand.\nTekan tombol di bawah untuk melanjutkan.',
              textAlign: TextAlign.center,
              style: GoogleFonts.openSans(
                fontSize: 16,
                color: Colors.blueGrey.shade700,
              ),
            ),
          ),
          // Tombol "Mulai Latihan" dan "Batal" dalam satu Row
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Tombol "Batal"
                OutlinedButton(
                  onPressed: () {
                    Get.back(); // Tutup dialog tanpa melanjutkan
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey.shade400),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                  ),
                  child: Text(
                    'Batal',
                    style: GoogleFonts.poppins(
                      color: Colors.blueGrey.shade700,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Tombol "Mulai Latihan"
                ElevatedButton(
                  onPressed: () {
                    Get.back(); // Tutup dialog
                    goToCamera(); // Lanjutkan ke kamera
                  },
                  style: ElevatedButton.styleFrom(
                    // *** MODIFIKASI: Ubah warna latar belakang tombol menjadi biru tua ***
                    backgroundColor:
                        Colors.indigo.shade900, // Menggunakan indigo.shade900
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                  ),
                  child: Text(
                    'Mulai Latihan',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  // Metode untuk navigasi ke halaman kamera
  void goToCamera() {
    Get.toNamed('/camera-backhand');
  }
}
