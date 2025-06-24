import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart'; // Import Ionicons for consistency
import 'package:loading_animation_widget/loading_animation_widget.dart'; // Import ini untuk LoadingAnimationWidget

import '../controllers/update_profile_controller.dart'; // Pastikan jalur ini benar

class UpdateProfileView extends GetView<UpdateProfileController> {
  const UpdateProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    // Removed isDarkMode detection.
    // Hardcoded colors to light theme values, consistent with MateriView's "super bagus" aesthetic.
    final Color primaryColor = const Color(0xFF0D47A1); // Deep Blue
    final Color accentColor = const Color(0xFF1976D2); // Medium Blue
    final Color backgroundColor = Colors.white; // Changed to white
    final Color surfaceColor = Colors.white; // Pure White
    final Color textColor = const Color(0xFF222222); // Dark Grey
    final Color hintColor = const Color(0xFF666666); // Medium Grey
    final Color inputFillColor = Colors.grey[100]!; // Very Light Grey
    final Color iconColor = Colors.grey[600]!; // Medium Grey

    return Obx(
      () => Stack(
        // Menggunakan Stack untuk menempatkan overlay di atas Scaffold
        children: [
          Scaffold(
            backgroundColor:
                backgroundColor, // Use hardcoded light background color
            appBar: AppBar(
              title: Text(
                'Edit Profil',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color:
                      Colors
                          .black87, // Hardcoded app bar title color for light mode
                ),
              ),
              centerTitle: true,
              backgroundColor:
                  backgroundColor, // Use hardcoded background color for app bar
              elevation: 0,
              iconTheme: IconThemeData(
                color:
                    Colors
                        .black87, // Hardcoded app bar icon color for light mode
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
                          ), // Uses hardcoded surface color
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
                            ), // Uses hardcoded primary color
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor:
                                primaryColor, // Uses hardcoded primary color
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
                                      accentColor, // Uses hardcoded accent color for snackbar
                                  colorText:
                                      Colors
                                          .white, // Hardcoded text color on accent
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
                        primaryColor, // Pass the hardcoded primary color
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
                        primaryColor, // Pass the hardcoded primary color
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
                      color:
                          sectionTitleColor(), // Uses hardcoded section title color logic
                    ),
                  ),
                  const SizedBox(height: 16.0),

                  PasswordFieldWidget(
                    label: 'Kata Sandi Lama',
                    hintText: 'Masukkan kata sandi lama Anda',
                    controller: controller.oldPasswordController,
                    primaryColor:
                        primaryColor, // Pass the hardcoded primary color
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
                        primaryColor, // Pass the hardcoded primary color
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
                        primaryColor, // Pass the hardcoded primary color
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
                            primaryColor, // Uses hardcoded primary color for button
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
                        primaryColor, // Warna animasi, gunakan hardcoded primaryColor Anda
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

  // Helper function for section title color, always returning light mode color
  Color sectionTitleColor() {
    return const Color(0xFF222222); // Hardcoded text color for light mode
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
