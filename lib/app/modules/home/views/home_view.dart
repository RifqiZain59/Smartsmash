import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:smartsmashapp/app/modules/Acara/views/acara_view.dart';
import 'package:smartsmashapp/app/modules/Gerakan/views/gerakan_view.dart';
import 'package:smartsmashapp/app/modules/Juara/views/juara_view.dart';
import 'package:smartsmashapp/app/modules/berita/views/berita_view.dart';
import 'package:marquee/marquee.dart'; // <--- NEW: Import the marquee package
import '../controllers/home_controller.dart';
import 'dart:convert'; // Pastikan ini ada!
import 'package:smartsmashapp/app/modules/profile/views/profile_view.dart'; // Import ProfileView
import 'package:smartsmashapp/app/modules/hapus_data/views/hapus_data_view.dart'; // NEW: Import HapusDataView

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Define colors explicitly for light mode
    final Color primaryColor = const Color(
      0xFF007BFF,
    ); // Blue (remains constant)
    final Color backgroundColor = const Color(0xFFF8F9FA); // Light grey
    final Color surfaceColor = Colors.white; // White for cards/containers
    final Color textColor = Colors.black87; // Dark for general text
    final Color hintTextColor = const Color(0xFF6C757D); // Muted grey
    final Color accentColor = const Color(0xFF6C757D); // Darker grey for light
    final Color shadowColor = Colors.grey.withOpacity(0.1); // Lighter shadow
    final Color avatarPlaceholderColor =
        Colors.grey[200]!; // Lighter avatar placeholder

    return Obx(() {
      final selectedIndex = controller.selectedIndex.value;
      final greetingData = controller.greetingByTime();
      final String greetingText = greetingData['text'];
      final IconData greetingIcon = greetingData['icon'];

      return Scaffold(
        backgroundColor: backgroundColor,
        body: IndexedStack(
          index: selectedIndex,
          children: [
            SafeArea(
              bottom: false,
              child: RefreshIndicator(
                onRefresh: () async {
                  await controller
                      .fetchPelatih(); // Panggil fungsi refresh data pelatih
                },
                color: primaryColor, // Warna indikator refresh
                child: SingleChildScrollView(
                  physics:
                      const AlwaysScrollableScrollPhysics(), // Penting agar bisa di-scroll meskipun konten sedikit
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 90),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(
                        greetingIcon,
                        greetingText,
                        primaryColor,
                        textColor,
                        surfaceColor,
                        shadowColor,
                      ),
                      const SizedBox(height: 28),
                      // --- Marquee Section ---
                      _buildMotionMarquee(
                        textColor,
                      ), // <--- MODIFIED: Calling the new Marquee widget
                      // --- End Marquee Section ---
                      const SizedBox(height: 28),
                      _buildSpecialOffers(textColor),
                      const SizedBox(height: 28),
                      Text(
                        'Menu Apps',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildServices(
                        primaryColor,
                        surfaceColor,
                        textColor,
                        shadowColor,
                      ),
                      const SizedBox(height: 28),
                      Text(
                        'Daftar Pelatih', // Judul "Daftar Pelatih"
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Kotak pencarian dipindahkan ke sini
                      _buildSearchBox(
                        surfaceColor,
                        textColor,
                        hintTextColor,
                        accentColor,
                        shadowColor,
                      ),
                      const SizedBox(
                        height: 16,
                      ), // Spasi antara search box dan daftar pelatih
                      _buildPelatihSection(
                        primaryColor,
                        accentColor,
                        textColor,
                        surfaceColor,
                        shadowColor,
                        avatarPlaceholderColor,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SafeArea(child: controller.pages[1]),
            SafeArea(child: controller.pages[2]),
            SafeArea(child: controller.pages[3]),
            SafeArea(child: controller.pages[4]),
          ],
        ),
        bottomNavigationBar: _buildBottomNavigationBar(
          selectedIndex,
          primaryColor,
          accentColor,
          surfaceColor,
          shadowColor,
        ),
      );
    });
  }

  // --- NEW: Widget for Marquee Text ---
  // --- NEW: Widget for Marquee Text ---
  Widget _buildMotionMarquee(Color textColor) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF333366), // Changed background color to dark blue
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF333366), // Dark blue border color
          width: 2, // Border width
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const Icon(
            Ionicons.information_circle_outline, // Information icon
            color: Colors.white, // Changed icon color to white for contrast
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SizedBox(
              height: 20, // Adjust height as needed to fit the text
              child: Marquee(
                text:
                    'Ingin coba tenis meja? Atau sudah jago dan ingin tingkatkan skill? Klub kami terbuka untuk semua level! Pelatih profesional siap membimbing Anda. Rasakan keseruan bermain tenis meja bersama kami!', // The text that will scroll
                style: const TextStyle(
                  fontSize: 14, // Adjusted font size
                  fontWeight: FontWeight.bold,
                  color:
                      Colors.white, // Changed text color to white for contrast
                ),
                scrollAxis: Axis.horizontal, // Horizontal scrolling
                blankSpace: 20.0, // Space between repetitions of the text
                velocity: 30.0, // Reduced scrolling speed
                pauseAfterRound: const Duration(
                  seconds: 2,
                ), // Pause after each round
                startPadding: 0.0, // Initial padding before text starts
                accelerationDuration: const Duration(
                  seconds: 1,
                ), // Acceleration duration
                accelerationCurve: Curves.easeOut, // Acceleration curve
                decelerationDuration: const Duration(
                  milliseconds: 500,
                ), // Deceleration duration
                decelerationCurve: Curves.easeIn, // Deceleration curve
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- END NEW Widget for Marquee Text ---
  Widget _buildHeader(
    IconData greetingIcon,
    String greetingText,
    Color primaryColor,
    Color textColor,
    Color surfaceColor,
    Color shadowColor,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(greetingIcon, size: 28, color: primaryColor),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  greetingText,
                  style: TextStyle(
                    fontSize: 16,
                    color: textColor.withOpacity(0.7),
                  ),
                ),
                Obx(
                  () => Text(
                    controller.namaUser.value,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        GestureDetector(
          // Added GestureDetector for onTap
          onTap: () {
            // Mengubah navigasi ke HapusDataView()
            Get.to(() => HapusDataView());
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: surfaceColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: shadowColor,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              Ionicons.settings_outline,
              color: textColor.withOpacity(0.8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBox(
    Color surfaceColor,
    Color textColor,
    Color hintColor,
    Color iconColor,
    Color shadowColor,
  ) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Ionicons.search_outline, color: iconColor),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller:
                  controller
                      .searchInputController, // Link to controller's TextEditingController
              decoration: InputDecoration(
                hintText: 'Cari pelatih...', // Mengubah hint text
                hintStyle: TextStyle(color: hintColor),
                border: InputBorder.none,
                isCollapsed: true,
              ),
              style: TextStyle(color: textColor),
              // onChanged tidak perlu lagi karena listener sudah ditambahkan di controller's onInit
            ),
          ),
          // Icon(Ionicons.options_outline, color: iconColor), // Filter icon removed
        ],
      ),
    );
  }

  Widget _buildSpecialOffers(Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Penawaran Spesial',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        const SizedBox(height: 16),
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(
            'assets/Banner/Banner.jpg',
            width: double.infinity,
            height: 160,
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }

  Widget _buildServices(
    Color primaryColor,
    Color surfaceColor,
    Color textColor,
    Color shadowColor,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: GridView.count(
        crossAxisCount: 4,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: [
          ServiceIcon(
            label: 'Gerakan',
            icon: Ionicons.body_outline,
            iconColor: primaryColor,
            textColor: textColor,
            onTap: () => Get.to(() => GerakanView()),
          ),
          ServiceIcon(
            label: 'Juara',
            icon: Ionicons.trophy_outline,
            iconColor: primaryColor,
            textColor: textColor,
            onTap: () => Get.to(() => JuaraView()),
          ),
          ServiceIcon(
            label: 'Acara',
            icon: Ionicons.calendar_outline,
            iconColor: primaryColor,
            textColor: textColor,
            onTap: () => Get.to(() => AcaraView()),
          ),
          ServiceIcon(
            label: 'Berita',
            icon: Ionicons.newspaper_outline,
            iconColor: primaryColor,
            textColor: textColor,
            onTap: () => Get.to(() => BeritaView()),
          ),
        ],
      ),
    );
  }

  Widget _buildPelatihSection(
    Color primaryColor,
    Color accentColor,
    Color textColor,
    Color surfaceColor,
    Color shadowColor,
    Color avatarPlaceholderColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          if (controller.isLoadingPelatih.value) {
            return Center(
              child: CircularProgressIndicator(color: primaryColor),
            );
          } else if (controller.errorMessagePelatih.isNotEmpty) {
            return Center(
              child: Text(
                controller.errorMessagePelatih.value,
                style: TextStyle(
                  color: Colors.red[700],
                  fontSize: 16,
                ), // Gaya error
                textAlign: TextAlign.center,
              ),
            );
          } else if (controller.filteredPelatihList.isEmpty) {
            // Menggunakan filteredPelatihList di sini
            return Center(
              child: Text(
                'Tidak ada pelatih yang cocok dengan pencarian Anda.',
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                textAlign: TextAlign.center,
              ),
            );
          } else {
            return Column(
              children:
                  controller.filteredPelatihList.map((pelatih) {
                    // Menggunakan filteredPelatihList
                    final String nama =
                        pelatih['nama'] ?? 'Nama Tidak Diketahui';
                    final String gambar = pelatih['gambar'] ?? '';
                    final String alamat =
                        pelatih['alamat'] ?? 'Alamat Tidak Diketahui';

                    return ServiceCard(
                      name: nama,
                      image: gambar, // Pass the image string (Base64 or URL)
                      address: alamat,
                      primaryColor: primaryColor,
                      textColor: textColor,
                      surfaceColor: surfaceColor,
                      shadowColor: shadowColor,
                      avatarPlaceholderColor: avatarPlaceholderColor,
                    );
                  }).toList(),
            );
          }
        }),
      ],
    );
  }

  Widget _buildBottomNavigationBar(
    int selectedIndex,
    Color primaryColor,
    Color accentColor,
    Color surfaceColor,
    Color shadowColor,
  ) {
    return Container(
      child: SafeArea(
        minimum: const EdgeInsets.only(bottom: 0),
        child: Container(
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            boxShadow: [
              BoxShadow(
                color: shadowColor,
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(controller.navItems.length, (index) {
                final item = controller.navItems[index];
                final isSelected = selectedIndex == index;

                return GestureDetector(
                  onTap: () => controller.changePage(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    padding: EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: isSelected ? 16 : 0,
                    ),
                    decoration:
                        isSelected
                            ? BoxDecoration(
                              color: primaryColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(30),
                            )
                            : null,
                    child: Row(
                      children: [
                        Icon(
                          item['icon'],
                          color: isSelected ? primaryColor : accentColor,
                        ),
                        if (isSelected) ...[
                          const SizedBox(width: 8),
                          Text(
                            item['label'],
                            style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class ServiceIcon extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;
  final Color? iconColor;
  final Color? textColor;

  const ServiceIcon({
    Key? key,
    required this.label,
    required this.icon,
    this.onTap,
    this.iconColor,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: iconColor ?? Colors.blueAccent, size: 28),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: textColor),
          ),
        ],
      ),
    );
  }
}

class FilterChipWidget extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final Color primaryColor;
  final Color textColor;
  final Color chipUnselectedBgColor;
  final Color chipUnselectedBorderColor;

  const FilterChipWidget({
    Key? key,
    required this.label,
    this.selected = false,
    this.onTap,
    required this.primaryColor,
    required this.textColor,
    required this.chipUnselectedBgColor,
    required this.chipUnselectedBorderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Chip(
        label: Text(label),
        backgroundColor: selected ? primaryColor : chipUnselectedBgColor,
        labelStyle: TextStyle(color: selected ? Colors.white : textColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: selected ? primaryColor : chipUnselectedBorderColor,
            width: 1,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final String name;
  final String address;
  final String image; // Ini sekarang bisa berupa Base64 atau URL
  final VoidCallback? onTap;
  final Color primaryColor;
  final Color textColor;
  final Color surfaceColor;
  final Color shadowColor;
  final Color avatarPlaceholderColor;

  const ServiceCard({
    Key? key,
    required this.name,
    required this.address,
    required this.image,
    this.onTap,
    required this.primaryColor,
    required this.textColor,
    required this.surfaceColor,
    required this.shadowColor,
    required this.avatarPlaceholderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ImageProvider imageProvider;
    // Tentukan apakah 'image' adalah Base64 atau URL biasa
    if (image.startsWith('data:image/') && image.contains(';base64,')) {
      // Ini adalah string Base64, dekode dan gunakan MemoryImage
      try {
        final String base64String = image.split(',')[1];
        imageProvider = MemoryImage(base64Decode(base64String));
      } catch (e) {
        debugPrint('Error decoding Base64 image for ServiceCard: $e');
        imageProvider = const AssetImage(
          'assets/placeholder_error.png',
        ); // Fallback error asset
      }
    } else if (image.isNotEmpty) {
      // Asumsi ini adalah URL jaringan jika bukan Base64 dan tidak kosong
      imageProvider = NetworkImage(image);
    } else {
      // Fallback placeholder jika string 'image' kosong
      imageProvider = const AssetImage(
        'assets/placeholder_user.png',
      ); // Fallback no-image asset
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(16),
          // FIX IS HERE: Removed 'box ' before 'boxShadow'
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 32,
              backgroundImage:
                  imageProvider, // Gunakan ImageProvider yang sudah ditentukan
              backgroundColor: avatarPlaceholderColor,
              onBackgroundImageError: (exception, stackTrace) {
                debugPrint('Failed to load image for ServiceCard: $exception');
              },
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name, // Nama pelatih
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    address, // Alamat
                    style: TextStyle(
                      color: textColor.withOpacity(0.6),
                      fontSize:
                          14, // Ukuran font alamat sedikit lebih besar dari sebelumnya
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
