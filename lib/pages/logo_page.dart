import 'package:flutter/material.dart';

class LogoPage extends StatelessWidget {
  const LogoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: const Stack(
          children: <Widget>[
            // Positioned images to control their positions
            Positioned(
              top: 0,
              left: 110,
              child: Image(
                image: AssetImage("assets/images/leftUp.png"),
                width: 190, // Control the size of the image
              ),
            ),
            Positioned(
              top: 0,
              right:70,
              child: Image(
                image: AssetImage("assets/images/rightUp.png"),
                width: 130, // Control the size of the image
              ),
            ),
            Positioned(
              right: 0,
              bottom: 100,
              child: Image(
                image: AssetImage("assets/images/right.png"),
                width: 120, // Control the size of the image
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
            Positioned(
              left: 250,
              bottom: 180,
              child: Image(
              image: AssetImage("assets/images/centerleft.png"),
              width: 100, // Control the size of the image
              ),
            ),
            // Center the logo image
            Center(
              child: Image(
                image: AssetImage("assets/images/logoWithTitle.png"),
                width: 350, // Control the size of the logo
              ),
            ),
          ],
        ),
      ),
    );
  }
}
