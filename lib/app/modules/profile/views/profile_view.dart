import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/profile_controller.dart'; // Pastikan path ini benar

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());

    // Definisikan warna primer untuk branding yang konsisten
    const Color primaryColor = Color(0xFF0D47A1); // Biru sangat gelap
    const Color accentColor = Color(0xFF1976D2); // Biru medium untuk gradien
    const Color backgroundColor = Color(
      0xFFE3F2FD,
    ); // Biru sangat terang untuk latar belakang, agar kontras

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Bagian Header
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [primaryColor, accentColor],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color:
                        Colors.black26, // Sedikit lebih gelap dari sebelumnya
                    blurRadius: 12, // Sedikit lebih blur
                    offset: Offset(0, 6), // Bayangan sedikit lebih ke bawah
                  ),
                ],
              ),
              padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Center(
                    child: Column(
                      children: [
                        // Avatar Profil
                        CircleAvatar(
                          radius: 48,
                          backgroundColor: Colors.white.withOpacity(
                            0.95,
                          ), // Lebih solid
                          child: Icon(
                            Ionicons.person_outline,
                            size: 50,
                            color: primaryColor.withOpacity(
                              0.8,
                            ), // Menggunakan primaryColor
                          ),
                        ),
                        const SizedBox(height: 16),
                        Obx(() {
                          return Text(
                            controller.userName.value,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  blurRadius: 5.0, // Lebih blur
                                  color: Colors.black26, // Lebih gelap
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                          );
                        }),
                        const SizedBox(height: 4),
                        Obx(() {
                          return Text(
                            controller.userEmail.value,
                            style: TextStyle(
                              color: Colors.white.withOpacity(
                                0.9,
                              ), // Lebih terlihat
                              fontSize: 14,
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30), // Ruang yang diperbesar setelah header
            // Bagian Akun
            _sectionTitle('Akun'),
            const SizedBox(height: 16),
            _menuBox([
              _accountTile(
                Ionicons
                    .person_circle_outline, // Ikon baru untuk Update Profile
                'Update Profile', // Teks baru
                onTap: () {
                  Get.toNamed(
                    '/update-profile',
                  ); // Navigasi ke halaman update profile
                },
              ),
              _accountTile(
                Ionicons.shield_outline,
                'History Login',
                onTap: () {
                  controller.navigateToHistoryLogin();
                },
              ),
              _accountTile(
                Ionicons.location_outline,
                'Daftar Alamat',
                isLast: true,
                onTap: () {
                  // Tangani ketukan untuk Daftar Alamat
                },
              ),
            ]),

            const SizedBox(height: 30),

            // Bagian Bantuan
            _sectionTitle('Bantuan'),
            const SizedBox(height: 16),
            _menuBox([
              _accountTile(
                Ionicons.help_circle_outline,
                'Pusat Bantuan',
                onTap: () {
                  // CALL THE NEW METHOD FROM THE CONTROLLER HERE
                  controller.navigateToPusatBantuan();
                },
              ),
              _accountTile(
                Ionicons.chatbubble_ellipses_outline,
                'Chat dengan Kami',
                onTap: () {
                  controller.navigateToChatdengankami();
                  // Tangani ketukan untuk Chat dengan Kami
                },
              ),
              _accountTile(
                Ionicons.document_text_outline,
                'Syarat & Ketentuan',
                isLast: true,
                onTap: () {
                  // Panggil metode dari controller
                  controller.navigateToTermsAndConditions();
                },
              ),
            ]),

            const SizedBox(height: 30),

            // Tombol Keluar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: GestureDetector(
                onTap: () async {
                  final confirm = await Get.dialog<bool>(
                    AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      title: const Text(
                        "Keluar",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      content: const Text(
                        "Apakah Anda yakin ingin keluar?",
                        style: TextStyle(fontSize: 15),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Get.back(result: false),
                          child: const Text(
                            "Batal",
                            style: TextStyle(
                              color: primaryColor,
                            ), // Menggunakan primaryColor
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => Get.back(result: true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.red, // Gunakan merah untuk keluar
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            "Ya",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  );
                  if (confirm == true) {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.clear();
                    Get.offAllNamed('/login');
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.red.withOpacity(0.5)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Ionicons.log_out_outline,
                        color: Colors.red,
                        size: 24,
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Keluar",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // --- Widget Pembantu ---

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 16, 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Color(0xFF222222), // Teks lebih gelap untuk judul
          ),
        ),
      ),
    );
  }

  Widget _menuBox(List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: children,
      ),
    );
  }

  Widget _accountTile(
    IconData icon,
    String title, {
    String? badge,
    bool isLast = false,
    VoidCallback? onTap, // Menambahkan callback onTap
  }) {
    // Definisikan warna yang konsisten untuk ikon item menu
    const Color menuIconColor = Color(0xFF1565C0); // Biru gelap untuk ikon menu

    return Column(
      children: [
        ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: menuIconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: menuIconColor, size: 24),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: Color(0xFF333333), // Teks sedikit lebih gelap
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (badge != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.amber[100],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    badge,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber[800],
                    ),
                  ),
                ),
              const SizedBox(width: 8),
              const Icon(
                Ionicons.chevron_forward_outline,
                size: 18,
                color: Colors.grey,
              ),
            ],
          ),
          onTap: onTap, // Tetapkan callback onTap
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 0,
          ), // Sesuaikan padding untuk ListTile
        ),
        if (!isLast)
          const Divider(
            height: 1,
            indent: 60, // Indentasi pembatas agar sejajar dengan teks
            endIndent: 10,
            color: Color(0xFFD0D0D0), // Warna divider sedikit lebih gelap
          ),
      ],
    );
  }
}
