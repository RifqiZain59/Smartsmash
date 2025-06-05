import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for TextInputFormatter
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:smartsmashapp/app/modules/otp_register/controllers/otp_register_controller.dart';
// PinCodeTextField is no longer used, so its import is removed.
// import 'package:pin_code_fields/pin_code_fields.dart';
// CHANGE THIS LINE: Import OtpRegisterasiController instead of OtpController

class OtpRegisterView extends StatefulWidget {
  @override
  _OtpViewState createState() => _OtpViewState();
}

class _OtpViewState extends State<OtpRegisterView> {
  // CHANGE THIS LINE: Use OtpRegisterasiController
  final OtpRegisterController controller =
      Get.find<OtpRegisterController>();
  late TapGestureRecognizer _tapRecognizer;
  // Controller untuk mengelola input PinCodeTextField dari keyboard kustom
  final TextEditingController _otpTextController = TextEditingController();

  // Define custom colors based on the image and requested changes
  // CHANGED: Replaced _primaryOrange with _primaryBlue
  final Color _primaryBlue = Color(0xFF007BFF); // A standard blue color
  final Color _lightBackground = Color(
    0xFFF8F8F8,
  ); // A slightly lighter background
  final Color _textColorDark = Color(
    0xFF212529,
  ); // Darker text color for titles
  final Color _textColorGrey = Color(0xFF6C757D); // Grey text for subtitles
  final Color _textFieldBorderColor = Color(
    0xFFDEE2E6,
  ); // Border color for text fields
  final Color _textFieldFillColor = Color(
    0xFFF8F9FA,
  ); // Fill color for text fields

  // Define the desired OTP length as a constant for easy modification
  static const int _otpLength = 6; // Changed from 4 to 6

  @override
  void initState() {
    super.initState();
    _tapRecognizer =
        TapGestureRecognizer()
          ..onTap = () {
            // Panggil fungsi yang benar dari controller
            controller.resendOtp();
          };
    // Menambahkan listener ke _otpTextController untuk memperbarui otpCode di controller GetX
    _otpTextController.addListener(() {
      controller.setOtp(_otpTextController.text);
      // Secara opsional, panggil verifikasi otomatis jika OTP lengkap
      if (_otpTextController.text.length == _otpLength) {
        // Updated length check
        controller.verifyOtp();
      }
    });
  }

  @override
  void dispose() {
    _tapRecognizer.dispose();
    _otpTextController.dispose(); // Pastikan controller teks dibuang
    super.dispose();
  }

  // Fungsi untuk menangani input angka dari keyboard kustom
  void _inputNumber(String number) {
    if (_otpTextController.text.length < _otpLength) {
      _otpTextController.text += number;
    }
  }

  // Fungsi untuk menangani penghapusan angka dari keyboard kustom
  void _deleteNumber() {
    if (_otpTextController.text.isNotEmpty) {
      _otpTextController.text = _otpTextController.text.substring(
        0,
        _otpTextController.text.length - 1,
      );
    }
  }

  // Widget untuk membangun tombol keyboard numerik tunggal
  Widget _buildKeyboardButton(
    String text, {
    IconData? icon,
    VoidCallback? onPressed,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(50), // Untuk efek melingkar
        child: Container(
          height: 55, // Mengurangi tinggi tombol lebih lanjut
          margin: EdgeInsets.all(3), // Mengurangi margin tombol lebih lanjut
          decoration: BoxDecoration(
            // Tidak ada warna latar belakang eksplisit untuk tombol itu sendiri, mengandalkan riak InkWell
            shape: BoxShape.circle,
          ),
          child: Center(
            child:
                icon != null
                    ? Icon(
                      icon,
                      size: 22,
                      color: _textColorDark,
                    ) // Mengurangi ukuran ikon lebih lanjut
                    : Text(
                      text,
                      style: TextStyle(
                        fontSize:
                            22, // Mengurangi ukuran font angka lebih lanjut
                        fontWeight: FontWeight.w600, // Semi-bold untuk angka
                        color: _textColorDark,
                      ),
                    ),
          ),
        ),
      ),
    );
  }

  // Widget untuk membangun seluruh keyboard numerik kustom
  Widget _buildNumericKeyboard() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildKeyboardButton('1', onPressed: () => _inputNumber('1')),
            _buildKeyboardButton('2', onPressed: () => _inputNumber('2')),
            _buildKeyboardButton('3', onPressed: () => _inputNumber('3')),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildKeyboardButton('4', onPressed: () => _inputNumber('4')),
            _buildKeyboardButton('5', onPressed: () => _inputNumber('5')),
            _buildKeyboardButton('6', onPressed: () => _inputNumber('6')),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildKeyboardButton('7', onPressed: () => _inputNumber('7')),
            _buildKeyboardButton('8', onPressed: () => _inputNumber('8')),
            _buildKeyboardButton('9', onPressed: () => _inputNumber('9')),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(child: SizedBox()), // Ruang kosong untuk penyelarasan
            _buildKeyboardButton('0', onPressed: () => _inputNumber('0')),
            _buildKeyboardButton(
              '',
              icon: Ionicons.backspace_outline,
              onPressed: _deleteNumber,
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          _lightBackground, // Menggunakan warna background dari gambar
      body: Column(
        // Mengganti SingleChildScrollView dengan Column langsung
        mainAxisAlignment:
            MainAxisAlignment.start, // Align content to the start
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Bagian atas konten (ilustrasi, teks, field OTP)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 40, // Reduced vertical padding
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start, // Atur ke awal kolom
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 120, // Mengurangi ukuran ilustrasi
                  height: 120, // Mengurangi ukuran ilustrasi
                  decoration: BoxDecoration(
                    // CHANGED: Used _primaryBlue here
                    color: _primaryBlue.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Ionicons.mail_outline,
                      size: 70, // Mengurangi ukuran ikon
                      // CHANGED: Used _primaryBlue here
                      color: _primaryBlue,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ), // Jarak setelah ikon, dikurangi untuk menaikkan teks
                Text(
                  'Enter Verification code',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: _textColorDark,
                  ),
                ),
                SizedBox(height: 10),
                Obx(
                  () => Text(
                    'Masukkan kode dari email yang kami kirimkan ke\n${controller.userEmail.value}',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: _textColorGrey, fontSize: 14),
                  ),
                ),
                SizedBox(
                  height: 30,
                ), // Jarak sebelum field OTP sedikit dikurangi
                // Replaced PinCodeTextField with TextFormField for a single input box
                Container(
                  width:
                      MediaQuery.of(context).size.width *
                      0.7, // Adjust width as needed
                  child: TextFormField(
                    controller: _otpTextController,
                    readOnly: true, // Set to true to use the custom keyboard
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: _otpLength, // Set max length to 6 digits
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: _textColorDark,
                      letterSpacing:
                          8.0, // Add letter spacing for visual separation of digits
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 16.0,
                        horizontal: 12.0,
                      ),
                      filled: true,
                      fillColor: _textFieldFillColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: _textFieldBorderColor,
                          width: 1.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: _textFieldBorderColor,
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          // CHANGED: Used _primaryBlue here
                          color: _primaryBlue,
                          width: 2.0,
                        ),
                      ),
                      counterText: "", // Hide the default character counter
                      hintText: "------", // Visual hint for 6 digits
                      hintStyle: TextStyle(
                        color: _textColorGrey.withOpacity(0.5),
                        letterSpacing: 8.0,
                      ),
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter
                          .digitsOnly, // Allow only digits
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Obx(() {
                  if (controller.errorMessage.value.isNotEmpty) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Text(
                        controller.errorMessage.value,
                        style: TextStyle(color: Colors.red, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                  return SizedBox.shrink();
                }),
                SizedBox(height: 10),
                Text.rich(
                  TextSpan(
                    text: "Didn't receive the code? ",
                    style: TextStyle(color: _textColorGrey, fontSize: 14),
                    children: [
                      TextSpan(
                        text: "Resend code",
                        style: TextStyle(
                          // CHANGED: Used _primaryBlue here
                          color: _primaryBlue,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        recognizer: _tapRecognizer,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          // Added a SizedBox to control the spacing between "Resend code" and "Verify" button
          SizedBox(height: 20),
          // Tombol Verify dan Keyboard Kustom
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Obx(
                    () => ElevatedButton(
                      onPressed:
                          controller.isLoading.value ||
                                  controller.otpCode.value.length <
                                      _otpLength // Updated length check
                              ? null
                              : () => controller.verifyOtp(),
                      child:
                          controller.isLoading.value
                              ? CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 3,
                              )
                              : Text(
                                "Verify",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      style: ElevatedButton.styleFrom(
                        // CHANGED: Used _primaryBlue here
                        backgroundColor: _primaryBlue,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        // CHANGED: Used _primaryBlue here
                        disabledBackgroundColor: _primaryBlue.withOpacity(0.5),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30), // Jarak setelah tombol Verify
                _buildNumericKeyboard(), // Keyboard numerik kustom
              ],
            ),
          ),
          SizedBox(height: 20), // Padding di bagian bawah
        ],
      ),
    );
  }
}
