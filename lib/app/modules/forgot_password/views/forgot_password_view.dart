import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import '../controllers/forgot_password_controller.dart'; // Pastikan path ini benar

class ForgotPasswordView extends GetView<ForgotPasswordController> {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    // Reactive variables for input fields
    final email = ''.obs;
    final otp = ''.obs; // This will be built from individual digit inputs
    final newPassword = ''.obs;
    final confirmNewPassword = ''.obs;

    // Get the primary color theme from the application
    final Color appBlue = Colors.blue[700]!;
    final TextTheme textTheme = Theme.of(context).textTheme;

    // List FocusNode for each OTP input field
    // final List<FocusNode> otpFocusNodes =
    //     List.generate(6, (index) => FocusNode());
    // List TextEditingController for each OTP input field
    // final List<TextEditingController> otpControllers =
    //     List.generate(6, (index) => TextEditingController());

    // Builder function for OTP input in separate boxes - REMOVED
    // Widget _buildOtpInputWithControllers() {
    //   return Row(
    //     mainAxisAlignment:
    //         MainAxisAlignment.spaceEvenly, // Distribute space evenly
    //     children: List.generate(6, (index) {
    //       return SizedBox(
    //         width: 48, // Smaller box width, suitable for 1 character
    //         child: TextFormField(
    //           controller: otpControllers[index],
    //           focusNode: otpFocusNodes[index],
    //           onChanged: (value) {
    //             // If a character is entered (length 1)
    //             if (value.length == 1) {
    //               // Move focus to the next field if not the last field
    //               if (index < 5) {
    //                 otpFocusNodes[index + 1].requestFocus();
    //               } else {
    //                 // If it's the last field, hide the keyboard
    //                 otpFocusNodes[index].unfocus();
    //               }
    //             } else if (value.isEmpty) {
    //               // If backspace is pressed and the field is empty, move focus to the previous field
    //               if (index > 0) {
    //                 otpFocusNodes[index - 1].requestFocus();
    //               }
    //             }
    //             // Concatenate all controller values to update the main otp observable
    //             otp.value = otpControllers.map((c) => c.text).join();
    //           },
    //           style: textTheme.headlineSmall?.copyWith(
    //             fontWeight: FontWeight.bold,
    //             color: appBlue,
    //           ),
    //           keyboardType: TextInputType.text, // Changed to TextInputType.text to allow letters
    //           textAlign: TextAlign.left, // Changed from TextAlign.center to TextAlign.left
    //           // Removed FilteringTextInputFormatter.digitsOnly to allow letters
    //           maxLength: 1, // Only one character per box
    //           decoration: InputDecoration(
    //             counterText: "", // Hide character counter (e.g., "1/1")
    //             border: OutlineInputBorder(
    //               borderRadius: BorderRadius.circular(12),
    //               borderSide: BorderSide(color: appBlue.withOpacity(0.5)),
    //             ),
    //             focusedBorder: OutlineInputBorder(
    //               borderRadius: BorderRadius.circular(12),
    //               borderSide: BorderSide(color: appBlue, width: 2),
    //             ),
    //             contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10), // Added horizontal padding
    //           ),
    //         ),
    //       );
    //     }),
    //   );
    // }

    return Scaffold(
      backgroundColor: Colors.white, // Clean white background
      appBar: AppBar(
        backgroundColor: appBlue, // Dark blue color for AppBar
        elevation: 0, // No shadow for a flat look
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ), // Back icon color becomes white
        title: Obx(() {
          String titleText;
          if (controller.showOtpAndNewPasswordFields.value) {
            titleText =
                controller.isOtpVerified.value
                    ? 'Atur Ulang Kata Sandi'
                    : 'Verifikasi OTP';
          } else {
            titleText = 'Lupa Kata Sandi';
          }
          return Text(
            titleText,
            style: textTheme.headlineSmall?.copyWith(
              color: Colors.white, // Title text color becomes white
              fontWeight: FontWeight.bold,
            ),
          );
        }),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 28.0,
            vertical: 20.0,
          ), // Better padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Attractive Illustration or Icon (Optional, can be replaced with an image)
              Center(
                child: Icon(
                  Icons.lock_reset,
                  size: 100,
                  color: appBlue.withOpacity(0.7), // Icon with theme blue color
                ),
              ),
              const SizedBox(height: 30),

              // Dynamic Description
              Obx(
                () => Text(
                  controller.showOtpAndNewPasswordFields.value
                      ? (controller.isOtpVerified.value
                          ? 'Silakan masukkan kata sandi baru Anda di kolom di bawah ini.'
                          : 'Kami telah mengirimkan kode verifikasi (OTP) ke email Anda. Masukkan kode tersebut untuk melanjutkan.')
                      : 'Jangan khawatir! Kami akan membantu Anda mereset kata sandi. Masukkan alamat email yang terdaftar untuk menerima instruksi.',
                  textAlign: TextAlign.center,
                  style: textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 50), // Larger spacing
              // Email Input
              Obx(
                () => AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (
                    Widget child,
                    Animation<double> animation,
                  ) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                  child:
                      !controller.showOtpAndNewPasswordFields.value
                          ? Column(
                            key: const ValueKey(
                              'email_input',
                            ), // Unique key for AnimatedSwitcher
                            children: [
                              TextField(
                                onChanged: (value) => email.value = value,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  labelText: 'Alamat Email',
                                  hintText: 'nama@contoh.com',
                                  labelStyle: TextStyle(
                                    color: appBlue,
                                  ), // Blue label color
                                  hintStyle: TextStyle(
                                    color: appBlue.withOpacity(0.6),
                                  ), // Blue hint text color with opacity
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: appBlue.withOpacity(0.5),
                                    ), // Blue input border
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: appBlue,
                                      width: 2,
                                    ), // Blue focused border
                                  ),
                                  prefixIcon: Icon(
                                    Icons.email_outlined,
                                    color: appBlue,
                                  ), // Icon is also blue
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                    horizontal: 16,
                                  ),
                                ),
                                style:
                                    textTheme
                                        .bodyMedium, // Input text style (typed by user)
                              ),
                              const SizedBox(height: 30), // Space before button
                            ],
                          )
                          : const SizedBox.shrink(
                            key: ValueKey('email_hidden'),
                          ),
                ),
              ),

              // OTP Input
              Obx(
                () => AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (
                    Widget child,
                    Animation<double> animation,
                  ) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                  child:
                      controller.showOtpAndNewPasswordFields.value &&
                              !controller.isOtpVerified.value
                          ? Column(
                            key: const ValueKey('otp_input'),
                            children: [
                              // Using a single TextFormField for OTP
                              TextField(
                                onChanged: (value) => otp.value = value,
                                keyboardType:
                                    TextInputType.text, // Allow letters
                                maxLength: 6, // Max length for OTP
                                decoration: InputDecoration(
                                  labelText: 'Kode Verifikasi (OTP)',
                                  hintText: 'Masukkan 6 karakter OTP',
                                  labelStyle: TextStyle(color: appBlue),
                                  hintStyle: TextStyle(
                                    color: appBlue.withOpacity(0.6),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: appBlue.withOpacity(0.5),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: appBlue,
                                      width: 2,
                                    ),
                                  ),
                                  prefixIcon: Icon(
                                    Ionicons.key_outline,
                                    color: Colors.grey[600],
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                    horizontal: 16,
                                  ),
                                ),
                                style: textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 20),
                              // Resend OTP Button
                              Obx(
                                () => TextButton(
                                  onPressed:
                                      controller.resendOtpCooldown.value == 0
                                          ? () => controller.resendOtp(
                                            email: email.value,
                                          )
                                          : null,
                                  style: TextButton.styleFrom(
                                    foregroundColor:
                                        controller.resendOtpCooldown.value > 0
                                            ? Colors.grey
                                            : appBlue, // Blue button text color
                                  ),
                                  child: Text(
                                    controller.resendOtpCooldown.value > 0
                                        ? 'Kirim Ulang OTP (${controller.resendOtpCooldown.value}s)'
                                        : 'Kirim Ulang OTP',
                                    style: textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ), // Space before main button
                            ],
                          )
                          : const SizedBox.shrink(key: ValueKey('otp_hidden')),
                ),
              ),

              // New Password and Confirm Password Input
              Obx(
                () => AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (
                    Widget child,
                    Animation<double> animation,
                  ) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                  child:
                      controller.isOtpVerified.value
                          ? Column(
                            key: const ValueKey('password_input'),
                            children: [
                              Obx(
                                () => TextField(
                                  onChanged:
                                      (value) => newPassword.value = value,
                                  obscureText:
                                      !controller
                                          .isPasswordVisible
                                          .value, // Use observable here
                                  decoration: InputDecoration(
                                    labelText: 'Kata Sandi Baru',
                                    hintText: 'Minimal 8 karakter',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: appBlue.withOpacity(0.5),
                                      ), // Blue input border
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: appBlue,
                                        width: 2,
                                      ), // Blue focused border
                                    ),
                                    prefixIcon: Icon(
                                      Icons.lock_outline,
                                      color: Colors.grey[600],
                                    ), // Icon remains gray
                                    suffixIcon: IconButton(
                                      // Add IconButton here
                                      icon: Icon(
                                        controller.isPasswordVisible.value
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: Colors.grey[600],
                                      ),
                                      onPressed:
                                          controller
                                              .togglePasswordVisibility, // Call toggle function
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                      horizontal: 16,
                                    ),
                                  ),
                                  style: textTheme.bodyMedium,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Obx(
                                () => TextField(
                                  onChanged:
                                      (value) =>
                                          confirmNewPassword.value = value,
                                  obscureText:
                                      !controller
                                          .isPasswordVisible
                                          .value, // Use the same observable
                                  decoration: InputDecoration(
                                    labelText: 'Konfirmasi Kata Sandi Baru',
                                    hintText: 'Ulangi kata sandi baru Anda',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: appBlue.withOpacity(0.5),
                                      ), // Blue input border
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: appBlue,
                                        width: 2,
                                      ), // Blue focused border
                                    ),
                                    prefixIcon: Icon(
                                      Icons.lock_reset_outlined,
                                      color: Colors.grey[600],
                                    ), // Icon remains gray
                                    suffixIcon: IconButton(
                                      // Add IconButton here
                                      icon: Icon(
                                        controller.isPasswordVisible.value
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: Colors.grey[600],
                                      ),
                                      onPressed:
                                          controller
                                              .togglePasswordVisibility, // Call toggle function
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                      horizontal: 16,
                                    ),
                                  ),
                                  style: textTheme.bodyMedium,
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ), // Space before main button
                            ],
                          )
                          : const SizedBox.shrink(
                            key: ValueKey('password_hidden'),
                          ),
                ),
              ),

              // Main Button (Send/Verify/Reset)
              Obx(
                () => ElevatedButton(
                  onPressed:
                      controller
                              .isLoading
                              .value // Disable button when loading
                          ? null
                          : (controller.showOtpAndNewPasswordFields.value
                              ? (controller.isOtpVerified.value
                                  ? () => controller.resetPassword(
                                    email: email.value,
                                    newPassword: newPassword.value,
                                    confirmNewPassword:
                                        confirmNewPassword.value,
                                  )
                                  : () => controller.verifyOtp(
                                    email: email.value,
                                    otp: otp.value,
                                  ))
                              : () => controller.sendOtp(email: email.value)),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: appBlue, // Blue main button background
                    foregroundColor: Colors.white,
                    textStyle: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    elevation: 4, // Slightly more prominent
                  ),
                  child: Obx(() {
                    // Show CircularProgressIndicator if loading
                    if (controller.isLoading.value) {
                      return const CircularProgressIndicator(
                        color: Colors.white,
                      );
                    }
                    String buttonText;
                    if (controller.showOtpAndNewPasswordFields.value) {
                      buttonText =
                          controller.isOtpVerified.value
                              ? 'Reset Kata Sandi'
                              : 'Verifikasi OTP';
                    } else {
                      buttonText = 'Kirim Permintaan Reset';
                    }
                    return Text(buttonText);
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
