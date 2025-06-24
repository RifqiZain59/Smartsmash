import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert'; // Import for Base64 decoding

import '../controllers/juara_controller.dart'; // Ensure this path is correct

class JuaraView extends GetView<JuaraController> {
  const JuaraView({super.key});

  @override
  Widget build(BuildContext context) {
    // It's highly recommended to bind your controller using Get.put() or Get.lazyPut()
    // either in your GetMaterialApp's GetPage definition or explicitly before navigating
    // to JuaraView. This check is a temporary fallback.
    if (!Get.isRegistered<JuaraController>()) {
      Get.put(JuaraController());
    }

    const Color darkBlue = Colors.indigo; // Consistent dark blue reference

    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        title: const Text(
          'Daftar Juara',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        backgroundColor: darkBlue,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 16.0),
        child: Column(
          children: [
            // --- Search Box with Button ---
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                // Applied a slight curve as requested
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: darkBlue.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.searchInputController,
                      decoration: InputDecoration(
                        hintText: 'Cari Juara Hebat...',
                        hintStyle: TextStyle(color: Colors.grey[500]),
                        prefixIcon: Icon(Icons.search, color: darkBlue),
                        // Removed border for a cleaner look within the container
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 15.0,
                          horizontal: 20.0,
                        ),
                      ),
                      onSubmitted: (value) {
                        print('Pencarian dari keyboard: $value');
                        controller.filterJuaraByName(value);
                        FocusScope.of(context).unfocus(); // Close keyboard
                      },
                    ),
                  ),
                  // Conditional Clear Button
                  Obx(() {
                    if (controller.searchQuery.value.isNotEmpty) {
                      return IconButton(
                        icon: Icon(Icons.clear, color: darkBlue),
                        onPressed: () {
                          controller.searchInputController.clear();
                          controller.searchQuery.value = '';
                          controller.filterJuaraByName(
                            '',
                          ); // Show all when clear
                          FocusScope.of(context).unfocus();
                        },
                      );
                    }
                    return const SizedBox.shrink();
                  }),
                ],
              ),
            ),
            const SizedBox(height: 25),

            // --- List of Champions ---
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => controller.refreshJuara(),
                color: darkBlue,
                child: Obx(() {
                  if (controller.isLoadingJuara.value) {
                    return Center(
                      child: CircularProgressIndicator(color: darkBlue),
                    );
                  } else if (controller.errorMessageJuara.isNotEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          controller.errorMessageJuara.value,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.red[700],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  } else if (controller.juaraList.isEmpty) {
                    return Center(
                      child: Text(
                        controller.searchQuery.value.isEmpty
                            ? 'Belum ada data juara yang tersedia.'
                            : 'Tidak ada juara yang ditemukan dengan nama "${controller.searchQuery.value}".',
                        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                        textAlign: TextAlign.center,
                      ),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: controller.juaraList.length,
                      itemBuilder: (context, index) {
                        final juara = controller.juaraList[index];

                        final String juaraName =
                            juara['nama'] ?? 'Nama Tidak Diketahui';
                        final String description =
                            juara['deskripsi'] ?? 'Deskripsi Tidak Tersedia';
                        final String imageUrl =
                            juara['gambar'] ?? ''; // URL or Base64 image

                        return JuaraCard(
                          juaraName: juaraName,
                          description: description,
                          imageUrl: imageUrl,
                          darkBlue: darkBlue,
                          onTap: () {
                            print('Detail Juara: $juaraName');
                            // You can navigate to a detail page here
                            // Get.to(() => DetailJuaraView(), arguments: juaraId);
                          },
                        );
                      },
                    );
                  }
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Champion Card Widget for Code Cleanliness ---
class JuaraCard extends StatelessWidget {
  final String juaraName;
  final String description;
  final String imageUrl;
  final VoidCallback onTap;
  final Color darkBlue;

  const JuaraCard({
    super.key,
    required this.juaraName,
    required this.description,
    required this.imageUrl,
    required this.onTap,
    required this.darkBlue,
  });

  @override
  Widget build(BuildContext context) {
    ImageProvider imageProvider;
    // Determine if imageUrl is Base64 or a regular URL
    if (imageUrl.startsWith('data:image/') && imageUrl.contains(';base64,')) {
      try {
        final String base64String = imageUrl.split(',')[1];
        imageProvider = MemoryImage(base64Decode(base64String));
      } catch (e) {
        print('Error decoding Base64 image: $e');
        imageProvider = const AssetImage(
          'assets/placeholder_error.png',
        ); // Fallback to an asset error image
      }
    } else if (imageUrl.isNotEmpty) {
      imageProvider = NetworkImage(imageUrl);
    } else {
      // Fallback placeholder if imageUrl is empty
      imageProvider = const AssetImage(
        'assets/placeholder_no_image.png',
      ); // Fallback to an asset no-image image
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 15.0),
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
          border: Border.all(color: Colors.grey[100]!, width: 0.5),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: imageProvider,
              backgroundColor: Colors.grey[200],
              onBackgroundImageError: (exception, stackTrace) {
                print('Failed to load image: $exception');
                // You can also update the imageProvider here to show a broken image icon
              },
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    juaraName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 19,
                      color: darkBlue,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    description,
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.grey[400],
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
