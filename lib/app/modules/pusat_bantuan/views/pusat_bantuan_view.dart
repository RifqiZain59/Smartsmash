import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/pusat_bantuan_controller.dart'; // Assuming this controller exists and is still needed

class PusatBantuanView extends GetView<PusatBantuanController> {
  const PusatBantuanView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pusat Bantuan',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue, // Changed from Colors.teal
        foregroundColor: Colors.white,
        elevation: 6,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section (Removed as per user request)
            // Container(
            //   padding: const EdgeInsets.all(20),
            //   decoration: BoxDecoration(
            //     color: Colors.teal.shade50,
            //     borderRadius: BorderRadius.circular(15),
            //     border: Border.all(color: Colors.teal.shade100),
            //   ),
            //   child: const Row(
            //     children: [
            //       Icon(Icons.help_outline, size: 50, color: Colors.blue), // Changed from Colors.teal
            //       SizedBox(width: 15),
            //       Expanded(
            //         child: Column(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             Text(
            //               'Halo, Ada yang bisa kami bantu?',
            //               style: TextStyle(
            //                 fontSize: 22,
            //                 fontWeight: FontWeight.bold,
            //                 color: Colors.blue, // Changed from Colors.teal
            //               ),
            //             ),
            //             SizedBox(height: 5),
            //             Text(
            //               'Cari jawaban pertanyaan Anda atau hubungi kami.',
            //               style: TextStyle(fontSize: 16, color: Colors.grey),
            //             ),
            //           ],
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            // const SizedBox(height: 30), // Also remove the SizedBox below the header if it was only for spacing after the header

            // --- Pertanyaan Umum (FAQ) ---
            Text(
              'Pertanyaan Umum (FAQ)',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color:
                    Colors.blue.shade800, // Changed from Colors.teal.shade800
              ),
            ),
            const SizedBox(height: 15),
            _buildFaqSection(), // Extracted FAQ section into a helper method
            // const SizedBox(height: 30), // Removed spacing before "Butuh Bantuan Lebih Lanjut?" section

            // --- Butuh Bantuan Lebih Lanjut? --- (Removed as per user request)
            // Text(
            //   'Butuh Bantuan Lebih Lanjut?',
            //   style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            //         fontWeight: FontWeight.bold,
            //         color: Colors.blue.shade800, // Changed from Colors.teal.shade800
            //       ),
            // ),
            // const SizedBox(height: 15),
            // Card(
            //   elevation: 3,
            //   shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.circular(12),
            //   ),
            //   child: Padding(
            //     padding: const EdgeInsets.all(20.0),
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         _buildContactOption(
            //           icon: Icons.email,
            //           title: 'Email Dukungan',
            //           subtitle: 'Kirimkan pertanyaan Anda melalui email',
            //           onTap: () => Get.snackbar('Aksi', 'Membuka aplikasi email'),
            //         ),
            //         const Divider(height: 25),
            //         _buildContactOption(
            //           icon: Icons.phone,
            //           title: 'Telepon Kami',
            //           subtitle: 'Hubungi tim dukungan kami langsung',
            //           onTap: () => Get.snackbar(
            //             'Aksi',
            //             'Melakukan panggilan telepon',
            //           ),
            //         ),
            //         const Divider(height: 25),
            //         _buildContactOption(
            //           icon: Icons.chat_bubble,
            //           title: 'Live Chat',
            //           subtitle: 'Obrolan langsung dengan agen kami',
            //           onTap: () => Get.snackbar('Aksi', 'Membuka fitur live chat'),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  // Helper widget for FAQ section using ExpansionTile
  Widget _buildFaqSection() {
    // Sample FAQ data
    final List<Map<String, String>> faqs = [
      {
        'question': 'Bagaimana cara mengubah informasi profil saya?',
        'answer':
            'Anda dapat mengubah informasi profil Anda dengan masuk ke bagian "Akun & Profil" di aplikasi, lalu pilih "Edit Profil".',
      },
      {
        'question': 'Bagaimana cara melacak pesanan saya?',
        'answer':
            'Status pesanan Anda dapat dilacak melalui menu "Pesanan Saya". Di sana Anda akan melihat pembaruan terkini mengenai pesanan Anda.',
      },
      {
        'question': 'Apa yang harus saya lakukan jika lupa kata sandi?',
        'answer':
            'Pada halaman login, klik "Lupa Kata Sandi?". Ikuti instruksi untuk mengatur ulang kata sandi Anda melalui email terdaftar.',
      },
      {
        'question': 'Bagaimana cara menghubungi layanan pelanggan?',
        'answer':
            'Anda bisa menghubungi kami melalui email, telepon, atau live chat yang tersedia di bagian "Butuh Bantuan Lebih Lanjut?" di bawah ini.',
      },
      {
        'question': 'Apakah data saya aman di aplikasi ini?',
        'answer':
            'Kami sangat menjaga keamanan dan privasi data pengguna. Semua data dienkripsi dan dilindungi dengan standar keamanan tinggi.',
      },
    ];

    return Column(
      children:
          faqs.map((faq) {
            return Card(
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ExpansionTile(
                collapsedShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                leading: Icon(
                  Icons.help_outline,
                  color: Colors.blue,
                ), // Added leading icon
                title: Text(
                  faq['question']!,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.blue, // Changed from Colors.teal
                  ),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
                    child: Text(
                      faq['answer']!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
                iconColor: Colors.blue, // Changed from Colors.teal
                collapsedIconColor: Colors.blue, // Changed from Colors.teal
              ),
            );
          }).toList(),
    );
  }

  // Helper widget for contact options (retained from original)
  // This helper is no longer used after removing the "Butuh Bantuan Lebih Lanjut?" section.
  // However, it's kept here in case it's needed for future additions.
}
