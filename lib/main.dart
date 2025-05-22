import 'package:event_planner/screens/splash_screen.dart';
import 'package:event_planner/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: "https://wczxuqgdnjrgbdtaicqq.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Indjenh1cWdkbmpyZ2JkdGFpY3FxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDY3NDA0NDgsImV4cCI6MjA2MjMxNjQ0OH0.kYEbYiAhlM38i-iAexy1O4lSyWaW94WVtQf-lvQ1YvU",
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home:  SplashScreen(),
    );
  }
}
