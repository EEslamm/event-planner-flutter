import 'package:event_planner/components/branch_items.dart';
import 'package:event_planner/screens/halls_screen.dart';
import 'package:event_planner/screens/makeup_screen.dart';
import 'package:event_planner/screens/photographer_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WeddingDetails extends StatelessWidget {
  const WeddingDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Wedding ', style: TextStyle(fontWeight: FontWeight.bold)),
    centerTitle: true,
    ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              BranchItems(
                title: 'Halls',
                imageName: 'assets/wedding_images/halls.jpg',
                onTap: () {
                  Get.to(HallsScreen());
                },
              ),
              const SizedBox(height: 16),
              BranchItems(
                title: 'Photographer',
                imageName: 'assets/wedding_images/photographer.jpg',
                onTap: () {
                  Get.to(PhotographerScreen());
                },
              ),
              const SizedBox(height: 16),
              BranchItems(
                title: 'Makeup',
                imageName: 'assets/wedding_images/makeup.jpg',
                onTap: () {
                  Get.to(MakeupArtistsScreen());
                },
              ),
            ],
          ),
        ),
      ),
    );
    }
}
