import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartsmashapp/app/modules/berita/controllers/berita_controller.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BeritaView extends GetView<BeritaController> {
  const BeritaView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          // Added const for better performance
          'Berita',
          style: TextStyle(color: Colors.white), // Set text color to white
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white, // <--- Tambahkan baris ini
        elevation: 4,
        shape: const RoundedRectangleBorder(
          // Added const
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
      ),
      body: const WebViewContent(),
    );
  }
}

class WebViewContent extends StatefulWidget {
  const WebViewContent({super.key});

  @override
  State<WebViewContent> createState() => _WebViewContentState();
}

class _WebViewContentState extends State<WebViewContent> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        WebViewController()
          ..loadRequest(Uri.parse('https://smartsmashapp.streamlit.app/'))
          ..setJavaScriptMode(JavaScriptMode.unrestricted);
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: _controller);
  }
}
