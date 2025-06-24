import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/hapus_data_controller.dart'; // Sesuaikan path jika perlu

class HapusDataView extends GetView<HapusDataController> {
  const HapusDataView({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the controller.
    Get.put(HapusDataController());

    return Scaffold(
      extendBodyBehindAppBar:
          true, // Allows the body to extend behind the app bar
      appBar: AppBar(
        title: Text(
          'Pengaturan Akun',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent, // Transparent app bar
        elevation: 0, // No shadow
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      body: Container(
        // Background with an attractive gradient
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.background,
              Theme.of(context).colorScheme.surface.withOpacity(
                0.9,
              ), // Lighter color at the bottom
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 32.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20), // Space below the app bar
                // Prominent Welcome section with shadow effect
                Text(
                  'Kelola Akun Anda',
                  style: TextStyle(
                    fontSize: 38, // Larger font size
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900], // Dark blue color
                    shadows: [
                      Shadow(
                        offset: const Offset(2.0, 2.0),
                        blurRadius: 3.0,
                        color: Colors.black.withOpacity(0.2),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16), // Larger space
                Text(
                  'Di sini Anda dapat mengelola pengaturan privasi atau menghapus akun Anda.', // More concise description
                  style: TextStyle(
                    fontSize: 18, // Slightly larger font size
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(
                      0.8,
                    ), // Slightly denser color
                    fontStyle: FontStyle.italic, // Italic text style
                  ),
                ),
                const SizedBox(height: 64), // Very large space
                // Account Actions section wrapped in a more prominent Card
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(
                      20,
                    ), // More rounded corners
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        spreadRadius: 0,
                        blurRadius: 15,
                        offset: const Offset(0, 8), // Downward shadow
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(
                      32.0,
                    ), // Larger padding inside the card
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tindakan Akun Penting',
                          style: TextStyle(
                            fontSize: 26, // Larger font size
                            fontWeight: FontWeight.bold,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const Divider(
                          height: 40,
                          thickness: 2,
                          color: Colors.grey,
                        ), // Thicker and colored divider
                        // Specific description for the delete button
                        Text(
                          'Harap perhatikan: Tindakan ini akan menghapus semua data terkait akun Anda secara permanen dari sistem kami. Proses ini tidak dapat dibatalkan setelah dikonfirmasi.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant.withOpacity(0.8),
                            height: 1.5, // Line spacing
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Delete Account Button with a more prominent style
                        _buildDeleteAccountButton(context),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32), // Space at the bottom
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Delete Account Button Widget ---
  Widget _buildDeleteAccountButton(BuildContext context) {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        height: 65, // Taller button
        child: ElevatedButton.icon(
          onPressed:
              controller.isLoading.value
                  ? null // Disable button when loading
                  : () => _showDeleteAccountConfirmationDialog(context),
          style: ElevatedButton.styleFrom(
            backgroundColor:
                Theme.of(
                  context,
                ).colorScheme.error, // Red color for dangerous action
            foregroundColor:
                Theme.of(
                  context,
                ).colorScheme.onError, // Contrasting text/icon color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15), // More rounded corners
            ),
            elevation: 8, // Higher elevation for a more prominent look
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
            textStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ), // Larger text size
            shadowColor: Theme.of(
              context,
            ).colorScheme.error.withOpacity(0.4), // Red shadow
          ),
          icon:
              controller.isLoading.value
                  ? SizedBox(
                    width: 30, // Larger loading indicator size
                    height: 30,
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.onError,
                      strokeWidth: 3.5, // Thicker indicator stroke
                    ),
                  )
                  : const Icon(
                    Icons
                        .delete_forever, // Back to the stronger delete_forever icon
                    size: 30, // Larger icon size
                  ),
          label: Text(
            controller.isLoading.value
                ? 'Memproses...'
                : 'Hapus Akun Permanen', // Clear text
          ),
        ),
      ),
    );
  }

  // --- Delete Account Confirmation Dialog ---
  void _showDeleteAccountConfirmationDialog(BuildContext context) {
    final TextEditingController passwordController = TextEditingController();
    final RxString passwordError = ''.obs;
    final RxBool _isPasswordVisible =
        false.obs; // State for password visibility

    Get.defaultDialog(
      title: 'Konfirmasi Hapus Akun', // More formal dialog title
      titleStyle: TextStyle(
        color: Theme.of(context).colorScheme.onSurface,
        fontWeight: FontWeight.bold,
        fontSize: 24, // Larger dialog title font size
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      radius: 20, // Very rounded dialog radius
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 20,
      ), // Dialog content padding
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Tindakan ini tidak dapat dibatalkan. Semua data Anda akan hilang secara permanen.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.85),
              fontSize: 18, // Larger dialog message font size
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Untuk melanjutkan, masukkan kata sandi login Anda:', // Request for login password
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Obx(
            () => TextField(
              controller: passwordController,
              obscureText:
                  !_isPasswordVisible.value, // Control password visibility
              decoration: InputDecoration(
                labelText: 'Kata Sandi Login', // Updated label
                hintText: 'Masukkan kata sandi login Anda', // Updated hint text
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                errorText:
                    passwordError.value.isNotEmpty ? passwordError.value : null,
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  // Button to toggle password visibility
                  icon: Icon(
                    _isPasswordVisible.value
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.6),
                  ),
                  onPressed: () {
                    _isPasswordVisible.value =
                        !_isPasswordVisible.value; // Toggle visibility
                  },
                ),
              ),
              onChanged: (value) {
                if (passwordError.value.isNotEmpty && value.isNotEmpty) {
                  passwordError.value = ''; // Clear error when typing starts
                }
              },
            ),
          ),
        ],
      ),
      confirm: ElevatedButton(
        onPressed: () async {
          // Changed to async because password validation might be async
          if (passwordController.text.isEmpty) {
            passwordError.value = 'Kata sandi harus diisi.';
            return;
          }

          // TODO: PENTING! GANTI LOGIKA VALIDASI KATA SANDI DI BAWAH INI.
          // Ini adalah bagian di mana Anda harus mengintegrasikan dengan sistem autentikasi Anda.
          // Contoh: Panggil fungsi dari Firebase Auth (seperti reauthenticateWithCredential)
          // atau API backend Anda untuk memverifikasi kata sandi pengguna saat ini.
          // Pastikan Anda memanggil fungsi autentikasi Anda secara asynchronous (menggunakan await).

          bool isPasswordValid = false; // Default to false
          try {
            // Contoh simulasi validasi dengan penundaan (misalnya, simulasi panggilan API)
            // Hapus baris ini di implementasi sebenarnya
            await Future.delayed(
              const Duration(milliseconds: 500),
            ); // Simulasi penundaan
            // Ganti 'PASSWORD_ASLI_PENGGUNA_DARI_AUTH' dengan kata sandi sebenarnya yang tersimpan atau diverifikasi.
            // Anda perlu mengambil kata sandi asli pengguna dari sesi login atau memverifikasinya melalui backend.
            if (passwordController.text == 'password_anda_yang_sebenarnya') {
              // <-- GANTI INI!
              isPasswordValid = true;
            }
          } catch (e) {
            // Tangani error autentikasi (misalnya, kredensial tidak valid, jaringan, dll.)
            print('Error during password validation: $e');
            passwordError.value =
                'Terjadi kesalahan saat memverifikasi kata sandi.';
            return;
          }

          if (!isPasswordValid) {
            passwordError.value = 'Kata sandi salah.';
            return;
          }

          Get.back(); // Close the dialog
          controller.hapusDataAkun(); // Call the account deletion method
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.error,
          foregroundColor: Theme.of(context).colorScheme.onError,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ), // Confirm button corners
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        child: const Text('Ya, Hapus Akun'),
      ),
      cancel: OutlinedButton(
        onPressed: () {
          Get.back(); // Close the dialog
        },
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ), // Thicker border
          foregroundColor: Theme.of(context).colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ), // Cancel button corners
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        child: const Text('Batal'),
      ),
    );
  }
}
