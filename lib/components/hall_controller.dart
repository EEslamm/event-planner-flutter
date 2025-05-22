import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/hall_model.dart';

class HallsController extends GetxController {
  var hallsList = <HallModel>[].obs;
  var isLoading = true.obs;

  final supabase = Supabase.instance.client;

  @override
  void onInit() {
    fetchHalls();
    super.onInit();
  }

  void fetchHalls() async {
    try {
      isLoading.value = true;
      final response = await supabase.from('Halls').select();
      print('Supabase Response Type: ${response.runtimeType}');
      if (response.isEmpty) {
        print('No data returned from Supabase');
      } else {
        hallsList.value = (response as List<dynamic>)
            .map((e) => HallModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      print('Error fetching halls: $e');
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}