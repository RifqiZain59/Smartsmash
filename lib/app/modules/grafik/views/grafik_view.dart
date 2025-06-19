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
    // Determine if dark mode is active based on system brightness
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    // Define dynamic color scheme
    final Color primaryColor =
        isDarkMode ? Colors.blue.shade300 : Colors.blueAccent;
    final Color backgroundColor =
        isDarkMode
            ? const Color(0xFF121212)
            : Colors.white; // Dark background for dark mode
    final Color cardBackgroundColor =
        isDarkMode
            ? const Color(0xFF1E1E1E)
            : Colors.white; // Darker surface for dark mode
    final Color textColor =
        isDarkMode ? Colors.grey.shade100 : Colors.grey.shade800;
    final Color subtleTextColor =
        isDarkMode ? Colors.grey.shade400 : Colors.grey;
    final Color appBarContentColor =
        Colors.white; // AppBar content remains white for contrast
    final Color accentColor =
        isDarkMode
            ? Colors.blue.shade200
            : Colors.blueAccent; // Used for date picker icon

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
        backgroundColor:
            primaryColor, // Set AppBar background color dynamically
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
                  ), // Dynamic color
                ),
                Row(
                  children: [
                    Text(
                      '2025-05-14',
                      style: TextStyle(fontSize: 16, color: textColor),
                    ), // Dynamic color
                    IconButton(
                      icon: Icon(
                        Icons.calendar_today,
                        color: accentColor,
                      ), // Dynamic color
                      onPressed: () {
                        // Implement date picker logic
                        // Example date picker (consider using Get.dialog or a custom dialog for better theming)
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
              color: cardBackgroundColor, // Dynamic color
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
                      ), // Dynamic color
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '62',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: textColor, // Dynamic color
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
                            ), // Dynamic color
                            const SizedBox(height: 4),
                            Text(
                              '20',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ), // Dynamic color
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              'Avg',
                              style: TextStyle(color: subtleTextColor),
                            ), // Dynamic color
                            const SizedBox(height: 4),
                            Text(
                              '10',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ), // Dynamic color
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              'Min',
                              style: TextStyle(color: subtleTextColor),
                            ), // Dynamic color
                            const SizedBox(height: 4),
                            Text(
                              '2',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ), // Dynamic color
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
              color: cardBackgroundColor, // Dynamic color
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
                        ), // Dynamic color
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
                          style: TextStyle(color: textColor), // Dynamic color
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
              ), // Dynamic color
            ),
            const SizedBox(height: 10),

            // Detection Timeline List (Hardcoded for example, use ListView.builder for dynamic data)
            DetectionTimelineItem(
              time: '00:00',
              detections: 2,
              cardBackgroundColor: cardBackgroundColor, // Pass dynamic color
              textColor: textColor, // Pass dynamic color
              subtleTextColor: subtleTextColor, // Pass dynamic color
            ),
            DetectionTimelineItem(
              time: '04:00',
              detections: 5,
              cardBackgroundColor: cardBackgroundColor, // Pass dynamic color
              textColor: textColor, // Pass dynamic color
              subtleTextColor: subtleTextColor, // Pass dynamic color
            ),
            DetectionTimelineItem(
              time: '08:00',
              detections: 12,
              cardBackgroundColor: cardBackgroundColor, // Pass dynamic color
              textColor: textColor, // Pass dynamic color
              subtleTextColor: subtleTextColor, // Pass dynamic color
            ),
            DetectionTimelineItem(
              time: '12:00',
              detections: 20,
              cardBackgroundColor: cardBackgroundColor, // Pass dynamic color
              textColor: textColor, // Pass dynamic color
              subtleTextColor: subtleTextColor, // Pass dynamic color
            ),
            DetectionTimelineItem(
              time: '16:00',
              detections: 15,
              cardBackgroundColor: cardBackgroundColor, // Pass dynamic color
              textColor: textColor, // Pass dynamic color
              subtleTextColor: subtleTextColor, // Pass dynamic color
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
  final Color cardBackgroundColor; // Added for dynamic background
  final Color textColor; // Added for dynamic text
  final Color subtleTextColor; // Added for dynamic text

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
      color: cardBackgroundColor, // Dynamic color
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
            ), // Dynamic color
            Text(
              '$detections detections',
              style: TextStyle(
                fontSize: 16,
                color: subtleTextColor,
              ), // Dynamic color
            ),
          ],
        ),
      ),
    );
  }
}
