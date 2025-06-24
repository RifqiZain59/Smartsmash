import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Keep if needed for other logic
import '../controllers/profile_controller.dart'; // Ensure path is correct

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());

    // Dark mode detection removed. All colors are now fixed for light theme.
    // final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    // Define colors for a fixed light theme
    final Color primaryColor = const Color(0xFF0D47A1); // Dark blue
    final Color accentColor = const Color(0xFF1976D2); // Medium blue
    final Color backgroundColor = const Color(0xFFE3F2FD); // Very light blue
    final Color surfaceColor = Colors.white; // White
    final Color textColor = const Color(0xFF222222); // Dark grey
    final Color sectionTitleColor = const Color(0xFF222222); // Dark grey
    final Color menuIconColor = const Color(
      0xFF1565C0,
    ); // Darker blue for menu icons
    final Color menuTileTextColor = const Color(0xFF333333); // Darker grey
    final Color shadowColor = Colors.black26; // Light shadow
    final Color dividerColor = const Color(0xFFD0D0D0); // Light grey divider
    final Color logoutButtonBgColor = Colors.white; // White
    final Color logoutButtonBorderColor = Colors.red.withOpacity(
      0.5,
    ); // Red with less opacity
    final Color logoutButtonShadowColor = Colors.red.withOpacity(
      0.2,
    ); // Red shadow
    final Color dialogBackgroundColor = Colors.white; // White
    final Color dialogTextColor = Colors.black87; // Black
    final Color dialogButtonColor = primaryColor; // Primary color

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Header Section
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    primaryColor,
                    accentColor,
                  ], // Fixed colors for gradient (light theme blues)
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: shadowColor, // Fixed shadow color
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
                        // Profile Avatar
                        CircleAvatar(
                          radius: 48,
                          backgroundColor: surfaceColor.withOpacity(
                            0.95,
                          ), // Fixed surface color
                          child: Icon(
                            Ionicons.person_outline,
                            size: 50,
                            color: primaryColor.withOpacity(
                              0.8,
                            ), // Fixed primary color
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
                                  color: shadowColor, // Fixed shadow color
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
            const SizedBox(height: 30), // Enlarged space after header
            // Account Section
            _sectionTitle('Akun', sectionTitleColor), // Fixed text color
            const SizedBox(height: 16),
            _menuBox(
              [
                _accountTile(
                  Ionicons.person_circle_outline, // New icon for Update Profile
                  'Update Profile', // New text
                  menuIconColor, // Fixed icon color
                  menuTileTextColor, // Fixed text color
                  onTap: () {
                    Get.toNamed(
                      '/update-profile',
                    ); // Navigate to update profile page
                  },
                ),
                _accountTile(
                  Ionicons.shield_outline,
                  'History Login',
                  menuIconColor, // Fixed icon color
                  menuTileTextColor, // Fixed text color
                  onTap: () {
                    controller.navigateToHistoryLogin();
                  },
                ),
              ],
              surfaceColor, // Fixed surface color
              shadowColor, // Fixed shadow color
            ),

            const SizedBox(height: 30),

            // Help Section
            _sectionTitle('Bantuan', sectionTitleColor), // Fixed text color
            const SizedBox(height: 16),
            _menuBox(
              [
                _accountTile(
                  Ionicons.help_circle_outline,
                  'Pusat Bantuan',
                  menuIconColor, // Fixed icon color
                  menuTileTextColor, // Fixed text color
                  onTap: () {
                    // CALL THE NEW METHOD FROM THE CONTROLLER HERE
                    controller.navigateToPusatBantuan();
                  },
                ),
                _accountTile(
                  Ionicons.chatbubble_ellipses_outline,
                  'Chat dengan Kami',
                  menuIconColor, // Fixed icon color
                  menuTileTextColor, // Fixed text color
                  onTap: () {
                    controller.navigateToChatdengankami();
                    // Handle tap for Chat dengan Kami
                  },
                ),
                _accountTile(
                  Ionicons.document_text_outline,
                  'Syarat & Ketentuan',
                  menuIconColor, // Fixed icon color
                  menuTileTextColor, // Fixed text color
                  isLast: true,
                  onTap: () {
                    // Call method from controller
                    controller.navigateToTermsAndConditions();
                  },
                ),
              ],
              surfaceColor, // Fixed surface color
              shadowColor, // Fixed shadow color
            ),

            const SizedBox(height: 30),

            // Logout Button
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
                          dialogBackgroundColor, // Fixed dialog background
                      title: Text(
                        "Keluar",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: dialogTextColor, // Fixed dialog text color
                        ),
                      ),
                      content: Text(
                        "Apakah Anda yakin ingin keluar?",
                        style: TextStyle(
                          fontSize: 15,
                          color: dialogTextColor, // Fixed dialog text color
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Get.back(result: false),
                          child: Text(
                            "Batal",
                            style: TextStyle(
                              color: dialogButtonColor, // Fixed button color
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
                    // Call logout method from controller
                    controller.logout();
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: logoutButtonBgColor, // Fixed background color
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: logoutButtonBorderColor,
                    ), // Fixed border color
                    boxShadow: [
                      BoxShadow(
                        color: logoutButtonShadowColor, // Fixed shadow color
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

  // --- Helper Widgets ---

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
            color: textColor, // Use fixed text color
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
        color: bgColor, // Use fixed background color
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: shadowColor, // Use fixed shadow color
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
    Color iconColor, // Accept fixed icon color
    Color textColor, {
    // Accept fixed text color
    String? badge,
    bool isLast = false,
    VoidCallback? onTap, // Add onTap callback
  }) {
    return Column(
      children: [
        ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1), // Fixed icon container color
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 24,
            ), // Use fixed icon color
          ),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: textColor, // Use fixed text color
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
                    color: Colors.amber[100], // Badge color can remain constant
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    badge,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color:
                          Colors
                              .amber[800], // Badge text color can remain constant
                    ),
                  ),
                ),
              const SizedBox(width: 8),
              const Icon(
                Ionicons.chevron_forward_outline,
                size: 18,
                color: Colors.grey, // Chevron color can remain constant
              ),
            ],
          ),
          onTap: onTap, // Assign onTap callback
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 0,
          ), // Adjust padding for ListTile
        ),
      ],
    );
  }
}
