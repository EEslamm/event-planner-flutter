import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'login_screen.dart';

class ProfileController extends GetxController {
  final _supabase = Supabase.instance.client;

  var userName = ''.obs;
  var userEmail = ''.obs;
  var profileImageUrl = ''.obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  Future<void> loadUserData() async {
    isLoading.value = true;
    try {
      final user = _supabase.auth.currentUser;
      if (user != null) {
        final data = await _supabase
            .from('profiles')
            .select()
            .eq('id', user.id)
            .single()
            .maybeSingle();

        userName.value = data != null && data['full_name'] != null && data['full_name'] != ''
            ? data['full_name']
            : user.userMetadata?['full_name'] ?? 'User';

        userEmail.value = user.email ?? 'No email';

        profileImageUrl.value = data != null && data['avatar_url'] != null
            ? data['avatar_url']
            : '';
      }
    } catch (e) {
      print('Error loading user data: $e');
      userName.value = 'User';
      userEmail.value = 'No email';
      profileImageUrl.value = '';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
      Get.offAll(() => LoginScreen());
    } catch (e) {
      print('Error signing out: $e');
      Get.snackbar(
        'Error',
        'Failed to sign out',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
class ProfileScreen extends StatelessWidget {
  final ProfileController profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (profileController.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      }

      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 20),
            GestureDetector(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blue[200],
                backgroundImage: profileController.profileImageUrl.value.isNotEmpty
                    ? NetworkImage(profileController.profileImageUrl.value)
                    : null,
                child: profileController.profileImageUrl.value.isEmpty
                    ? Icon(Icons.person, size: 50, color: Colors.blue[900])
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              profileController.userName.value,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildInfoRow(Icons.email, 'Email', profileController.userEmail.value),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 75),
            OutlinedButton.icon(
              onPressed: () {
                _showLogoutConfirmation(context);
              },
              icon: Icon(Icons.logout),
              label: Text('Logout'),
              style: OutlinedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                const SizedBox(height: 4),
                Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }


  void _showLogoutConfirmation(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: Text('Logout'),
        content: Text('Are you sure you want to logout?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              profileController.signOut();
            },
            child: Text('Logout'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          ),
        ],
      ),
    );
  }
}
