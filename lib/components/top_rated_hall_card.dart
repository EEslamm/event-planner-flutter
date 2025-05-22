import 'package:event_planner/components/top_rated_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/hall_model.dart';
import 'halls_details_item.dart';

class TopRatedHallCard extends StatelessWidget {
  final HallModel hall;
  final VoidCallback onTap;

  const TopRatedHallCard({
    super.key,
    required this.hall,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 6,
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: hall.photo != null && hall.photo!.isNotEmpty
                  ? Image.network(
                hall.photo!,
                width: double.infinity,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 100,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image_not_supported),
                  );
                },
              )
                  : Image.asset(
                'assets/default_image.jpg',
                width: double.infinity,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Text(
                hall.name ?? 'No Name',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    hall.rate?.toStringAsFixed(1) ?? '0.0',
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}


class TopRatedHallsList extends StatelessWidget {
  const TopRatedHallsList({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TopRatedHallsController());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            'Top Rated Halls',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (controller.topRatedHalls.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('No top rated halls available'),
              ),
            );
          }

          return SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              itemCount: controller.topRatedHalls.length,
              itemBuilder: (context, index) {
                final hall = controller.topRatedHalls[index];
                return TopRatedHallCard(
                  hall: hall,
                  onTap: () {
                    Get.to(HallDetailsItem(hall: hall,),);
                  },
                );
              },
            ),
          );
        }),
      ],
    );
  }
}
