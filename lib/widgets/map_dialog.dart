import 'package:blood_line_desktop/widgets/custom_map.dart';
import 'package:flutter/material.dart';


class MapDialog extends StatelessWidget {
  const MapDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 800,
        height: 600,
        child: MapView(
          onLocationSelected: (lat, lng) {
            Navigator.of(context).pop({'latitude': lat, 'longitude': lng});
          },
        ),
      ),
    );
  }
}

