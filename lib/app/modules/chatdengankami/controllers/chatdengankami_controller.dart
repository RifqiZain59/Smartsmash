import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:smartsmashapp/app/data/service/api_service.dart'; // Import ini diperlukan untuk interaksi API

// Model untuk setiap pesan obrolan
class ChatMessage {
  final String sender; // Siapa yang mengirim pesan (misal: 'User', 'Admin')
  final String message; // Konten pesan
  final DateTime timestamp; // Waktu pesan dikirim

  ChatMessage({
    required this.sender,
    required this.message,
    required this.timestamp,
  });
}

class ChatdengankamiController extends GetxController {
  // Observable list untuk menyimpan pesan-pesan obrolan
  // .obs membuat list ini reaktif, sehingga UI akan otomatis diperbarui saat ada perubahan
  final RxList<ChatMessage> messages = <ChatMessage>[].obs;

  // Controller untuk input teks pesan
  final TextEditingController messageInputController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    // Menambahkan pesan sambutan dari chatbot saat inisialisasi
    // Pesan ini akan muncul di awal daftar (paling atas jika ListView tidak dibalik)
    messages.add(
      ChatMessage(
        sender: 'Admin',
        message:
            'Halo! Saya chatbot SMART SMASH. Ada yang bisa saya bantu terkait materi badminton?',
        timestamp: DateTime.now(),
      ),
    );
  }

  // Fungsi untuk mengirim pesan baru
  void sendMessage() async {
    // Memastikan pesan tidak kosong setelah di-trim (menghilangkan spasi di awal/akhir)
    if (messageInputController.text.trim().isNotEmpty) {
      final userMessage = messageInputController.text.trim();

      // Menambahkan pesan user ke daftar pesan (akan muncul di bagian bawah)
      messages.add(
        ChatMessage(
          sender: 'User',
          message: userMessage,
          timestamp: DateTime.now(),
        ),
      );

      // Mengosongkan input teks setelah pesan dikirim
      messageInputController.clear();

      try {
        // Panggil API untuk mengirim pesan ke chatbot
        final response = await ApiService.sendMessageToChatbot(userMessage);

        if (response['success'] == true) {
          final chatbotResponse =
              response['data'] as String; // Ambil respons dari 'data'
          messages.add(
            // Tambahkan respons chatbot di akhir daftar
            ChatMessage(
              sender: 'Admin',
              message: chatbotResponse,
              timestamp: DateTime.now(),
            ),
          );
        } else {
          // Tangani error jika chatbot gagal merespons
          final errorMessage =
              response['message'] as String? ??
              'Gagal mendapatkan respons dari chatbot.';
          messages.add(
            // Tambahkan pesan error di akhir daftar
            ChatMessage(
              sender: 'Admin',
              message: 'Error: $errorMessage',
              timestamp: DateTime.now(),
            ),
          );
        }
      } catch (e) {
        // Tangani error jika terjadi masalah pada koneksi atau API
        messages.add(
          ChatMessage(
            sender: 'Admin',
            message: 'Terjadi kesalahan jaringan atau server: $e',
            timestamp: DateTime.now(),
          ),
        );
      }
    }
  }

  // Fungsi untuk menghapus riwayat chat
  void clearChatHistory() {
    messages.clear(); // Menghapus semua pesan dari daftar
    // Opsional: Tambahkan kembali pesan sambutan setelah dihapus
    messages.add(
      ChatMessage(
        sender: 'Admin',
        message:
            'Halo! Saya chatbot SMART SMASH. Ada yang bisa saya bantu terkait materi Tenis Meja?',
        timestamp: DateTime.now(),
      ),
    );
  }

  @override
  void onClose() {
    // Membuang (dispose) TextEditingController saat controller tidak lagi digunakan
    // Ini penting untuk mencegah kebocoran memori
    messageInputController.dispose();
    super.onClose();
  }
}
