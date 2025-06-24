import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for TextInputFormatter
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart'; // Add this import
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
  // Removed isDarkMode parameter as it's no longer needed
  Widget _buildKeyboardButton(
    String text, {
    IconData? icon,
    VoidCallback? onPressed,
  }) {
    // Hardcoded text color for light mode
    final Color textColor = const Color(0xFF212529);
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
                      color: textColor, // Hardcoded icon color for light mode
                    )
                    : Text(
                      text,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: textColor, // Hardcoded text color for light mode
                      ),
                    ),
          ),
        ),
      ),
    );
  }

  // Widget untuk membangun seluruh keyboard numerik kustom
  // Removed isDarkMode parameter
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
            const Expanded(
              child: SizedBox(),
            ), // Ruang kosong untuk penyelarasan
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
    // Removed isDarkMode detection
    // Hardcoded colors to light theme values
    final Color primaryBlue = const Color(0xFF007BFF);
    final Color lightBackground = const Color(0xFFF8F8F8);
    final Color textColorDark = const Color(0xFF212529);
    final Color textColorGrey = const Color(0xFF6C757D);
    final Color textFieldBorderColor = const Color(0xFFDEE2E6);
    final Color textFieldFillColor = const Color(0xFFF8F9FA);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      // Always set status bar icons for light theme
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor:
            lightBackground, // Hardcoded background color for light mode
        body: Obx(() {
          // Wrap with Obx to react to controller.isLoadingOverlay
          return Stack(
            children: [
              Column(
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
                            ), // Hardcoded icon background color
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Icon(
                              Ionicons.mail_outline,
                              size: 70,
                              color: primaryBlue, // Hardcoded icon color
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Enter Verification code',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: textColorDark, // Hardcoded text color
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
                            ), // Hardcoded text color
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
                            readOnly:
                                true, // Set to true to use the custom keyboard
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            maxLength: _otpLength, // Set max length to 6 digits
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: textColorDark, // Hardcoded text color
                              letterSpacing: 8.0,
                            ),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 16.0,
                                horizontal: 12.0,
                              ),
                              filled: true,
                              fillColor:
                                  textFieldFillColor, // Hardcoded fill color
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color:
                                      textFieldBorderColor, // Hardcoded border color
                                  width: 1.0,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color:
                                      textFieldBorderColor, // Hardcoded border color
                                  width: 1.0,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color:
                                      primaryBlue, // Hardcoded focused border color
                                  width: 2.0,
                                ),
                              ),
                              counterText:
                                  "", // Hide the default character counter
                              hintText: "------", // Visual hint for 6 digits
                              hintStyle: TextStyle(
                                color: textColorGrey.withOpacity(
                                  0.5,
                                ), // Hardcoded hint style
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
                            ), // Hardcoded text color
                            children: [
                              TextSpan(
                                text: "Resend code",
                                style: TextStyle(
                                  color: primaryBlue, // Hardcoded link color
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
                                          controller.otpCode.value.length <
                                              _otpLength
                                      ? null
                                      : () => controller.verifyOtp(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    primaryBlue, // Hardcoded button background color
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                disabledBackgroundColor: primaryBlue
                                    .withOpacity(
                                      0.5,
                                    ), // Hardcoded disabled color
                              ),
                              child:
                                  controller.isLoading.value
                                      ? LoadingAnimationWidget.threeArchedCircle(
                                        // Changed to threeArchedCircle
                                        color:
                                            Colors
                                                .white, // Use white color for contrast
                                        size: 28, // Adjust size as needed
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
                        const SizedBox(
                          height: 30,
                        ), // Jarak setelah tombol Verify
                        _buildNumericKeyboard(), // Removed isDarkMode parameter
                      ],
                    ),
                  ),
                  const SizedBox(height: 20), // Padding di bagian bawah
                ],
              ),
              // Loading Overlay (similar to login_view.dart)
              if (controller.isLoadingOverlay.value)
                Positioned.fill(
                  child: Container(
                    color: lightBackground.withOpacity(0.7),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          LoadingAnimationWidget.threeArchedCircle(
                            color: primaryBlue,
                            size: 100,
                          ),
                          const SizedBox(height: 25),
                          Text(
                            "Loading...",
                            style: TextStyle(
                              color: textColorDark,
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
      ),
    );
  }
}
