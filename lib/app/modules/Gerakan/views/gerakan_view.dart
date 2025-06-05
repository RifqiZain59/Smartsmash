import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/gerakan_controller.dart';

class GerakanView extends GetView<GerakanController> {
  const GerakanView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GerakanView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'GerakanView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
