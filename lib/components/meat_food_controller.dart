import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/meat_model.dart';

class MeatRestaurantController extends GetxController {
  final RxList<MeatRestaurantModel> restaurantList = <MeatRestaurantModel>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchRestaurants();
  }

  void fetchRestaurants() async {
    isLoading.value = true;
    try {
      final data = await Supabase.instance.client
          .from('meatfood_restaurants')
          .select();

      restaurantList.value = (data as List<dynamic>)
          .map((e) => MeatRestaurantModel.fromJson(e))
          .toList();
    } catch (error) {
      print('Error fetching restaurants: $error');
    } finally {
      isLoading.value = false;
    }
  }
}
