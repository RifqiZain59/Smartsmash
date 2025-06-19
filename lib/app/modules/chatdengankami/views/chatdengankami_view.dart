import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/chatdengankami_controller.dart';

class ChatdengankamiView extends GetView<ChatdengankamiController> {
  const ChatdengankamiView({super.key});

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    // Determine if dark mode is active based on system brightness
    final bool isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    // Define adaptive colors
    final Color _scaffoldBackgroundColor =
        isDarkMode ? Colors.black : Colors.white;
    final Color _appBarBackgroundColor =
        isDarkMode
            ? const Color(0xFF1E1E1E)
            : Colors.blue[800]!; // Dark grey for dark mode
    final Color _appBarIconColor =
        isDarkMode ? Colors.white : Colors.white; // White icons for contrast
    final Color _appBarTextColor =
        isDarkMode ? Colors.white : Colors.white; // White text for contrast
    final Color _dividerColor =
        isDarkMode
            ? Colors.grey[800]!
            : Colors.grey; // Darker grey for divider in dark mode
    final Color _inputFillColor =
        isDarkMode
            ? const Color(0xFF2C2C2C)
            : Colors.grey.shade100; // Dark grey for input field
    final Color _inputIconColor =
        isDarkMode
            ? Colors.blue[400]!
            : Colors.blue[800]!; // Lighter blue for icons in dark mode
    final Color _hintTextColor =
        isDarkMode ? Colors.grey[500]! : Colors.grey[700]!; // Lighter hint text
    final Color _chatbotAvatarBgColor =
        isDarkMode
            ? const Color(0xFF424242)
            : Colors.white; // Darker avatar background
    final Color _chatbotIconColor =
        isDarkMode
            ? Colors.blue[400]!
            : Colors.blue; // Consistent blue for chatbot icon
    final Color _chatbotLabelColor =
        isDarkMode
            ? Colors.grey[400]!
            : Colors.grey[600]!; // Lighter grey for chatbot label
    final Color _userBubbleColor =
        isDarkMode
            ? Colors.blue[700]!
            : Colors.blue[600]!; // Slightly darker blue for user bubble
    final Color _chatbotBubbleColor =
        isDarkMode
            ? const Color(0xFF333333)
            : Colors.grey[200]!; // Darker grey for chatbot bubble
    final Color _userTextColor =
        isDarkMode ? Colors.white : Colors.white; // White text for user bubble
    final Color _chatbotTextColor =
        isDarkMode
            ? Colors.white70
            : Colors.black87; // Lighter text for chatbot bubble

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
      backgroundColor: _scaffoldBackgroundColor, // Adaptive background
      appBar: AppBar(
        backgroundColor: _appBarBackgroundColor, // Adaptive AppBar background
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: _appBarIconColor,
          ), // Adaptive icon color
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Chat Dengan Kami',
          style: TextStyle(
            color: _appBarTextColor,
            fontWeight: FontWeight.bold,
          ), // Adaptive text color
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: _appBarIconColor,
            ), // Adaptive icon color
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
                  return _buildMessageRow(
                    message,
                    isDarkMode,
                    _chatbotAvatarBgColor,
                    _chatbotIconColor,
                    _chatbotLabelColor,
                    _userBubbleColor,
                    _chatbotBubbleColor,
                    _userTextColor,
                    _chatbotTextColor,
                  ); // Pass adaptive colors
                },
              ),
            ),
          ),
          Divider(height: 1, color: _dividerColor), // Adaptive divider color
          _buildMessageInput(
            context,
            isDarkMode,
            _inputFillColor,
            _inputIconColor,
            _hintTextColor,
          ), // Pass adaptive colors
        ],
      ),
    );
  }

  /// Membangun satu baris pesan, menangani perataan dan avatar.
  Widget _buildMessageRow(
    ChatMessage message,
    bool isDarkMode,
    Color chatbotAvatarBgColor,
    Color chatbotIconColor,
    Color chatbotLabelColor,
    Color userBubbleColor,
    Color chatbotBubbleColor,
    Color userTextColor,
    Color chatbotTextColor,
  ) {
    final bool isMe = message.sender == 'User';
    final bool isChatbotMessage = message.sender == 'Admin';

    final Widget? avatar =
        isChatbotMessage
            ? Padding(
              // Tambahkan sedikit bottom padding untuk avatar
              padding: const EdgeInsets.only(right: 8.0, bottom: 1.0),
              child: CircleAvatar(
                radius: 18,
                backgroundColor:
                    chatbotAvatarBgColor, // Adaptive avatar background
                child: Icon(
                  Icons.smart_toy, // Ikon robot untuk chatbot
                  color: chatbotIconColor, // Adaptive chatbot icon color
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
                        color:
                            chatbotLabelColor, // Adaptive chatbot label color
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                _buildMessageBubble(
                  message,
                  isMe,
                  userBubbleColor,
                  chatbotBubbleColor,
                  userTextColor,
                  chatbotTextColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Membangun gelembung pesan dengan gaya yang sesuai.
  Widget _buildMessageBubble(
    ChatMessage message,
    bool isMe,
    Color userBubbleColor,
    Color chatbotBubbleColor,
    Color userTextColor,
    Color chatbotTextColor,
  ) {
    return Container(
      constraints: BoxConstraints(maxWidth: Get.width * 0.75),
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 14.0),
      decoration: BoxDecoration(
        color:
            isMe
                ? userBubbleColor
                : chatbotBubbleColor, // Adaptive bubble color
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
          color:
              isMe
                  ? userTextColor
                  : chatbotTextColor, // Adaptive text color inside bubble
          fontSize: 15.0,
        ),
      ),
    );
  }

  /// Membangun bidang input pesan dan tombol kirim.
  Widget _buildMessageInput(
    BuildContext context,
    bool isDarkMode,
    Color inputFillColor,
    Color inputIconColor,
    Color hintTextColor,
  ) {
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
                  backgroundColor:
                      isDarkMode
                          ? Colors.grey[800]
                          : Colors.white, // Adaptive snackbar background
                  colorText:
                      isDarkMode
                          ? Colors.white
                          : Colors.black87, // Adaptive snackbar text color
                );
              },
              borderRadius: BorderRadius.circular(25.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.add,
                  color: inputIconColor,
                  size: 28,
                ), // Adaptive icon color
              ),
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: TextField(
                controller: controller.messageInputController,
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ), // Adaptive text input color
                decoration: InputDecoration(
                  hintText: 'Ketik pesan...',
                  hintStyle: TextStyle(
                    color: hintTextColor,
                  ), // Adaptive hint text color
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: inputFillColor, // Adaptive fill color
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
                child: Icon(
                  Icons.send,
                  color: inputIconColor,
                  size: 28,
                ), // Adaptive icon color
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
