import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Assuming GrafikController is still used for other logic, otherwise it can be removed
class GrafikController extends GetxController {
  // Add any necessary state or logic for your UI here
}

class GrafikView extends GetView<GrafikController> {
  const GrafikView({super.key});

  @override
  Widget build(BuildContext context) {
    // Fixed light mode color scheme
    const Color primaryColor = Colors.blueAccent;
    const Color backgroundColor = Colors.white;
    const Color cardBackgroundColor = Colors.white;
    final Color textColor = Colors.grey.shade800;
    const Color subtleTextColor = Colors.grey;
    const Color appBarContentColor = Colors.white;
    const Color accentColor = Colors.blueAccent; // Used for date picker icon

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          'Detection Analysis',
          style: TextStyle(
            color: appBarContentColor, // Set AppBar title text color to white
          ),
        ),
        centerTitle: true,
        backgroundColor: primaryColor, // Set AppBar background color
        // elevation: 0, // No shadow in the image
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Select Date Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select Date',
                  style: TextStyle(
                    fontSize: 16,
                    color: subtleTextColor,
                  ), // Fixed color
                ),
                Row(
                  children: [
                    Text(
                      '2025-05-14',
                      style: TextStyle(fontSize: 16, color: textColor),
                    ), // Fixed color
                    IconButton(
                      icon: Icon(
                        Icons.calendar_today,
                        color: accentColor,
                      ), // Fixed color
                      onPressed: () {
                        // Implement date picker logic
                        // Example date picker
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2030),
                          builder: (context, child) {
                            return Theme(
                              // Apply theme for the date picker itself
                              data: Theme.of(context).copyWith(
                                colorScheme: ColorScheme.light(
                                  primary:
                                      primaryColor, // header background color
                                  onPrimary: Colors.white, // header text color
                                  onSurface: textColor, // body text color
                                ),
                                textButtonTheme: TextButtonThemeData(
                                  style: TextButton.styleFrom(
                                    foregroundColor:
                                        primaryColor, // button text color
                                  ),
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Total Detections Card
            Card(
              color: cardBackgroundColor, // Fixed color
              elevation: 0, // No shadow
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Detections',
                      style: TextStyle(
                        fontSize: 16,
                        color: subtleTextColor,
                      ), // Fixed color
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '62',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: textColor, // Fixed color
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text(
                              'Max',
                              style: TextStyle(color: subtleTextColor),
                            ), // Fixed color
                            const SizedBox(height: 4),
                            Text(
                              '20',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ), // Fixed color
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              'Avg',
                              style: TextStyle(color: subtleTextColor),
                            ), // Fixed color
                            const SizedBox(height: 4),
                            Text(
                              '10',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ), // Fixed color
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              'Min',
                              style: TextStyle(color: subtleTextColor),
                            ), // Fixed color
                            const SizedBox(height: 4),
                            Text(
                              '2',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ), // Fixed color
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
              color: cardBackgroundColor, // Fixed color
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
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          'Bar Chart Placeholder',
                          style: TextStyle(color: subtleTextColor),
                        ), // Fixed color
                        // You'd replace this with actual chart drawing
                      ),
                    ),
                    // X-axis labels (0, 1, 2, 3, 4, 5)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(
                        6,
                        (index) => Text(
                          '$index',
                          style: TextStyle(color: textColor), // Fixed color
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Detection Timeline
            Text(
              'Detection Timeline',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ), // Fixed color
            ),
            const SizedBox(height: 10),

            // Detection Timeline List (Hardcoded for example, use ListView.builder for dynamic data)
            DetectionTimelineItem(
              time: '00:00',
              detections: 2,
              cardBackgroundColor: cardBackgroundColor, // Pass fixed color
              textColor: textColor, // Pass fixed color
              subtleTextColor: subtleTextColor, // Pass fixed color
            ),
            DetectionTimelineItem(
              time: '04:00',
              detections: 5,
              cardBackgroundColor: cardBackgroundColor, // Pass fixed color
              textColor: textColor, // Pass fixed color
              subtleTextColor: subtleTextColor, // Pass fixed color
            ),
            DetectionTimelineItem(
              time: '08:00',
              detections: 12,
              cardBackgroundColor: cardBackgroundColor, // Pass fixed color
              textColor: textColor, // Pass fixed color
              subtleTextColor: subtleTextColor, // Pass fixed color
            ),
            DetectionTimelineItem(
              time: '12:00',
              detections: 20,
              cardBackgroundColor: cardBackgroundColor, // Pass fixed color
              textColor: textColor, // Pass fixed color
              subtleTextColor: subtleTextColor, // Pass fixed color
            ),
            DetectionTimelineItem(
              time: '16:00',
              detections: 15,
              cardBackgroundColor: cardBackgroundColor, // Pass fixed color
              textColor: textColor, // Pass fixed color
              subtleTextColor: subtleTextColor, // Pass fixed color
            ),
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
  final Color cardBackgroundColor; // Added for fixed background
  final Color textColor; // Added for fixed text
  final Color subtleTextColor; // Added for fixed text

  const DetectionTimelineItem({
    Key? key,
    required this.time,
    required this.detections,
    required this.cardBackgroundColor,
    required this.textColor,
    required this.subtleTextColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: cardBackgroundColor, // Fixed color
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              time,
              style: TextStyle(fontSize: 16, color: textColor),
            ), // Fixed color
            Text(
              '$detections detections',
              style: TextStyle(
                fontSize: 16,
                color: subtleTextColor,
              ), // Fixed color
            ),
          ],
        ),
      ),
    );
  }
}
