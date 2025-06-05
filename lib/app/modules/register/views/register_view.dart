import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartsmashapp/app/modules/register/controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light, // Set status bar icons to light
      child: Scaffold(
        resizeToAvoidBottomInset:
            true, // Memungkinkan Scaffold menyesuaikan diri saat keyboard muncul
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF0D47A1), // Dark Blue (lebih gelap dari sebelumnya)
                Color(0xFF1976D2), // Medium Blue
                Color(0xFF2196F3), // Original Blue (tetap sebagai referensi)
              ],
            ),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                // SingleChildScrollView dikembalikan di sini
                physics: const AlwaysScrollableScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                    children: [
                      // Top Section (App Bar like)
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 60.0,
                          left: 24.0,
                          right: 24.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // START: Mengubah GestureDetector menjadi IconButton
                            IconButton(
                              icon: const Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                                size: 24,
                              ),
                              onPressed: () {
                                Get.back(); // Navigasi kembali
                              },
                              splashRadius:
                                  24, // Menambahkan splashRadius agar konsisten
                            ),
                            // END: Mengubah GestureDetector menjadi IconButton
                            // START: Mengelompokkan teks dan tombol untuk mendekatkan mereka
                            Row(
                              mainAxisSize:
                                  MainAxisSize
                                      .min, // Agar row tidak mengambil seluruh lebar
                              children: [
                                Text(
                                  'Sudah punya akun?',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white, // Warna teks putih
                                    fontSize: 16, // Ukuran font 16
                                    fontWeight:
                                        FontWeight.w500, // Ketebalan font w500
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ), // Spasi kecil antara teks dan tombol
                                ElevatedButton(
                                  onPressed: () {
                                    Get.toNamed(
                                      '/login',
                                    ); // Navigasi ke halaman login
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(
                                      0xFF1976D2,
                                    ), // Warna latar belakang biru sedang
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        12,
                                      ), // Border radius 12
                                    ),
                                    elevation: 0, // Tanpa shadow
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20, // Padding horizontal 20
                                      vertical: 10, // Padding vertical 10
                                    ),
                                  ),
                                  child: Text(
                                    'Masuk', // Teks tombol "Masuk"
                                    style: GoogleFonts.poppins(
                                      color: Colors.white, // Warna teks putih
                                      fontSize: 16, // Ukuran font 16
                                      fontWeight:
                                          FontWeight
                                              .w600, // Ketebalan font w600
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // END: Mengelompokkan teks dan tombol
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      Text(
                        'SMART SMASH APP',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 20), // Mengurangi spasi di sini
                      // White Card Container
                      Container(
                        width: double.infinity,
                        constraints: BoxConstraints(
                          minHeight:
                              constraints.maxHeight -
                              200, // Adjust minHeight as needed
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 40,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, -10),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              // Ditambahkan untuk menengahkan teks "Register"
                              child: Text(
                                'Register',
                                style: GoogleFonts.poppins(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF212121),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Email
                            _buildTextFormField(
                              controller: controller.emailController,
                              keyboardType: TextInputType.emailAddress,
                              labelText: 'Email', // Label ini akan floating
                              hintText: 'user@gmail.com',
                            ),
                            const SizedBox(height: 16),

                            // Nama Lengkap (Your name)
                            _buildTextFormField(
                              controller: controller.namaController,
                              labelText: 'Nama', // Label ini akan floating
                              hintText: 'User',
                            ),
                            const SizedBox(height: 16),

                            // Password
                            Obx(
                              () => _buildPasswordFormField(
                                controller: controller.passwordController,
                                obscureText:
                                    !controller.isPasswordVisible.value,
                                labelText:
                                    'Password', // Label ini akan floating
                                hintText: '••••••••••••',
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    controller.isPasswordVisible.value
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.grey[600],
                                  ),
                                  onPressed:
                                      controller.togglePasswordVisibility,
                                  splashRadius: 24,
                                ),
                                passwordStrength:
                                    controller.passwordController.text.length >
                                            7
                                        ? 'Strong'
                                        : (controller
                                                .passwordController
                                                .text
                                                .isNotEmpty
                                            ? 'Medium'
                                            : 'Weak'),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Konfirmasi Password
                            Obx(
                              () => _buildPasswordFormField(
                                controller:
                                    controller.confirmPasswordController,
                                obscureText:
                                    !controller.isConfirmPasswordVisible.value,
                                labelText:
                                    'Confirm Password', // Label ini akan floating
                                hintText: '••••••••••••',
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    controller.isConfirmPasswordVisible.value
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.grey[600],
                                  ),
                                  onPressed:
                                      controller
                                          .toggleConfirmPasswordVisibility,
                                  splashRadius: 24,
                                ),
                                passwordStrength: '',
                                showStrengthIndicator: false,
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Tombol Daftar (Sign up)
                            SizedBox(
                              width: double.infinity,
                              child: Obx(
                                () => ElevatedButton(
                                  onPressed:
                                      controller.isLoading.value
                                          ? null
                                          : controller.registerUser,
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size.fromHeight(55),
                                    padding: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 5,
                                    animationDuration: Duration.zero,
                                  ).copyWith(
                                    overlayColor: MaterialStateProperty.all(
                                      Colors.transparent,
                                    ),
                                    backgroundColor:
                                        MaterialStateProperty.resolveWith<
                                          Color
                                        >((Set<MaterialState> states) {
                                          if (states.contains(
                                            MaterialState.pressed,
                                          )) {
                                            return Colors.transparent;
                                          }
                                          return Colors.transparent;
                                        }),
                                  ),
                                  child: Ink(
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFF1976D2), // Medium Blue
                                          Color(0xFF0D47A1), // Dark Blue
                                        ],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Container(
                                      alignment: Alignment.center,
                                      constraints: const BoxConstraints(
                                        minHeight: 55,
                                      ),
                                      child:
                                          controller.isLoading.value
                                              ? const SizedBox(
                                                width: 24,
                                                height: 24,
                                                child:
                                                    CircularProgressIndicator(
                                                      color: Colors.white,
                                                      strokeWidth: 2,
                                                    ),
                                              )
                                              : Text(
                                                'Sign up',
                                                style: GoogleFonts.poppins(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    TextInputType? keyboardType,
    int? maxLength,
    List<TextInputFormatter>? inputFormatters,
    required String labelText,
    required String hintText,
    Widget? suffixIcon,
    bool obscureText = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLength: maxLength,
          inputFormatters: inputFormatters,
          obscureText: obscureText,
          style: GoogleFonts.poppins(fontSize: 16, color: Colors.black87),
          decoration: InputDecoration(
            hintText: hintText,
            labelText: labelText,
            labelStyle: GoogleFonts.poppins(
              color: const Color(0xFF0D47A1),
            ), // Warna label diubah menjadi biru gelap
            suffixIcon: suffixIcon,
            hintStyle: GoogleFonts.poppins(
              color: const Color(0xFF0D47A1),
            ), // Warna hint diubah menjadi biru gelap
            filled: true,
            fillColor: Colors.white,
            counterText: '',
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                // Warna border diubah menjadi biru gelap
                color: Color(0xFF0D47A1),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFF0D47A1), // Dark Blue
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.redAccent, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordFormField({
    required TextEditingController controller,
    TextInputType? keyboardType,
    int? maxLength,
    List<TextInputFormatter>? inputFormatters,
    required String labelText,
    required String hintText,
    Widget? suffixIcon,
    bool obscureText = false,
    String passwordStrength = 'Weak',
    bool showStrengthIndicator = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLength: maxLength,
          inputFormatters: inputFormatters,
          obscureText: obscureText,
          style: GoogleFonts.poppins(fontSize: 16, color: Colors.black87),
          decoration: InputDecoration(
            hintText: hintText,
            labelText: labelText,
            labelStyle: GoogleFonts.poppins(
              color: const Color(0xFF0D47A1),
            ), // Warna label diubah menjadi biru gelap
            suffixIcon: suffixIcon,
            hintStyle: GoogleFonts.poppins(
              color: const Color(0xFF0D47A1),
            ), // Warna hint diubah menjadi biru gelap
            filled: true,
            fillColor: Colors.white,
            counterText: '',
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                // Warna border diubah menjadi biru gelap
                color: Color(0xFF0D47A1),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFF0D47A1), // Dark Blue
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.redAccent, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
          ),
        ),
        if (showStrengthIndicator) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              _buildStrengthIndicatorBar(
                passwordStrength == 'Strong'
                    ? Colors.green
                    : (passwordStrength == 'Medium'
                        ? Colors.orange
                        : Colors.grey[300]!),
              ),
              const SizedBox(width: 4),
              _buildStrengthIndicatorBar(
                passwordStrength == 'Strong' || passwordStrength == 'Medium'
                    ? Colors.orange
                    : Colors.grey[300]!,
              ),
              const SizedBox(width: 4),
              _buildStrengthIndicatorBar(
                passwordStrength == 'Strong' ? Colors.green : Colors.grey[300]!,
              ),
              const SizedBox(width: 8),
              Text(
                passwordStrength,
                style: GoogleFonts.poppins(
                  color:
                      passwordStrength == 'Strong'
                          ? Colors.green
                          : (passwordStrength == 'Medium'
                              ? Colors.orange
                              : Colors.grey[500]),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildStrengthIndicatorBar(Color color) {
    return Expanded(
      child: Container(
        height: 6,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(3),
        ),
      ),
    );
  }
}
