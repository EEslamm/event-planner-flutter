import 'package:event_planner/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../components/hall_controller.dart';
import '../components/top_rated_hall_card.dart';
import 'chat_bot_screen.dart';
import 'idea_screen.dart';
import 'wedding_screen.dart';
import 'birthday_screen.dart';
import 'dinner_screen.dart';
import '../components/main_items.dart';

class HomeController extends GetxController {
  var currentIndex = 0.obs;
  var isLoading = false.obs;
  
  void changeIndex(int index) {
    if (index != currentIndex.value) {
      isLoading.value = true;
      currentIndex.value = index;
      // Simulate loading time for smooth transition
      Future.delayed(const Duration(milliseconds: 300), () {
        isLoading.value = false;
      });
    }
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.put(HomeController());

    final List<Widget> screens = [
      HomeContent(),
      IdeaScreen(),
      ProfileScreen(),
    ];

    final List<String> appBarTitles = [
      'H O M E',
      'Idea',
      'PROFILE'
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Obx(() => Text(
            appBarTitles[homeController.currentIndex.value],
            style: const TextStyle(fontWeight: FontWeight.bold)
        )),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Obx(() {
        if (homeController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return screens[homeController.currentIndex.value];
      }),
      bottomNavigationBar: Obx(() {
        return BottomNavigationBar(
          currentIndex: homeController.currentIndex.value,
          onTap: (index) => homeController.changeIndex(index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.lightbulb),
              label: 'Idea',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(ChatBotScreen()),
        child: Icon(Icons.chat),
        backgroundColor: Colors.blue,
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  final HallsController hallController = Get.put(HallsController());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                MainItems(
                  title: 'Wedding',
                  imageName: 'assets/items_images/wedding.jpg',
                  onTap: () => Get.to(WeddingDetails()),
                ),
                Spacer(),
                MainItems(
                  title: 'Birthday',
                  imageName: 'assets/items_images/birthday.jpg',
                  onTap: () => Get.to(BirthdayDetails()),
                ),
                Spacer(),
                MainItems(
                  title: 'Dinner',
                  imageName: 'assets/items_images/dinner.jpg',
                  onTap: () => Get.to(DinnersScreen()),
                ),
              ],
            ),
            const SizedBox(height: 70),
            const TopRatedHallsList(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}