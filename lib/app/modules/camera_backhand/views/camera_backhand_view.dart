import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:smartsmashapp/app/modules/camera_backhand/controllers/camera_backhand_controller.dart';

class CameraBackhandView extends StatefulWidget {
  const CameraBackhandView({Key? key}) : super(key: key);

  @override
  State<CameraBackhandView> createState() => _FindDeviceViewState();
}

class _FindDeviceViewState extends State<CameraBackhandView> {
  late CameraBackhandController _cameraBackhandController;

  @override
  void initState() {
    super.initState();
    _cameraBackhandController = CameraBackhandController();
    _cameraBackhandController.initialize();
  }

  @override
  void dispose() {
    _cameraBackhandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Definisi warna biru gelap utama
    const Color primaryDarkBlue = Color(
      0xFF1A237E,
    ); // Indigo, biru gelap yang bagus
    const Color lighterBlue = Colors.blue; // Untuk kontras yang lebih ringan
    const Color darkTextOnBlue =
        Colors.white; // Teks di atas latar belakang biru gelap
    const Color lightTextOnBlue =
        Colors
            .white; // Teks di atas latar belakang biru gelap yang lebih transparan

    return Scaffold(
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Camera Preview
            ValueListenableBuilder<bool>(
              valueListenable: _cameraBackhandController.isCameraInitialized,
              builder: (context, isInitialized, child) {
                if (isInitialized &&
                    _cameraBackhandController.cameraController != null &&
                    _cameraBackhandController
                        .cameraController!
                        .value
                        .isInitialized) {
                  return SizedBox.expand(
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width:
                            _cameraBackhandController
                                .cameraController!
                                .value
                                .previewSize!
                                .height,
                        height:
                            _cameraBackhandController
                                .cameraController!
                                .value
                                .previewSize!
                                .width,
                        child: CameraPreview(
                          _cameraBackhandController.cameraController!,
                        ),
                      ),
                    ),
                  );
                } else if (!isInitialized &&
                    _cameraBackhandController.cameras.isEmpty) {
                  return const Center(
                    child: Text(
                      'No camera available on this device.',
                      style: TextStyle(color: darkTextOnBlue),
                    ),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),

            // Gradient Overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      primaryDarkBlue.withOpacity(0.4), // Biru gelap transparan
                      Colors.transparent,
                      Colors.transparent,
                      primaryDarkBlue.withOpacity(0.4), // Biru gelap transparan
                    ],
                    stops: const [0.0, 0.2, 0.8, 1.0],
                  ),
                ),
              ),
            ),

            // Tombol Navigasi Kembali
            Positioned(
              top: 50,
              left: 20,
              child: Container(
                decoration: BoxDecoration(
                  color: primaryDarkBlue.withOpacity(
                    0.6,
                  ), // Biru gelap transparan
                  borderRadius: BorderRadius.circular(15),
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: darkTextOnBlue, // Teks putih
                    size: 28,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),

            // Tombol Ganti Kamera (Posisi tetap di kanan paling luar)
            Positioned(
              top: 50,
              right: 20,
              child: Container(
                decoration: BoxDecoration(
                  color: primaryDarkBlue.withOpacity(
                    0.6,
                  ), // Biru gelap transparan
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ValueListenableBuilder<bool>(
                  valueListenable:
                      _cameraBackhandController.isCameraInitialized,
                  builder: (context, isInitialized, child) {
                    final bool canSwitch =
                        isInitialized &&
                        _cameraBackhandController.cameras.length > 1;
                    final IconData iconToShow =
                        _cameraBackhandController
                                    .cameraController
                                    ?.description
                                    .lensDirection ==
                                CameraLensDirection.front
                            ? Icons.camera_rear
                            : Icons.camera_front;

                    return IconButton(
                      icon: Icon(
                        iconToShow,
                        color: darkTextOnBlue,
                        size: 28,
                      ), // Teks putih
                      onPressed:
                          canSwitch
                              ? () => _cameraBackhandController.switchCamera()
                              : null,
                    );
                  },
                ),
              ),
            ),

            // Tombol Mulai/Jeda Deteksi (Baru, di sebelah kiri tombol Ganti Kamera)
            Positioned(
              top: 50,
              right:
                  90, // Menyesuaikan posisi agar di sebelah kiri tombol ganti kamera
              child: Container(
                decoration: BoxDecoration(
                  color: primaryDarkBlue.withOpacity(
                    0.6,
                  ), // Biru gelap transparan
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ValueListenableBuilder<bool>(
                  // Memastikan tombol hanya aktif jika kamera sudah diinisialisasi
                  valueListenable:
                      _cameraBackhandController.isCameraInitialized,
                  builder: (context, isInitialized, child) {
                    return ValueListenableBuilder<bool>(
                      // Mengubah ikon berdasarkan status perekaman
                      valueListenable: _cameraBackhandController.isRecording,
                      builder: (context, isRecording, child) {
                        return IconButton(
                          icon: Icon(
                            isRecording
                                ? Icons.pause
                                : Icons.play_arrow, // Ikon play/pause
                            color: darkTextOnBlue, // Teks putih
                            size: 28,
                          ),
                          onPressed:
                              isInitialized // Tombol aktif hanya jika kamera siap
                                  ? () {
                                    _cameraBackhandController.toggleRecording();
                                  }
                                  : null, // Nonaktifkan tombol jika kamera belum siap
                        );
                      },
                    );
                  },
                ),
              ),
            ),

            // Indikator Gerakan (predictedLabel dari controller)
            Positioned(
              bottom: 290,
              left: 0,
              right: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 20,
                    ),
                    decoration: BoxDecoration(
                      color: primaryDarkBlue.withOpacity(
                        0.7,
                      ), // Biru gelap transparan
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ValueListenableBuilder<String>(
                      valueListenable: _cameraBackhandController.predictedLabel,
                      builder: (context, label, child) {
                        return Text(
                          label.isEmpty ? 'Menunggu Gerakan...' : label,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: lightTextOnBlue, // Teks putih
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Bottom Panel for Device Tracking
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 30,
                ),
                decoration: BoxDecoration(
                  color: primaryDarkBlue, // Latar belakang biru gelap
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: primaryDarkBlue.withOpacity(
                        0.5,
                      ), // Bayangan biru gelap
                      blurRadius: 10,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Wrench Icon
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: lighterBlue.withOpacity(
                          0.3,
                        ), // Biru yang lebih terang transparan
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.build_circle,
                        color: lighterBlue, // Biru yang lebih terang
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Teks Waktu (sekarang dalam format 00:00)
                    ValueListenableBuilder<String>(
                      valueListenable: _cameraBackhandController.timeLeft,
                      builder: (context, time, child) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color:
                                Colors
                                    .transparent, // Tetap transparan, karena permintaan sebelumnya untuk menghapus kotak merah.
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            time,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: darkTextOnBlue, // Teks putih
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 5),
                    // Teks Akurasi (dengan desimal)
                    ValueListenableBuilder<double>(
                      valueListenable:
                          _cameraBackhandController.accuracyPercentage,
                      builder: (context, accuracy, child) {
                        return Text(
                          'Akurasi: ${accuracy.toStringAsFixed(1)}%',
                          style: const TextStyle(
                            fontSize: 14,
                            color: lightTextOnBlue, // Teks putih
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 5),
                    // Teks Benar atau Salah
                    ValueListenableBuilder<String>(
                      valueListenable:
                          _cameraBackhandController.correctnessStatus,
                      builder: (context, status, child) {
                        return Text(
                          status.isEmpty ? 'Menunggu Gerakan...' : status,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color:
                                status == 'Benar'
                                    ? Colors
                                        .blue
                                        .shade300 // Biru muda untuk "Benar"
                                    : (status == 'Salah'
                                        ? Colors
                                            .blue
                                            .shade700 // Biru lebih gelap untuk "Salah"
                                        : lightTextOnBlue), // Teks putih untuk default
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    // Tombol 'switch to map'
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          print('Switch to map button pressed');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.blue.shade800, // Biru gelap yang solid
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Text(
                          'switch to map',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: darkTextOnBlue, // Teks putih
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
