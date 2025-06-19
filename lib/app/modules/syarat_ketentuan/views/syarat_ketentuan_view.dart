import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Assuming GetX is still used for controller, though not strictly needed for UI

import '../controllers/syarat_ketentuan_controller.dart'; // Keep the import for consistency

class SyaratKetentuanView extends GetView<SyaratKetentuanController> {
  const SyaratKetentuanView({super.key});

  @override
  Widget build(BuildContext context) {
    // Determine if dark mode is active based on system brightness
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    // Define colors based on the theme mode
    final Color _darkBlue =
        isDarkMode
            ? const Color(0xFF90CAF9)
            : const Color(
              0xFF1A237E,
            ); // Lighter blue for dark, deep indigo for light
    final Color _appBarBackgroundColor =
        isDarkMode ? Colors.black : _darkBlue; // Black AppBar for dark mode
    final Color _appBarTextColor =
        isDarkMode
            ? Colors.white
            : Colors.white; // White text for AppBar in both modes
    final Color _scaffoldBackgroundColor =
        isDarkMode
            ? Colors.black
            : Colors.white; // Black background for dark mode, white for light
    final Color _bodyTextColor =
        isDarkMode
            ? Colors.white70
            : Colors.black87; // Lighter text for dark mode, dark for light
    final Color _footerTextColor =
        isDarkMode
            ? Colors.grey[400]!
            : Colors.grey[700]!; // Lighter grey for dark mode footer

    return Scaffold(
      backgroundColor:
          _scaffoldBackgroundColor, // Set Scaffold background based on theme
      appBar: AppBar(
        // Customize AppBar appearance
        title: Text(
          'Syarat & Ketentuan',
          style: TextStyle(
            color: _appBarTextColor, // Text color adapts to theme
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor:
            _appBarBackgroundColor, // AppBar background color adapts to theme
        elevation: 0, // Remove shadow for a flatter design
        iconTheme: IconThemeData(
          color: _appBarTextColor, // Back button color adapts to theme
        ),
      ),
      // Wrap the body content with SafeArea to prevent it from encroaching on system UI (e.g., notches, status bar)
      body: SafeArea(
        child: SingleChildScrollView(
          // Allows content to scroll if it overflows
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 25.0,
          ), // Adjusted padding
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Align text to the start (left)
            children: [
              // --- Introduction Section ---
              Text(
                'Selamat datang di aplikasi kami. Dengan menggunakan aplikasi ini, Anda setuju untuk mematuhi dan terikat oleh syarat dan ketentuan berikut:',
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5, // Line height for readability
                  color: _bodyTextColor, // Text color adapts to theme
                ),
              ),
              const SizedBox(
                height: 30,
              ), // Increased space between main sections
              // --- Section 1: Penggunaan Aplikasi ---
              _buildSectionTitle(
                '1. Penggunaan Aplikasi',
                _darkBlue,
              ), // Pass adaptive darkBlue to title
              const SizedBox(height: 10),
              _buildSectionContent(
                'Aplikasi ini disediakan untuk penggunaan pribadi dan non-komersial Anda. Anda tidak boleh menggunakan aplikasi ini untuk tujuan ilegal atau tidak sah.',
                _bodyTextColor,
              ), // Pass adaptive body text color
              const SizedBox(height: 10),
              _buildSectionContent(
                'Anda bertanggung jawab untuk menjaga kerahasiaan akun dan kata sandi Anda serta untuk semua aktivitas yang terjadi di bawah akun Anda.',
                _bodyTextColor,
              ), // Pass adaptive body text color
              const SizedBox(height: 30),

              // --- Section 2: Hak Kekayaan Intelektual ---
              _buildSectionTitle('2. Hak Kekayaan Intelektual', _darkBlue),
              const SizedBox(height: 10),
              _buildSectionContent(
                'Semua konten, merek dagang, logo, dan materi lain yang ditampilkan dalam aplikasi ini adalah milik kami atau pemberi lisensi kami dan dilindungi oleh undang-undang hak cipta dan merek dagang.',
                _bodyTextColor,
              ), // Pass adaptive body text color
              const SizedBox(height: 30),

              // --- Section 3: Batasan Tanggung Jawab ---
              _buildSectionTitle('3. Batasan Tanggung Jawab', _darkBlue),
              const SizedBox(height: 10),
              _buildSectionContent(
                'Kami tidak bertanggung jawab atas kerugian atau kerusakan apa pun yang timbul dari penggunaan atau ketidakmampuan untuk menggunakan aplikasi ini, termasuk namun tidak terbatas pada kerugian langsung, tidak langsung, insidental, atau konsekuensial.',
                _bodyTextColor,
              ), // Pass adaptive body text color
              const SizedBox(height: 30),

              // --- Section 4: Perubahan Syarat & Ketentuan ---
              _buildSectionTitle('4. Perubahan Syarat & Ketentuan', _darkBlue),
              const SizedBox(height: 10),
              _buildSectionContent(
                'Kami berhak untuk mengubah syarat dan ketentuan ini kapan saja. Perubahan akan berlaku segera setelah diposting di aplikasi. Penggunaan Anda yang berkelanjutan atas aplikasi ini setelah perubahan tersebut merupakan penerimaan Anda terhadap syarat dan ketentuan yang direvisi.',
                _bodyTextColor,
              ), // Pass adaptive body text color
              const SizedBox(height: 30),

              // --- Section 5: Hukum yang Berlaku ---
              _buildSectionTitle('5. Hukum yang Berlaku', _darkBlue),
              const SizedBox(height: 10),
              _buildSectionContent(
                'Syarat dan ketentuan ini diatur dan ditafsirkan sesuai dengan hukum yang berlaku di Indonesia.',
                _bodyTextColor,
              ), // Pass adaptive body text color
              const SizedBox(height: 30),

              // --- Section 6: Kontak Kami ---
              _buildSectionTitle('6. Kontak Kami', _darkBlue),
              const SizedBox(height: 10),
              _buildSectionContent(
                'Jika Anda memiliki pertanyaan tentang Syarat & Ketentuan ini, silakan hubungi kami melalui [alamat email/informasi kontak Anda].',
                _bodyTextColor,
              ), // Pass adaptive body text color
              const SizedBox(height: 40), // More space before the footer
              // --- Footer / Date ---
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Terakhir diperbarui: 29 Mei 2025',
                  style: TextStyle(
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                    color: _footerTextColor, // Footer text color adapts
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method for consistent section titles
  Widget _buildSectionTitle(String title, Color color) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 19, // Slightly larger for better hierarchy
        fontWeight: FontWeight.bold,
        color: color, // Use the passed-in adaptive color
      ),
    );
  }

  // Helper method for consistent section content
  Widget _buildSectionContent(String content, Color textColor) {
    return Text(
      content,
      textAlign: TextAlign.justify, // Justify text for a cleaner look
      style: TextStyle(
        fontSize: 16,
        height: 1.6, // Increased line height for better readability
        color: textColor, // Use the passed-in adaptive text color
      ),
    );
  }
}
