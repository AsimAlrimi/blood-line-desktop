import 'package:flutter/material.dart';

class BackgroundDecorations extends StatelessWidget {
  const BackgroundDecorations({super.key});

  @override
  Widget build(BuildContext context) {
    return  Stack(
      children: <Widget>[

        // Positioned images for decoration
        Positioned(
          top: 0,
          left: 110,
          child: Image(
            image: AssetImage("assets/images/leftUp.png"),
            width: 190, // Control the size of the image
          ),
        ),
        Positioned(
          bottom: 0,
          right: 110,
          child: Image(
            image: AssetImage("assets/images/centerleft.png"),
            width: 190, // Control the size of the image
          ),
        ),
        Positioned(
          left: 20,
          bottom: 0,
          child: Image(
            image: AssetImage("assets/images/leftdown.png"),
            width: 100, // Control the size of the image
          ),
        ),
      ],
    );
  }
}
