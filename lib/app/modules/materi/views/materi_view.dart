import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui'; // Untuk ImageFilter (blur)

import '../controllers/materi_controller.dart';
// import '../views/materi_detail_view.dart'; // <--- Uncomment ini jika Anda memiliki MateriDetailView dan ingin menavigasi ke sana

class MateriView extends GetView<MateriController> {
  const MateriView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(MateriController()); // Inisialisasi controller

    // Determine if dark mode is active based on system brightness
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    // Define dynamic color scheme
    final Color primaryColor =
        isDarkMode ? Colors.blue.shade300 : Colors.blue.shade700;
    final Color secondaryColor =
        isDarkMode ? Colors.blue.shade900 : Colors.blue.shade50;
    final Color accentColor =
        Colors.pink.shade400; // YouTube red/pink generally stays consistent
    final Color textColor =
        isDarkMode ? Colors.grey.shade100 : Colors.grey.shade800;
    final Color subtleTextColor =
        isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600;
    final Color backgroundColor =
        isDarkMode
            ? const Color(0xFF121212)
            : const Color(0xFFF0F4F8); // Dark background for dark mode
    final Color cardBackgroundColor =
        isDarkMode
            ? const Color(0xFF1E1E1E)
            : Colors.white; // Darker surface for dark mode
    final Color appBarColor =
        isDarkMode
            ? const Color(0xFF1F1F1F)
            : primaryColor; // Dark AppBar for dark mode
    final Color appBarContentColor =
        isDarkMode
            ? Colors.white
            : Colors.white; // White title/icons for both app bars (dark/light)
    final Color shadowColor =
        isDarkMode
            ? Colors.black.withOpacity(0.5)
            : Colors.grey.withOpacity(0.1);
    final Color cardShadowColor =
        isDarkMode
            ? Colors.black.withOpacity(0.4)
            : Colors.grey.withOpacity(0.06);
    final Color borderCardColor =
        isDarkMode
            ? Colors.grey.shade800.withOpacity(0.7)
            : Colors.grey.shade200.withOpacity(0.7);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          'Daftar Materi',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22, // Sedikit lebih besar
            color:
                appBarContentColor, // Mengubah warna teks judul menjadi putih
          ),
        ),
        centerTitle: true,
        backgroundColor:
            appBarColor, // Mengubah warna app bar menjadi primaryColor (biru)
        foregroundColor:
            appBarContentColor, // Mengubah warna ikon dan teks default di app bar menjadi putih
        elevation: 1.0, // Bayangan lebih halus
        shadowColor: shadowColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16), // Radius lebih besar
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 🔍 Search Box and Search Button
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 16.0,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: cardBackgroundColor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: shadowColor,
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: controller.searchTextInputController,
                        style: TextStyle(color: textColor, fontSize: 16),
                        decoration: InputDecoration(
                          hintText: "Cari materi favoritmu...",
                          hintStyle: TextStyle(
                            color: subtleTextColor.withOpacity(0.8),
                          ),
                          filled: false, // fillColor diatur oleh Container
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 20, // Sesuaikan padding horizontal
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide:
                                BorderSide
                                    .none, // Hapus border default, sudah ada shadow
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: primaryColor.withOpacity(0.5),
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      controller.searchQuery.value =
                          controller.searchTextInputController.text;
                      FocusScope.of(context).unfocus(); // Tutup keyboard
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      elevation: 2,
                      shadowColor: primaryColor.withOpacity(0.4),
                    ),
                    child: const Icon(Ionicons.search_outline, size: 24),
                  ),
                ],
              ),
            ),
            // 📦 List Content
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: primaryColor,
                      strokeWidth: 3,
                    ),
                  );
                } else if (controller.errorMessage.isNotEmpty) {
                  return _buildErrorState(
                    controller,
                    primaryColor,
                    cardBackgroundColor,
                    textColor,
                    isDarkMode, // Pass isDarkMode to error state
                  );
                } else if (controller.materiList.isEmpty) {
                  return _buildEmptyState(
                    subtleTextColor,
                    cardBackgroundColor,
                    isDarkMode,
                  );
                } else {
                  return RefreshIndicator(
                    onRefresh: () => controller.refreshMateri(),
                    color: primaryColor,
                    backgroundColor:
                        cardBackgroundColor, // Adapt refresh indicator background
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      itemCount: controller.materiList.length,
                      itemBuilder: (context, index) {
                        final materi = controller.materiList[index];
                        final String title =
                            materi['title'] as String? ??
                            'Judul Tidak Tersedia';
                        final String youtubeLink =
                            materi['youtube_link'] as String? ?? '';
                        final bool isYoutube = youtubeLink.isNotEmpty;

                        return _buildMateriCard(
                          context,
                          title,
                          youtubeLink,
                          isYoutube,
                          materi,
                          primaryColor,
                          secondaryColor,
                          accentColor,
                          textColor,
                          subtleTextColor,
                          cardBackgroundColor,
                          cardShadowColor,
                          borderCardColor,
                          isDarkMode, // Pass isDarkMode to materi card
                        );
                      },
                    ),
                  );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget untuk tampilan error
  Widget _buildErrorState(
    MateriController controller,
    Color primaryColor,
    Color cardBackgroundColor,
    Color textColor,
    bool isDarkMode, // Added isDarkMode
  ) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(20.0),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        decoration: BoxDecoration(
          color: cardBackgroundColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color:
                  isDarkMode
                      ? Colors.red.withOpacity(0.3)
                      : Colors.red.withOpacity(
                        0.1,
                      ), // Darker shadow in dark mode
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Ionicons.alert_circle_outline,
              size: 70,
              color:
                  isDarkMode
                      ? Colors.red.shade300
                      : Colors.red.shade400, // Adapt icon color
            ),
            const SizedBox(height: 20),
            Text(
              "Oops! Terjadi Kesalahan",
              style: TextStyle(
                color:
                    isDarkMode
                        ? Colors.red.shade200
                        : Colors.red.shade700, // Adapt text color
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              controller.errorMessage.value,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isDarkMode ? Colors.red.shade300 : Colors.red.shade600,
                fontSize: 15,
              ), // Adapt text color
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Ionicons.refresh_outline, size: 20),
              label: const Text('Coba Lagi', style: TextStyle(fontSize: 16)),
              onPressed: () => controller.fetchMateri(),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget untuk tampilan kosong
  Widget _buildEmptyState(
    Color subtleTextColor,
    Color cardBackgroundColor,
    bool isDarkMode,
  ) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(20.0),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        decoration: BoxDecoration(
          color: cardBackgroundColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color:
                  isDarkMode
                      ? Colors.grey.withOpacity(0.2)
                      : Colors.grey.withOpacity(
                        0.08,
                      ), // Darker shadow in dark mode
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Ionicons.file_tray_outline,
              size: 70,
              color: subtleTextColor.withOpacity(0.7),
            ),
            const SizedBox(height: 20),
            Text(
              "Belum Ada Materi",
              style: TextStyle(
                color: subtleTextColor,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Coba cari kata kunci lain atau kembali lagi nanti.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: subtleTextColor.withOpacity(0.9),
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget untuk Card Materi
  Widget _buildMateriCard(
    BuildContext context,
    String title,
    String youtubeLink,
    bool isYoutube,
    Map<String, dynamic> materi,
    Color primaryColor,
    Color secondaryColor,
    Color accentColor,
    Color textColor,
    Color subtleTextColor,
    Color cardBackgroundColor,
    Color cardShadowColor, // Added dynamic shadow color
    Color borderCardColor, // Added dynamic border color
    bool isDarkMode, // Added isDarkMode
  ) {
    return Card(
      color: cardBackgroundColor,
      elevation: 0, // Bayangan dikelola oleh Container di bawah
      margin: const EdgeInsets.only(bottom: 18),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        borderRadius: BorderRadius.circular(18.0),
        onTap: () async {
          if (isYoutube) {
            final Uri url = Uri.parse(youtubeLink);
            if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
              Get.snackbar(
                'Error',
                'Tidak dapat membuka link YouTube. Pastikan aplikasi YouTube terinstal atau link valid.',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.red.shade600,
                colorText: Colors.white,
                borderRadius: 12,
                margin: const EdgeInsets.all(12),
                icon: const Icon(
                  Ionicons.warning_outline,
                  color: Colors.white,
                  size: 24,
                ),
                titleText: const Text(
                  "Gagal Membuka Link",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                messageText: const Text(
                  "Pastikan aplikasi YouTube terinstal atau link valid.",
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              );
            }
          } else {
            // Get.to(() => MateriDetailView(materi: materi));
            Get.snackbar(
              'Info',
              'Navigasi ke detail materi ini belum tersedia.',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: primaryColor.withOpacity(
                0.9,
              ), // Use dynamic primary color
              colorText: Colors.white,
              borderRadius: 12,
              margin: const EdgeInsets.all(12),
              icon: const Icon(
                Ionicons.information_circle_outline,
                color: Colors.white,
                size: 24,
              ),
              titleText: const Text(
                "Informasi",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              messageText: const Text(
                "Fitur detail untuk materi non-video sedang dalam pengembangan.",
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            );
          }
        },
        child: Container(
          // Tambahkan Container untuk bayangan dan border yang lebih baik
          decoration: BoxDecoration(
            color: cardBackgroundColor, // Use dynamic background color
            borderRadius: BorderRadius.circular(18.0),
            border: Border.all(
              color: borderCardColor, // Use dynamic border color
              width: 0.8,
            ),
            boxShadow: [
              BoxShadow(
                color: cardShadowColor, // Use dynamic shadow color
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Icon Section
                Container(
                  width: 75, // Sedikit lebih besar
                  height: 75,
                  decoration: BoxDecoration(
                    color:
                        isYoutube
                            ? accentColor.withOpacity(0.1)
                            : (isDarkMode
                                ? secondaryColor.withOpacity(0.2)
                                : secondaryColor), // Adapt secondary color for dark mode
                    borderRadius: BorderRadius.circular(
                      16,
                    ), // Radius lebih besar
                  ),
                  child: Icon(
                    isYoutube
                        ? Ionicons.logo_youtube
                        : Ionicons.document_text_outline,
                    color:
                        isYoutube
                            ? accentColor
                            : primaryColor, // Use dynamic primary color for document icon
                    size: 38, // Ukuran ikon tetap
                  ),
                ),
                const SizedBox(width: 18),
                // Text Section
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 17, // Sedikit lebih besar
                          color: textColor, // Use dynamic text color
                          height: 1.35, // Jarak antar baris
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            isYoutube
                                ? Ionicons.play_circle_outline
                                : Ionicons.reader_outline,
                            size: 17,
                            color:
                                isYoutube
                                    ? accentColor.withOpacity(0.8)
                                    : primaryColor.withOpacity(
                                      0.7,
                                    ), // Use dynamic primary color
                          ),
                          const SizedBox(width: 6),
                          Text(
                            isYoutube ? "Tonton Video" : "Baca Materi",
                            style: TextStyle(
                              fontSize: 13.5,
                              color:
                                  isYoutube
                                      ? accentColor.withOpacity(0.9)
                                      : primaryColor.withOpacity(
                                        0.8,
                                      ), // Use dynamic primary color
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Trailing Icon
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Icon(
                    Ionicons.chevron_forward_outline,
                    color: subtleTextColor.withOpacity(
                      0.6,
                    ), // Use dynamic subtle text color
                    size: 22,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
