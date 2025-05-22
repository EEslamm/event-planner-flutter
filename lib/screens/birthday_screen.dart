import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../components/branch_items.dart';
import 'birthday_cake.dart';
import 'birthday_venu.dart';

class BirthdayDetails extends StatelessWidget {
  const BirthdayDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Birthday ', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            BranchItems(
              title: 'Birthday Venue',
              imageName: 'assets/birthday_images/venue.png',
              onTap: () {
                Get.to(BirthdayVenueScreen());
              }
            ),
            const SizedBox(height: 20),
            BranchItems(
              title: 'Birthday Cake',
              imageName: 'assets/birthday_images/cake.png',
              onTap: () {
                Get.to(BirthdayCakeScreen());

              }
            ),
          ],
        ),
      ),    );
  }
}
