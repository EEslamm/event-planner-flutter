import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'login_screen.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  bool isValidEmail(String email) {
    return RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(email);
  }

  bool containsOnlyLetters(String name) {
    return RegExp(
      r"^[a-zA-Z\s]+$",
    ).hasMatch(name);
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController confirmPasswordController =
        TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Full Name'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Confirm Password'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final name = nameController.text.trim();
                final email = emailController.text.trim();
                final password = passwordController.text;
                final confirmPassword = confirmPasswordController.text;

                if (name.isEmpty ||
                    email.isEmpty ||
                    password.isEmpty ||
                    confirmPassword.isEmpty) {
                  Get.snackbar(
                    'Error',
                    'Please fill all fields',
                    backgroundColor: Colors.blue.shade400,
                    colorText: Colors.white,
                    snackPosition: SnackPosition.TOP,
                  );
                  return;
                }

                if (!containsOnlyLetters(name)) {
                  Get.snackbar(
                    'Invalid Name',
                    'Name must contain only letters.',
                    backgroundColor: Colors.blue.shade400,
                    colorText: Colors.white,
                    snackPosition: SnackPosition.TOP,
                  );
                  return;
                }

                if (!isValidEmail(email)) {
                  Get.snackbar(
                    'Invalid Email',
                    'Please enter a valid email address.',
                    backgroundColor: Colors.blue.shade400,
                    colorText: Colors.white,
                    snackPosition: SnackPosition.TOP,
                  );
                  return;
                }

                if (password.length < 8 ||
                    !password.contains(RegExp(r'[a-z]')) ||
                    !password.contains(RegExp(r'[A-Z]'))) {
                  Get.snackbar(
                    'Invalid Password',
                    'Password must be at least 8 characters and include both uppercase and lowercase letters.',
                    backgroundColor: Colors.blue.shade400,
                    colorText: Colors.white,
                    snackPosition: SnackPosition.TOP,
                  );
                  return;
                }

                if (password != confirmPassword) {
                  Get.snackbar(
                    'Error',
                    'Passwords do not match',
                    backgroundColor: Colors.blue.shade400,
                    colorText: Colors.white,
                    snackPosition: SnackPosition.TOP,
                  );
                  return;
                }

                try {
                  final response = await Supabase.instance.client.auth.signUp(
                    email: email,
                    password: password,
                    data: {'full_name': name},
                  );

                  if (response.user != null) {
                    Get.snackbar(
                      'Success',
                      'Registration Successful',
                      backgroundColor: Colors.blue,
                      colorText: Colors.white,
                      snackPosition: SnackPosition.TOP,
                    );
                    Future.delayed(const Duration(seconds: 1), () {
                      Get.off(() => const LoginScreen());
                    });
                  }
                } catch (e) {
                  String errorMessage = 'Registration Failed';
                  if (e is AuthException) errorMessage = e.message;
                  Get.snackbar(
                    'Error',
                    errorMessage,
                    backgroundColor: Colors.blue.shade400,
                    colorText: Colors.white,
                    snackPosition: SnackPosition.TOP,
                  );
                }
              },
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
