import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/acara_controller.dart';

class AcaraView extends GetView<AcaraController> {
  const AcaraView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AcaraView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'AcaraView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
