import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart'; // Import untuk font kustom
import 'package:smartsmashapp/app/modules/detail_backhand/controllers/detail_backhand_controller.dart';
import 'dart:async';

import 'package:smartsmashapp/app/modules/detail_forehand/controllers/detail_forehand_controller.dart'; // Import untuk Timer

class DetailForehandView extends GetView<DetailBackhandController> {
  const DetailForehandView({super.key});

  @override
  Widget build(BuildContext context) {
    final DetailForehandController controller = Get.put(
      DetailForehandController(),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detail Gerakan',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            // *** MODIFIKASI: Warna teks AppBar menjadi biru tua ***
            color: Colors.indigo.shade900, // Menggunakan indigo.shade900
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0, // Tanpa bayangan
      ),
      backgroundColor:
          Colors.blueGrey.shade50, // Latar belakang yang lebih tenang
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 24,
        ), // Padding vertikal lebih besar
        child: Column(
          children: [
            // Kontainer Utama dengan Card dan Gradien
            Card(
              elevation: 10, // Elevasi lebih tinggi untuk kesan "mengambang"
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  25,
                ), // Sudut yang lebih membulat
              ),
              child: Container(
                // Menggunakan Container di dalam Card untuk gradien
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  gradient: LinearGradient(
                    colors: [
                      Colors.white,
                      Colors.blue.shade50, // Gradien lembut tetap biru muda
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: const EdgeInsets.all(
                  24,
                ), // Padding internal lebih besar
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Gambar Ilustrasi
                    ClipRRect(
                      borderRadius: BorderRadius.circular(
                        20,
                      ), // Sudut gambar lebih membulat
                      child: Image.asset(
                        'assets/images/matematika.png', // ganti dengan path sesuai gambar kamu
                        width: double.infinity,
                        height: 220, // Tinggi gambar sedikit lebih besar
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 32), // Spasi lebih besar
                    // Judul Kursus
                    Text(
                      'Kursus Online Matematika Komprehensif', // Judul lebih menarik
                      style: GoogleFonts.poppins(
                        fontSize: 28, // Ukuran font lebih besar
                        fontWeight: FontWeight.w800, // Lebih tebal
                        // *** MODIFIKASI: Warna judul kursus menjadi biru tua ***
                        color:
                            Colors
                                .indigo
                                .shade900, // Menggunakan indigo.shade900
                        height: 1.2, // Spasi baris
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Deskripsi Kursus
                    Text(
                      'Selami dunia matematika dengan kurikulum yang dirancang ahli. Pelajari konsep-konsep kompleks melalui pendekatan yang intuitif dan contoh praktis.', // Deskripsi lebih detail
                      style: GoogleFonts.openSans(
                        fontSize: 16,
                        color:
                            Colors.blueGrey.shade600, // Warna teks lebih lembut
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32), // Spasi antara Card dan tombol
            // Widget untuk menampilkan hitung mundur (hanya terlihat saat hitung mundur aktif)
            Obx(
              () =>
                  controller.isCountingDown.value
                      ? Column(
                        children: [
                          Text(
                            'Latihan akan dimulai dalam...',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.blueGrey.shade700,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '${controller.countdown.value}', // Menampilkan nilai hitung mundur
                            style: GoogleFonts.poppins(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              // *** MODIFIKASI: Warna hitung mundur menjadi biru tua ***
                              color:
                                  Colors
                                      .indigo
                                      .shade900, // Menggunakan indigo.shade900
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      )
                      : const SizedBox.shrink(),
            ), // Menyembunyikan widget saat tidak hitung mundur
            // Tombol "Latihan Sekarang"
            SizedBox(
              width: double.infinity,
              height: 60, // Tinggi tombol lebih besar
              child: ElevatedButton(
                onPressed:
                    controller.isCountingDown.value
                        ? null // Nonaktifkan tombol saat hitung mundur berlangsung
                        : () {
                          controller.startCountdown(); // Mulai hitung mundur
                        },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      controller.isCountingDown.value
                          ? Colors
                              .grey // Warna abu-abu saat dinonaktifkan
                          // *** MODIFIKASI: Warna tombol menjadi biru tua ***
                          : Colors
                              .indigo
                              .shade900, // Menggunakan indigo.shade900
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      15,
                    ), // Sudut tombol lebih membulat
                  ),
                  elevation: 8, // Elevasi tombol lebih menonjol
                  // *** MODIFIKASI: Warna bayangan tombol menjadi nuansa biru ***
                  shadowColor:
                      Colors.indigo.shade200, // Menggunakan indigo.shade200
                ),
                child: Text(
                  controller.isCountingDown.value
                      ? 'Memulai...' // Teks tombol saat hitung mundur
                      : 'Latihan Sekarang', // Teks tombol default
                  style: GoogleFonts.poppins(
                    fontSize: 20, // Ukuran font lebih besar
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.8, // Spasi antar huruf
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24), // Spasi di bawah tombol (opsional)
          ],
        ),
      ),
    );
  }
}
