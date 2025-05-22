import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/birthday_cake_model.dart';

class BirthdayCakeController extends GetxController {
  var cakeList = <BirthdayCakeModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    fetchCakes();
    super.onInit();
  }

  void fetchCakes() async {
    try {
      isLoading.value = true;

      final response = await Supabase.instance.client
          .from('birthday_cake')
          .select();

      cakeList.value = (response as List)
          .map((json) => BirthdayCakeModel.fromJson(json))
          .toList();
    } catch (e) {
      print('Error loading birthday cakes: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
