import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart'; // Import Ionicons for consistency
import 'package:loading_animation_widget/loading_animation_widget.dart'; // Import ini untuk LoadingAnimationWidget

import '../controllers/update_profile_controller.dart'; // Pastikan jalur ini benar

class UpdateProfileView extends GetView<UpdateProfileController> {
  const UpdateProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    // Determine if dark mode is active based on system brightness
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    // Define colors based on the theme mode, consistent with ProfileView
    final Color primaryColor =
        isDarkMode ? const Color(0xFF90CAF9) : const Color(0xFF0D47A1);
    final Color accentColor =
        isDarkMode ? const Color(0xFF64B5F6) : const Color(0xFF1976D2);
    final Color backgroundColor =
        isDarkMode ? const Color(0xFF121212) : const Color(0xFFE3F2FD);
    final Color surfaceColor =
        isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final Color textColor =
        isDarkMode ? const Color(0xFFE0E0E0) : const Color(0xFF222222);
    final Color hintColor =
        isDarkMode ? const Color(0xFFA0A0A0) : const Color(0xFF666666);
    final Color inputFillColor =
        isDarkMode ? const Color(0xFF2C2C2C) : Colors.grey[100]!;
    final Color iconColor =
        isDarkMode ? const Color(0xFFB0B0B0) : Colors.grey[600]!;

    return Obx(
      () => Stack(
        // Menggunakan Stack untuk menempatkan overlay di atas Scaffold
        children: [
          Scaffold(
            backgroundColor: backgroundColor, // Use dynamic background color
            appBar: AppBar(
              title: Text(
                'Edit Profil',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color:
                      isDarkMode
                          ? Colors.white
                          : Colors.black87, // Adapt app bar title color
                ),
              ),
              centerTitle: true,
              backgroundColor:
                  backgroundColor, // Use dynamic background color for app bar
              elevation: 0,
              iconTheme: IconThemeData(
                color:
                    isDarkMode
                        ? Colors.white
                        : Colors.black87, // Adapt app bar icon color
              ),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: surfaceColor.withOpacity(
                            0.95,
                          ), // Adapt to surface color
                          // Mengganti URL placeholder gambar
                          backgroundImage: const NetworkImage(
                            'https://placehold.co/150x150/0000FF/FFFFFF?text=User', // Menggunakan placehold.co
                          ),
                          child: Icon(
                            Ionicons
                                .person_outline, // Use Ionicons for consistency
                            size: 60,
                            color: primaryColor.withOpacity(
                              0.8,
                            ), // Adapt to primary color
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor: primaryColor, // Use primary color
                            child: IconButton(
                              icon: const Icon(
                                Ionicons.camera, // Use Ionicons for consistency
                                color:
                                    Colors
                                        .white, // Camera icon remains white for contrast
                                size: 18,
                              ),
                              onPressed: () {
                                Get.snackbar(
                                  'Fitur Belum Tersedia',
                                  'Fungsi ubah gambar profil akan segera hadir!',
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor:
                                      accentColor, // Use accent color for snackbar
                                  colorText:
                                      isDarkMode
                                          ? Colors.black87
                                          : Colors
                                              .white, // Text color on accent
                                  duration: const Duration(seconds: 2),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32.0),

                  // Ini adalah bagian di mana nama akan muncul secara otomatis
                  _buildInputField(
                    label: 'Nama Lengkap',
                    hintText: 'Masukkan nama lengkap Anda',
                    controller:
                        controller
                            .nameController, // <-- Terhubung dengan nameController
                    icon: Ionicons.person_outline, // Use Ionicons
                    primaryColor:
                        primaryColor, // Pass the dynamic primary color
                    textColor: textColor,
                    hintColor: hintColor,
                    inputFillColor: inputFillColor,
                    iconColor: iconColor,
                  ),
                  const SizedBox(height: 16.0),

                  // Ini adalah bagian di mana email akan muncul secara otomatis
                  _buildInputField(
                    label: 'Email',
                    hintText: 'Masukkan alamat email Anda',
                    controller:
                        controller
                            .emailController, // <-- Terhubung dengan emailController
                    icon: Ionicons.mail_outline, // Use Ionicons
                    keyboardType: TextInputType.emailAddress,
                    primaryColor:
                        primaryColor, // Pass the dynamic primary color
                    textColor: textColor,
                    hintColor: hintColor,
                    inputFillColor: inputFillColor,
                    iconColor: iconColor,
                  ),
                  const SizedBox(height: 24.0),

                  Text(
                    'Ubah Kata Sandi (Opsional)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: sectionTitleColor(
                        isDarkMode,
                      ), // Use consistent section title color logic
                    ),
                  ),
                  const SizedBox(height: 16.0),

                  PasswordFieldWidget(
                    label: 'Kata Sandi Lama',
                    hintText: 'Masukkan kata sandi lama Anda',
                    controller: controller.oldPasswordController,
                    primaryColor:
                        primaryColor, // Pass the dynamic primary color
                    textColor: textColor,
                    hintColor: hintColor,
                    inputFillColor: inputFillColor,
                    iconColor: iconColor,
                  ),
                  const SizedBox(height: 16.0),

                  PasswordFieldWidget(
                    label: 'Kata Sandi Baru',
                    hintText: 'Masukkan kata sandi baru Anda',
                    controller: controller.newPasswordController,
                    primaryColor:
                        primaryColor, // Pass the dynamic primary color
                    textColor: textColor,
                    hintColor: hintColor,
                    inputFillColor: inputFillColor,
                    iconColor: iconColor,
                  ),
                  const SizedBox(height: 16.0),

                  PasswordFieldWidget(
                    label: 'Konfirmasi Kata Sandi Baru',
                    hintText: 'Ketik ulang kata sandi baru Anda',
                    controller: controller.confirmPasswordController,
                    primaryColor:
                        primaryColor, // Pass the dynamic primary color
                    textColor: textColor,
                    hintColor: hintColor,
                    inputFillColor: inputFillColor,
                    iconColor: iconColor,
                  ),
                  const SizedBox(height: 32.0),

                  Obx(
                    () => ElevatedButton(
                      onPressed:
                          controller.isLoading.value
                              ? null
                              : () {
                                controller.updateProfile();
                              },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            primaryColor, // Use dynamic primary color for button
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        elevation: 3,
                      ),
                      child:
                          controller.isLoading.value
                              ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                              : const Text(
                                'Simpan Perubahan',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Colors
                                          .white, // Button text remains white for contrast
                                ),
                              ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                ],
              ),
            ),
          ),
          // <--- Perubahan di sini: Menggunakan LoadingAnimationWidget.threeArchedCircle --->
          if (controller.isLoadingOverlay.value)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(
                  0.5,
                ), // Latar belakang transparan
                child: Center(
                  child: LoadingAnimationWidget.threeArchedCircle(
                    // Mengubah jenis animasi loading
                    color:
                        primaryColor, // Warna animasi, gunakan primaryColor Anda
                    size: 50,
                  ),
                ),
              ),
            ),
          // <--- Akhir Perubahan --->
        ],
      ),
    );
  }

  // Helper function for section title color, consistent with ProfileView
  Color sectionTitleColor(bool isDarkMode) {
    return isDarkMode ? const Color(0xFFB0B0B0) : const Color(0xFF222222);
  }

  Widget _buildInputField({
    required String label,
    required String hintText,
    required TextEditingController controller,
    IconData? icon,
    TextInputType keyboardType = TextInputType.text,
    required Color primaryColor, // Use primaryColor for active state
    required Color textColor,
    required Color hintColor,
    required Color inputFillColor,
    required Color iconColor,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: TextStyle(color: textColor), // Apply text color to input
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: hintColor), // Label color
        hintText: hintText,
        hintStyle: TextStyle(
          color: hintColor.withOpacity(0.7),
        ), // Hint text color
        prefixIcon:
            icon != null
                ? Icon(icon, color: iconColor)
                : null, // Use dynamic icon color
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: inputFillColor, // Use dynamic fill color
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 20.0,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(
            color: primaryColor, // Use primary color for focused border
            width: 2.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class PasswordFieldWidget extends StatefulWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final Color primaryColor; // Use primaryColor for active state
  final Color textColor;
  final Color hintColor;
  final Color inputFillColor;
  final Color iconColor;

  const PasswordFieldWidget({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    required this.primaryColor, // Initialize primaryColor
    required this.textColor,
    required this.hintColor,
    required this.inputFillColor,
    required this.iconColor,
  });

  @override
  State<PasswordFieldWidget> createState() => _PasswordFieldWidgetState();
}

class _PasswordFieldWidgetState extends State<PasswordFieldWidget> {
  bool _isPasswordHidden = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _isPasswordHidden,
      style: TextStyle(color: widget.textColor), // Apply text color to input
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: TextStyle(color: widget.hintColor), // Label color
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: widget.hintColor.withOpacity(0.7),
        ), // Hint text color
        prefixIcon: Icon(
          Ionicons.lock_closed_outline, // Use Ionicons
          color: widget.iconColor,
        ), // Use dynamic icon color
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordHidden
                ? Ionicons.eye_outline
                : Ionicons.eye_off_outline, // Use Ionicons
            color: widget.iconColor, // Use dynamic icon color
          ),
          onPressed: () {
            setState(() {
              _isPasswordHidden = !_isPasswordHidden;
            });
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: widget.inputFillColor, // Use dynamic fill color
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 20.0,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(
            color: widget.primaryColor, // Use primary color for focused border
            width: 2.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
