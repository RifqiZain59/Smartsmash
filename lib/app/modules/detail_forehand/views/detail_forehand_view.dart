import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/detail_forehand_controller.dart';

class DetailForehandView extends GetView<DetailForehandController> {
  const DetailForehandView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DetailForehandView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'DetailForehandView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
