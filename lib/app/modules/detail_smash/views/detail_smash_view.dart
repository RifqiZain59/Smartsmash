import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/detail_smash_controller.dart';

class DetailSmashView extends GetView<DetailSmashController> {
  const DetailSmashView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DetailSmashView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'DetailSmashView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
