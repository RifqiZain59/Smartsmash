import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/juara_controller.dart';

class JuaraView extends GetView<JuaraController> {
  const JuaraView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('JuaraView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'JuaraView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
