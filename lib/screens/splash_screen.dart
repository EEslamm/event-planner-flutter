import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'home_screen.dart';
import 'login_screen.dart';

class SplashController extends GetxController {
  RxBool isTextFinished = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  void onTextAnimationFinished() async {
    isTextFinished.value = true;

    await Future.delayed(const Duration(seconds: 2));

    final session = Supabase.instance.client.auth.currentSession;

    if (session != null) {
      Get.offAll(() => const HomeScreen());
    } else {
      Get.offAll(() => const LoginScreen());
    }
  }
}

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  final SplashController controller = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.event_available,
              size: 100,
              color: Colors.blueAccent,
            ),
            const SizedBox(height: 30),
            DefaultTextStyle(
              style: const TextStyle(
                fontSize: 36.0,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
              child: AnimatedTextKit(
                isRepeatingAnimation: false,
                onFinished: controller.onTextAnimationFinished,
                animatedTexts: [
                  TypewriterAnimatedText('Welcome to', speed: Duration(milliseconds: 100)),
                  TypewriterAnimatedText('Event Planner', speed: Duration(milliseconds: 100)),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Obx(() => controller.isTextFinished.value
                ? const CircularProgressIndicator(color: Colors.blueAccent)
                : const SizedBox()),
          ],
        ),
      ),
    );
  }
}
