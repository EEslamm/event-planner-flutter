import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:event_planner/screens/login_screen.dart';

import '../components/birthday_venue_controller.dart';
import '../components/venue_booking.dart';
import '../models/birthday_venue_model.dart';


class BirthdayVenueScreen extends StatelessWidget {
  final BirthdayVenueController controller = Get.put(BirthdayVenueController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Birthday Venues'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.venueList.isEmpty) {
          return const Center(child: Text('No venues available.'));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.venueList.length,
          itemBuilder: (context, index) {
            final venue = controller.venueList[index];
            return _buildVenueCard(context, venue);
          },
        );
      }),
    );
  }

  Widget _buildVenueCard(BuildContext context, BirthdayVenueModel venue) {
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
              venue.name ?? 'Unknown Venue',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (venue.address != null) Text(venue.address!),
            const SizedBox(height: 8),
            Row(
              children: [
                if (venue.phoneNumber != null && venue.phoneNumber!.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.phone, color: Colors.green),
                    onPressed: () => _launchUrl('tel:${venue.phoneNumber!}'),
                  ),
                if (venue.websiteLink != null && venue.websiteLink!.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.language, color: Colors.blue),
                    onPressed: () => _launchUrl(venue.websiteLink!),
                  ),
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
                      'redirectRoute': '/booking_birthday_venue_dialog',
                      'bookingDetails': {
                        'id': venue.id,
                        'name': venue.name ?? '',
                      },
                      'bookingType': 'birthday_venue'
                    });
                  } else {
                    showDialog(
                      context: context,
                      builder: (_) => BookingBirthdayVenueDialog(
                        venueId: venue.id,
                        venueName: venue.name ?? '',
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
