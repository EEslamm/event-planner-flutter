import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/hall_model.dart';

class TopRatedHallsController extends GetxController {
  final RxList<HallModel> topRatedHalls = <HallModel>[].obs;
  final RxBool isLoading = false.obs;

  final SupabaseClient supabase = Supabase.instance.client;

  @override
  void onInit() {
    super.onInit();
    if (topRatedHalls.isEmpty) {
      fetchTopRatedHalls();
    }
  }

  Future<void> fetchTopRatedHalls() async {
    try {
      isLoading.value = true;

      final List<dynamic> response = await supabase
          .from('Halls')
          .select('id, hall_name, hall_rate, hall_photo, hall_capacity, hall_location, hall_price, hall_phone')
          .order('hall_rate', ascending: false)
          .limit(5);

      topRatedHalls.assignAll(
        response.map((item) => HallModel.fromJson(item)).toList(),
      );
    } catch (error) {
      Get.snackbar(
        'Error',
        'Failed to load top rated halls: ${error.toString()}',
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
