import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/hall_model.dart';
import '../screens/booking_screen.dart';
import '../screens/login_screen.dart';

class HallDetailsItem extends StatelessWidget {
  final HallModel hall;
  const HallDetailsItem({Key? key, required this.hall}) : super(key: key);

  void _launchAction(String url, {bool isPhone = false}) async {
    final Uri uri = isPhone ? Uri(scheme: 'tel', path: url) : Uri.parse(url);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        title: Text(hall.name ?? 'Hall Details'),
        elevation: 1,
        shadowColor: Colors.grey[200],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                hall.photo ?? '',
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 220,
                  color: Colors.grey[100],
                  child: Icon(Icons.photo, size: 50, color: Colors.grey[400]),
                ),
              ),
            ),

            const SizedBox(height: 24),

            Text(
              hall.name ?? '',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            _buildDetailCard(
              icon: Icons.star,
              color: Colors.amber,
              title: 'Rating',
              value: '${hall.rate?.toStringAsFixed(1) ?? '0.0'}/5.0',
            ),

            _buildDetailCard(
              icon: Icons.location_pin,
              color: Colors.blue,
              title: 'Location',
              value: hall.location ?? '',
              onTap: () => _launchAction('https://maps.google.com?q=${hall.location}'),
            ),

            _buildDetailCard(
              icon: Icons.people_alt,
              color: Colors.green,
              title: 'Capacity',
              value: '${hall.capacity ?? '--'} people',
            ),

            _buildDetailCard(
              icon: Icons.phone,
              color: Colors.purple,
              title: 'Contact',
              value: hall.phone ?? '',
              onTap: () => _launchAction(hall.phone ?? '', isPhone: true),
            ),

            const SizedBox(height: 30),

            SizedBox(

              width: double.infinity,
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
                      'redirectRoute': '/booking',
                      'bookingDetails': hall,
                      'bookingType': 'hall'
                    });
                  } else {
                    Get.to(() => BookingScreen(hall: hall));
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Book Now',
                  style: TextStyle(fontSize: 16,color:Colors.white),

                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard({
    required IconData icon,
    required Color color,
    required String title,
    required String value,
    VoidCallback? onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              if (onTap != null) Icon(Icons.chevron_right, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }
}