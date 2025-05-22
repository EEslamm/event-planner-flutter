import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:event_planner/screens/login_screen.dart';
import '../components/booking_dialog.dart';
import '../components/meat_food_controller.dart';
import '../models/meat_model.dart';


class MeatFoodScreen extends StatelessWidget {
  MeatFoodScreen({Key? key}) : super(key: key);

  final MeatRestaurantController controller = Get.put(MeatRestaurantController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Meat Food Restaurants',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.restaurantList.isEmpty) {
          return const Center(child: Text('No meat food restaurants available.'));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.restaurantList.length,
          itemBuilder: (context, index) {
            final restaurant = controller.restaurantList[index];
            return _buildRestaurantCard(context, restaurant);
          },
        );
      }),
    );
  }

  Widget _buildRestaurantCard(BuildContext context, MeatRestaurantModel restaurant) {
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
              restaurant.name ?? 'Unknown',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (restaurant.address != null && restaurant.address!.isNotEmpty)
              Text('📍 ${restaurant.address!}'),
            Row(
              children: [
                if (restaurant.phoneNumber != null && restaurant.phoneNumber!.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.phone, color: Colors.green),
                    onPressed: () => _launchUrl('tel:${restaurant.phoneNumber!}'),
                  ),
                if (restaurant.websiteLink != null && restaurant.websiteLink!.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.language, color: Colors.blue),
                    onPressed: () => _launchUrl(restaurant.websiteLink!),
                  ),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 16),
                const SizedBox(width: 4),
                Text(restaurant.rating?.toStringAsFixed(1) ?? '0.0'),
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
                      'redirectRoute': '/booking_restaurant_dialog',
                      'bookingDetails': {
                        'name': restaurant.name ?? '',
                      },
                      'bookingType': 'restaurant'
                    });
                  } else {
                    showDialog(
                      context: context,
                      builder: (_) => BookingRestaurantDialog(restaurantName: restaurant.name ?? ''),
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
