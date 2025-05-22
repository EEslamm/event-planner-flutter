import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IdeaBotController extends GetxController {
  var messages = <Map<String, String>>[].obs;

  final capacityController = TextEditingController();

  var selectedLocation = ''.obs;
  var photographerAvailability = 'No'.obs;
  var makeup = 'No'.obs;
  var cake = 'No'.obs;
  var food = 'No'.obs;
  var rating = 1.0.obs;

  List<String> selectedLocationList = ['Cairo', 'Alex', 'Giza'];

  String _lastPredictionData = '';

  void clearAllData() {
    messages.clear();
    capacityController.clear();
    selectedLocation.value = '';
    photographerAvailability.value = 'No';
    makeup.value = 'No';
    cake.value = 'No';
    food.value = 'No';
    rating.value = 1.0;
    _lastPredictionData = '';
  }

  String predictPrice() {
    int peopleCount = int.tryParse(capacityController.text) ?? 0;

    final currentData = "$peopleCount-${selectedLocation.value}-${photographerAvailability.value}-${makeup.value}-${cake.value}-${food.value}-${rating.value}";
    if (_lastPredictionData == currentData) {
      return "Please change the data before predict new price.";
    }
    _lastPredictionData = currentData;

    double baseHallPrice = 5000;
    double pricePerPerson = 50;
    double totalPrice = baseHallPrice + (peopleCount * pricePerPerson);

    if (food.value == 'Yes') totalPrice += peopleCount * 50;
    if (photographerAvailability.value == 'Yes') totalPrice += 200;
    if (makeup.value == 'Yes') totalPrice += 1000;
    if (cake.value == 'Yes') totalPrice += 300;

    totalPrice += rating.value * 100;

    return "${totalPrice.toStringAsFixed(2)} EGP";
  }
}
