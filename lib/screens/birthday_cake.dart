import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../components/birthday_cake_controller.dart';
import '../models/birthday_cake_model.dart';

class BirthdayCakeScreen extends StatelessWidget {
  final BirthdayCakeController controller = Get.put(BirthdayCakeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Birthday Cakes'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.cakeList.isEmpty) {
          return const Center(child: Text('No cakes available.'));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.cakeList.length,
          itemBuilder: (context, index) {
            final cake = controller.cakeList[index];
            return _buildCakeCard(context, cake);
          },
        );
      }),
    );
  }

  Widget _buildCakeCard(BuildContext context, BirthdayCakeModel cake) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              cake.name ?? 'Unknown Cake',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (cake.address != null && cake.address!.isNotEmpty)
              Text(cake.address!),
            const SizedBox(height: 8),
            Row(
              children: [
                if (cake.phoneNumber != null && cake.phoneNumber!.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.phone, color: Colors.green),
                    onPressed: () => _launchUrl('tel:${cake.phoneNumber!}'),
                  ),
                if (cake.websiteLink != null && cake.websiteLink!.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.language, color: Colors.blue),
                    onPressed: () => _launchUrl(cake.websiteLink!),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _launchUrl(String urlString) async {
    final uri = Uri.parse(urlString);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      Get.snackbar('Error', 'Could not launch $urlString');
    }
  }
}
