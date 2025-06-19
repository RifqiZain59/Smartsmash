import 'dart:convert';
import 'dart:async';
import 'dart:io'; // Untuk SocketException
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart'; // Untuk kDebugMode
import 'package:device_info_plus/device_info_plus.dart'; // Import for device info
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart'; // NEW: Import for Google Sign-In

class ApiService {
  // PASTIKAN URL INI BENAR DAN DAPAT DIAKSES DARI PERANGKAT/EMULATOR ANDA
  static const String baseUrl =
      'https://absolute-slightly-ray.ngrok-free.app'; // GANTI DENGAN URL NGROK/SERVER ANDA
  // PASTIKAN INI ADALAH URL NGROK TERBARU DAN AKTIF SAAT INI!

  // Tambahkan API Key di sini
  static const String apiKey = 'smartsmash'; // Ganti dengan API Key Anda

  // MENINGKATKAN DURASI TIMEOUT UNTUK DEBUGGING SEMENTARA
  static const Duration timeoutDuration = Duration(
    seconds: 60,
  ); // Diperpanjang menjadi 60 detik

  // --- Utility Methods ---

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', token);
    await prefs.setString(
      'token_update_time',
      // Menggunakan toUtc() untuk memastikan timestamp selalu disimpan sebagai UTC
      DateTime.now().toUtc().toIso8601String(),
    );
    if (kDebugMode) {
      print('Token disimpan: $token (UTC ISO 8601)');
    }
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  static Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('token_update_time');
    if (kDebugMode) {
      print('Token dihapus.');
    }
  }

  // Helper function to get detailed device information
  static Future<String> getDeviceInfoString() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String deviceName = 'Unknown Device';

    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        // Example: Xiaomi 24115RA8EG (Android 14)
        deviceName =
            '${androidInfo.manufacturer ?? 'Android'} ${androidInfo.model ?? 'Device'} (Android ${androidInfo.version.release ?? ''})';
        if (kDebugMode) {
          print('DEBUG getDeviceInfoString: Android Info: $deviceName');
        }
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        deviceName =
            '${iosInfo.name ?? 'iOS'} ${iosInfo.model ?? 'Device'} (iOS ${iosInfo.systemVersion ?? ''})';
        if (kDebugMode) {
          print('DEBUG getDeviceInfoString: iOS Info: $deviceName');
        }
      } else if (Platform.isWindows) {
        WindowsDeviceInfo windowsInfo = await deviceInfo.windowsInfo;
        deviceName =
            '${windowsInfo.computerName ?? 'Windows PC'} (Windows ${windowsInfo.majorVersion ?? ''}.${windowsInfo.minorVersion ?? ''})';
        if (kDebugMode) {
          print('DEBUG getDeviceInfoString: Windows Info: $deviceName');
        }
      } else if (Platform.isMacOS) {
        MacOsDeviceInfo macOsInfo = await deviceInfo.macOsInfo;
        deviceName =
            '${macOsInfo.model ?? 'Mac'} (macOS ${macOsInfo.osRelease ?? ''})';
        if (kDebugMode) {
          print('DEBUG getDeviceInfoString: macOS Info: $deviceName');
        }
      } else if (Platform.isLinux) {
        LinuxDeviceInfo linuxInfo = await deviceInfo.linuxInfo;
        deviceName = '${linuxInfo.name ?? 'Linux Device'} (Linux)';
        if (kDebugMode) {
          print('DEBUG getDeviceInfoString: Linux Info: $deviceName');
        }
      } else if (kIsWeb) {
        // Check if running on web
        WebBrowserInfo webBrowserInfo = await deviceInfo.webBrowserInfo;
        deviceName =
            '${webBrowserInfo.browserName.name} on ${webBrowserInfo.platform ?? 'Web'}';
        if (kDebugMode) {
          print('DEBUG getDeviceInfoString: Web Info: $deviceName');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting device info in getDeviceInfoString: $e');
      }
      deviceName = 'Failed to get device info';
    }
    if (kDebugMode) {
      print('DEBUG: getDeviceInfoString() final return: $deviceName');
    }
    return deviceName.trim().isEmpty ? 'Unknown Device' : deviceName.trim();
  }

  // Updated tryDecode to check Content-Type
  static Map<String, dynamic> tryDecode(http.Response response) {
    final String source = response.body;
    final int statusCode = response.statusCode;
    final String? contentType = response.headers['content-type'];

    if (source.isEmpty) {
      return {
        'success': false,
        'message':
            'Respons server kosong atau tidak ada. (Status Code: $statusCode)',
        'data': null,
      };
    }

    // Check if the content type is JSON before attempting to decode
    if (contentType == null || !contentType.contains('application/json')) {
      if (kDebugMode) {
        print(
          'Respons server bukan JSON. Content-Type: $contentType. Status: $statusCode. Body: "$source"',
        );
      }
      String message =
          'Format respons server tidak valid. Diterima $contentType bukan application/json. (Status Code: $statusCode)';
      // FIX: Added null check for contentType before calling .contains()
      if (contentType != null && contentType.contains('text/html')) {
        message =
            'Server mengembalikan halaman HTML, bukan JSON. Periksa konfigurasi server atau URL. (Status Code: $statusCode)';
      }
      return {
        'success': false,
        'message': message,
        'data': {'raw_body': source, 'content_type': contentType},
      };
    }

    try {
      final decoded = jsonDecode(source);
      if (decoded is Map<String, dynamic>) {
        if (kDebugMode && !decoded.containsKey('success')) {
          print(
            'Warning: Server response JSON tidak mengandung key "success". Status Code: $statusCode, Body: $source',
          );
        }
        return decoded;
      } else {
        return {
          'success': false,
          'message': 'Respons server JSON bukan objek Map yang diharapkan.',
          'data': {'raw_decoded_data': decoded},
        };
      }
    } on FormatException catch (e) {
      if (kDebugMode) {
        print(
          'Gagal decode JSON (FormatException): Status: $statusCode, Body: "$source", Error: $e',
        );
      }
      return {
        'success': false,
        'message':
            'Format respons server JSON tidak valid. (Status Code: $statusCode)',
        'data': {'raw_body': source, 'error_details': e.toString()},
      };
    } catch (e) {
      if (kDebugMode) {
        print(
          'Gagal decode JSON (Exception umum): Status: $statusCode, Body: "$source", Error: $e',
        );
      }
      return {
        'success': false,
        'message': 'Terjadi kesalahan saat menguraikan respons server JSON.',
        'data': {'raw_body': source, 'error_details': e.toString()},
      };
    }
  }

  static Map<String, dynamic> _errorResponse(
    String message, {
    dynamic data,
    int? statusCode,
  }) {
    if (kDebugMode) {
      print(
        'API Error: "$message" (Status: ${statusCode ?? 'N/A'}), Data: $data',
      );
    }
    return {'success': false, 'message': message, 'data': data};
  }

  // --- API Methods ---

  static Future<Map<String, dynamic>> registerUser({
    required String nama,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    if (password != confirmPassword) {
      return _errorResponse(
        'Password dan Konfirmasi Password tidak cocok.',
        statusCode: 400,
      );
    }

    final url = Uri.parse('$baseUrl/register');
    final requestBody = jsonEncode({
      'nama': nama,
      'email': email,
      'password': password,
      // 'confirm_password': confirmPassword, // Backend app.py tidak mengharapkan ini
    });
    if (kDebugMode) {
      print('Calling API Register URL: $url');
      print('Request Body: $requestBody');
    }
    try {
      final http.Response response = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json', // Client expects JSON
              'X-API-Key': apiKey,
            },
            body: requestBody,
          )
          .timeout(timeoutDuration);

      final body = tryDecode(response); // Pass the whole response object
      if (kDebugMode) {
        print(
          'Respons API Register: Status Code: ${response.statusCode}, Raw Body: ${response.body}',
        );
      }

      bool isSuccessFromServer = body['success'] == true;
      final dynamic responseData = body['data']; // Get the 'data' object

      // Check for successful registration (201 Created)
      if (response.statusCode == 201 && isSuccessFromServer) {
        // Server (app.py) sekarang mengembalikan data dalam format:
        // {"success": true, "message": "...", "data": {"user": {...}}}
        // Kita perlu mengekstrak objek 'user' dari dalam 'data'.
        if (responseData is Map<String, dynamic> &&
            responseData.containsKey('user') &&
            responseData['user'] is Map<String, dynamic>) {
          return {
            'success': true,
            'message':
                body['message'] as String? ??
                'Registrasi berhasil. Silakan cek email Anda.',
            'data':
                responseData['user']
                    as Map<String, dynamic>, // Mengembalikan objek user lengkap
          };
        } else {
          // Jika format data tidak sesuai harapan (misalnya, kunci 'user' hilang)
          return _errorResponse(
            'Format data pengguna tidak valid dari server setelah registrasi.',
            data: responseData, // Sertakan data yang bermasalah untuk debugging
            statusCode: response.statusCode,
          );
        }
      } else {
        // Use message from decoded body if available, otherwise a generic one
        return _errorResponse(
          body['message'] as String? ?? 'Registrasi gagal.',
          data: body['data'], // Include raw_body if decoding failed
          statusCode: response.statusCode,
        );
      }
    } on SocketException {
      return _errorResponse(
        'Tidak ada koneksi internet. Silakan periksa jaringan Anda.',
      );
    } on TimeoutException {
      return _errorResponse('Koneksi ke server timeout. Silakan coba lagi.');
    } catch (e) {
      if (kDebugMode) {
        print('Error saat registrasi: $e');
      }
      return _errorResponse(
        'Terjadi kesalahan saat registrasi. Silakan coba lagi nanti.',
      );
    }
  }

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/login');
    // Pastikan `device_info_plus` sudah ditambahkan ke pubspec.yaml
    // dan `flutter pub get` sudah dijalankan.
    // Juga pastikan import `package:device_info_plus/device_info_plus.dart` ada di paling atas.
    String deviceDetails = await getDeviceInfoString(); // Get device info
    final requestBody = jsonEncode({
      'email': email,
      'password': password,
      'device_details': deviceDetails, // Send device info to backend
    });
    if (kDebugMode) {
      print('Calling API Login URL: $url');
      print('Request Body: $requestBody');
    }

    try {
      final http.Response response = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'X-API-Key': apiKey,
            },
            body: requestBody,
          )
          .timeout(timeoutDuration);

      final body = tryDecode(response);
      if (kDebugMode) {
        print(
          'Respons API Login: Status Code: ${response.statusCode}, Raw Body: ${response.body}',
        );
      }

      bool isSuccessFromServer = body['success'] == true;
      final dynamic responseData = body['data'];

      if (response.statusCode == 200 &&
          isSuccessFromServer &&
          responseData is Map<String, dynamic> &&
          responseData.containsKey('token') &&
          responseData['token'] is String) {
        final token = responseData['token'] as String;
        await saveToken(token);

        // Perbaikan: Cek apakah ada kunci 'user' di dalam responseData.
        // Jika ada, kembalikan objek 'user' tersebut sebagai 'data'.
        // Ini mengasumsikan server mungkin mengembalikan data pengguna lengkap
        // bersama dengan token saat login.
        if (responseData.containsKey('user') &&
            responseData['user'] is Map<String, dynamic>) {
          return {
            'success': true,
            'message': body['message'] as String? ?? 'Login berhasil.',
            'data':
                responseData['user']
                    as Map<String, dynamic>, // Mengembalikan hanya objek user
          };
        } else {
          // Jika tidak ada kunci 'user', kembalikan seluruh responseData
          // (yang setidaknya berisi token).
          return {
            'success': true,
            'message': body['message'] as String? ?? 'Login berhasil.',
            'data':
                responseData, // Mengembalikan responseData asli (termasuk token)
          };
        }
      } else {
        if (body['action_required'] == 'verify_otp' &&
            body['email'] is String) {
          return {
            'success': false,
            'message':
                body['message'] as String? ??
                'Email belum diverifikasi. Silakan verifikasi akun Anda.',
            'action_required': 'verify_otp',
            'data': {
              'email': body['email'] as String,
            }, // Pass the email for OTP screen
          };
        }
        return _errorResponse(
          body['message'] as String? ??
              'Login gagal. Email atau password salah.',
          data: body['data'],
          statusCode: response.statusCode,
        );
      }
    } on SocketException {
      return _errorResponse(
        'Tidak ada koneksi internet. Silakan periksa jaringan Anda.',
      );
    } on TimeoutException {
      return _errorResponse('Koneksi ke server timeout. Silakan coba lagi.');
    } catch (e) {
      if (kDebugMode) {
        print('Error saat login: $e');
      }
      return _errorResponse(
        'Terjadi kesalahan saat login. Silakan coba lagi nanti.',
      );
    }
  }

  static Future<Map<String, dynamic>> verifyOtp({
    required String email,
    required String otp,
    String? type,
  }) async {
    final url = Uri.parse('$baseUrl/verify-otp');
    final requestBody = jsonEncode({
      'email': email,
      'otp_code': otp, // FIX: Changed key from 'otp' to 'otp_code'
      if (type != null) 'type': type,
    });
    if (kDebugMode) {
      print('Calling API Verify OTP URL: $url');
      print('Request Body: $requestBody');
    }
    try {
      final http.Response response = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'X-API-Key': apiKey,
            },
            body: requestBody,
          )
          .timeout(timeoutDuration);

      final body = tryDecode(response);
      if (kDebugMode) {
        print(
          'Respons API verifyOtp: Status Code: ${response.statusCode}, Raw Body: ${response.body}',
        );
      }

      bool isSuccessFromServer = body['success'] == true;
      final dynamic responseData = body['data'];

      if (response.statusCode == 200 && isSuccessFromServer) {
        // Hapus logika saveToken di sini karena token hanya didapat saat login.
        // if (type == 'register' &&
        //     responseData is Map<String, dynamic> &&
        //     responseData.containsKey('token') &&
        //     responseData['token'] is String) {
        //   final token = responseData['token'] as String;
        //   await saveToken(token);
        // }
        return {
          'success': true,
          'message': body['message'] as String? ?? 'OTP berhasil diverifikasi.',
          'data': responseData,
        };
      } else {
        // Menambahkan penanganan khusus untuk status 400 (Bad Request)
        // yang mungkin mengindikasikan OTP tidak valid
        if (response.statusCode == 400) {
          return _errorResponse(
            body['message'] as String? ?? 'Kode OTP tidak valid.',
            data: body['data'],
            statusCode: response.statusCode,
          );
        }
        return _errorResponse(
          body['message'] as String? ?? 'Verifikasi OTP gagal.',
          data: body['data'],
          statusCode: response.statusCode,
        );
      }
    } on SocketException {
      return _errorResponse('Tidak ada koneksi internet.');
    } on TimeoutException {
      return _errorResponse('Koneksi ke server timeout.');
    } catch (e) {
      if (kDebugMode) {
        print('Error saat verifikasi OTP: $e');
      }
      return _errorResponse('Terjadi kesalahan saat verifikasi OTP.');
    }
  }

  // Metode ini memanggil endpoint '/send-otp' yang baru di server Flask Anda.
  static Future<Map<String, dynamic>> resendOtp({required String email}) async {
    final url = Uri.parse(
      '$baseUrl/send-otp',
    ); // Mengarah ke endpoint /send-otp di server Flask
    final requestBody = jsonEncode({'email': email});
    if (kDebugMode) {
      print('Calling API Resend OTP URL: $url');
      print('Request Body: $requestBody');
    }
    try {
      final http.Response response = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'X-API-Key': apiKey,
            },
            body: requestBody,
          )
          .timeout(timeoutDuration);

      final body = tryDecode(response);
      if (kDebugMode) {
        print(
          'Respons API Resend OTP: Status Code: ${response.statusCode}, Raw Body: ${response.body}',
        );
      }

      bool isSuccessFromServer = body['success'] == true;

      if (response.statusCode == 200 && isSuccessFromServer) {
        return {
          'success': true,
          'message':
              body['message'] as String? ?? 'OTP berhasil dikirim ulang.',
          'data': body['data'], // Pass through any data from server
        };
      } else {
        // Menambahkan penanganan khusus untuk status 500 (Internal Server Error)
        // yang mungkin mengindikasikan masalah di server saat mengirim OTP
        if (response.statusCode == 500) {
          return _errorResponse(
            body['message'] as String? ??
                'Gagal mengirim OTP. Silakan coba lagi nanti.',
            data: body['data'],
            statusCode: response.statusCode,
          );
        }
        return _errorResponse(
          body['message'] as String? ?? 'Gagal mengirim ulang OTP.',
          data: body['data'],
          statusCode: response.statusCode,
        );
      }
    } on SocketException {
      return _errorResponse('Tidak ada koneksi internet.');
    } on TimeoutException {
      return _errorResponse('Koneksi ke server timeout.');
    } catch (e) {
      if (kDebugMode) {
        print('Error saat kirim ulang OTP: $e');
      }
      return _errorResponse('Terjadi kesalahan saat mengirim ulang OTP.');
    }
  }

  static Future<Map<String, dynamic>> loginWithGoogle({
    required String idToken,
  }) async {
    // FIX: Changed endpoint to match Flask backend's /login-google
    final url = Uri.parse('$baseUrl/login-google');
    String deviceDetails = await getDeviceInfoString(); // Get device info
    Map<String, dynamic> requestBodyMap = {
      'id_token': idToken,
      'device_details': deviceDetails, // Send device info to backend
    };

    if (kDebugMode) {
      print('Calling API loginWithGoogle URL: $url');
      print('Request Body: ${jsonEncode(requestBodyMap)}');
    }

    try {
      final http.Response response = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'X-API-Key': apiKey,
            },
            body: jsonEncode(requestBodyMap),
          )
          .timeout(timeoutDuration);

      final body = tryDecode(response);
      if (kDebugMode) {
        print(
          'Respons API loginWithGoogle: Status Code: ${response.statusCode}, Raw Body: ${response.body}',
        );
        print('Decoded Body (loginWithGoogle): $body'); // Added for debugging
      }

      bool isSuccessFromServer = body['success'] == true;
      final dynamic responseData = body['data'];

      // Perbaikan: Prioritaskan flag 'success' dari server.
      // Jika server menyatakan sukses, kita akan menganggapnya sukses di sini.
      if (isSuccessFromServer) {
        String message = body['message'] as String? ?? 'Login Google berhasil.';
        Map<String, dynamic>? userData;
        String? token;

        if (responseData is Map<String, dynamic>) {
          token = responseData['token'] as String?;
          if (token != null) {
            await saveToken(token);
          } else if (kDebugMode) {
            print(
              'Warning: Token not found in successful Google login response data.',
            );
          }

          if (responseData.containsKey('user') &&
              responseData['user'] is Map<String, dynamic>) {
            userData = responseData['user'] as Map<String, dynamic>;
          } else if (kDebugMode) {
            print(
              'Warning: User data not found or invalid in successful Google login response data.',
            );
          }
        } else if (kDebugMode) {
          print(
            'Warning: Response data is not a Map in successful Google login.',
          );
        }

        return {
          'success': true,
          'message': message,
          'data':
              userData ??
              responseData, // Prioritize user data, fallback to raw responseData
        };
      } else {
        // Jika server secara eksplisit mengatakan itu bukan sukses
        if (kDebugMode) {
          print(
            'Login Google gagal. Status Code: ${response.statusCode}, Pesan: ${body['message']}, Data: ${body['data']}',
          );
        }
        return _errorResponse(
          body['message'] as String? ?? 'Login dengan Google gagal.',
          data: body['data'],
          statusCode: response.statusCode,
        );
      }
    } on SocketException {
      return _errorResponse(
        'Tidak ada koneksi internet. Silakan periksa jaringan Anda.',
      );
    } on TimeoutException {
      return _errorResponse('Koneksi ke server timeout. Silakan coba lagi.');
    } // ignore: avoid_catches_without_on_clauses
    catch (e) {
      if (kDebugMode) {
        print('Error saat login Google: $e');
      }
      return _errorResponse(
        'Terjadi kesalahan saat login dengan Google. Silakan coba lagi nanti.',
      );
    }
  }

  // NEW METHOD: Handle Google Sign Out
  static Future<Map<String, dynamic>> signOutGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      if (await googleSignIn.isSignedIn()) {
        // Use disconnect() instead of signOut() to force account selection on next login
        await googleSignIn.disconnect();
        if (kDebugMode) {
          print(
            'Google account disconnected successfully. Will prompt for email selection next time.',
          );
        }
        return {
          'success': true,
          'message': 'Berhasil keluar dari akun Google.',
        };
      } else {
        if (kDebugMode) {
          print('Google account was not signed in.');
        }
        return {
          'success': true,
          'message': 'Tidak ada akun Google yang terhubung.',
        };
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error during Google disconnect: $e');
      }
      return _errorResponse('Terjadi kesalahan saat keluar dari akun Google.');
    }
  }

  // NEW METHOD: Combined Logout for both app token and Google (if applicable)
  static Future<Map<String, dynamic>> logout() async {
    // First, remove the application's internal token
    await removeToken(); // This method already exists
    if (kDebugMode) {
      print('Aplikasi token berhasil dihapus.');
    }

    // Then, attempt to sign out from Google
    final googleSignOutResult =
        await signOutGoogle(); // Call the new Google specific logout
    if (!googleSignOutResult['success'] && kDebugMode) {
      print(
        'Peringatan: Gagal keluar dari Google: ${googleSignOutResult['message']}',
      );
    }

    return {'success': true, 'message': 'Berhasil logout dari aplikasi.'};
  }

  static Future<Map<String, dynamic>> revalidateToken() async {
    final token = await getToken();
    if (token == null) {
      return _errorResponse(
        'Tidak ada token yang tersimpan. Pengguna perlu login.',
      );
    }
    if (kDebugMode) {
      print('Revalidating token by calling getProfile.');
    }
    return getProfile();
  }

  static Future<Map<String, dynamic>> getProfile() async {
    final token = await getToken();
    if (token == null) {
      return _errorResponse('Sesi tidak valid atau Anda belum login.');
    }

    final url = Uri.parse('$baseUrl/profile');
    if (kDebugMode) {
      print('Calling API Get Profile URL: $url');
    }

    try {
      final http.Response response = await http
          .get(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
              'X-API-Key': apiKey,
            },
          )
          .timeout(timeoutDuration);

      final body = tryDecode(response);
      if (kDebugMode) {
        print(
          'Respons API Get Profile: Status Code: ${response.statusCode}, Raw Body: ${response.body}',
        );
      }

      bool isSuccessFromServer = body['success'] == true;
      final dynamic responseData =
          body['data']; // This is the Map: {"materi": []}

      if (response.statusCode == 200 &&
          isSuccessFromServer &&
          responseData is Map<String, dynamic> &&
          responseData.containsKey('user')) {
        final userProfileData = responseData['user'];
        if (userProfileData is Map<String, dynamic>) {
          return {
            'success': true,
            'message': body['message'] as String? ?? 'Profil berhasil diambil.',
            'data': userProfileData,
          };
        } else {
          return _errorResponse(
            'Format data profil (user) tidak valid dari server.',
            data: body['data'],
            statusCode: response.statusCode,
          );
        }
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        await removeToken();
        return _errorResponse(
          body['message'] as String? ??
              'Sesi Anda telah berakhir atau akun belum diverifikasi, silakan login kembali.',
          data: body['data'],
          statusCode: response.statusCode,
        );
      } else {
        return _errorResponse(
          body['message'] as String? ?? 'Gagal mengambil profil.',
          data: body['data'],
          statusCode: response.statusCode,
        );
      }
    } on SocketException {
      return _errorResponse('Tidak ada koneksi internet.');
    } on TimeoutException {
      return _errorResponse('Koneksi ke server timeout.');
    } catch (e) {
      if (kDebugMode) {
        print('Exception saat ambil profil: $e');
      }
      return _errorResponse('Gagal mengambil profil: Terjadi kesalahan.');
    }
  }

  static Future<Map<String, dynamic>> updateProfile({
    String? nama,
    String? currentPassword,
    String? newPassword,
    String? confirmNewPassword,
  }) async {
    final token = await getToken();
    if (token == null) {
      return _errorResponse('Sesi tidak valid atau Anda belum login.');
    }

    final url = Uri.parse('$baseUrl/profile');
    Map<String, dynamic> bodyDataToSend = {};

    if (nama != null && nama.isNotEmpty) {
      bodyDataToSend['nama'] = nama;
    }

    if (currentPassword != null ||
        newPassword != null ||
        confirmNewPassword != null) {
      if (currentPassword == null ||
          newPassword == null ||
          confirmNewPassword == null) {
        return _errorResponse(
          'Untuk mengubah password, password saat ini, password baru, dan konfirmasi password baru harus diisi.',
          statusCode: 400,
        );
      }
      if (newPassword != confirmNewPassword) {
        return _errorResponse(
          'Password baru dan Konfirmasi Password baru tidak cocok.',
          statusCode: 400,
        );
      }
      bodyDataToSend['current_password'] = currentPassword;
      bodyDataToSend['new_password'] = newPassword;
      // FIX: Corrected typo from 'confirm_new_new_password' to 'confirm_new_password'
      bodyDataToSend['confirm_new_password'] = confirmNewPassword;
    }

    if (bodyDataToSend.isEmpty) {
      // FIX: Changed 'success' to false and provided a more informative message.
      return {
        'success': false,
        'message':
            'Tidak ada data yang disediakan untuk diperbarui. Harap isi setidaknya satu kolom untuk memperbarui profil.',
        'data': null,
      };
    }

    final requestBody = jsonEncode(bodyDataToSend);
    if (kDebugMode) {
      print('Calling API Update Profile URL: $url');
      print('Request Body: $requestBody'); // Added for debugging
    }

    try {
      final http.Response response = await http
          .put(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
              'X-API-Key': apiKey,
            },
            body: requestBody,
          )
          .timeout(timeoutDuration);

      final body = tryDecode(response);
      if (kDebugMode) {
        print(
          'Respons API Update Profile: Status Code: ${response.statusCode}, Raw Body: ${response.body}',
        );
      }

      bool isSuccessFromServer = body['success'] == true;
      final dynamic responseData = body['data'];

      if (response.statusCode == 200 && isSuccessFromServer) {
        // PERHATIAN: Respons dari endpoint profile PUT sekarang mengembalikan objek user.
        // Jika Anda sebelumnya mengharapkan 'materi' di sini, itu adalah salah.
        // Asumsi: 'data' langsung berisi objek user yang diupdate.
        if (responseData is Map<String, dynamic> &&
            responseData.containsKey('user') && // Pastikan ada kunci 'user'
            responseData['user'] is Map<String, dynamic>) {
          final Map<String, dynamic> updatedUserData =
              responseData['user'] as Map<String, dynamic>;
          return {
            'success': true,
            'message':
                body['message'] as String? ?? 'Profil berhasil diperbarui.',
            'data': updatedUserData, // Mengembalikan objek user yang diupdate
          };
        } else {
          return _errorResponse(
            'Format data profil yang diperbarui tidak valid dari server (kunci "user" tidak ditemukan atau bukan objek).',
            data: responseData,
            statusCode: response.statusCode,
          );
        }
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        await removeToken();
        return _errorResponse(
          body['message'] as String? ??
              'Sesi Anda telah berakhir, silakan login kembali.',
          data: body['data'],
          statusCode: response.statusCode,
        );
      } else {
        return _errorResponse(
          body['message'] as String? ?? 'Gagal memperbarui profil.',
          data: body['data'],
          statusCode: response.statusCode,
        );
      }
    } on SocketException {
      return _errorResponse('Tidak ada koneksi internet.');
    } on TimeoutException {
      return _errorResponse('Koneksi ke server timeout.');
    } // ignore: avoid_catches_without_on_clauses
    catch (e) {
      if (kDebugMode) {
        print('Error saat update profil: $e');
      }
      return _errorResponse('Terjadi kesalahan saat memperbarui profil.');
    }
  }

  // NEW METHOD: Meminta OTP reset password
  static Future<Map<String, dynamic>> requestPasswordResetOtp({
    required String email,
  }) async {
    final url = Uri.parse(
      '$baseUrl/forgot-password',
    ); // Endpoint /forgot-password di server Flask
    final requestBody = jsonEncode({'email': email});
    if (kDebugMode) {
      print('Calling API Request Password Reset OTP URL: $url');
      print('Request Body: $requestBody');
    }
    try {
      final http.Response response = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'X-API-Key': apiKey,
            },
            body: requestBody,
          )
          .timeout(timeoutDuration);

      final body = tryDecode(response);
      if (kDebugMode) {
        print(
          'Respons API Request Password Reset OTP: Status Code: ${response.statusCode}, Raw Body: ${response.body}',
        );
      }

      bool isSuccessFromServer = body['success'] == true;

      if (response.statusCode == 200 && isSuccessFromServer) {
        return {
          'success': true,
          'message':
              body['message'] as String? ??
              'Kode OTP untuk reset password telah dikirim.',
          'data': body['data'],
        };
      } else {
        return _errorResponse(
          body['message'] as String? ??
              'Gagal mengirim permintaan OTP reset password.',
          data: body['data'],
          statusCode: response.statusCode,
        );
      }
    } on SocketException {
      return _errorResponse(
        'Tidak ada koneksi internet. Silakan periksa jaringan Anda.',
      );
    } on TimeoutException {
      return _errorResponse('Koneksi ke server timeout. Silakan coba lagi.');
    } // ignore: avoid_catches_without_on_clauses
    catch (e) {
      if (kDebugMode) {
        print('Error saat meminta OTP reset password: $e');
      }
      return _errorResponse(
        'Terjadi kesalahan saat meminta OTP reset password.',
      );
    }
  }

  // NEW METHOD: Memverifikasi OTP reset password dan mendapatkan reset_token
  static Future<Map<String, dynamic>> verifyPasswordResetOtp({
    required String email,
    required String otp,
  }) async {
    final url = Uri.parse('$baseUrl/verify-reset-otp');
    final requestBody = jsonEncode({
      'email': email,
      'otp_code': otp, // Menggunakan 'otp_code' sesuai dengan Flask backend
    });

    if (kDebugMode) {
      print('Calling API Verify Password Reset OTP URL: $url');
      print('Request Body: $requestBody');
    }

    try {
      final http.Response response = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'X-API-Key': apiKey,
            },
            body: requestBody,
          )
          .timeout(timeoutDuration);

      final body = tryDecode(response);
      if (kDebugMode) {
        print(
          'Respons API Verify Password Reset OTP: Status Code: ${response.statusCode}, Raw Body: ${response.body}',
        );
      }

      bool isSuccessFromServer = body['success'] == true;
      final dynamic responseData = body['data'];

      if (response.statusCode == 200 &&
          isSuccessFromServer &&
          responseData is Map<String, dynamic> &&
          responseData.containsKey('reset_token') &&
          responseData['reset_token'] is String) {
        return {
          'success': true,
          'message':
              body['message'] as String? ??
              'Kode OTP berhasil diverifikasi. Silakan lanjutkan untuk mereset password.',
          'data': responseData, // Mengandung 'reset_token'
        };
      } else {
        return _errorResponse(
          body['message'] as String? ??
              'Gagal memverifikasi OTP reset password.',
          data: body['data'],
          statusCode: response.statusCode,
        );
      }
    } on SocketException {
      return _errorResponse(
        'Tidak ada koneksi internet. Periksa koneksi Anda.',
      );
    } on TimeoutException {
      return _errorResponse('Koneksi ke server timeout. Silakan coba lagi.');
    } catch (e) {
      if (kDebugMode) {
        print('Error saat verifikasi OTP reset password: $e');
      }
      return _errorResponse(
        'Terjadi kesalahan saat memverifikasi OTP reset password.',
      );
    }
  }

  // NEW METHOD: Mereset password menggunakan reset_token
  static Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String resetToken, // Parameter baru: resetToken
    required String newPassword,
    required String confirmNewPassword,
  }) async {
    final url = Uri.parse('$baseUrl/reset-password');
    final requestBody = jsonEncode({
      'email': email,
      'reset_token': resetToken, // Menggunakan 'reset_token'
      'new_password': newPassword,
      'confirm_new_password': confirmNewPassword,
    });

    if (kDebugMode) {
      print('Calling API Reset Password URL: $url');
      print('Request Body: $requestBody');
    }

    try {
      final http.Response response = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'X-API-Key': apiKey,
            },
            body: requestBody,
          )
          .timeout(timeoutDuration);

      final body = tryDecode(response);
      if (kDebugMode) {
        print(
          'Respons API Reset Password: Status Code: ${response.statusCode}, Raw Body: ${response.body}',
        );
      }

      bool isSuccessFromServer = body['success'] == true;

      if (response.statusCode == 200 && isSuccessFromServer) {
        return {
          'success': true,
          'message':
              body['message'] as String? ??
              'Password berhasil direset. Silakan login.',
          'data': body['data'],
        };
      } else {
        return _errorResponse(
          body['message'] as String? ?? 'Gagal mereset password.',
          data: body['data'],
          statusCode: response.statusCode,
        );
      }
    } on SocketException {
      return _errorResponse(
        'Tidak ada koneksi internet. Periksa koneksi Anda.',
      );
    } on TimeoutException {
      return _errorResponse('Koneksi ke server timeout. Silakan coba lagi.');
    } // ignore: avoid_catches_without_on_clauses
    catch (e) {
      if (kDebugMode) {
        print('Error saat reset password: $e');
      }
      return _errorResponse('Terjadi kesalahan saat mereset password.');
    }
  }

  static Future<Map<String, dynamic>> getMateri() async {
    final token = await getToken();
    if (token == null) {
      return _errorResponse(
        'Sesi tidak valid atau Anda belum login untuk mengakses materi.',
      );
    }

    final url = Uri.parse('$baseUrl/materi');
    if (kDebugMode) {
      print('Calling API Get Materi URL: $url');
    }

    try {
      final http.Response response = await http
          .get(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
              'X-API-Key': apiKey,
            },
          )
          .timeout(timeoutDuration);

      final body = tryDecode(response);
      if (kDebugMode) {
        print(
          'Respons API Get Materi: Status Code: ${response.statusCode}, Raw Body: ${response.body}',
        );
      }

      bool isSuccessFromServer = body['success'] == true;
      final dynamic responseData =
          body['data']; // This is the Map: {"materi": []}

      if (response.statusCode == 200 && isSuccessFromServer) {
        // PENTING: Server mengembalikan {"data": {"materi": [...]}}.
        // Kode ini mengekstrak list 'materi' dari objek 'data'.
        // Jika tidak ada materi, 'materiListFromServer' akan menjadi list kosong `[]`.
        if (responseData is Map<String, dynamic> &&
            responseData.containsKey('materi') &&
            responseData['materi'] is List) {
          final List<dynamic> materiListFromServer =
              responseData['materi'] as List<dynamic>;
          if (kDebugMode) {
            print(
              'Materi berhasil diekstrak. Jumlah materi: ${materiListFromServer.length}, Data: $materiListFromServer',
            );
          }
          return {
            'success': true,
            'message':
                body['message'] as String? ?? 'Data materi berhasil diambil.',
            'data':
                materiListFromServer, // Mengembalikan List materi (bisa kosong)
          };
        } else {
          // Jika format 'data' tidak sesuai harapan (bukan Map dengan kunci 'materi' berupa List)
          return _errorResponse(
            'Format data materi tidak valid dari server (kunci "materi" tidak ditemukan atau bukan List).',
            data: responseData, // Sertakan data yang bermasalah untuk debugging
            statusCode: response.statusCode,
          );
        }
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        await removeToken();
        return _errorResponse(
          body['message'] as String? ??
              'Sesi Anda telah berakhir atau tidak valid untuk mengakses materi.',
          data: body['data'],
          statusCode: response.statusCode,
        );
      } else {
        return _errorResponse(
          body['message'] as String? ?? 'Gagal mengambil data materi.',
          data: body['data'],
          statusCode: response.statusCode,
        );
      }
    } on SocketException {
      return _errorResponse('Tidak ada koneksi internet.');
    } on TimeoutException {
      return _errorResponse('Koneksi ke server timeout.');
    } // ignore: avoid_catches_without_on_clauses
    catch (e) {
      if (kDebugMode) {
        print('Exception saat ambil materi: $e');
      }
      return _errorResponse('Gagal mengambil data materi: Terjadi kesalahan.');
    }
  }

  // --- New API Methods for single Materi item ---

  static Future<Map<String, dynamic>> getMateriById(String materiId) async {
    final token = await getToken();
    if (token == null) {
      return _errorResponse(
        'Sesi tidak valid atau Anda belum login untuk mengakses materi.',
      );
    }

    final url = Uri.parse('$baseUrl/materi/$materiId');
    if (kDebugMode) {
      print('Calling API Get Materi By ID URL: $url');
    }

    try {
      final http.Response response = await http
          .get(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
              'X-API-Key': apiKey,
            },
          )
          .timeout(timeoutDuration);

      final body = tryDecode(response);
      if (kDebugMode) {
        print(
          'Respons API Get Materi By ID: Status Code: ${response.statusCode}, Raw Body: ${response.body}',
        );
      }

      bool isSuccessFromServer = body['success'] == true;
      final dynamic responseData = body['data'];

      if (response.statusCode == 200 && isSuccessFromServer) {
        // Server mengembalikan {"data": {"materi": {...}}}
        if (responseData is Map<String, dynamic> &&
            responseData.containsKey('materi') &&
            responseData['materi'] is Map<String, dynamic>) {
          final Map<String, dynamic> materiItem =
              responseData['materi'] as Map<String, dynamic>;
          return {
            'success': true,
            'message': body['message'] as String? ?? 'Materi berhasil diambil.',
            'data': materiItem, // Mengembalikan satu objek materi
          };
        } else {
          return _errorResponse(
            'Format data materi tidak valid dari server (kunci "materi" tidak ditemukan atau bukan objek).',
            data: responseData,
            statusCode: response.statusCode,
          );
        }
      } else if (response.statusCode == 404) {
        return _errorResponse(
          body['message'] as String? ?? 'Materi tidak ditemukan.',
          data: body['data'],
          statusCode: response.statusCode,
        );
      } else if (response.statusCode == 400) {
        return _errorResponse(
          body['message'] as String? ?? 'ID materi tidak valid.',
          data: body['data'],
          statusCode: response.statusCode,
        );
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        await removeToken();
        return _errorResponse(
          body['message'] as String? ??
              'Sesi Anda telah berakhir atau tidak valid untuk mengakses materi ini.',
          data: body['data'],
          statusCode: response.statusCode,
        );
      } else {
        return _errorResponse(
          body['message'] as String? ?? 'Gagal mengambil materi.',
          data: body['data'],
          statusCode: response.statusCode,
        );
      }
    } on SocketException {
      return _errorResponse('Tidak ada koneksi internet.');
    } on TimeoutException {
      return _errorResponse('Koneksi ke server timeout.');
    } // ignore: avoid_catches_without_on_clauses
    catch (e) {
      if (kDebugMode) {
        print('Exception saat ambil materi berdasarkan ID: $e');
      }
      return _errorResponse(
        'Gagal mengambil materi berdasarkan ID: Terjadi kesalahan.',
      );
    }
  }

  static Future<Map<String, dynamic>> updateMateri(
    String materiId, {
    String? title,
    String? description,
    String? youtubeLink,
  }) async {
    final token = await getToken();
    if (token == null) {
      return _errorResponse(
        'Sesi tidak valid atau Anda belum login untuk memperbarui materi.',
      );
    }

    final url = Uri.parse('$baseUrl/materi/$materiId');
    Map<String, dynamic> bodyDataToSend = {};

    if (title != null && title.isNotEmpty) {
      bodyDataToSend['title'] = title;
    }
    if (description != null && description.isNotEmpty) {
      bodyDataToSend['description'] = description;
    }
    if (youtubeLink != null && youtubeLink.isNotEmpty) {
      bodyDataToSend['youtube_link'] = youtubeLink;
    }

    if (bodyDataToSend.isEmpty) {
      return {
        'success': false,
        'message': 'Tidak ada data yang disediakan untuk diperbarui.',
        'data': null,
      };
    }

    final requestBody = jsonEncode(bodyDataToSend);
    if (kDebugMode) {
      print('Calling API Update Materi URL: $url');
    }

    try {
      final http.Response response = await http
          .put(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
              'X-API-Key': apiKey,
            },
            body: requestBody,
          )
          .timeout(timeoutDuration);

      final body = tryDecode(response);
      if (kDebugMode) {
        print(
          'Respons API Update Materi: Status Code: ${response.statusCode}, Raw Body: ${response.body}',
        );
      }

      bool isSuccessFromServer = body['success'] == true;
      final dynamic responseData = body['data'];

      if (response.statusCode == 200 && isSuccessFromServer) {
        if (responseData is Map<String, dynamic> &&
            responseData.containsKey('materi') &&
            responseData['materi'] is Map<String, dynamic>) {
          final Map<String, dynamic> updatedMateriItem =
              responseData['materi'] as Map<String, dynamic>;
          return {
            'success': true,
            'message':
                body['message'] as String? ?? 'Materi berhasil diperbarui.',
            'data': updatedMateriItem,
          };
        } else {
          return _errorResponse(
            'Format data materi yang diperbarui tidak valid dari server.',
            data: responseData,
            statusCode: response.statusCode,
          );
        }
      } else if (response.statusCode == 404) {
        return _errorResponse(
          body['message'] as String? ?? 'Materi tidak ditemukan.',
          data: body['data'],
          statusCode: response.statusCode,
        );
      } else if (response.statusCode == 400) {
        return _errorResponse(
          body['message'] as String? ??
              'ID materi atau format link YouTube tidak valid.',
          data: body['data'],
          statusCode: response.statusCode,
        );
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        await removeToken();
        return _errorResponse(
          body['message'] as String? ??
              'Anda tidak diizinkan untuk memperbarui materi ini atau sesi telah berakhir.',
          data: body['data'],
          statusCode: response.statusCode,
        );
      } else {
        return _errorResponse(
          body['message'] as String? ?? 'Gagal memperbarui materi.',
          data: body['data'],
          statusCode: response.statusCode,
        );
      }
    } on SocketException {
      return _errorResponse('Tidak ada koneksi internet.');
    } on TimeoutException {
      return _errorResponse('Koneksi ke server timeout.');
    } // ignore: avoid_catches_without_on_clauses
    catch (e) {
      if (kDebugMode) {
        print('Exception saat update materi: $e');
      }
      return _errorResponse('Gagal memperbarui materi: Terjadi kesalahan.');
    }
  }

  // NEW METHOD: Send message to chatbot endpoint
  static Future<Map<String, dynamic>> sendMessageToChatbot(
    String message,
  ) async {
    final url = Uri.parse('$baseUrl/chatbot'); // Endpoint chatbot di Flask
    final requestBody = jsonEncode({'message': message});

    if (kDebugMode) {
      print('Calling API Chatbot URL: $url');
      print('Request Body: $requestBody');
    }

    try {
      final http.Response response = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'X-API-Key': apiKey,
              // Tambahkan Authorization header jika endpoint chatbot di Flask dilindungi JWT
              // 'Authorization': 'Bearer ${await getToken()}',
            },
            body: requestBody,
          )
          .timeout(timeoutDuration);

      final body = tryDecode(response);
      if (kDebugMode) {
        print(
          'Respons API Chatbot: Status Code: ${response.statusCode}, Raw Body: ${response.body}',
        );
      }

      bool isSuccessFromServer = body['success'] == true;
      final dynamic responseData = body['data'];

      if (response.statusCode == 200 &&
          isSuccessFromServer &&
          responseData is Map<String, dynamic> &&
          responseData.containsKey('response') &&
          responseData['response'] is String) {
        return {
          'success': true,
          'message': body['message'] as String? ?? 'Pesan chatbot berhasil.',
          'data':
              responseData['response']
                  as String, // Mengembalikan respons chatbot
        };
      } else {
        return _errorResponse(
          body['message'] as String? ?? 'Gagal mendapatkan respons chatbot.',
          data: body['data'],
          statusCode: response.statusCode,
        );
      }
    } on SocketException {
      return _errorResponse('Tidak ada koneksi internet.');
    } on TimeoutException {
      return _errorResponse('Koneksi ke server timeout.');
    } catch (e) {
      if (kDebugMode) {
        print('Error saat mengirim pesan ke chatbot: $e');
      }
      return _errorResponse(
        'Terjadi kesalahan saat berinteraksi dengan chatbot.',
      );
    }
  }
}
