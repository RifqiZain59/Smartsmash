import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts

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
        title: Text(
          'Gerakan Tenis Meja',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        backgroundColor:
            Colors.blue.shade800, // Warna biru yang sedikit lebih gelap
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade800, Colors.blue.shade600],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Colors.blue.shade50,
            ], // Gradien latar belakang body
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Obx(
          () =>
              controller.daftarGerakan.isEmpty
                  ? Center(
                    child: Text(
                      'Belum ada gerakan tersedia.',
                      style: GoogleFonts.openSans(
                        fontSize: 18,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  )
                  : ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: controller.daftarGerakan.length,
                    itemBuilder: (context, index) {
                      final gerakan = controller.daftarGerakan[index];
                      return Card(
                        margin: const EdgeInsets.only(
                          bottom: 20.0,
                        ), // Margin sedikit lebih besar
                        elevation:
                            8, // Elevasi lebih tinggi untuk efek bayangan
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            20,
                          ), // Border radius lebih besar
                        ),
                        child: InkWell(
                          onTap: () {
                            // Determine the route based on the movement's name
                            String? routeName;
                            if (gerakan.nama == 'Forehand') {
                              routeName = '/detail-forehand';
                            } else if (gerakan.nama == 'Backhand') {
                              routeName = '/detail-backhand';
                            } else if (gerakan.nama == 'Serve') {
                              routeName = '/detail-serve';
                            } else if (gerakan.nama == 'Smash') {
                              routeName = '/detail-smash';
                            }

                            if (routeName != null) {
                              Get.toNamed(routeName);
                            } else {
                              Get.snackbar(
                                'Info Gerakan',
                                'Halaman detail untuk ${gerakan.nama} belum tersedia.',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.orange.shade700,
                                colorText: Colors.white,
                                borderRadius: 10,
                                margin: const EdgeInsets.all(15),
                                icon: const Icon(
                                  Icons.warning_amber,
                                  color: Colors.white,
                                ),
                                duration: const Duration(seconds: 2),
                              );
                            }
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(
                                // Gradien latar belakang kartu
                                colors: [Colors.white, Colors.blue.shade50!],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blue.shade100.withOpacity(0.6),
                                  spreadRadius: 2,
                                  blurRadius: 10,
                                  offset: const Offset(
                                    0,
                                    4,
                                  ), // Perubahan posisi bayangan
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(
                                20.0,
                              ), // Padding lebih besar
                              child: Row(
                                crossAxisAlignment:
                                    CrossAxisAlignment
                                        .center, // Pusatkan secara vertikal
                                children: [
                                  Container(
                                    width:
                                        100, // Ukuran gambar sedikit lebih besar
                                    height: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                        color:
                                            Colors
                                                .blue
                                                .shade300, // Border yang lebih lembut
                                        width: 2,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          spreadRadius: 1,
                                          blurRadius: 5,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.asset(
                                        gerakan.imagePath,
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Container(
                                                  width: 100,
                                                  height: 100,
                                                  color: Colors.grey[200],
                                                  child: Icon(
                                                    Icons.broken_image,
                                                    size: 50,
                                                    color: Colors.grey[500],
                                                  ),
                                                ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20.0,
                                  ), // Jarak lebih luas
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          gerakan.nama,
                                          style: GoogleFonts.poppins(
                                            fontSize:
                                                22, // Ukuran font nama lebih besar
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue.shade900,
                                          ),
                                        ),
                                        const SizedBox(height: 8.0),
                                        Text(
                                          gerakan.deskripsi,
                                          style: GoogleFonts.openSans(
                                            fontSize:
                                                15, // Ukuran font deskripsi lebih besar
                                            color: Colors.grey[800],
                                            height:
                                                1.5, // Spasi baris untuk keterbacaan
                                          ),
                                          maxLines:
                                              3, // Tampilkan lebih banyak baris deskripsi
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
        ),
      ),
    );
  }
}
