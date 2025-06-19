import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Tetap diperlukan jika ada logika lain yang bergantung padanya, tapi tidak untuk logout langsung
import '../controllers/profile_controller.dart'; // Pastikan path ini benar

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());

    // Determine if dark mode is active based on system brightness
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    // Define colors based on the theme mode
    final Color primaryColor =
        isDarkMode
            ? const Color(0xFF90CAF9)
            : const Color(
              0xFF0D47A1,
            ); // Lighter blue for dark, dark blue for light
    final Color accentColor =
        isDarkMode
            ? const Color(0xFF64B5F6)
            : const Color(
              0xFF1976D2,
            ); // Medium blue for dark, medium blue for light
    final Color backgroundColor =
        isDarkMode
            ? const Color(0xFF121212)
            : const Color(
              0xFFE3F2FD,
            ); // Dark grey for dark, very light blue for light
    final Color surfaceColor =
        isDarkMode
            ? const Color(0xFF1E1E1E)
            : Colors.white; // Darker grey for dark, white for light
    final Color textColor =
        isDarkMode
            ? const Color(0xFFE0E0E0)
            : const Color(
              0xFF222222,
            ); // Light grey for dark, dark grey for light
    final Color sectionTitleColor =
        isDarkMode
            ? const Color(0xFFB0B0B0)
            : const Color(
              0xFF222222,
            ); // Slightly muted light grey for dark, dark grey for light
    final Color menuIconColor =
        isDarkMode
            ? primaryColor
            : const Color(
              0xFF1565C0,
            ); // Use primary color or dark blue for menu icons
    final Color menuTileTextColor =
        isDarkMode
            ? const Color(0xFFE0E0E0)
            : const Color(
              0xFF333333,
            ); // Light grey for dark, darker grey for light
    final Color shadowColor =
        isDarkMode
            ? Colors.black.withOpacity(0.5)
            : Colors.black26; // Darker shadow for dark mode
    final Color dividerColor =
        isDarkMode
            ? const Color(0xFF424242)
            : const Color(0xFFD0D0D0); // Darker divider for dark mode
    final Color logoutButtonBgColor =
        isDarkMode
            ? const Color(0xFF2C2C2C)
            : Colors.white; // Dark grey for dark, white for light
    final Color logoutButtonBorderColor =
        isDarkMode
            ? Colors.red.withOpacity(0.7)
            : Colors.red.withOpacity(0.5); // Red with more opacity for dark
    final Color logoutButtonShadowColor =
        isDarkMode
            ? Colors.red.withOpacity(0.3)
            : Colors.red.withOpacity(0.2); // Red shadow
    final Color dialogBackgroundColor =
        isDarkMode
            ? const Color(0xFF2C2C2C)
            : Colors.white; // Dark grey for dark, white for light
    final Color dialogTextColor =
        isDarkMode
            ? Colors.white
            : Colors.black87; // White for dark, black for light
    final Color dialogButtonColor =
        isDarkMode
            ? primaryColor
            : primaryColor; // Primary color for dialog buttons

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Bagian Header
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    primaryColor,
                    accentColor,
                  ], // Use dynamic colors for gradient
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: shadowColor, // Use dynamic shadow color
                    blurRadius: 12,
                    offset: const Offset(0, 6),
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
                          backgroundColor: surfaceColor.withOpacity(
                            0.95,
                          ), // Adapt to surface color
                          child: Icon(
                            Ionicons.person_outline,
                            size: 50,
                            color: primaryColor.withOpacity(
                              0.8,
                            ), // Adapt to primary color
                          ),
                        ),
                        const SizedBox(height: 16),
                        Obx(() {
                          return Text(
                            controller.userName.value,
                            style: TextStyle(
                              color:
                                  Colors
                                      .white, // Text on gradient is always white for contrast
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  blurRadius: 5.0,
                                  color: shadowColor, // Adapt shadow color
                                  offset: const Offset(0, 2),
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
                              ), // Text on gradient is always white for contrast
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
            _sectionTitle('Akun', sectionTitleColor),
            const SizedBox(height: 16),
            _menuBox(
              [
                _accountTile(
                  Ionicons
                      .person_circle_outline, // Ikon baru untuk Update Profile
                  'Update Profile', // Teks baru
                  menuIconColor, // Pass dynamic color
                  menuTileTextColor, // Pass dynamic color
                  onTap: () {
                    Get.toNamed(
                      '/update-profile',
                    ); // Navigasi ke halaman update profile
                  },
                ),
                _accountTile(
                  Ionicons.shield_outline,
                  'History Login',
                  menuIconColor, // Pass dynamic color
                  menuTileTextColor, // Pass dynamic color
                  onTap: () {
                    controller.navigateToHistoryLogin();
                  },
                ),
              ],
              surfaceColor, // Pass dynamic surface color
              shadowColor, // Pass dynamic shadow color
            ),

            const SizedBox(height: 30),

            // Bagian Bantuan
            _sectionTitle('Bantuan', sectionTitleColor),
            const SizedBox(height: 16),
            _menuBox(
              [
                _accountTile(
                  Ionicons.help_circle_outline,
                  'Pusat Bantuan',
                  menuIconColor, // Pass dynamic color
                  menuTileTextColor, // Pass dynamic color
                  onTap: () {
                    // CALL THE NEW METHOD FROM THE CONTROLLER HERE
                    controller.navigateToPusatBantuan();
                  },
                ),
                _accountTile(
                  Ionicons.chatbubble_ellipses_outline,
                  'Chat dengan Kami',
                  menuIconColor, // Pass dynamic color
                  menuTileTextColor, // Pass dynamic color
                  onTap: () {
                    controller.navigateToChatdengankami();
                    // Tangani ketukan untuk Chat dengan Kami
                  },
                ),
                _accountTile(
                  Ionicons.document_text_outline,
                  'Syarat & Ketentuan',
                  menuIconColor, // Pass dynamic color
                  menuTileTextColor, // Pass dynamic color
                  isLast: true,
                  onTap: () {
                    // Panggil metode dari controller
                    controller.navigateToTermsAndConditions();
                  },
                ),
              ],
              surfaceColor, // Pass dynamic surface color
              shadowColor, // Pass dynamic shadow color
            ),

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
                      backgroundColor:
                          dialogBackgroundColor, // Adapt dialog background
                      title: Text(
                        "Keluar",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: dialogTextColor,
                        ), // Adapt dialog text color
                      ),
                      content: Text(
                        "Apakah Anda yakin ingin keluar?",
                        style: TextStyle(
                          fontSize: 15,
                          color: dialogTextColor,
                        ), // Adapt dialog text color
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Get.back(result: false),
                          child: Text(
                            "Batal",
                            style: TextStyle(
                              color: dialogButtonColor, // Adapt button color
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => Get.back(result: true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.red, // Logout button remains red
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            "Ya",
                            style: TextStyle(
                              color: Colors.white,
                            ), // Text on red button is always white
                          ),
                        ),
                      ],
                    ),
                  );
                  if (confirm == true) {
                    // Panggil metode logout dari controller
                    controller.logout();
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: logoutButtonBgColor, // Adapt background color
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: logoutButtonBorderColor,
                    ), // Adapt border color
                    boxShadow: [
                      BoxShadow(
                        color: logoutButtonShadowColor, // Adapt shadow color
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
                        color: Colors.red, // Icon remains red
                        size: 24,
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Keluar",
                        style: TextStyle(
                          color: Colors.red, // Text remains red
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

  Widget _sectionTitle(String title, Color textColor) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 16, 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: textColor, // Use dynamic text color
          ),
        ),
      ),
    );
  }

  Widget _menuBox(List<Widget> children, Color bgColor, Color shadowColor) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: bgColor, // Use dynamic background color
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: shadowColor, // Use dynamic shadow color
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
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
    String title,
    Color iconColor, // Accept dynamic icon color
    Color textColor, {
    // Accept dynamic text color
    String? badge,
    bool isLast = false,
    VoidCallback? onTap, // Menambahkan callback onTap
  }) {
    return Column(
      children: [
        ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1), // Adapt icon container color
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 24,
            ), // Use dynamic icon color
          ),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: textColor, // Use dynamic text color
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
                    color:
                        Colors
                            .amber[100], // Badge color can remain constant or be adapted
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    badge,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color:
                          Colors
                              .amber[800], // Badge text color can remain constant or be adapted
                    ),
                  ),
                ),
              const SizedBox(width: 8),
              const Icon(
                Ionicons.chevron_forward_outline,
                size: 18,
                color:
                    Colors
                        .grey, // Chevron color can remain constant or be adapted
              ),
            ],
          ),
          onTap: onTap, // Tetapkan callback onTap
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 0,
          ), // Sesuaikan padding untuk ListTile
        ),
      ],
    );
  }
}
