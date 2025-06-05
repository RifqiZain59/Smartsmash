import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:smartsmashapp/app/modules/Acara/views/acara_view.dart';
import 'package:smartsmashapp/app/modules/Gerakan/views/gerakan_view.dart';
import 'package:smartsmashapp/app/modules/Juara/views/juara_view.dart';
import 'package:smartsmashapp/app/modules/berita/views/berita_view.dart';
import '../controllers/home_controller.dart'; // Pastikan path ini benar

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selectedIndex = controller.selectedIndex.value;
      // Dapatkan data sapaan dan ikon dari controller
      final greetingData = controller.greetingByTime();
      final String greetingText = greetingData['text'];
      final IconData greetingIcon = greetingData['icon'];

      return Scaffold(
        backgroundColor:
            Colors.white, // Latar belakang putih untuk seluruh halaman
        body:
            selectedIndex == 0
                ? SafeArea(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      20,
                      20,
                      20,
                      MediaQuery.of(context).padding.bottom +
                          20, // Padding bottom disesuaikan dengan tinggi bottom navigation bar
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                // Ikon waktu yang dinamis
                                Icon(
                                  greetingIcon,
                                  size: 24,
                                  color: Colors.blueAccent,
                                ),
                                const SizedBox(
                                  width: 8,
                                ), // Spasi antara ikon dan teks
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      greetingText, // Menggunakan teks sapaan dari controller
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    Obx(
                                      () => Text(
                                        controller
                                            .namaUser
                                            .value, // Akses namaUser yang reaktif
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const Icon(Ionicons.notifications_outline),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Search Box
                        Container(
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: const [
                              Icon(Ionicons.search_outline, color: Colors.grey),
                              SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: 'Search',
                                    border: InputBorder.none,
                                    isCollapsed:
                                        true, // Mengurangi padding internal TextField
                                  ),
                                ),
                              ),
                              Icon(
                                Ionicons.options_outline,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Special Offers
                        const Text(
                          'Special Offers',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),

                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            'assets/Banner/Banner.jpg',
                            width: double.infinity,
                            height: 160,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Services
                        const Text(
                          'Services',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),

                        GridView.count(
                          crossAxisCount: 4,
                          shrinkWrap: true,
                          physics:
                              const NeverScrollableScrollPhysics(), // Menonaktifkan scroll GridView
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          children: [
                            // Menggunakan ServiceIcon yang sudah diperbaiki dengan onTap
                            ServiceIcon(
                              label: 'Gerakan',
                              icon: Ionicons.body_outline,
                              onTap: () {
                                Get.to(
                                  () => GerakanView(),
                                ); // Navigasi ke GerakanPage
                              },
                            ),
                            ServiceIcon(
                              label: 'Juara',
                              icon: Ionicons.trophy_outline,
                              onTap: () {
                                Get.to(
                                  () => JuaraView(),
                                ); // Navigasi ke JuaraPage
                              },
                            ),
                            ServiceIcon(
                              label: 'Acara',
                              icon: Ionicons.calendar_outline,
                              onTap: () {
                                Get.to(
                                  () => AcaraView(),
                                ); // Navigasi ke AcaraPage
                              },
                            ),
                            ServiceIcon(
                              label: 'Berita',
                              icon: Ionicons.newspaper_outline,
                              onTap: () {
                                Get.to(
                                  () => BeritaView(),
                                ); // Navigasi ke CommunityPage
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Most Popular Services
                        const Text(
                          'Most Popular Services',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Filter Chips
                        Wrap(
                          spacing: 12,
                          children: const [
                            FilterChipWidget(label: 'All', selected: true),
                            FilterChipWidget(label: 'Cleaning'),
                            FilterChipWidget(label: 'Repairing'),
                            FilterChipWidget(label: 'Painting'),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Service Cards
                        const ServiceCard(
                          name: 'Kylee Danford',
                          service: 'House Cleaning',
                          price: 25,
                          rating: 4.8,
                          reviews: 2809,
                          image: 'assets/user1.png',
                        ),
                        const ServiceCard(
                          name: 'Alfonso Schuessler',
                          service: 'Floor Cleaning',
                          price: 20,
                          rating: 4.9,
                          reviews: 6102,
                          image: 'assets/user2.png',
                        ),
                        const ServiceCard(
                          name: 'Sanjuanita Ordanez',
                          service: 'Washing Clothes',
                          price: 22,
                          rating: 4.7,
                          reviews: 7038,
                          image: 'assets/user3.png',
                        ),
                        const ServiceCard(
                          name: 'Freda Varnes',
                          service: 'Bathroom Cleaning',
                          price: 24,
                          rating: 4.9,
                          reviews: 9125,
                          image: 'assets/user4.png',
                        ),
                      ],
                    ),
                  ),
                )
                : Container(
                  color: Colors.white,
                  child:
                      controller
                          .pages[selectedIndex], // Menampilkan halaman yang dipilih dari controller
                ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, -2),
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
                              color: Colors.blueAccent.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(30),
                            )
                            : null,
                    child: Row(
                      children: [
                        Icon(
                          item['icon'],
                          color:
                              isSelected ? Colors.blueAccent : Colors.black54,
                        ),
                        if (isSelected) ...[
                          const SizedBox(width: 8),
                          Text(
                            item['label'],
                            style: const TextStyle(
                              color: Colors.blueAccent,
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
      );
    });
  }
}

// =========================================
// Definisi Widget Pembantu (jika berada dalam file yang sama)
// =========================================

class ServiceIcon extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onTap; // Tambahkan properti onTap opsional
  final Color? iconColor; // Tambahkan properti untuk warna ikon kustom
  final Color?
  backgroundColor; // Tambahkan properti untuk warna latar belakang kustom

  const ServiceIcon({
    super.key,
    required this.label,
    required this.icon,
    this.onTap, // Masukkan ke konstruktor
    this.iconColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Bungkus dengan GestureDetector
      onTap: onTap, // Gunakan properti onTap
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color:
                  backgroundColor ??
                  Colors.grey[100], // Gunakan warna kustom atau default
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor ?? Colors.blueAccent,
            ), // Gunakan warna kustom atau default
          ),
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

class FilterChipWidget extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap; // Tambahkan onTap untuk filter chip

  const FilterChipWidget({
    super.key,
    required this.label,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Chip(
        label: Text(label),
        backgroundColor: selected ? Colors.blueAccent : Colors.grey[200],
        labelStyle: TextStyle(color: selected ? Colors.white : Colors.black),
        side:
            selected
                ? const BorderSide(color: Colors.blueAccent)
                : BorderSide.none, // Tambahkan border jika dipilih
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
  final VoidCallback? onTap; // Tambahkan onTap untuk ServiceCard

  const ServiceCard({
    super.key,
    required this.name,
    required this.service,
    required this.price,
    required this.rating,
    required this.reviews,
    required this.image,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Bungkus dengan GestureDetector
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(radius: 30, backgroundImage: AssetImage(image)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    '\$$price',
                    style: const TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        size: 14,
                        color: Colors.blueAccent,
                      ),
                      const SizedBox(width: 4),
                      Text('$rating • $reviews reviews'),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Ionicons.bookmark_outline),
          ],
        ),
      ),
    );
  }
}
