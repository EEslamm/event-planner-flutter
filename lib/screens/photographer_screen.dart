import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:event_planner/screens/login_screen.dart';

import '../components/booking_photo.dart';
import '../components/photograpghers_controller.dart';
import '../models/photographers_model.dart';


class PhotographerScreen extends StatelessWidget {
  final PhotographerController controller = Get.put(PhotographerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Photographers'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.photographerList.isEmpty) {
          return const Center(child: Text('No photographers available.'));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.photographerList.length,
          itemBuilder: (context, index) {
            final photographer = controller.photographerList[index];
            return _buildPhotographerCard(context, photographer);
          },
        );
      }),
    );
  }

  Widget _buildPhotographerCard(BuildContext context, PhotographerModel photographer) {
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
              photographer.name ?? 'Unknown',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                if (photographer.phoneNumber != null && photographer.phoneNumber!.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.phone, color: Colors.green),
                    onPressed: () => _launchUrl('tel:${photographer.phoneNumber!}'),
                  ),
                if (photographer.websiteLink != null && photographer.websiteLink!.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.language, color: Colors.blue),
                    onPressed: () => _launchUrl(photographer.websiteLink!),
                  ),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 16),
                const SizedBox(width: 4),
                Text(photographer.rating?.toStringAsFixed(1) ?? '0.0'),
              ],
            ),
            const SizedBox(height: 12),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  final currentUser = Supabase.instance.client.auth.currentUser;
                  if (currentUser == null) {
                    Get.snackbar(
                      "Login Required",
                      "Please log in to continue your booking.",
                      snackPosition: SnackPosition.BOTTOM,
                    );
                    Get.to(() => const LoginScreen(), arguments: {
                      'redirectRoute': '/booking_photographer_dialog',
                      'bookingDetails': {
                        'name': photographer.name ?? '',
                        'hourlyRate': photographer.hourlyRate ?? 0.0,
                      },
                      'bookingType': 'photographer'
                    });
                  } else {
                    showDialog(
                      context: context,
                      builder: (_) => BookingPhotographerDialog(
                        photographerName: photographer.name ?? '',
                        hourlyRate: photographer.hourlyRate ?? 0.0,
                      ),
                    );
                  }
                },
                child: const Text('Book Now'),
              ),
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
