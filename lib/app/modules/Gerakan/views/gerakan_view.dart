import 'package:flutter/material.dart';
import 'package:get/get.dart';

// --- Data Model ---
class Gerakan {
  final String nama;
  final String deskripsi;
  final String imagePath;

  Gerakan({
    required this.nama,
    required this.deskripsi,
    required this.imagePath,
  });
}

// --- Controller ---
class GerakanController extends GetxController {
  final List<Gerakan> daftarGerakan =
      <Gerakan>[
        Gerakan(
          nama: 'Backhand',
          deskripsi:
              'Pukulan yang dilakukan dengan sisi punggung tangan menghadap bola, sering digunakan untuk pertahanan atau serangan balik presisi.',
          imagePath: 'assets/gambar/Backhand.jpeg',
        ),
        Gerakan(
          nama: 'Forehand',
          deskripsi:
              'Pukulan dengan sisi telapak tangan menghadap bola, merupakan pukulan ofensif utama dengan kekuatan dan putaran tinggi.',
          imagePath: 'assets/gambar/Forehand.jpeg',
        ),
        Gerakan(
          nama: 'Serve',
          deskripsi:
              'Pukulan pembuka poin yang diawali dengan melambungkan bola, lalu memukulnya agar memantul di meja sendiri dan meja lawan.',
          imagePath: 'assets/gambar/Serve.jpeg',
        ),
        Gerakan(
          nama: 'Smash',
          deskripsi:
              'Pukulan serang yang sangat cepat dan kuat untuk mengakhiri reli, biasanya dilakukan saat bola lawan berada di posisi tinggi.',
          imagePath: 'assets/gambar/Smash.jpeg',
        ),
      ].obs;
}

// --- View ---
class GerakanView extends GetView<GerakanController> {
  const GerakanView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(GerakanController());

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Gerakan Tenis Meja', // Ubah judul AppBar
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue[900],
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Obx(
        () =>
            controller.daftarGerakan.isEmpty
                ? const Center(
                  child: Text(
                    'Belum ada gerakan tersedia.',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
                : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: controller.daftarGerakan.length,
                  itemBuilder: (context, index) {
                    final gerakan = controller.daftarGerakan[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16.0),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.blue.shade900,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  gerakan.imagePath,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (context, error, stackTrace) => Container(
                                        // Gunakan Container sebagai placeholder
                                        width: 80,
                                        height: 80,
                                        color:
                                            Colors
                                                .grey[300], // Warna abu-abu terang untuk placeholder
                                        child: Icon(
                                          Icons.broken_image,
                                          size: 40, // Ukuran ikon diperkecil
                                          color:
                                              Colors
                                                  .grey[600], // Warna ikon abu-abu gelap
                                        ),
                                      ),
                                ),
                              ),
                              const SizedBox(width: 16.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      gerakan.nama,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue[900],
                                      ),
                                    ),
                                    const SizedBox(height: 8.0),
                                    Text(
                                      gerakan.deskripsi,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[700],
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
      ),
    );
  }
}
