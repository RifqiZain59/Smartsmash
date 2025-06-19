import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart'; // <--- UBAH IMPORT INI
import '../controllers/login_controller.dart';

class LoginView extends StatefulWidget {
  LoginView({Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final LoginController controller = Get.put(LoginController());

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateInputs);
    _passwordController.addListener(_validateInputs);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.arguments != null && Get.arguments is Map<String, dynamic>) {
        final Map<String, dynamic> args = Get.arguments;
        if (args.containsKey('email') && args['email'] is String) {
          _emailController.text = args['email'];
        }
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _validateInputs() {
    controller.validateInputs(
      email: _emailController.text,
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Determine if dark mode is active based on system brightness
    final bool isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    // Define adaptive colors
    final Color adaptivePrimaryBlue =
        isDarkMode ? const Color(0xFF90CAF9) : const Color(0xFF0D47A1);
    final Color adaptiveAccentBlue =
        isDarkMode ? const Color(0xFF64B5F6) : const Color(0xFF1976D2);
    final Color adaptiveBackgroundColor =
        isDarkMode ? const Color(0xFF121212) : Colors.white;
    final Color adaptiveSurfaceColor =
        isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final Color adaptiveTextDark =
        isDarkMode ? Colors.white : const Color(0xFF222222);
    final Color adaptiveTextLight = isDarkMode ? Colors.black : Colors.white;
    final Color adaptiveHintColor =
        isDarkMode ? Colors.grey[400]! : Colors.grey[600]!;
    final Color adaptiveButtonDisabledColor =
        isDarkMode ? Colors.grey[700]! : const Color(0xFFBBDEFB);
    final Color adaptiveDividerColor =
        isDarkMode ? Colors.grey[800]! : Colors.grey[300]!;
    final Color adaptiveGoogleButtonTextColor =
        isDarkMode ? Colors.white : Colors.black87;
    final Color adaptiveGoogleButtonBorderColor =
        isDarkMode ? Colors.grey[700]! : Colors.grey.shade300;

    return Scaffold(
      backgroundColor: adaptiveBackgroundColor,
      body: Obx(() {
        // Use Obx to rebuild when isLoadingOverlay changes
        return Stack(
          children: [
            // Latar Belakang Biru Atas (Gradient)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: MediaQuery.of(context).size.height * 0.45,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [adaptivePrimaryBlue, adaptiveAccentBlue],
                  ),
                ),
              ),
            ),
            // Kartu Putih untuk Form Login
            Positioned(
              top: MediaQuery.of(context).size.height * 0.25,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: adaptiveSurfaceColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isDarkMode ? Colors.black54 : Colors.black12,
                      blurRadius: 15,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 32,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "Login",
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: adaptiveTextDark,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Masuk ke akun Anda",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: adaptiveHintColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      _emailInput(
                        isDarkMode,
                        adaptivePrimaryBlue,
                        adaptiveHintColor,
                        adaptiveTextDark,
                        adaptiveSurfaceColor,
                      ),
                      const SizedBox(height: 16),
                      _passwordInput(
                        isDarkMode,
                        adaptivePrimaryBlue,
                        adaptiveHintColor,
                        adaptiveTextDark,
                        adaptiveSurfaceColor,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Get.toNamed('/forgot-password');
                          },
                          child: Text(
                            'Forgot your password?',
                            style: GoogleFonts.poppins(
                              color: adaptivePrimaryBlue,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _errorText(adaptiveTextDark),
                      const SizedBox(height: 20),
                      _loginButton(
                        isDarkMode,
                        adaptivePrimaryBlue,
                        adaptiveButtonDisabledColor,
                        adaptiveTextLight,
                      ),
                      const SizedBox(height: 24),
                      _dividerWithText(
                        isDarkMode,
                        adaptiveDividerColor,
                        adaptiveHintColor,
                      ),
                      const SizedBox(height: 16),
                      _googleSignInButton(
                        isDarkMode,
                        adaptiveGoogleButtonTextColor,
                        adaptiveGoogleButtonBorderColor,
                        adaptiveSurfaceColor,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Bagian App Bar (teks Selamat Datang dan SMART SMASH APP Anda)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.arrow_back_ios,
                              color: adaptiveTextLight,
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
                                "Belum punya akun?",
                                style: GoogleFonts.poppins(
                                  color: adaptiveTextLight,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: () {
                                  Get.toNamed('/register');
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: adaptiveAccentBlue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                ),
                                child: Text(
                                  "Daftar",
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
                      const SizedBox(height: 25),
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Selamat Datang Di",
                              style: GoogleFonts.poppins(
                                color: adaptiveTextLight,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 0),
                            Text(
                              "HARCIMOTION APP",
                              style: GoogleFonts.poppins(
                                color: adaptiveTextLight,
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Loading Overlay
            if (controller.isLoadingOverlay.value)
              Positioned.fill(
                child: Container(
                  color: adaptiveBackgroundColor.withOpacity(0.7),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Menggunakan threeArchedCircle dari loading_animation_widget
                        LoadingAnimationWidget.threeArchedCircle(
                          // <--- UBAH DI SINI
                          color: adaptivePrimaryBlue, // <--- Warna indikator
                          size: 100, // <--- Ukuran indikator
                        ),
                        const SizedBox(height: 25),
                        Text(
                          "Loading...",
                          style: GoogleFonts.poppins(
                            color: adaptiveTextDark,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }

  // Helper widget for email input
  Widget _emailInput(
    bool isDarkMode,
    Color adaptivePrimaryBlue,
    Color adaptiveHintColor,
    Color adaptiveTextDark,
    Color adaptiveSurfaceColor,
  ) {
    return TextField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      style: GoogleFonts.poppins(fontSize: 16, color: adaptiveTextDark),
      decoration: InputDecoration(
        labelText: "Email Address",
        labelStyle: GoogleFonts.poppins(
          color: adaptivePrimaryBlue,
          fontSize: 14,
        ),
        hintText: "user@ergemla.com",
        hintStyle: GoogleFonts.poppins(color: adaptiveHintColor, fontSize: 16),
        filled: true,
        fillColor: adaptiveSurfaceColor,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: adaptivePrimaryBlue, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: adaptivePrimaryBlue, width: 2),
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
      ),
    );
  }

  // Helper widget for password input
  Widget _passwordInput(
    bool isDarkMode,
    Color adaptivePrimaryBlue,
    Color adaptiveHintColor,
    Color adaptiveTextDark,
    Color adaptiveSurfaceColor,
  ) {
    return Obx(() {
      return TextField(
        controller: _passwordController,
        obscureText: !controller.isPasswordVisible.value,
        style: GoogleFonts.poppins(fontSize: 16, color: adaptiveTextDark),
        decoration: InputDecoration(
          labelText: "Password",
          labelStyle: GoogleFonts.poppins(
            color: adaptivePrimaryBlue,
            fontSize: 14,
          ),
          hintText: "**********",
          hintStyle: GoogleFonts.poppins(
            color: adaptiveHintColor,
            fontSize: 16,
          ),
          filled: true,
          fillColor: adaptiveSurfaceColor,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: adaptivePrimaryBlue, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: adaptivePrimaryBlue, width: 2),
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
          suffixIcon: IconButton(
            icon: Icon(
              controller.isPasswordVisible.value
                  ? Icons.visibility
                  : Icons.visibility_off,
              color: adaptiveHintColor,
            ),
            onPressed: controller.togglePasswordVisibility,
            splashRadius: 24,
          ),
        ),
      );
    });
  }

  // Helper widget for error text
  Widget _errorText(Color adaptiveTextDark) {
    return Obx(() {
      return controller.errorMessage.isNotEmpty
          ? Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              controller.errorMessage.value,
              style: GoogleFonts.poppins(
                color: Colors.red,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          )
          : const SizedBox.shrink();
    });
  }

  // Helper widget for login button
  Widget _loginButton(
    bool isDarkMode,
    Color adaptivePrimaryBlue,
    Color adaptiveButtonDisabledColor,
    Color adaptiveTextLight,
  ) {
    return Obx(() {
      return ElevatedButton(
        onPressed:
            controller.isButtonEnabled.value
                ? () {
                  controller.login(
                    email: _emailController.text,
                    password: _passwordController.text,
                  );
                }
                : null,
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(55),
          backgroundColor:
              controller.isButtonEnabled.value
                  ? adaptivePrimaryBlue
                  : adaptiveButtonDisabledColor,
          shape:
              isDarkMode
                  ? RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Colors.white, width: 1.5),
                  )
                  : RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
          elevation: 5,
          shadowColor: adaptivePrimaryBlue.withOpacity(0.4),
        ),
        child:
            controller
                    .isLoading
                    .value // Ini untuk indikator di dalam tombol
                ? const SizedBox(
                  height: 28,
                  width: 28,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                )
                : Text(
                  "Sign In",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
      );
    });
  }

  // Helper widget for divider with text
  Widget _dividerWithText(
    bool isDarkMode,
    Color adaptiveDividerColor,
    Color adaptiveHintColor,
  ) {
    return Row(
      children: [
        Expanded(child: Divider(color: adaptiveDividerColor, thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            "Or sign in with",
            style: GoogleFonts.poppins(fontSize: 13, color: adaptiveHintColor),
          ),
        ),
        Expanded(child: Divider(color: adaptiveDividerColor, thickness: 1)),
      ],
    );
  }

  // Helper widget for Google sign-in button
  Widget _googleSignInButton(
    bool isDarkMode,
    Color adaptiveGoogleButtonTextColor,
    Color adaptiveGoogleButtonBorderColor,
    Color adaptiveSurfaceColor,
  ) {
    return OutlinedButton.icon(
      onPressed: () {
        controller.isLoadingOverlay.value = true;
        controller.loginWithGoogle();
      },
      icon: Image.asset('assets/logo/logo_google.png', height: 24),
      label: Text(
        "Google",
        style: GoogleFonts.poppins(
          color: adaptiveGoogleButtonTextColor,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(55),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        side: BorderSide(color: adaptiveGoogleButtonBorderColor, width: 1.5),
        backgroundColor: adaptiveSurfaceColor,
        elevation: 2,
        shadowColor:
            isDarkMode
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.1),
      ),
    );
  }
}
