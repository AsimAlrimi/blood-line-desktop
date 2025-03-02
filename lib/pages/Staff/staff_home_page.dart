import 'dart:async';

import 'package:blood_line_desktop/services/home_page_services.dart';
import 'package:blood_line_desktop/theme/app_theme.dart';
import 'package:blood_line_desktop/widgets/custom_header.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

// Chart Data Model
class _ChartData {
  _ChartData(this.category, this.value);
  final String category;
  final int value;
}

class StaffHomePage extends StatefulWidget {
  const StaffHomePage({super.key});

  @override
  State<StaffHomePage> createState() => _StaffHomePageState();
}

class _StaffHomePageState extends State<StaffHomePage> {
  int bloodNeedsCount = 0;
  int donationsCount = 0;
  int eventsCount = 0;

  bool isLoading = true;
  Timer? _timer;

  Future<void> _fetchAndSetEvents() async {
    if (!mounted) return; // Check if the widget is still mounted
    final data = await HomePageService.fetchUserData(context);
    if (data != null && mounted) {
      setState(() {
        bloodNeedsCount = data['blood_needs_count'] ?? 0;
        donationsCount = data['donations_count'] ?? 0;
        eventsCount = data['events_count'] ?? 0;
        isLoading = false;
      });
    } else if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchAndSetEvents();

    // Set up a timer to fetch data every 10 seconds
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (mounted) {
        _fetchAndSetEvents();
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    final List<_ChartData> chartData = [
      _ChartData('Donation', donationsCount),
      _ChartData('Event', eventsCount),
      _ChartData('Emergency', bloodNeedsCount),
    ];

    return isLoading
        ? Center(child: CircularProgressIndicator())
        : SizedBox(
            width: screenWidth,
            height: screenHeight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomHeader(title: "Home"),
                  const SizedBox(height: 10),
                  Text(
                    "In the last 30 days.",
                    style: AppTheme.h3(),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _StatCard(value: donationsCount.toString(), label: "Donation"),
                          SizedBox(width: screenWidth * 0.1),
                          _StatCard(value: eventsCount.toString(), label: "Event"),
                          SizedBox(width: screenWidth * 0.1),
                          _StatCard(value: bloodNeedsCount.toString(), label: "Emergency"),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text("Statistics Overview.", style: AppTheme.h3()),
                  const SizedBox(height: 20),
                  Flexible(
                    child: Row(
                      children: [
                        // Bar Chart
                        Expanded(
                          child: SfCartesianChart(
                            primaryXAxis: CategoryAxis(),
                            title: ChartTitle(text: ''),
                            tooltipBehavior: TooltipBehavior(enable: true),
                            series: <CartesianSeries<_ChartData, String>>[
                              ColumnSeries<_ChartData, String>(
                                dataSource: chartData,
                                xValueMapper: (_ChartData data, _) => data.category,
                                yValueMapper: (_ChartData data, _) => data.value,
                                color: const Color.fromARGB(255, 132, 170, 199),
                                name: 'Counts',
                                dataLabelSettings: const DataLabelSettings(isVisible: true),
                              ),
                            ],
                          ),
                        ),
                        // Pie Chart
                        Flexible(
                          child: SfCircularChart(
                            title: ChartTitle(text: ''),
                            legend: Legend(isVisible: true),
                            tooltipBehavior: TooltipBehavior(enable: true),
                            series: <CircularSeries>[
                              PieSeries<_ChartData, String>(
                                dataSource: chartData,
                                xValueMapper: (_ChartData data, _) => data.category,
                                yValueMapper: (_ChartData data, _) => data.value,
                                pointColorMapper: (_ChartData data, int index) {
                                  // Define colors for each category
                                  switch (data.category) {
                                    case 'Donation':
                                      return Colors.red.shade200;
                                    case 'Event':
                                      return Colors.red.shade400;
                                    case 'Emergency':
                                      return const Color(0xFFEE7272);
                                    default:
                                      return Colors.grey;
                                  }
                                },
                                dataLabelSettings: const DataLabelSettings(
                                  isVisible: true,
                                  labelPosition: ChartDataLabelPosition.outside,
                                ),
                                enableTooltip: true,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;

  const _StatCard({
    required this.value,
    required this.label,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(9),
      ),
      clipBehavior: Clip.antiAlias,
      child: Container(
        width: screenWidth * 0.18,
        height: screenHeight * 0.10,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(9),
          child: CustomPaint(
            painter: _DiagonalBackgroundPainter(),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 0),
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


class _DiagonalBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill;

    // First diagonal band (dark red)
    paint.color = Colors.red.shade900;
    canvas.drawPath(
      Path()
        ..moveTo(0, 0)
        ..lineTo(size.width * 0.4, 0)
        ..lineTo(size.width * 0.3, size.height)
        ..lineTo(0, size.height)
        ..close(),
      paint,
    );

    // Second diagonal band (red)
    paint.color = Colors.red.shade400;
    canvas.drawPath(
      Path()
        ..moveTo(size.width * 0.4, 0)
        ..lineTo(size.width * 0.6, 0)
        ..lineTo(size.width * 0.5, size.height)
        ..lineTo(size.width * 0.3, size.height)
        ..close(),
      paint,
    );

    // Third diagonal band (gray)
    paint.color = Color(0xFFEE7272);;
    canvas.drawPath(
      Path()
        ..moveTo(size.width * 0.6, 0)
        ..lineTo(size.width * 0.8, 0)
        ..lineTo(size.width * 0.7, size.height)
        ..lineTo(size.width * 0.5, size.height)
        ..close(),
      paint,
    );

    // Fourth diagonal band (light red)
    paint.color = Colors.red.shade200;
    canvas.drawPath(
      Path()
        ..moveTo(size.width * 0.8, 0)
        ..lineTo(size.width, 0)
        ..lineTo(size.width, size.height)
        ..lineTo(size.width * 0.7, size.height)
        ..close(),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}