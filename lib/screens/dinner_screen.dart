import 'package:event_planner/screens/meat_food_screen.dart';
import 'package:event_planner/screens/sea_food_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../components/branch_items.dart';

class DinnersScreen extends StatelessWidget {
  const DinnersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Dinner', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            BranchItems(
              title: 'Seafood',
              imageName: 'assets/dinner_images/sea_food.jpg',
              onTap: () => Get.to(SeafoodRestaurantScreen()),
            ),
            const SizedBox(height: 20),
            BranchItems(
              title: 'Meat Food',
              imageName: 'assets/dinner_images/meat_food.jpg',
              onTap: () => Get.to(MeatFoodScreen()),
            ),
          ],
        ),
      ),
    );
  }
}
