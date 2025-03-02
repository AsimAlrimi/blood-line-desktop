import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // for rootBundle
import 'package:webview_windows/webview_windows.dart';

class MapView extends StatefulWidget {
  final Function(double, double) onLocationSelected;

  const MapView({Key? key, required this.onLocationSelected}) : super(key: key);

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final WebviewController _controller = WebviewController();

  @override
  void initState() {
    super.initState();
    _initWebview();
  }

  Future<void> _initWebview() async {
    try {
      // Load the map.html file from the assets folder
      String filePath = await _loadHtmlFile();
      await _controller.initialize();
      await _controller.loadUrl('file:///$filePath');
      setState(() {});
    } catch (e) {
      print("Error initializing webview: $e");
    }
  }

  Future<String> _loadHtmlFile() async {
    final directory = Directory.systemTemp;
    final file = File('${directory.path}/map.html');

    // Write the asset content to a temporary file
    final htmlContent = await rootBundle.loadString('assets/map.html');
    await file.writeAsString(htmlContent);

    return file.path;
  }

  Future<void> _getLocation() async {
    try {
      final latitude = await _controller.executeScript('localStorage.getItem("latitude")');
      final longitude = await _controller.executeScript('localStorage.getItem("longitude")');

      if (latitude != null && longitude != null) {
        widget.onLocationSelected(double.parse(latitude), double.parse(longitude));
      }
    } catch (e) {
      print("Error fetching location: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: _controller.value.isInitialized
              ? Webview(_controller)
              : const Center(child: CircularProgressIndicator()),
        ),
        ElevatedButton(
          onPressed: _getLocation,
          child: const Text("Select Location"),
        ),
      ],
    );
  }
}
