import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:event_planner/screens/login_screen.dart';

import '../components/booking_makeup.dart';
import '../components/makeup_controller.dart';
import '../models/makeup_artists_model.dart';


class MakeupArtistsScreen extends StatelessWidget {
  MakeupArtistsScreen({Key? key}) : super(key: key);

  final MakeupArtistController controller = Get.put(MakeupArtistController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Makeup Artists'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.artistList.isEmpty) {
          return const Center(child: Text('No makeup artists available.'));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.artistList.length,
          itemBuilder: (context, index) {
            final artist = controller.artistList[index];
            return _buildArtistCard(context, artist);
          },
        );
      }),
    );
  }

  Widget _buildArtistCard(BuildContext context, MakeupArtistModel artist) {
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
              artist.name ?? 'Unknown',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                if (artist.phoneNumber != null && artist.phoneNumber!.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.phone, color: Colors.green),
                    onPressed: () => _launchUrl('tel:${artist.phoneNumber!}'),
                  ),
                if (artist.websiteLink != null && artist.websiteLink!.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.language, color: Colors.blue),
                    onPressed: () => _launchUrl(artist.websiteLink!),
                  ),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 16),
                const SizedBox(width: 4),
                Text(artist.rating?.toStringAsFixed(1) ?? '0.0'),
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
                      'redirectRoute': '/booking_makeup_dialog',
                      'bookingDetails': {
                        'name': artist.name ?? '',
                        'hourlyRate': artist.hourlyRate ?? 0.0,
                      },
                      'bookingType': 'makeup_artist'
                    });
                  } else {
                    showDialog(
                      context: context,
                      builder: (_) => BookingMakeupDialog(
                        artistName: artist.name ?? '',
                        hourlyRate: artist.hourlyRate ?? 0.0,
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
