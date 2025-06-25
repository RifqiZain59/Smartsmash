import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    // Define light mode colors directly, as the app is now forced to light mode
    const Color primaryColor = Color(0xFF0D47A1);
    const Color mediumBlue = Color(0xFF1976D2);
    const Color originalBlue = Color(0xFF2196F3);

    const Color backgroundColor = Colors.white;
    const Color surfaceColor = Colors.white;

    const Color textDarkColor = Color(0xFF212121);
    const Color textLightColor =
        Colors.white; // Used for text on the gradient background
    final Color hintTextColor = Colors.grey[600]!;
    const Color inputTextColor = Colors.black87;
    const Color inputBorderColor = Color(0xFF0D47A1);
    final Color suffixIconColor = Colors.grey[600]!;
    const Color successColor = Colors.green;
    const Color errorColor =
        Colors.red; // Define a specific error color for the cross icon
    const Color disabledButtonColor = Color(0xFFBBDEFB);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      // Set status bar icons for light theme (dark icons on light background)
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Obx(() {
          return Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [primaryColor, mediumBlue, originalBlue],
                  ),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.arrow_back_ios,
                                      color: textLightColor,
                                      size: 24,
                                    ),
                                    onPressed: () {
                                      Get.back();
                                    },
                                    splashRadius: 24,
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Sudah punya akun?',
                                        style: GoogleFonts.poppins(
                                          color: textLightColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      ElevatedButton(
                                        onPressed: () {
                                          Get.toNamed('/login');
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: mediumBlue,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          elevation: 0,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 20,
                                            vertical: 10,
                                          ),
                                        ),
                                        child: Text(
                                          'Masuk',
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 30),
                            Text(
                              'HARCIMOTION APP',
                              style: GoogleFonts.poppins(
                                color: textLightColor,
                                fontSize: 30,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 20),
                            // White Card Container
                            Container(
                              width: double.infinity,
                              constraints: BoxConstraints(
                                minHeight: constraints.maxHeight - 200,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 40,
                              ),
                              decoration: BoxDecoration(
                                color: surfaceColor,
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
                                    child: Text(
                                      'Register',
                                      style: GoogleFonts.poppins(
                                        fontSize: 28,
                                        fontWeight: FontWeight.w700,
                                        color: textDarkColor,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),

                                  // Email
                                  _buildTextFormField(
                                    controller: controller.emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    labelText: 'Email',
                                    hintText: 'user@gmail.com',
                                    primaryColor: primaryColor,
                                    inputTextColor: inputTextColor,
                                    inputBorderColor: inputBorderColor,
                                    hintTextColor: hintTextColor,
                                  ),
                                  const SizedBox(height: 16),

                                  // Nama Lengkap (Your name)
                                  _buildTextFormField(
                                    controller: controller.namaController,
                                    labelText: 'Nama',
                                    hintText: 'User',
                                    primaryColor: primaryColor,
                                    inputTextColor: inputTextColor,
                                    inputBorderColor: inputBorderColor,
                                    hintTextColor: hintTextColor,
                                  ),
                                  const SizedBox(height: 16),

                                  // Password
                                  Obx(
                                    () => _buildPasswordFormField(
                                      controller: controller.passwordController,
                                      obscureText:
                                          !controller.isPasswordVisible.value,
                                      labelText: 'Password',
                                      hintText: '••••••••••••',
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          controller.isPasswordVisible.value
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: suffixIconColor,
                                        ),
                                        onPressed:
                                            controller.togglePasswordVisibility,
                                        splashRadius: 24,
                                      ),
                                      showStrengthIndicator: false,
                                      primaryColor: primaryColor,
                                      inputTextColor: inputTextColor,
                                      inputBorderColor: inputBorderColor,
                                      hintTextColor: hintTextColor,
                                    ),
                                  ),
                                  const SizedBox(height: 8),

                                  // Password validation criteria
                                  Obx(
                                    () => Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start, // Align criteria to start
                                      children: [
                                        _buildPasswordCriteriaRow(
                                          'Minimal 8 karakter',
                                          controller.hasMinLength.value,
                                          textDarkColor,
                                          successColor,
                                          errorColor, // Pass error color
                                        ),
                                        _buildPasswordCriteriaRow(
                                          'Satu huruf kapital',
                                          controller.hasUppercase.value,
                                          textDarkColor,
                                          successColor,
                                          errorColor, // Pass error color
                                        ),
                                        _buildPasswordCriteriaRow(
                                          'Satu huruf kecil',
                                          controller.hasLowercase.value,
                                          textDarkColor,
                                          successColor,
                                          errorColor, // Pass error color
                                        ),
                                        _buildPasswordCriteriaRow(
                                          'Satu angka',
                                          controller.hasDigit.value,
                                          textDarkColor,
                                          successColor,
                                          errorColor, // Pass error color
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 16),

                                  // Konfirmasi Password
                                  Obx(
                                    () => _buildPasswordFormField(
                                      controller:
                                          controller.confirmPasswordController,
                                      obscureText:
                                          !controller
                                              .isConfirmPasswordVisible
                                              .value,
                                      labelText: 'Konfirmasi Password',
                                      hintText: '••••••••••••',
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          controller
                                                  .isConfirmPasswordVisible
                                                  .value
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: suffixIconColor,
                                        ),
                                        onPressed:
                                            controller
                                                .toggleConfirmPasswordVisibility,
                                        splashRadius: 24,
                                      ),
                                      showStrengthIndicator: false,
                                      primaryColor: primaryColor,
                                      inputTextColor: inputTextColor,
                                      inputBorderColor: inputBorderColor,
                                      hintTextColor: hintTextColor,
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
                                          minimumSize: const Size.fromHeight(
                                            55,
                                          ),
                                          padding: EdgeInsets.zero,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          elevation: 5,
                                          animationDuration: Duration.zero,
                                        ).copyWith(
                                          overlayColor:
                                              MaterialStateProperty.all(
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
                                            gradient: LinearGradient(
                                              colors: [
                                                mediumBlue,
                                                primaryColor,
                                              ],
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: Container(
                                            alignment: Alignment.center,
                                            constraints: const BoxConstraints(
                                              minHeight: 55,
                                            ),
                                            // Removed the conditional loading indicator from the button
                                            child: Text(
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

              // Loading Overlay (modified) - Tanpa Kotak dan Tulisan Loading
              if (controller.isLoadingOverlay.value)
                Positioned.fill(
                  child: Container(
                    color: backgroundColor.withOpacity(0.7),
                    child: Center(
                      child: LoadingAnimationWidget.threeArchedCircle(
                        color: primaryColor, // Warna indikator
                        size: 100, // Ukuran indikator
                      ),
                    ),
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }

  // Common TextFormField widget
  Widget _buildTextFormField({
    required TextEditingController controller,
    TextInputType? keyboardType,
    int? maxLength,
    List<TextInputFormatter>? inputFormatters,
    required String labelText,
    required String hintText,
    Widget? suffixIcon,
    bool obscureText = false,
    required Color primaryColor,
    required Color inputTextColor,
    required Color inputBorderColor,
    required Color hintTextColor,
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
          style: GoogleFonts.poppins(fontSize: 16, color: inputTextColor),
          decoration: InputDecoration(
            hintText: hintText,
            labelText: labelText,
            labelStyle: GoogleFonts.poppins(color: primaryColor),
            suffixIcon: suffixIcon,
            hintStyle: GoogleFonts.poppins(color: hintTextColor),
            filled: true,
            fillColor: Colors.white,
            counterText: '',
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: inputBorderColor, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: primaryColor, width: 2),
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

  // Password TextFormField (modified)
  Widget _buildPasswordFormField({
    required TextEditingController controller,
    TextInputType? keyboardType,
    int? maxLength,
    List<TextInputFormatter>? inputFormatters,
    required String labelText,
    required String hintText,
    Widget? suffixIcon,
    bool obscureText = false,
    bool showStrengthIndicator = true,
    required Color primaryColor,
    required Color inputTextColor,
    required Color inputBorderColor,
    required Color hintTextColor,
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
          style: GoogleFonts.poppins(fontSize: 16, color: inputTextColor),
          decoration: InputDecoration(
            hintText: hintText,
            labelText: labelText,
            labelStyle: GoogleFonts.poppins(color: primaryColor),
            suffixIcon: suffixIcon,
            hintStyle: GoogleFonts.poppins(color: hintTextColor),
            filled: true,
            fillColor: Colors.white,
            counterText: '',
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: inputBorderColor, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: primaryColor, width: 2),
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

  // Updated widget to build a password criteria row with a checkmark/cross
  Widget _buildPasswordCriteriaRow(
    String text,
    bool isValid,
    Color textColor,
    Color successColor,
    Color errorColor, // New parameter for error color
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(
            isValid
                ? Icons.check_circle
                : Icons.cancel, // Change icon to cancel for invalid
            color:
                isValid
                    ? successColor
                    : errorColor, // Use errorColor for invalid
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color:
                  isValid
                      ? successColor
                      : errorColor, // Use errorColor for text too
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // This widget is no longer used for password strength, but kept for other TextFormFields if needed.
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
