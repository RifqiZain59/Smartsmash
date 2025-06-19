import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/pusat_bantuan_controller.dart'; // Assuming this controller exists and is still needed
import 'package:ionicons/ionicons.dart'; // Import Ionicons jika digunakan untuk ikon lain

class PusatBantuanView extends GetView<PusatBantuanController> {
  const PusatBantuanView({super.key});

  // Warna biru tua kustom yang akan kita gunakan (konsisten dengan HistoryLoginView)
  static const Color _darkBlue = Color(0xFF1A237E);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Memastikan latar belakang Scaffold putih
      body: ClipRRect(
        // Menerapkan lengkungan di sudut atas body
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(
            24,
          ), // Radius lengkungan yang konsisten dengan Home/HistoryLogin
          topRight: Radius.circular(24), // Radius lengkungan yang konsisten
        ),
        child: SafeArea(
          // Menjaga area aman dari status bar
          child: Column(
            // Menggunakan Column untuk menata header kustom dan konten utama
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Kustom
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  20,
                  20,
                  28,
                ), // Padding bawah header sedikit diperbesar
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          // Menggunakan IconButton untuk ikon kembali
                          icon: const Icon(Icons.arrow_back),
                          color: _darkBlue, // Warna ikon konsisten
                          iconSize: 28,
                          onPressed:
                              () =>
                                  Get.back(), // Fungsi untuk kembali ke halaman sebelumnya
                        ),
                        const SizedBox(
                          width: 16,
                        ), // Jarak antara ikon dan teks judul sedikit diperbesar
                        const Text(
                          'Pusat Bantuan',
                          style: TextStyle(
                            fontSize:
                                24, // Ukuran font judul tetap besar untuk penekanan
                            fontWeight: FontWeight.bold,
                            color: _darkBlue, // Warna judul konsisten
                          ),
                        ),
                      ],
                    ),
                    // Anda bisa menambahkan ikon lain di sini jika diperlukan
                  ],
                ),
              ),
              Expanded(
                // Memastikan SingleChildScrollView mengambil sisa ruang yang tersedia
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                    20.0,
                    0,
                    20.0,
                    20.0,
                  ), // Padding disesuaikan, tambahkan padding bawah
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- Pertanyaan Umum (FAQ) ---
                      Text(
                        'Pertanyaan Umum (FAQ)',
                        style: Theme.of(
                          context,
                        ).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: _darkBlue, // Menggunakan warna _darkBlue
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ), // Jarak antara judul FAQ dan daftar FAQ
                      _buildFaqSection(), // Extracted FAQ section into a helper method
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget for FAQ section using ExpansionTile
  Widget _buildFaqSection() {
    // Sample FAQ data
    final List<Map<String, String>> faqs = [
      {
        'question': 'Bagaimana cara mengubah informasi profil saya?',
        'answer':
            'Anda dapat mengubah informasi profil Anda dengan masuk ke bagian "Akun & Profil" di aplikasi, lalu pilih "Edit Profil".',
      },
      {
        'question': 'Bagaimana cara melacak pesanan saya?',
        'answer':
            'Status pesanan Anda dapat dilacak melalui menu "Pesanan Saya". Di sana Anda akan melihat pembaruan terkini mengenai pesanan Anda.',
      },
      {
        'question': 'Apa yang harus saya lakukan jika lupa kata sandi?',
        'answer':
            'Pada halaman login, klik "Lupa Kata Sandi?". Ikuti instruksi untuk mengatur ulang kata sandi Anda melalui email terdaftar.',
      },
      {
        'question': 'Bagaimana cara menghubungi layanan pelanggan?',
        'answer':
            'Anda bisa menghubungi kami melalui email, telepon, atau live chat yang tersedia di bagian "Butuh Bantuan Lebih Lanjut?" di bawah ini.',
      },
      {
        'question': 'Apakah data saya aman di aplikasi ini?',
        'answer':
            'Kami sangat menjaga keamanan dan privasi data pengguna. Semua data dienkripsi dan dilindungi dengan standar keamanan tinggi.',
      },
    ];

    return Column(
      children:
          faqs.map((faq) {
            return Card(
              elevation:
                  4, // Meningkatkan elevasi card untuk efek bayangan yang lebih baik
              margin: const EdgeInsets.only(
                bottom: 16,
              ), // Margin bawah sedikit diperbesar
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  16,
                ), // Meningkatkan radius sudut card
                side: BorderSide(
                  color: _darkBlue.withOpacity(0.1),
                  width: 1,
                ), // Menambahkan border tipis
              ),
              child: ExpansionTile(
                collapsedShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                tilePadding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 12.0,
                ), // Padding tile lebih lega
                leading: const Icon(
                  Icons.help_outline,
                  color: _darkBlue, // Menggunakan warna _darkBlue
                  size: 28, // Ukuran ikon lebih besar
                ),
                title: Text(
                  faq['question']!,
                  style: const TextStyle(
                    fontWeight:
                        FontWeight.bold, // Membuat pertanyaan lebih tebal
                    fontSize: 18, // Ukuran font pertanyaan sedikit lebih besar
                    color: _darkBlue, // Menggunakan warna _darkBlue
                  ),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      20.0,
                      0,
                      20.0,
                      20.0,
                    ), // Padding konten jawaban
                    child: Text(
                      faq['answer']!,
                      style: const TextStyle(
                        fontSize: 15, // Ukuran font jawaban sedikit lebih besar
                        color: Colors.black87,
                        height:
                            1.6, // Menambah tinggi baris untuk keterbacaan yang optimal
                      ),
                    ),
                  ),
                ],
                iconColor: _darkBlue, // Menggunakan warna _darkBlue
                collapsedIconColor: _darkBlue, // Menggunakan warna _darkBlue
              ),
            );
          }).toList(),
    );
  }
}
