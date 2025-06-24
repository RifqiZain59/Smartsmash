import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Assuming GetX is still used for controller, though not strictly needed for UI

import '../controllers/syarat_ketentuan_controller.dart'; // Keep the import for consistency

class SyaratKetentuanView extends GetView<SyaratKetentuanController> {
  const SyaratKetentuanView({super.key});

  @override
  Widget build(BuildContext context) {
    // Warna yang ditentukan untuk mode terang (sebelumnya deteksi isDarkMode telah dihapus)
    const Color darkBlue = Color(
      0xFF1A237E,
    ); // Warna biru indigo tua untuk mode terang
    const Color appBarBackgroundColor =
        darkBlue; // AppBar akan menggunakan warna biru tua
    const Color appBarTextColor = Colors.white; // Teks AppBar tetap putih
    const Color scaffoldBackgroundColor =
        Colors.white; // Latar belakang Scaffold putih
    const Color bodyTextColor = Colors.black87; // Teks isi hitam pekat
    const Color footerTextColor = Colors.grey; // Teks footer abu-abu

    return Scaffold(
      backgroundColor: scaffoldBackgroundColor, // Setel latar belakang Scaffold
      appBar: AppBar(
        // Sesuaikan tampilan AppBar
        title: Text(
          'Syarat & Ketentuan',
          style: TextStyle(
            color: appBarTextColor, // Warna teks
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: appBarBackgroundColor, // Warna latar belakang AppBar
        elevation: 0, // Hapus bayangan untuk desain yang lebih datar
        iconTheme: IconThemeData(
          color: appBarTextColor, // Warna tombol kembali
        ),
      ),
      // Bungkus konten body dengan SafeArea untuk mencegahnya melanggar UI sistem (misalnya, notch, status bar)
      body: SafeArea(
        child: SingleChildScrollView(
          // Memungkinkan konten untuk digulir jika meluap
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 25.0,
          ), // Padding yang disesuaikan
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Sejajarkan teks ke awal (kiri)
            children: [
              // --- Bagian Pendahuluan ---
              Text(
                'Selamat datang di aplikasi kami. Dengan menggunakan aplikasi ini, Anda setuju untuk mematuhi dan terikat oleh syarat dan ketentuan berikut:',
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5, // Tinggi baris untuk keterbacaan
                  color: bodyTextColor, // Warna teks
                ),
              ),
              const SizedBox(
                height: 30,
              ), // Jarak yang ditingkatkan antara bagian utama
              // --- Bagian 1: Penggunaan Aplikasi ---
              _buildSectionTitle(
                '1. Penggunaan Aplikasi',
                darkBlue,
              ), // Meneruskan warna biru tua ke judul
              const SizedBox(height: 10),
              _buildSectionContent(
                'Aplikasi ini disediakan untuk penggunaan pribadi dan non-komersial Anda. Anda tidak boleh menggunakan aplikasi ini untuk tujuan ilegal atau tidak sah.',
                bodyTextColor,
              ), // Meneruskan warna teks body
              const SizedBox(height: 10),
              _buildSectionContent(
                'Anda bertanggung jawab untuk menjaga kerahasiaan akun dan kata sandi Anda serta untuk semua aktivitas yang terjadi di bawah akun Anda.',
                bodyTextColor,
              ), // Meneruskan warna teks body
              const SizedBox(height: 30),

              // --- Bagian 2: Hak Kekayaan Intelektual ---
              _buildSectionTitle('2. Hak Kekayaan Intelektual', darkBlue),
              const SizedBox(height: 10),
              _buildSectionContent(
                'Semua konten, merek dagang, logo, dan materi lain yang ditampilkan dalam aplikasi ini adalah milik kami atau pemberi lisensi kami dan dilindungi oleh undang-undang hak cipta dan merek dagang.',
                bodyTextColor,
              ), // Meneruskan warna teks body
              const SizedBox(height: 30),

              // --- Bagian 3: Batasan Tanggung Jawab ---
              _buildSectionTitle('3. Batasan Tanggung Jawab', darkBlue),
              const SizedBox(height: 10),
              _buildSectionContent(
                'Kami tidak bertanggung jawab atas kerugian atau kerusakan apa pun yang timbul dari penggunaan atau ketidakmampuan untuk menggunakan aplikasi ini, termasuk namun tidak terbatas pada kerugian langsung, tidak langsung, insidental, atau konsekuensial.',
                bodyTextColor,
              ), // Meneruskan warna teks body
              const SizedBox(height: 30),

              // --- Bagian 4: Perubahan Syarat & Ketentuan ---
              _buildSectionTitle('4. Perubahan Syarat & Ketentuan', darkBlue),
              const SizedBox(height: 10),
              _buildSectionContent(
                'Kami berhak untuk mengubah syarat dan ketentuan ini kapan saja. Perubahan akan berlaku segera setelah diposting di aplikasi. Penggunaan Anda yang berkelanjutan atas aplikasi ini setelah perubahan tersebut merupakan penerimaan Anda terhadap syarat dan ketentuan yang direvisi.',
                bodyTextColor,
              ), // Meneruskan warna teks body
              const SizedBox(height: 30),

              // --- Bagian 5: Hukum yang Berlaku ---
              _buildSectionTitle('5. Hukum yang Berlaku', darkBlue),
              const SizedBox(height: 10),
              _buildSectionContent(
                'Syarat dan ketentuan ini diatur dan ditafsirkan sesuai dengan hukum yang berlaku di Indonesia.',
                bodyTextColor,
              ), // Meneruskan warna teks body
              const SizedBox(height: 30),

              // --- Bagian 6: Kontak Kami ---
              _buildSectionTitle('6. Kontak Kami', darkBlue),
              const SizedBox(height: 10),
              _buildSectionContent(
                'Jika Anda memiliki pertanyaan tentang Syarat & Ketentuan ini, silakan hubungi kami melalui [alamat email/informasi kontak Anda].',
                bodyTextColor,
              ), // Meneruskan warna teks body
              const SizedBox(height: 40), // Ruang lebih banyak sebelum footer
              // --- Footer / Tanggal ---
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Terakhir diperbarui: 29 Mei 2025',
                  style: TextStyle(
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                    color: footerTextColor, // Warna teks footer
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Metode pembantu untuk judul bagian yang konsisten
  Widget _buildSectionTitle(String title, Color color) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 19, // Sedikit lebih besar untuk hierarki yang lebih baik
        fontWeight: FontWeight.bold,
        color: color, // Menggunakan warna yang diteruskan
      ),
    );
  }

  // Metode pembantu untuk konten bagian yang konsisten
  Widget _buildSectionContent(String content, Color textColor) {
    return Text(
      content,
      textAlign:
          TextAlign.justify, // Ratakan teks untuk tampilan yang lebih bersih
      style: TextStyle(
        fontSize: 16,
        height:
            1.6, // Tinggi baris yang ditingkatkan untuk keterbacaan yang lebih baik
        color: textColor, // Menggunakan warna teks yang diteruskan
      ),
    );
  }
}
