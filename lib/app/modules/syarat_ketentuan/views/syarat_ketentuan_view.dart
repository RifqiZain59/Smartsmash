import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Assuming GetX is still used for controller, though not strictly needed for UI

import '../controllers/syarat_ketentuan_controller.dart'; // Keep the import for consistency

class SyaratKetentuanView extends GetView<SyaratKetentuanController> {
  const SyaratKetentuanView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Customize AppBar appearance
        title: const Text(
          'Syarat & Ketentuan',
          style: TextStyle(
            color: Colors.white, // Text color
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent, // AppBar background color
        elevation: 0, // Remove shadow
        iconTheme: const IconThemeData(
          color: Colors.white,
        ), // Back button color
      ),
      // Wrap the body content with SafeArea to prevent it from encroaching on system UI (e.g., notches, status bar)
      body: SafeArea(
        child: SingleChildScrollView(
          // Allows content to scroll if it overflows
          padding: const EdgeInsets.all(
            20.0,
          ), // Padding around the entire content
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Align text to the start (left)
            children: [
              // Section 1: Introduction
              const Text(
                'Selamat datang di aplikasi kami. Dengan menggunakan aplikasi ini, Anda setuju untuk mematuhi dan terikat oleh syarat dan ketentuan berikut:',
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                ), // Line height for readability
              ),
              const SizedBox(height: 20), // Space between sections
              // Section 2: Penggunaan Aplikasi
              const Text(
                '1. Penggunaan Aplikasi',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Aplikasi ini disediakan untuk penggunaan pribadi dan non-komersial Anda. Anda tidak boleh menggunakan aplikasi ini untuk tujuan ilegal atau tidak sah.',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 10),
              const Text(
                'Anda bertanggung jawab untuk menjaga kerahasiaan akun dan kata sandi Anda serta untuk semua aktivitas yang terjadi di bawah akun Anda.',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 20),

              // Section 3: Hak Kekayaan Intelektual
              const Text(
                '2. Hak Kekayaan Intelektual',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Semua konten, merek dagang, logo, dan materi lain yang ditampilkan dalam aplikasi ini adalah milik kami atau pemberi lisensi kami dan dilindungi oleh undang-undang hak cipta dan merek dagang.',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 20),

              // Section 4: Batasan Tanggung Jawab
              const Text(
                '3. Batasan Tanggung Jawab',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Kami tidak bertanggung jawab atas kerugian atau kerusakan apa pun yang timbul dari penggunaan atau ketidakmampuan untuk menggunakan aplikasi ini, termasuk namun tidak terbatas pada kerugian langsung, tidak langsung, insidental, atau konsekuensial.',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 20),

              // Section 5: Perubahan Syarat & Ketentuan
              const Text(
                '4. Perubahan Syarat & Ketentuan',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Kami berhak untuk mengubah syarat dan ketentuan ini kapan saja. Perubahan akan berlaku segera setelah diposting di aplikasi. Penggunaan Anda yang berkelanjutan atas aplikasi ini setelah perubahan tersebut merupakan penerimaan Anda terhadap syarat dan ketentuan yang direvisi.',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 20),

              // Section 6: Hukum yang Berlaku
              const Text(
                '5. Hukum yang Berlaku',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Syarat dan ketentuan ini diatur dan ditafsirkan sesuai dengan hukum yang berlaku di Indonesia.',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 20),

              // Section 7: Kontak Kami
              const Text(
                '6. Kontak Kami',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Jika Anda memiliki pertanyaan tentang Syarat & Ketentuan ini, silakan hubungi kami melalui [alamat email/informasi kontak Anda].',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 20),

              // Footer / Date
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Terakhir diperbarui: 29 Mei 2025',
                  style: TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
