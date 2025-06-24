import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';

import '../controllers/history_login_controller.dart';

class HistoryLoginView extends GetView<HistoryLoginController> {
  const HistoryLoginView({super.key});

  // Fungsi helper untuk memformat timestamp ke WIB (Waktu Indonesia Barat)
  String _formatTimestamp(String? isoString) {
    if (isoString == null || isoString.isEmpty) return 'Tanggal tidak tersedia';
    try {
      DateTime parsedDateTime = DateTime.parse(isoString);
      // Backend mengirim timestamp dalam UTC, jadi kita tidak perlu toUtc() lagi
      // jika sudah dijamin dari backend. Jika tidak, aktifkan baris ini:
      // if (!parsedDateTime.isUtc) {
      //   parsedDateTime = parsedDateTime.toUtc();
      // }
      final Duration wibOffset = Duration(hours: 7);
      final DateTime dateTimeWib = parsedDateTime.add(wibOffset);
      return DateFormat('dd/MM/yyyy HH:mm').format(dateTimeWib);
    } catch (e) {
      return 'Format tanggal tidak valid';
    }
  }

  // Fungsi helper baru untuk mendapatkan ikon metode login
  IconData _getLoginMethodIcon(String? method) {
    if (method == null) return Ionicons.help_circle_outline; // Default unknown
    final lowerCaseMethod = method.toLowerCase();
    if (lowerCaseMethod.contains('google')) {
      return Ionicons.logo_google;
    } else if (lowerCaseMethod.contains('email_password') ||
        lowerCaseMethod.contains('email')) {
      return Ionicons.mail_outline;
    } else if (lowerCaseMethod.contains('logout')) {
      return Ionicons.log_out_outline; // Icon for logout actions
    }
    return Ionicons.person_circle_outline; // Default for other methods
  }

  // Fungsi helper untuk memformat nama metode login agar lebih mudah dibaca
  String _formatLoginMethodName(String? method) {
    if (method == null) return 'Metode Tidak Dikenali';
    final lowerCaseMethod = method.toLowerCase();
    if (lowerCaseMethod == 'google') {
      return 'Login Google';
    } else if (lowerCaseMethod == 'email_password') {
      return 'Login Email/Password';
    } else if (lowerCaseMethod == 'logout') {
      return 'Logout'; // Display logout action clearly
    }
    return method; // Return as is if not specifically mapped
  }

  // Fungsi helper untuk menentukan ikon perangkat berdasarkan string informasi perangkat
  IconData _getDeviceIcon(String? deviceName) {
    if (deviceName == null || deviceName.isEmpty) return Icons.device_unknown;
    final lowerCaseDeviceInfo = deviceName.toLowerCase();
    if (lowerCaseDeviceInfo.contains('android')) {
      return Ionicons.logo_android;
    } else if (lowerCaseDeviceInfo.contains('ios') ||
        lowerCaseDeviceInfo.contains('iphone') ||
        lowerCaseDeviceInfo.contains('ipad')) {
      return Ionicons.logo_apple;
    } else if (lowerCaseDeviceInfo.contains('windows')) {
      return Ionicons.logo_windows;
    } else if (lowerCaseDeviceInfo.contains('mac')) {
      return Ionicons.logo_apple; // macOS icon same as Apple for simplicity
    } else if (lowerCaseDeviceInfo.contains('linux')) {
      return Ionicons.logo_tux; // Tux icon for Linux
    } else if (lowerCaseDeviceInfo.contains('web')) {
      return Ionicons.browsers_outline; // Browser icon for web
    }
    // Fallback based on broader categories from device_info_plus output
    if (lowerCaseDeviceInfo.contains('phone') ||
        lowerCaseDeviceInfo.contains('mobile')) {
      return Ionicons.phone_portrait_outline;
    } else if (lowerCaseDeviceInfo.contains('tablet')) {
      return Ionicons.tablet_landscape_outline;
    } else if (lowerCaseDeviceInfo.contains('pc') ||
        lowerCaseDeviceInfo.contains('desktop')) {
      return Ionicons.desktop_outline;
    }
    return Ionicons.shield_outline; // Default if none match
  }

  // Fungsi helper untuk mengekstrak versi Android dari string device_name
  String? _extractAndroidVersion(String? deviceName) {
    if (deviceName == null) return null;
    final RegExp regex = RegExp(
      r'\(Android (\d+(?:\.\d+)*)\)',
    ); // Menangkap versi penuh
    final Match? match = regex.firstMatch(deviceName);
    return match?.group(1); // Mengambil hanya grup pertama (versi)
  }

  // Fungsi untuk mengekstrak nama OS dari user agent
  String _getOSNameFromUserAgent(String? userAgent) {
    if (userAgent == null) return 'Unknown OS';
    if (userAgent.contains('Android')) return 'Android';
    if (userAgent.contains('iOS')) return 'iOS';
    if (userAgent.contains('Windows')) return 'Windows';
    if (userAgent.contains('Mac OS X')) return 'macOS';
    if (userAgent.contains('Linux')) return 'Linux';
    return 'Unknown OS';
  }

  // Fungsi untuk mengekstrak versi OS dari user agent
  String _getOSVersionFromUserAgent(String? userAgent) {
    if (userAgent == null) return 'Unknown Version';
    RegExp regex;
    Match? match;

    if (userAgent.contains('Android')) {
      regex = RegExp(r'Android (\d+(?:\.\d+)*)');
      match = regex.firstMatch(userAgent);
      if (match != null && match.groupCount >= 1) return match.group(1)!;
    }
    if (userAgent.contains('iPhone OS') || userAgent.contains('iPad OS')) {
      regex = RegExp(r'(?:iPhone OS|iPad OS)\s([\d_]+)');
      match = regex.firstMatch(userAgent);
      if (match != null && match.groupCount >= 1)
        return match.group(1)!.replaceAll('_', '.');
    }
    if (userAgent.contains('Windows NT')) {
      regex = RegExp(r'Windows NT (\d+\.\d+)');
      match = regex.firstMatch(userAgent);
      if (match != null && match.groupCount >= 1) {
        String version = match.group(1)!;
        if (version == '10.0') return '10';
        if (version == '6.3') return '8.1';
        if (version == '6.2') return '8';
        if (version == '6.1') return '7';
        return version;
      }
    }
    if (userAgent.contains('Mac OS X')) {
      regex = RegExp(r'Mac OS X (\d+_\d+(?:_\d+)*)');
      match = regex.firstMatch(userAgent);
      if (match != null && match.groupCount >= 1)
        return match.group(1)!.replaceAll('_', '.');
    }
    if (userAgent.contains('Linux')) {
      return 'Linux Kernel';
    }
    return 'Unknown Version';
  }

  // Fungsi untuk mengekstrak nama browser dari user agent
  String _getBrowserNameFromUserAgent(String? userAgent) {
    if (userAgent == null) return 'Unknown Browser';
    if (userAgent.contains('Chrome') && !userAgent.contains('Edge'))
      return 'Chrome';
    if (userAgent.contains('Firefox')) return 'Firefox';
    if (userAgent.contains('Safari') && !userAgent.contains('Chrome'))
      return 'Safari';
    if (userAgent.contains('Edge')) return 'Edge';
    if (userAgent.contains('Opera') || userAgent.contains('OPR'))
      return 'Opera';
    if (userAgent.contains('MSIE') || userAgent.contains('Trident'))
      return 'Internet Explorer';
    return 'Unknown Browser';
  }

  // Fungsi untuk mengekstrak versi browser dari user agent
  String _getBrowserVersionFromUserAgent(String? userAgent) {
    if (userAgent == null) return 'Unknown Version';
    RegExp regex;
    Match? match;

    if (userAgent.contains('Chrome') && !userAgent.contains('Edge')) {
      regex = RegExp(r'Chrome/(\d+\.\d+\.\d+\.\d+)');
      match = regex.firstMatch(userAgent);
      if (match != null && match.groupCount >= 1) return match.group(1)!;
    }
    if (userAgent.contains('Firefox')) {
      regex = RegExp(r'Firefox/(\d+\.\d+)');
      match = regex.firstMatch(userAgent);
      if (match != null && match.groupCount >= 1) return match.group(1)!;
    }
    if (userAgent.contains('Safari') && !userAgent.contains('Chrome')) {
      regex = RegExp(r'Version/(\d+\.\d+\.\d+).*Safari');
      match = regex.firstMatch(userAgent);
      if (match != null && match.groupCount >= 1) return match.group(1)!;
    }
    if (userAgent.contains('Edge')) {
      regex = RegExp(r'Edge/(\d+\.\d+)');
      match = regex.firstMatch(userAgent);
      if (match != null && match.groupCount >= 1) return match.group(1)!;
    }
    if (userAgent.contains('Opera') || userAgent.contains('OPR')) {
      regex = RegExp(r'(?:Opera|OPR)/(\d+\.\d+)');
      match = regex.firstMatch(userAgent);
      if (match != null && match.groupCount >= 1) return match.group(1)!;
    }
    if (userAgent.contains('MSIE')) {
      regex = RegExp(r'MSIE (\d+\.\d+)');
      match = regex.firstMatch(userAgent);
      if (match != null && match.groupCount >= 1) return match.group(1)!;
    }
    return 'Unknown Version';
  }

  @override
  Widget build(BuildContext context) {
    // Menghapus deteksi mode gelap, selalu menggunakan warna untuk mode terang
    const Color darkBlue = Color(0xFF1A237E); // Warna biru tua
    const Color scaffoldBackgroundColor = Colors.white; // Latar belakang putih
    const Color cardBackgroundColor = Colors.white; // Warna kartu putih
    const Color textColor = Colors.black87; // Warna teks gelap
    const Color subtitleColor = Colors.grey; // Warna subjudul abu-abu

    return Scaffold(
      backgroundColor:
          scaffoldBackgroundColor, // Menggunakan warna latar belakang
      body: ClipRRect(
        // Menerapkan lengkungan di sudut atas body
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24), // Radius lengkungan yang konsisten
          topRight: Radius.circular(24), // Radius lengkungan yang konsisten
        ),
        child: SafeArea(
          // Menjaga area aman dari status bar
          child: Column(
            // Menggunakan Column untuk menata header kustom dan konten utama
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Kustom
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  20,
                  20,
                  16,
                ), // Padding untuk header
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          // Menggunakan IconButton untuk ikon kembali
                          icon: Icon(
                            Icons.arrow_back,
                            color: darkBlue,
                          ), // Ikon kembali
                          iconSize: 28,
                          onPressed:
                              () =>
                                  Get.back(), // Fungsi untuk kembali ke halaman sebelumnya
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Riwayat Login',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: darkBlue, // Judul
                          ),
                        ),
                      ],
                    ),
                    // Anda bisa menambahkan ikon lain di sini jika diperlukan, misalnya ikon pengaturan
                    // const Icon(Ionicons.settings_outline, color: darkBlue),
                  ],
                ),
              ),
              Expanded(
                // Memastikan ListView mengambil sisa ruang yang tersedia
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return Center(
                      child: CircularProgressIndicator(color: darkBlue),
                    );
                  } else if (controller.errorMessage.isNotEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: Colors.red[700],
                              size: 50,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Terjadi kesalahan: ${controller.errorMessage.value}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.red,
                              ),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton.icon(
                              onPressed: () => controller.fetchLoginHistory(),
                              icon: const Icon(Icons.refresh),
                              label: const Text('Coba Lagi'),
                              style: ElevatedButton.styleFrom(
                                foregroundColor:
                                    Colors.white, // Teks tombol putih
                                backgroundColor: darkBlue, // Warna tombol
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
                          Text(
                            'Tidak ada riwayat login ditemukan.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              color: subtitleColor,
                            ), // Warna teks
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            onPressed: () => controller.fetchLoginHistory(),
                            icon: const Icon(Icons.refresh),
                            label: const Text('Refresh Data'),
                            style: ElevatedButton.styleFrom(
                              foregroundColor:
                                  Colors.white, // Teks tombol putih
                              backgroundColor: darkBlue, // Warna tombol
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 0,
                      ), // Menyesuaikan padding untuk ListView
                      itemCount: controller.loginHistory.length,
                      itemBuilder: (context, index) {
                        final entry = controller.loginHistory[index];
                        const bool isSuccess =
                            true; // Asumsi selalu sukses untuk riwayat login yang tercatat

                        final String? androidVersionFromDeviceName =
                            _extractAndroidVersion(
                              entry['device_name'] as String?,
                            );

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          shadowColor: darkBlue.withOpacity(0.3),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              dividerColor: Colors.transparent,
                            ), // Menghilangkan divider
                            child: ExpansionTile(
                              tilePadding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 10.0,
                              ),
                              collapsedBackgroundColor:
                                  cardBackgroundColor, // Warna latar belakang kartu
                              backgroundColor:
                                  cardBackgroundColor, // Warna latar belakang kartu
                              leading: Container(
                                padding: const EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  color: darkBlue.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Icon(
                                  _getDeviceIcon(
                                    entry['device_name'] as String?,
                                  ),
                                  color: darkBlue, // Ikon perangkat
                                  size: 30,
                                ),
                              ),
                              title: Text(
                                (androidVersionFromDeviceName != null &&
                                        entry['device_name'] != null)
                                    ? (entry['device_name'] as String)
                                        .replaceFirst(
                                          ' (Android $androidVersionFromDeviceName)', // Menghapus bagian versi Android
                                          '',
                                        )
                                        .trim()
                                    : (entry['device_name'] ??
                                        'Perangkat Tidak Dikenali'),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  color: darkBlue, // Teks judul
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                _formatTimestamp(entry['timestamp'] as String?),
                                style: TextStyle(
                                  color: subtitleColor, // Teks subjudul
                                  fontSize: 13,
                                ),
                              ),
                              trailing: Icon(
                                isSuccess
                                    ? Icons.check_circle_outline
                                    : Icons.cancel_outlined,
                                color:
                                    isSuccess
                                        ? Colors.green[700]
                                        : Colors.red[700],
                                size: 28,
                              ),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                    vertical: 10.0,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Menampilkan metode login
                                      _buildLoginMethodWidget(
                                        entry['method'] as String?,
                                        darkBlue,
                                      ), // Warna teks
                                      if (entry['ip_address'] != null)
                                        _buildDetailRow(
                                          'IP Address',
                                          entry['ip_address'] as String,
                                          Ionicons.globe_outline,
                                          textColor,
                                          subtitleColor,
                                        ), // Warna teks
                                      if (androidVersionFromDeviceName != null)
                                        _buildDetailRow(
                                          'Versi Android',
                                          androidVersionFromDeviceName,
                                          Ionicons.logo_android,
                                          textColor,
                                          subtitleColor,
                                        ), // Warna teks
                                      if (androidVersionFromDeviceName ==
                                              null &&
                                          entry['device_info'] != null) ...[
                                        if (_getOSNameFromUserAgent(
                                                  entry['device_info']
                                                      as String?,
                                                ) !=
                                                'Unknown OS' &&
                                            _getOSNameFromUserAgent(
                                                  entry['device_info']
                                                      as String?,
                                                ) !=
                                                'Android')
                                          _buildDetailRow(
                                            'Sistem Operasi',
                                            _getOSNameFromUserAgent(
                                              entry['device_info'] as String?,
                                            ),
                                            Ionicons.information_circle_outline,
                                            textColor,
                                            subtitleColor,
                                          ), // Warna teks
                                        if (_getOSVersionFromUserAgent(
                                              entry['device_info'] as String?,
                                            ) !=
                                            'Unknown Version')
                                          _buildDetailRow(
                                            'Versi OS',
                                            _getOSVersionFromUserAgent(
                                              entry['device_info'] as String?,
                                            ),
                                            Ionicons.cube_outline,
                                            textColor,
                                            subtitleColor,
                                          ), // Warna teks
                                        if (_getBrowserNameFromUserAgent(
                                              entry['device_info'] as String?,
                                            ) !=
                                            'Unknown Browser')
                                          _buildDetailRow(
                                            'Browser',
                                            _getBrowserNameFromUserAgent(
                                              entry['device_info'] as String?,
                                            ),
                                            Ionicons.browsers_outline,
                                            textColor,
                                            subtitleColor,
                                          ), // Warna teks
                                        if (_getBrowserVersionFromUserAgent(
                                              entry['device_info'] as String?,
                                            ) !=
                                            'Unknown Version')
                                          _buildDetailRow(
                                            'Versi Browser',
                                            _getBrowserVersionFromUserAgent(
                                              entry['device_info'] as String?,
                                            ),
                                            Ionicons.git_branch_outline,
                                            textColor,
                                            subtitleColor,
                                          ), // Warna teks
                                      ],
                                      if (entry['location'] != null)
                                        _buildDetailRow(
                                          'Lokasi',
                                          entry['location'] as String,
                                          Ionicons.location_outline,
                                          textColor,
                                          subtitleColor,
                                        ), // Warna teks
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Fungsi helper untuk membuat baris detail dengan label, nilai, dan ikon
  Widget _buildDetailRow(
    String label,
    String value,
    IconData icon,
    Color labelColor,
    Color valueColor,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 4.0,
      ), // Padding vertikal untuk pemisah antar baris
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: valueColor), // Warna ikon
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
                    color: labelColor, // Warna label
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 13,
                    color: valueColor,
                  ), // Warna nilai
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget baru untuk menampilkan metode login dengan ikonnya
  Widget _buildLoginMethodWidget(String? method, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            _getLoginMethodIcon(method),
            size: 20,
            color: color,
          ), // Warna ikon
          const SizedBox(width: 10),
          Text(
            _formatLoginMethodName(method),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: color, // Warna teks
            ),
          ),
        ],
      ),
    );
  }
}
