import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:smartsmashapp/app/modules/Acara/views/acara_view.dart';
import 'package:smartsmashapp/app/modules/Gerakan/views/gerakan_view.dart';
import 'package:smartsmashapp/app/modules/Juara/views/juara_view.dart';
import 'package:smartsmashapp/app/modules/berita/views/berita_view.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determine if dark mode is active based on system brightness
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    // Define colors based on the theme mode
    final Color primaryColor = const Color(
      0xFF007BFF,
    ); // Blue (remains constant)

    final Color backgroundColor =
        isDarkMode
            ? const Color(0xFF121212)
            : const Color(0xFFF8F9FA); // Dark or light grey
    final Color surfaceColor =
        isDarkMode
            ? const Color(0xFF1E1E1E)
            : Colors.white; // Dark or white for cards/containers
    final Color textColor =
        isDarkMode
            ? const Color(0xFFE0E0E0)
            : Colors.black87; // Light grey or dark for general text
    final Color hintTextColor =
        isDarkMode
            ? const Color(0xFF9E9E9E)
            : const Color(0xFF6C757D); // Muted grey
    final Color accentColor =
        isDarkMode
            ? const Color(0xFFADB5BD)
            : const Color(
              0xFF6C757D,
            ); // Lighter grey for dark, darker for light
    final Color shadowColor =
        isDarkMode
            ? Colors.black.withOpacity(0.3)
            : Colors.grey.withOpacity(0.1); // Darker or lighter shadow
    final Color avatarPlaceholderColor =
        isDarkMode
            ? Colors.grey[700]!
            : Colors.grey[200]!; // Darker or lighter avatar placeholder
    final Color chipUnselectedBgColor =
        isDarkMode
            ? Colors.grey[800]!
            : Colors.white; // Darker or white chip background
    final Color chipUnselectedBorderColor =
        isDarkMode
            ? Colors.grey.shade600
            : Colors.grey.shade300; // Darker or lighter chip border

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
              child: SingleChildScrollView(
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
                    _buildSearchBox(
                      surfaceColor,
                      textColor,
                      hintTextColor,
                      accentColor,
                      shadowColor,
                    ),
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
                    _buildPopularServices(
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
        Container(
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
              decoration: InputDecoration(
                hintText: 'Cari layanan atau berita...',
                hintStyle: TextStyle(color: hintColor),
                border: InputBorder.none,
                isCollapsed: true,
              ),
              style: TextStyle(color: textColor),
            ),
          ),
          Icon(Ionicons.options_outline, color: iconColor),
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

  Widget _buildPopularServices(
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
        Text(
          'Layanan Terpopuler',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        const SizedBox(height: 16),
        ServiceCard(
          name: 'Kylee Danford',
          service: 'Pembersihan Rumah',
          price: 25,
          rating: 4.8,
          reviews: 2809,
          image: 'assets/user1.png',
          primaryColor: primaryColor,
          accentColor: accentColor,
          textColor: textColor,
          surfaceColor: surfaceColor,
          shadowColor: shadowColor,
          avatarPlaceholderColor: avatarPlaceholderColor,
        ),
        ServiceCard(
          name: 'Alfonso Schuessler',
          service: 'Pembersihan Lantai',
          price: 20,
          rating: 4.9,
          reviews: 6102,
          image: 'assets/user2.png',
          primaryColor: primaryColor,
          accentColor: accentColor,
          textColor: textColor,
          surfaceColor: surfaceColor,
          shadowColor: shadowColor,
          avatarPlaceholderColor: avatarPlaceholderColor,
        ),
        ServiceCard(
          name: 'Sanjuanita Ordanez',
          service: 'Mencuci Pakaian',
          price: 22,
          rating: 4.7,
          reviews: 7038,
          image: 'assets/user3.png',
          primaryColor: primaryColor,
          accentColor: accentColor,
          textColor: textColor,
          surfaceColor: surfaceColor,
          shadowColor: shadowColor,
          avatarPlaceholderColor: avatarPlaceholderColor,
        ),
        ServiceCard(
          name: 'Freda Varnes',
          service: 'Pembersihan Kamar Mandi',
          price: 24,
          rating: 4.9,
          reviews: 9125,
          image: 'assets/user4.png',
          primaryColor: primaryColor,
          accentColor: accentColor,
          textColor: textColor,
          surfaceColor: surfaceColor,
          shadowColor: shadowColor,
          avatarPlaceholderColor: avatarPlaceholderColor,
        ),
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

// Widget FilterChipWidget ini tidak lagi digunakan, tapi saya biarkan di sini
// jika Anda mungkin memerlukannya lagi di masa depan.
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
  final String service;
  final double price;
  final double rating;
  final int reviews;
  final String image;
  final VoidCallback? onTap;
  final Color primaryColor;
  final Color accentColor;
  final Color textColor;
  final Color surfaceColor;
  final Color shadowColor;
  final Color avatarPlaceholderColor;

  const ServiceCard({
    Key? key,
    required this.name,
    required this.service,
    required this.price,
    required this.rating,
    required this.reviews,
    required this.image,
    this.onTap,
    required this.primaryColor,
    required this.accentColor,
    required this.textColor,
    required this.surfaceColor,
    required this.shadowColor,
    required this.avatarPlaceholderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(16),
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
              backgroundImage: AssetImage(image),
              backgroundColor: avatarPlaceholderColor,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Oleh $name',
                    style: TextStyle(
                      color: textColor.withOpacity(0.7),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Ionicons.star, size: 16, color: Colors.amber),
                      const SizedBox(width: 6),
                      Text(
                        '$rating ($reviews ulasan)',
                        style: TextStyle(
                          fontSize: 13,
                          color: textColor.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${price.toStringAsFixed(0)}',
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  '/jam',
                  style: TextStyle(
                    fontSize: 12,
                    color: textColor.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 8),
                Icon(Ionicons.bookmark_outline, color: accentColor),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
