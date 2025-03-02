import 'package:blood_line_desktop/routes/app_routes.dart';
import 'package:blood_line_desktop/theme/app_theme.dart';
//import 'package:blood_line_desktop/widgets/SplashScreen.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

late double screenWidth;
late double screenHeight ;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    minimumSize: Size(1200, 700),
    center: true,
    title: "Blood Line",
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
    await windowManager.maximize();
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return MaterialApp(
      title: "Blood Line",
      debugShowCheckedModeBanner: false,
      //home:  SplashScreen(),
      initialRoute: AppRoutes.staffMainScreem,
      routes: AppRoutes.routes,
      theme: AppTheme.lightTheme,
    );
  }
}
