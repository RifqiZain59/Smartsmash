import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/pusat_bantuan_controller.dart'; // Assuming this controller exists and is still needed
import 'package:ionicons/ionicons.dart'; // Import Ionicons jika digunakan untuk ikon lain

class PusatBantuanView extends GetView<PusatBantuanController> {
  const PusatBantuanView({super.key});

  @override
  Widget build(BuildContext context) {
    // Determine if dark mode is active based on system brightness
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    // Define colors based on the theme mode
    final Color _adaptiveBlue =
        isDarkMode
            ? const Color(0xFF90CAF9)
            : const Color(
              0xFF1A237E,
            ); // Lighter blue for dark, deep indigo for light
    final Color _scaffoldBackgroundColor =
        isDarkMode
            ? Colors.black
            : Colors.white; // Black background for dark mode, white for light
    final Color _headerTextColor =
        isDarkMode
            ? Colors.white
            : _adaptiveBlue; // White for dark, adaptive blue for light
    final Color _bodyTextColor =
        isDarkMode
            ? Colors.white70
            : Colors.black87; // Lighter text for dark mode, dark for light
    final Color _cardBackgroundColor =
        isDarkMode
            ? const Color(0xFF212121)
            : Colors.white; // Darker grey for cards in dark mode

    return Scaffold(
      backgroundColor:
          _scaffoldBackgroundColor, // Memastikan latar belakang Scaffold adaptif
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
                          icon: Icon(Icons.arrow_back),
                          color: _headerTextColor, // Warna ikon adaptif
                          iconSize: 28,
                          onPressed:
                              () =>
                                  Get.back(), // Fungsi untuk kembali ke halaman sebelumnya
                        ),
                        const SizedBox(
                          width: 16,
                        ), // Jarak antara ikon dan teks judul sedikit diperbesar
                        Text(
                          'Pusat Bantuan',
                          style: TextStyle(
                            fontSize:
                                24, // Ukuran font judul tetap besar untuk penekanan
                            fontWeight: FontWeight.bold,
                            color: _headerTextColor, // Warna judul adaptif
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
                          color:
                              _adaptiveBlue, // Menggunakan warna _adaptiveBlue
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ), // Jarak antara judul FAQ dan daftar FAQ
                      _buildFaqSection(
                        isDarkMode,
                        _adaptiveBlue,
                        _bodyTextColor,
                        _cardBackgroundColor,
                      ), // Pass theme specific colors
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
  Widget _buildFaqSection(
    bool isDarkMode,
    Color adaptiveBlue,
    Color bodyTextColor,
    Color cardBackgroundColor,
  ) {
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
                  color: adaptiveBlue.withOpacity(0.1),
                  width: 1,
                ), // Menambahkan border tipis
              ),
              color: cardBackgroundColor, // Card background adapts to theme
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
                leading: Icon(
                  Icons.help_outline,
                  color: adaptiveBlue, // Menggunakan warna _adaptiveBlue
                  size: 28, // Ukuran ikon lebih besar
                ),
                title: Text(
                  faq['question']!,
                  style: TextStyle(
                    fontWeight:
                        FontWeight.bold, // Membuat pertanyaan lebih tebal
                    fontSize: 18, // Ukuran font pertanyaan sedikit lebih besar
                    color: adaptiveBlue, // Menggunakan warna _adaptiveBlue
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
                      style: TextStyle(
                        fontSize: 15, // Ukuran font jawaban sedikit lebih besar
                        color: bodyTextColor, // Text color adapts to theme
                        height:
                            1.6, // Menambah tinggi baris untuk keterbacaan yang optimal
                      ),
                    ),
                  ),
                ],
                iconColor: adaptiveBlue, // Menggunakan warna _adaptiveBlue
                collapsedIconColor:
                    adaptiveBlue, // Menggunakan warna _adaptiveBlue
              ),
            );
          }).toList(),
    );
  }
}
