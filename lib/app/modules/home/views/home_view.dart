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
    const Color primaryColor = Color(0xFF007BFF);
    const Color accentColor = Color(0xFF6C757D);
    const Color lightGrey = Color(0xFFF8F9FA);

    return Obx(() {
      final selectedIndex = controller.selectedIndex.value;
      final greetingData = controller.greetingByTime();
      final String greetingText = greetingData['text'];
      final IconData greetingIcon = greetingData['icon'];

      return Scaffold(
        backgroundColor: lightGrey,
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
                      accentColor,
                    ),
                    const SizedBox(height: 28),
                    _buildSearchBox(accentColor),
                    const SizedBox(height: 28),
                    _buildSpecialOffers(),
                    const SizedBox(height: 28),
                    const Text(
                      'Menu Apps',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildServices(primaryColor),
                    const SizedBox(height: 28),
                    _buildPopularServices(primaryColor, accentColor),
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
        ),
      );
    });
  }

  Widget _buildHeader(
    IconData greetingIcon,
    String greetingText,
    Color primaryColor,
    Color accentColor,
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
                  style: TextStyle(fontSize: 16, color: accentColor),
                ),
                Obx(
                  () => Text(
                    controller.namaUser.value,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
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
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Ionicons.settings_outline,
            color: Color(0xFF6C757D),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBox(Color accentColor) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Ionicons.search_outline, color: Color(0xFF6C757D)),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari layanan atau berita...',
                hintStyle: const TextStyle(color: Color(0xFF6C757D)),
                border: InputBorder.none,
                isCollapsed: true,
              ),
              style: const TextStyle(color: Colors.black87),
            ),
          ),
          const Icon(Ionicons.options_outline, color: Color(0xFF6C757D)),
        ],
      ),
    );
  }

  Widget _buildSpecialOffers() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Penawaran Spesial',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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

  Widget _buildServices(Color primaryColor) {
    // Ini adalah kotak putih yang membungkus GRID ikon layanan
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
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
            onTap: () => Get.to(() => GerakanView()),
          ),
          ServiceIcon(
            label: 'Juara',
            icon: Ionicons.trophy_outline,
            iconColor: primaryColor,
            onTap: () => Get.to(() => JuaraView()),
          ),
          ServiceIcon(
            label: 'Acara',
            icon: Ionicons.calendar_outline,
            iconColor: primaryColor,
            onTap: () => Get.to(() => AcaraView()),
          ),
          ServiceIcon(
            label: 'Berita',
            icon: Ionicons.newspaper_outline,
            iconColor: primaryColor,
            onTap: () => Get.to(() => BeritaView()),
          ),
        ],
      ),
    );
  }

  Widget _buildPopularServices(Color primaryColor, Color accentColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Layanan Terpopuler',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        // BAGIAN INI DIHAPUS:
        // Wrap(
        //   spacing: 12,
        //   children: [
        //     FilterChipWidget(
        //       label: 'Semua',
        //       selected: true,
        //       primaryColor: primaryColor,
        //     ),
        //     FilterChipWidget(label: 'Pembersihan', primaryColor: primaryColor),
        //     FilterChipWidget(label: 'Perbaikan', primaryColor: primaryColor),
        //     FilterChipWidget(label: 'Pengecatan', primaryColor: primaryColor),
        //   ],
        // ),
        // const SizedBox(height: 16), // SizedBox ini juga dihapus karena tidak ada lagi Wrap di atasnya
        ServiceCard(
          name: 'Kylee Danford',
          service: 'Pembersihan Rumah',
          price: 25,
          rating: 4.8,
          reviews: 2809,
          image: 'assets/user1.png',
          primaryColor: primaryColor,
          accentColor: accentColor,
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
        ),
      ],
    );
  }

  Widget _buildBottomNavigationBar(
    int selectedIndex,
    Color primaryColor,
    Color accentColor,
  ) {
    return Container(
      child: SafeArea(
        minimum: const EdgeInsets.only(bottom: 0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
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
                              color: primaryColor.withOpacity(0.1),
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

  const ServiceIcon({
    Key? key,
    required this.label,
    required this.icon,
    this.onTap,
    this.iconColor,
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
            style: const TextStyle(fontSize: 12),
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

  const FilterChipWidget({
    Key? key,
    required this.label,
    this.selected = false,
    this.onTap,
    required this.primaryColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Chip(
        label: Text(label),
        backgroundColor: selected ? primaryColor : Colors.white,
        labelStyle: TextStyle(color: selected ? Colors.white : Colors.black87),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: selected ? primaryColor : Colors.grey.shade300,
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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
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
              backgroundColor: Colors.grey[200],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Oleh $name',
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Ionicons.star, size: 16, color: Colors.amber),
                      const SizedBox(width: 6),
                      Text(
                        '$rating ($reviews ulasan)',
                        style: TextStyle(fontSize: 13, color: Colors.grey[700]),
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
                const Text(
                  '/jam',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
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
