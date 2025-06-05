import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartsmashapp/app/modules/login/controllers/login_controller.dart';

class LoginView extends StatefulWidget {
  LoginView({Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final LoginController controller = Get.put(LoginController());

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Definisi warna biru gelap
  static const Color _darkBluePrimary = Color(0xFF0D47A1);
  static const Color _darkBlueAccent = Color(0xFF1976D2);
  static const Color _textDark = Color(0xFF222222);
  static const Color _textLight = Colors.white;
  static const Color _buttonDisabled = Color(0xFFBBDEFB);

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
    return Scaffold(
      body: Stack(
        children: [
          // Latar Belakang Biru Atas
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.45,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [_darkBluePrimary, _darkBlueAccent],
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
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 15,
                    offset: Offset(0, -5),
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
                      "Login", // Teks untuk halaman login
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: _textDark,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Masuk ke akun Anda", // Sub-teks untuk halaman login
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    _emailInput(),
                    const SizedBox(height: 16),
                    _passwordInput(),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Get.toNamed('/forgot-password');
                        },
                        child: Text(
                          'Forgot your password?',
                          style: GoogleFonts.poppins(
                            color:
                                _darkBluePrimary, // Menggunakan warna biru gelap utama
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _errorText(),
                    const SizedBox(height: 20),
                    _loginButton(),
                    const SizedBox(height: 24),
                    _dividerWithText(),
                    const SizedBox(height: 16),
                    _googleSignInButton(),
                  ],
                ),
              ),
            ),
          ),
          // Bagian App Bar (teks Smart Smash dan SMART SMASH APP Anda)
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
                    const SizedBox(height: 10), // Padding dari atas layar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Ikon Back
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: _textLight,
                          ),
                          onPressed: () {
                            Get.back();
                          },
                          splashRadius: 24,
                        ),
                        // Teks "Belum punya akun?" dan tombol "Daftar"
                        Row(
                          // Mengelompokkan teks dan tombol
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Belum punya akun?",
                              style: GoogleFonts.poppins(
                                color: _textLight, // Warna teks putih
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
                                Get.toNamed('/register');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    _darkBlueAccent, // Warna latar belakang biru sedang
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
                                "Daftar", // Teks tombol "Daftar"
                                style: GoogleFonts.poppins(
                                  color: Colors.white, // Warna teks putih
                                  fontSize: 16, // Ukuran font 16
                                  fontWeight:
                                      FontWeight.w600, // Ketebalan font w600
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // Teks "Selamat Datang Di" dan "SMART SMASH APP" yang dirapikan
                    const SizedBox(height: 25),
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Selamat Datang Di",
                            style: GoogleFonts.poppins(
                              color: _textLight,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 0),
                          Text(
                            "SMART SMASH APP",
                            style: GoogleFonts.poppins(
                              color: _textLight,
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
        ],
      ),
    );
  }

  Widget _emailInput() {
    return TextField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      style: GoogleFonts.poppins(
        fontSize: 16,
        color: Colors.black, // Warna teks input tetap hitam
      ),
      decoration: InputDecoration(
        labelText: "Email Address",
        labelStyle: GoogleFonts.poppins(color: _darkBluePrimary, fontSize: 14),
        hintText: "user@ergemla.com",
        hintStyle: GoogleFonts.poppins(
          color: _darkBluePrimary, // Mengubah warna hint text menjadi biru
          fontSize: 16,
        ),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _darkBluePrimary, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _darkBluePrimary, width: 2),
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

  Widget _passwordInput() {
    return Obx(() {
      return TextField(
        controller: _passwordController,
        obscureText: !controller.isPasswordVisible.value,
        style: GoogleFonts.poppins(
          fontSize: 16,
          color: Colors.black, // Warna teks input tetap hitam
        ),
        decoration: InputDecoration(
          labelText: "Password",
          labelStyle: GoogleFonts.poppins(
            color: _darkBluePrimary,
            fontSize: 14,
          ),
          hintText: "**********",
          hintStyle: GoogleFonts.poppins(
            color: _darkBluePrimary, // Mengubah warna hint text menjadi biru
            fontSize: 16,
          ),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: _darkBluePrimary, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: _darkBluePrimary, width: 2),
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
              color: Colors.grey[600],
            ),
            onPressed: controller.togglePasswordVisibility,
            splashRadius: 24,
          ),
        ),
      );
    });
  }

  Widget _errorText() {
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

  Widget _loginButton() {
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
                  ? _darkBluePrimary
                  : _buttonDisabled,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 5,
          shadowColor: _darkBluePrimary.withOpacity(0.4),
        ),
        child:
            controller.isLoading.value
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
                    color: _textLight,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
      );
    });
  }

  Widget _dividerWithText() {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey[300], thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            "Or sign in with",
            style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[600]),
          ),
        ),
        Expanded(child: Divider(color: Colors.grey[300], thickness: 1)),
      ],
    );
  }

  Widget _googleSignInButton() {
    return OutlinedButton.icon(
      onPressed: controller.loginWithGoogle,
      icon: Image.asset('assets/logo/logo_google.png', height: 24),
      label: Text(
        "Google",
        style: GoogleFonts.poppins(
          color: Colors.black87,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(55),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        side: BorderSide(color: Colors.grey.shade300, width: 1.5),
        backgroundColor: Colors.white,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
      ),
    );
  }
}
