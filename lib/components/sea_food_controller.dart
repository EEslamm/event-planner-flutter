import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/sea_model.dart';

class SeafoodRestaurantController extends GetxController {
  final RxList<SeafoodRestaurantModel> restaurantList = <SeafoodRestaurantModel>[].obs;
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
          .from('seafood_restaurants')
          .select();

      restaurantList.value = (data as List<dynamic>)
          .map((e) => SeafoodRestaurantModel.fromJson(e))
          .toList();
    } catch (error) {
      print('Error fetching seafood restaurants: $error');
    } finally {
      isLoading.value = false;
    }
  }
}
