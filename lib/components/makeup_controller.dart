import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/makeup_artists_model.dart';

class MakeupArtistController extends GetxController {
  var artistList = <MakeupArtistModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    fetchMakeupArtists();
    super.onInit();
  }

  void fetchMakeupArtists() async {
    try {
      isLoading.value = true;

      final response = await Supabase.instance.client
          .from('makeup_artists')
          .select();

      artistList.value = (response as List)
          .map((json) => MakeupArtistModel.fromJson(json))
          .toList();
    } catch (e) {
      print('Error loading makeup artists: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
