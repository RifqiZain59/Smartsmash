import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui'; // Untuk ImageFilter (blur)
import 'package:loading_animation_widget/loading_animation_widget.dart'; // <--- Tambahkan import ini

import '../controllers/materi_controller.dart';
// import '../views/materi_detail_view.dart'; // <--- Uncomment ini jika Anda memiliki MateriDetailView dan ingin menavigasi ke sana

class MateriView extends GetView<MateriController> {
  const MateriView({super.key});

  @override
  Widget build(BuildContext context) {
    // Inisialisasi controller jika belum terdaftar, atau temukan yang sudah ada
    // Jika Anda sudah mendaftarkannya di Binding, Anda bisa menghapus baris ini.
    Get.put(MateriController());

    // Removed isDarkMode detection.
    // Hardcoded colors to light theme values.
    final Color primaryColor = Colors.blue.shade700;
    final Color secondaryColor = Colors.blue.shade50;
    final Color accentColor =
        Colors.pink.shade400; // YouTube red/pink generally stays consistent
    final Color textColor = Colors.grey.shade800;
    final Color subtleTextColor = Colors.grey.shade600;
    final Color backgroundColor = const Color(
      0xFFF0F4F8,
    ); // Light background for light mode
    final Color cardBackgroundColor =
        Colors.white; // Light surface for light mode
    final Color appBarColor =
        primaryColor; // Standard blue AppBar for light mode
    final Color appBarContentColor =
        Colors.white; // White title/icons for app bar
    final Color shadowColor = Colors.grey.withOpacity(0.1);
    final Color cardShadowColor = Colors.grey.withOpacity(0.06);
    final Color borderCardColor = Colors.grey.shade200.withOpacity(0.7);

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
      body: Obx(
        () => Stack(
          // <--- Bungkus seluruh konten body dengan Stack
          children: [
            SafeArea(
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
                                filled:
                                    false, // fillColor diatur oleh Container
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                  horizontal:
                                      20, // Sesuaikan padding horizontal
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
                      // Obx ini untuk merespons isLoading, errorMessage, materiList
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
                          // Removed isDarkMode parameter
                        );
                      } else if (controller.materiList.isEmpty) {
                        return _buildEmptyState(
                          subtleTextColor,
                          cardBackgroundColor,
                          // Removed isDarkMode parameter
                        );
                      } else {
                        return RefreshIndicator(
                          onRefresh:
                              () =>
                                  controller
                                      .refreshMateri(), // Memanggil refreshMateri
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
                                // Removed isDarkMode parameter
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

            // <--- BARU: Loading Overlay Penuh Layar
            if (controller.isLoadingOverlay.value)
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 5.0,
                    sigmaY: 5.0,
                  ), // Efek blur
                  child: Container(
                    color: Colors.black.withOpacity(
                      0.5,
                    ), // Latar belakang gelap transparan
                    child: Center(
                      child: LoadingAnimationWidget.threeArchedCircle(
                        color: Colors.white,
                        size: 100,
                      ),
                    ),
                  ),
                ),
              ),
            // BARU: Loading Overlay Penuh Layar --->
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
    // Removed isDarkMode
  ) {
    // Hardcoded colors for light mode
    final Color errorShadowColor = Colors.red.withOpacity(0.1);
    final Color errorIconColor = Colors.red.shade400;
    final Color errorTitleColor = Colors.red.shade700;
    final Color errorMessageColor = Colors.red.shade600;

    return Center(
      child: Container(
        margin: const EdgeInsets.all(20.0),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        decoration: BoxDecoration(
          color: cardBackgroundColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: errorShadowColor, // Hardcoded shadow for light mode
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
              color: errorIconColor, // Hardcoded icon color for light mode
            ),
            const SizedBox(height: 20),
            Text(
              "Oops! Terjadi Kesalahan",
              style: TextStyle(
                color: errorTitleColor, // Hardcoded text color for light mode
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              controller.errorMessage.value,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: errorMessageColor, // Hardcoded text color for light mode
                fontSize: 15,
              ),
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
    // Removed isDarkMode
  ) {
    // Hardcoded colors for light mode
    final Color emptyShadowColor = Colors.grey.withOpacity(0.08);

    return Center(
      child: Container(
        margin: const EdgeInsets.all(20.0),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        decoration: BoxDecoration(
          color: cardBackgroundColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: emptyShadowColor, // Hardcoded shadow for light mode
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
    // Removed isDarkMode
  ) {
    // Hardcoded colors for light mode for the card's internal elements
    final Color cardIconBackgroundSecondary =
        secondaryColor; // Always use light secondary for background
    final Color cardDocumentIconColor =
        primaryColor; // Always use primary for document icon
    final Color cardPlayIconColor = accentColor.withOpacity(0.8);
    final Color cardPlayTextColor = accentColor.withOpacity(0.9);
    final Color cardReadIconColor = primaryColor.withOpacity(0.7);
    final Color cardReadTextColor = primaryColor.withOpacity(0.8);
    final Color cardChevronColor = subtleTextColor.withOpacity(0.6);

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
                            : cardIconBackgroundSecondary, // Hardcoded secondary color for light mode
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
                            : cardDocumentIconColor, // Hardcoded primary color for document icon
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
                                    ? cardPlayIconColor
                                    : cardReadIconColor, // Hardcoded colors
                          ),
                          const SizedBox(width: 6),
                          Text(
                            isYoutube ? "Tonton Video" : "Baca Materi",
                            style: TextStyle(
                              fontSize: 13.5,
                              color:
                                  isYoutube
                                      ? cardPlayTextColor
                                      : cardReadTextColor, // Hardcoded colors
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
                    color: cardChevronColor, // Hardcoded subtle text color
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
