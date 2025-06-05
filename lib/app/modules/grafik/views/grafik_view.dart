import 'package:flutter/material.dart';
import 'package:get/get.dart';
// Removed webview_flutter imports as they are not needed for this UI

// Assuming GrafikController is still used for other logic, otherwise it can be removed
class GrafikController extends GetxController {
  // Add any necessary state or logic for your UI here
}

class GrafikView extends GetView<GrafikController> {
  const GrafikView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detection Analysis',
          style: TextStyle(
            color: Colors.white,
          ), // Set AppBar title text color to white
        ),
        centerTitle: true,
        backgroundColor:
            Colors.blueAccent, // Set AppBar background color to blue
        // elevation: 0, // No shadow in the image
      ),
      body: SingleChildScrollView(
        // Use SingleChildScrollView if the content can exceed screen height
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Select Date Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Select Date',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                Row(
                  children: [
                    const Text('2025-05-14', style: TextStyle(fontSize: 16)),
                    IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () {
                        // Implement date picker logic
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Total Detections Card
            Card(
              elevation: 0, // No shadow
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Detections',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '62',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const [
                        Column(
                          children: [
                            Text('Max', style: TextStyle(color: Colors.grey)),
                            SizedBox(height: 4),
                            Text(
                              '20',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text('Avg', style: TextStyle(color: Colors.grey)),
                            SizedBox(height: 4),
                            Text(
                              '10',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text('Min', style: TextStyle(color: Colors.grey)),
                            SizedBox(height: 4),
                            Text(
                              '2',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Bar Chart (Placeholder)
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                height: 200, // Adjust height as needed
                child: Column(
                  children: [
                    // This is where you would integrate a bar chart library or custom painter
                    // For example, using a placeholder for now:
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child: const Text('Bar Chart Placeholder'),
                        // You'd replace this with actual chart drawing
                      ),
                    ),
                    // X-axis labels (0, 1, 2, 3, 4, 5)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(6, (index) => Text('$index')),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Detection Timeline
            const Text(
              'Detection Timeline',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Detection Timeline List (Hardcoded for example, use ListView.builder for dynamic data)
            DetectionTimelineItem(time: '00:00', detections: 2),
            DetectionTimelineItem(time: '04:00', detections: 5),
            DetectionTimelineItem(time: '08:00', detections: 12),
            DetectionTimelineItem(time: '12:00', detections: 20),
            DetectionTimelineItem(time: '16:00', detections: 15),
            // Add more items as needed
          ],
        ),
      ),
    );
  }
}

// Custom Widget for Detection Timeline Items
class DetectionTimelineItem extends StatelessWidget {
  final String time;
  final int detections;

  const DetectionTimelineItem({
    Key? key,
    required this.time,
    required this.detections,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(time, style: const TextStyle(fontSize: 16)),
            Text(
              '$detections detections',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
