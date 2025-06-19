import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for TextInputFormatter
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:smartsmashapp/app/modules/otp_register/controllers/otp_register_controller.dart';

class OtpRegisterView extends StatefulWidget {
  @override
  _OtpViewState createState() => _OtpViewState();
}

class _OtpViewState extends State<OtpRegisterView> {
  final OtpRegisterController controller = Get.find<OtpRegisterController>();
  late TapGestureRecognizer _tapRecognizer;
  final TextEditingController _otpTextController = TextEditingController();

  static const int _otpLength = 6;

  @override
  void initState() {
    super.initState();
    _tapRecognizer =
        TapGestureRecognizer()
          ..onTap = () {
            controller.resendOtp();
          };
    _otpTextController.addListener(() {
      controller.setOtp(_otpTextController.text);
      if (_otpTextController.text.length == _otpLength) {
        controller.verifyOtp();
      }
    });
  }

  @override
  void dispose() {
    _tapRecognizer.dispose();
    _otpTextController.dispose();
    super.dispose();
  }

  void _inputNumber(String number) {
    if (_otpTextController.text.length < _otpLength) {
      _otpTextController.text += number;
    }
  }

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
    required bool isDarkMode, // Added isDarkMode parameter
  }) {
    final Color textColor =
        isDarkMode
            ? Colors.white
            : const Color(0xFF212529); // Adaptive text color
    return Expanded(
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(50),
        child: Container(
          height: 55,
          margin: const EdgeInsets.all(3),
          decoration: const BoxDecoration(shape: BoxShape.circle),
          child: Center(
            child:
                icon != null
                    ? Icon(
                      icon,
                      size: 22,
                      color: textColor, // Adaptive icon color
                    )
                    : Text(
                      text,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: textColor, // Adaptive text color
                      ),
                    ),
          ),
        ),
      ),
    );
  }

  // Widget untuk membangun seluruh keyboard numerik kustom
  Widget _buildNumericKeyboard(bool isDarkMode) {
    // Pass isDarkMode
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildKeyboardButton(
              '1',
              onPressed: () => _inputNumber('1'),
              isDarkMode: isDarkMode,
            ),
            _buildKeyboardButton(
              '2',
              onPressed: () => _inputNumber('2'),
              isDarkMode: isDarkMode,
            ),
            _buildKeyboardButton(
              '3',
              onPressed: () => _inputNumber('3'),
              isDarkMode: isDarkMode,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildKeyboardButton(
              '4',
              onPressed: () => _inputNumber('4'),
              isDarkMode: isDarkMode,
            ),
            _buildKeyboardButton(
              '5',
              onPressed: () => _inputNumber('5'),
              isDarkMode: isDarkMode,
            ),
            _buildKeyboardButton(
              '6',
              onPressed: () => _inputNumber('6'),
              isDarkMode: isDarkMode,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildKeyboardButton(
              '7',
              onPressed: () => _inputNumber('7'),
              isDarkMode: isDarkMode,
            ),
            _buildKeyboardButton(
              '8',
              onPressed: () => _inputNumber('8'),
              isDarkMode: isDarkMode,
            ),
            _buildKeyboardButton(
              '9',
              onPressed: () => _inputNumber('9'),
              isDarkMode: isDarkMode,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Expanded(
              child: SizedBox(),
            ), // Ruang kosong untuk penyelarasan
            _buildKeyboardButton(
              '0',
              onPressed: () => _inputNumber('0'),
              isDarkMode: isDarkMode,
            ),
            _buildKeyboardButton(
              '',
              icon: Ionicons.backspace_outline,
              onPressed: _deleteNumber,
              isDarkMode: isDarkMode, // Pass isDarkMode
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Determine if dark mode is active based on system brightness
    final bool isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    // Define adaptive colors
    final Color primaryBlue =
        isDarkMode
            ? const Color(0xFF90CAF9)
            : const Color(
              0xFF007BFF,
            ); // Lighter blue for dark, standard blue for light
    final Color lightBackground =
        isDarkMode
            ? const Color(0xFF121212)
            : const Color(
              0xFFF8F8F8,
            ); // Dark grey for dark, light grey for light
    final Color textColorDark =
        isDarkMode
            ? Colors.white
            : const Color(0xFF212529); // White for dark, darker for light
    final Color textColorGrey =
        isDarkMode
            ? Colors.grey[400]!
            : const Color(
              0xFF6C757D,
            ); // Lighter grey for dark, standard grey for light
    final Color textFieldBorderColor =
        isDarkMode
            ? const Color(0xFF333333)
            : const Color(
              0xFFDEE2E6,
            ); // Darker border for dark, light for light
    final Color textFieldFillColor =
        isDarkMode
            ? const Color(0xFF1E1E1E)
            : const Color(0xFFF8F9FA); // Darker fill for dark, light for light

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value:
          isDarkMode
              ? SystemUiOverlayStyle.light
              : SystemUiOverlayStyle
                  .dark, // Set status bar icons based on theme
      child: Scaffold(
        backgroundColor: lightBackground, // Adaptive background color
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Bagian atas konten (ilustrasi, teks, field OTP)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 40,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: primaryBlue.withOpacity(
                        0.1,
                      ), // Adaptive icon background color
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        Ionicons.mail_outline,
                        size: 70,
                        color: primaryBlue, // Adaptive icon color
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Enter Verification code',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: textColorDark, // Adaptive text color
                    ),
                  ),
                  const SizedBox(height: 10),
                  Obx(
                    () => Text(
                      'Masukkan kode dari email yang kami kirimkan ke\n${controller.userEmail.value}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: textColorGrey,
                        fontSize: 14,
                      ), // Adaptive text color
                    ),
                  ),
                  const SizedBox(height: 30),
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
                        color: textColorDark, // Adaptive text color
                        letterSpacing: 8.0,
                      ),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16.0,
                          horizontal: 12.0,
                        ),
                        filled: true,
                        fillColor: textFieldFillColor, // Adaptive fill color
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color:
                                textFieldBorderColor, // Adaptive border color
                            width: 1.0,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color:
                                textFieldBorderColor, // Adaptive border color
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: primaryBlue, // Adaptive focused border color
                            width: 2.0,
                          ),
                        ),
                        counterText: "", // Hide the default character counter
                        hintText: "------", // Visual hint for 6 digits
                        hintStyle: TextStyle(
                          color: textColorGrey.withOpacity(
                            0.5,
                          ), // Adaptive hint style
                          letterSpacing: 8.0,
                        ),
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter
                            .digitsOnly, // Allow only digits
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  Obx(() {
                    if (controller.errorMessage.value.isNotEmpty) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Text(
                          controller.errorMessage.value,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  }),
                  const SizedBox(height: 10),
                  Text.rich(
                    TextSpan(
                      text: "Didn't receive the code? ",
                      style: TextStyle(
                        color: textColorGrey,
                        fontSize: 14,
                      ), // Adaptive text color
                      children: [
                        TextSpan(
                          text: "Resend code",
                          style: TextStyle(
                            color: primaryBlue, // Adaptive link color
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
            const SizedBox(height: 20),
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
                                    controller.otpCode.value.length < _otpLength
                                ? null
                                : () => controller.verifyOtp(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              primaryBlue, // Adaptive button background color
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          disabledBackgroundColor: primaryBlue.withOpacity(
                            0.5,
                          ), // Adaptive disabled color
                        ),
                        child:
                            controller.isLoading.value
                                ? const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 3,
                                )
                                : const Text(
                                  "Verify",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30), // Jarak setelah tombol Verify
                  _buildNumericKeyboard(
                    isDarkMode,
                  ), // Pass isDarkMode to the keyboard builder
                ],
              ),
            ),
            const SizedBox(height: 20), // Padding di bagian bawah
          ],
        ),
      ),
    );
  }
}
