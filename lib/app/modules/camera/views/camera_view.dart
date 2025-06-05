// smartsmashapp/app/modules/camera/views/camera_view.dart

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:smartsmashapp/app/modules/camera/controllers/camera_controller.dart';

class CameraView extends StatefulWidget {
  const CameraView({Key? key}) : super(key: key);

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  late final PoseCameraController controller;

  @override
  void initState() {
    super.initState();
    controller = PoseCameraController();
    controller.initialize();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ValueListenableBuilder<bool>(
          valueListenable: controller.isCameraInitialized,
          builder: (context, isInitialized, _) {
            if (!isInitialized || controller.cameraController == null) {
              return const Center(child: CircularProgressIndicator());
            }

            return Stack(
              fit: StackFit.expand,
              children: [
                CameraPreview(controller.cameraController!),

                // Gerakan text + icon panah
                Positioned(
                  top: 90,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      ValueListenableBuilder<String>(
                        valueListenable: controller.predictedLabel,
                        builder: (context, label, _) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            margin: const EdgeInsets.symmetric(horizontal: 60),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Gerakan : $label',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      const Icon(
                        Icons.arrow_downward,
                        size: 36,
                        color: Colors.green,
                      ),
                    ],
                  ),
                ),

                // Bottom control panel
                Positioned(
                  bottom: 20,
                  left: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 24,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(30),
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Bagian kiri: indikator waktu rekam dan status Benar/Salah
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Kotak indikator waktu rekam (lingkaran merah + waktu)
                            Container(
                              width: 60, // Lebarkan sedikit untuk menampung "00:00"
                              height: 40,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.all(Radius.circular(20)), // Ubah ke border radius
                              ),
                              alignment: Alignment.center,
                              // --- ENSURE THIS IS ValueListenableBuilder<String> ---
                              child: ValueListenableBuilder<String>(
                                valueListenable: controller.recordingCounter, // This should be ValueNotifier<String>
                                builder: (context, timeString, _) {
                                  return Text(
                                    timeString, // Menampilkan string waktu
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16, // Sesuaikan ukuran font jika perlu
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Text "Status" dan "Benar/Salah"
                            const Text(
                              "Status",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            ValueListenableBuilder<String>(
                              valueListenable: controller.correctnessStatus,
                              builder: (context, status, _) {
                                Color textColor = Colors.grey;
                                if (status == 'Benar') {
                                  textColor = Colors.green;
                                } else if (status == 'Salah') {
                                  textColor = Colors.red;
                                }
                                return Text(
                                  status,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: textColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),

                        // Tombol switch kamera DAN Play/Pause
                        Row(
                          children: [
                            // Tombol switch kamera
                            ElevatedButton(
                              onPressed: () {
                                controller.switchCamera();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                padding: const EdgeInsets.all(12),
                                shape: const CircleBorder(),
                              ),
                              child: const Icon(
                                Icons.cameraswitch,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 10),

                            // Play/Pause button
                            ValueListenableBuilder<bool>(
                              valueListenable: controller.isRecording,
                              builder: (context, isRecording, _) {
                                return ElevatedButton(
                                  onPressed: () {
                                    controller.toggleRecording();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    padding: const EdgeInsets.all(12),
                                    shape: const CircleBorder(),
                                  ),
                                  child: Icon(
                                    isRecording ? Icons.pause : Icons.play_arrow,
                                    size: 24,
                                    color: Colors.white,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}