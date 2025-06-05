import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/chatdengankami_controller.dart';

class ChatdengankamiView extends GetView<ChatdengankamiController> {
  const ChatdengankamiView({super.key});

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();

    ever(controller.messages, (_) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController.hasClients) {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Chat Dengan Kami',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            tooltip: 'Bersihkan riwayat obrolan',
            onPressed: () => controller.clearChatHistory(),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(
              () => ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.all(8.0),
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final message = controller.messages[index];
                  return _buildMessageRow(message);
                },
              ),
            ),
          ),
          const Divider(height: 1, color: Colors.grey),
          _buildMessageInput(context),
        ],
      ),
    );
  }

  /// Membangun satu baris pesan, menangani perataan dan avatar.
  Widget _buildMessageRow(ChatMessage message) {
    final bool isMe = message.sender == 'User';
    final bool isChatbotMessage = message.sender == 'Admin';

    final Widget? avatar =
        isChatbotMessage
            ? const Padding(
              // Tambahkan sedikit bottom padding untuk avatar
              padding: EdgeInsets.only(right: 8.0, bottom: 1.0),
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.smart_toy, // Ikon robot untuk chatbot
                  color: Colors.blue,
                  size: 20,
                ),
              ),
            )
            : null;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        // Ubah crossAxisAlignment menjadi CrossAxisAlignment.center
        // agar ikon dan teks sejajar secara vertikal di tengah.
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (isChatbotMessage) avatar!,
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (isChatbotMessage)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4.0, left: 4.0),
                    child: Text(
                      'Chatbot',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                _buildMessageBubble(message, isMe),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Membangun gelembung pesan dengan gaya yang sesuai.
  Widget _buildMessageBubble(ChatMessage message, bool isMe) {
    return Container(
      constraints: BoxConstraints(maxWidth: Get.width * 0.75),
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 14.0),
      decoration: BoxDecoration(
        color: isMe ? Colors.blue[600] : Colors.grey[200],
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(16.0),
          topRight: const Radius.circular(16.0),
          bottomLeft:
              isMe ? const Radius.circular(16.0) : const Radius.circular(4.0),
          bottomRight:
              isMe ? const Radius.circular(4.0) : const Radius.circular(16.0),
        ),
      ),
      child: Text(
        message.message,
        style: TextStyle(
          color: isMe ? Colors.white : Colors.black87,
          fontSize: 15.0,
        ),
      ),
    );
  }

  /// Membangun bidang input pesan dan tombol kirim.
  Widget _buildMessageInput(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            InkWell(
              onTap: () {
                Get.snackbar(
                  'Fitur',
                  'Fitur attachment belum diimplementasikan',
                );
              },
              borderRadius: BorderRadius.circular(25.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.add, color: Colors.blue[800], size: 28),
              ),
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: TextField(
                controller: controller.messageInputController,
                decoration: InputDecoration(
                  hintText: 'Ketik pesan...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 10.0,
                  ),
                ),
                onSubmitted: (value) => controller.sendMessage(),
              ),
            ),
            const SizedBox(width: 8.0),
            InkWell(
              onTap: controller.sendMessage,
              borderRadius: BorderRadius.circular(25.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.send, color: Colors.blue[800], size: 28),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Pastikan Anda memiliki definisi kelas ChatMessage tersedia.
/// Sebaiknya letakkan ini di file terpisah, misalnya, 'lib/models/chat_message_model.dart'.
///
/// Contoh `chat_message_model.dart`:
/// ```dart
/// class ChatMessage {
///   final String message;
///   final String sender; // 'User' atau 'Admin'
///   final DateTime timestamp; // Jika Anda ingin menambahkan waktu
///
///   ChatMessage({
///     required this.message,
///     required this.sender,
///     required this.timestamp, // Tambahkan ini jika Anda menggunakan timestamp
///   });
/// }
/// ```
