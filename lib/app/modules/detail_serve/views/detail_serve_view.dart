import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/detail_serve_controller.dart';

class DetailServeView extends GetView<DetailServeController> {
  const DetailServeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DetailServeView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'DetailServeView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
