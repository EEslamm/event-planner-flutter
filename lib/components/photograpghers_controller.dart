import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/photographers_model.dart';

class PhotographerController extends GetxController {
  var photographerList = <PhotographerModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    fetchPhotographers();
    super.onInit();
  }

  void fetchPhotographers() async {
    try {
      isLoading.value = true;

      final response = await Supabase.instance.client
          .from('photographers')
          .select();

      photographerList.value = (response as List)
          .map((json) => PhotographerModel.fromJson(json))
          .toList();
    } catch (e) {
      print('Error loading photographers: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
