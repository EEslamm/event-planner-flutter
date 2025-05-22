import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/birthday_venue_model.dart';

class BirthdayVenueController extends GetxController {
  var venueList = <BirthdayVenueModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    fetchVenues();
    super.onInit();
  }

  void fetchVenues() async {
    try {
      isLoading.value = true;

      final response = await Supabase.instance.client
          .from('birthday_venue')
          .select();

      venueList.value = (response as List)
          .map((json) => BirthdayVenueModel.fromJson(json))
          .toList();
    } catch (e) {
      print('Error loading venues: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
