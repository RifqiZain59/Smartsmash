import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';

import '../controllers/history_login_controller.dart';

class HistoryLoginView extends GetView<HistoryLoginController> {
  const HistoryLoginView({super.key});

  // Warna biru tua kustom yang akan kita gunakan
  static const Color _darkBlue = Color(0xFF1A237E);

  // Fungsi helper untuk memformat timestamp ke WIB (Waktu Indonesia Barat)
  String _formatTimestamp(String? isoString) {
    if (isoString == null || isoString.isEmpty) return 'Tanggal tidak tersedia';
    try {
      DateTime parsedDateTime = DateTime.parse(isoString);
      if (!parsedDateTime.isUtc) {
        parsedDateTime = parsedDateTime.toUtc();
      }
      final Duration wibOffset = Duration(hours: 7);
      final DateTime dateTimeWib = parsedDateTime.add(wibOffset);
      return DateFormat('dd/MM/yyyy HH:mm').format(dateTimeWib);
    } catch (e) {
      return 'Format tanggal tidak valid';
    }
  }

  // Fungsi helper untuk menentukan ikon perangkat berdasarkan string informasi perangkat
  IconData _getDeviceIcon(String? deviceInfo) {
    if (deviceInfo == null) return Icons.device_unknown;
    final lowerCaseDeviceInfo = deviceInfo.toLowerCase();
    if (lowerCaseDeviceInfo.contains('xiaomi')) {
      return Icons.phone_android;
    } else if (lowerCaseDeviceInfo.contains('android') ||
        lowerCaseDeviceInfo.contains('ios') ||
        lowerCaseDeviceInfo.contains('mobile')) {
      return Icons.phone_android;
    } else if (lowerCaseDeviceInfo.contains('tablet')) {
      return Icons.tablet_android;
    } else if (lowerCaseDeviceInfo.contains('windows') ||
        lowerCaseDeviceInfo.contains('mac') ||
        lowerCaseDeviceInfo.contains('linux') ||
        lowerCaseDeviceInfo.contains('desktop')) {
      return Icons.desktop_windows;
    }
    return Ionicons.shield_outline;
  }

  // Fungsi helper untuk mengekstrak versi Android dari string device_name
  String? _extractAndroidVersion(String? deviceName) {
    if (deviceName == null) return null;
    final RegExp regex = RegExp(r'\(Android (\d+)\)');
    final Match? match = regex.firstMatch(deviceName);
    return match?.group(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Riwayat Login',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: _darkBlue,
        elevation: 4,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: _darkBlue),
          );
        } else if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: Colors.red[700], size: 50),
                  const SizedBox(height: 10),
                  Text(
                    'Terjadi kesalahan: ${controller.errorMessage.value}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, color: Colors.red),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () => controller.fetchLoginHistory(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Coba Lagi'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: _darkBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else if (controller.loginHistory.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Ionicons.hourglass_outline,
                  color: Colors.grey[400],
                  size: 60,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Tidak ada riwayat login ditemukan.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () => controller.fetchLoginHistory(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Refresh Data'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: _darkBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return ListView.builder(
            padding: const EdgeInsets.all(12.0),
            itemCount: controller.loginHistory.length,
            itemBuilder: (context, index) {
              final entry = controller.loginHistory[index];
              const bool isSuccess = true;

              final String? androidVersionFromDeviceName =
                  _extractAndroidVersion(entry['device_name'] as String?);

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                shadowColor: _darkBlue.withOpacity(0.3),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                // --- PERUBAHAN UTAMA: Membungkus ExpansionTile dengan Theme ---
                child: Theme(
                  data: Theme.of(context).copyWith(
                    dividerColor:
                        Colors
                            .transparent, // Menghilangkan garis pemisah default
                    // Jika Anda ingin menghilangkan indikator panah saat diperluas (tidak disarankan untuk UX)
                    // splashColor: Colors.transparent, // Mengatasi efek ripple pada tile
                    // highlightColor: Colors.transparent, // Mengatasi efek highlight saat ditekan
                  ),
                  child: ExpansionTile(
                    tilePadding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 10.0,
                    ),
                    collapsedBackgroundColor: Colors.white,
                    backgroundColor: Colors.white,
                    leading: Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: _darkBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Icon(
                        _getDeviceIcon(entry['device_info'] as String?),
                        color: _darkBlue,
                        size: 30,
                      ),
                    ),
                    title: Text(
                      (androidVersionFromDeviceName != null &&
                              entry['device_name'] != null)
                          ? (entry['device_name'] as String)
                              .replaceFirst(androidVersionFromDeviceName, '')
                              .trim()
                          : (entry['device_name'] ??
                              'Perangkat Tidak Dikenali'),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: _darkBlue,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      _formatTimestamp(entry['timestamp'] as String?),
                      style: TextStyle(color: Colors.grey[700], fontSize: 13),
                    ),
                    trailing: Icon(
                      isSuccess
                          ? Icons.check_circle_outline
                          : Icons.cancel_outlined,
                      color: isSuccess ? Colors.green[700] : Colors.red[700],
                      size: 28,
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 10.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (entry['ip_address'] != null)
                              _buildDetailRow(
                                'IP Address',
                                entry['ip_address'] as String,
                                Ionicons.globe_outline,
                              ),
                            if (entry['device_model'] != null)
                              _buildDetailRow(
                                'Model Perangkat',
                                entry['device_model'] as String,
                                Ionicons.hardware_chip_outline,
                              ),
                            if (androidVersionFromDeviceName != null)
                              _buildDetailRow(
                                'Versi Android',
                                androidVersionFromDeviceName,
                                Ionicons.logo_android,
                              ),
                            if (androidVersionFromDeviceName == null) ...[
                              if (entry['os_name'] != null)
                                _buildDetailRow(
                                  'Sistem Operasi',
                                  entry['os_name'] as String,
                                  Ionicons.information_circle_outline,
                                ),
                              if (entry['os_version'] != null)
                                _buildDetailRow(
                                  'Versi OS',
                                  entry['os_version'] as String,
                                  Ionicons.cube_outline,
                                ),
                            ],
                            if (entry['browser_name'] != null)
                              _buildDetailRow(
                                'Browser',
                                entry['browser_name'] as String,
                                Ionicons.browsers_outline,
                              ),
                            if (entry['browser_version'] != null)
                              _buildDetailRow(
                                'Versi Browser',
                                entry['browser_version'] as String,
                                Ionicons.git_branch_outline,
                              ),
                            if (entry['location'] != null)
                              _buildDetailRow(
                                'Lokasi',
                                entry['location'] as String,
                                Ionicons.location_outline,
                              ),
                            if (entry['user_agent'] != null)
                              _buildDetailRow(
                                'User Agent (Lengkap)',
                                entry['user_agent'] as String,
                                Ionicons.text_outline,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      }),
    );
  }

  // Fungsi helper untuk membuat baris detail dengan label, nilai, dan ikon
  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 4.0,
      ), // Padding vertikal untuk pemisah antar baris
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.grey[600]),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$label:',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: Colors.grey[800],
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
