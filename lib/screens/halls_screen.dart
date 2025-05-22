import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../components/hall_controller.dart';
import '../components/halls_details_item.dart';
import '../components/shared/custom_card.dart';
import '../models/hall_model.dart';

class HallsScreen extends StatelessWidget {
  final HallsController controller = Get.put(HallsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Halls', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.hallsList.isEmpty) {
          return const Center(child: Text('There is no available halls for now'));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.hallsList.length,
          itemBuilder: (context, index) {
            final hall = controller.hallsList[index];
            return CustomCard(
              imageUrl: hall.photo,
              title: hall.name ?? '',
              rating: hall.rate,
              onTap: () => Get.to(() => HallDetailsItem(hall: hall)),
            );
          },
        );
      }),
    );
  }
}