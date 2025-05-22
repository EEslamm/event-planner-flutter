import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/hall_model.dart';

class BookingController extends GetxController {
  final Rxn<HallModel> hall = Rxn<HallModel>();

  final RxList<HallModel> availableHalls = <HallModel>[].obs;
  final RxBool isLoadingHalls = false.obs;

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final membersController = TextEditingController(text: '1');
  var selectedDate = Rxn<DateTime>();
  var selectedPaymentMethod = Rxn<String>();
  final int capacity = 200;
  final paymentMethods = ['Credit Card', 'PayPal', 'InstaPay', 'Cash'];
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      hall.value = Get.arguments as HallModel;
    }
  }

  Future<void> fetchAllHalls() async {
    try {
      isLoadingHalls.value = true;
      final supabase = Supabase.instance.client;
      final response = await supabase
          .from('Halls')
          .select();

      availableHalls.value = response
          .map((item) => HallModel.fromJson(item))
          .toList();
    } catch (error) {
      Get.snackbar(
        'Error',
        'Failed to load halls: ${error.toString()}',
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoadingHalls.value = false;
    }
  }

  Future<void> createBooking() async {
    try {
      if (hall.value == null) {
        Get.snackbar(
          'Error',
          'No hall selected. Please select a hall before booking.',
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      isLoading.value = true;
      final supabase = Supabase.instance.client;

      final existingBookings = await supabase
          .from('bookings')
          .select()
          .eq('booking_date', selectedDate.value!.toIso8601String())
          .eq('hall_id', hall.value!.id);

      String status;
      if (existingBookings != null && existingBookings.isNotEmpty) {
        status = 'rejected';
      } else {
        status = 'approved';
      }

      final booking = {
        'name': nameController.text,
        'phone': phoneController.text,
        'email': emailController.text,
        'booking_date': selectedDate.value!.toIso8601String(),
        'members_count': int.parse(membersController.text),
        'payment_method': selectedPaymentMethod.value,
        'status': status,
        'created_at': DateTime.now().toIso8601String(),
        'hall_id': hall.value!.id,
      };

      final response = await supabase
          .from('bookings')
          .insert(booking)
          .select()
          .single();

      if (response != null) {
        Get.dialog(
          AlertDialog(
            title: Text(status == 'approved' ? 'Booking Successful' : 'Booking Rejected'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hall: ${hall.value!.name}'),
                Text('Date: ${selectedDate.value!.toLocal().toString().split(' ')[0]}'),
                Text('Number of People: ${membersController.text}'),
                const SizedBox(height: 8),
                Text('Status: ${status[0].toUpperCase()}${status.substring(1)}',
                    style: TextStyle(color: status == 'approved' ? Colors.green : Colors.red)),
                if (status == 'rejected')
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text('Sorry, this date is already booked.',
                        style: TextStyle(color: Colors.grey)),
                  ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back(); // Close dialog
                  Get.back(); // Return to previous screen
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (error) {
      Get.snackbar(
        'Error',
        'Failed to create booking. Please try again: ${error.toString()}',
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  bool validateForm() {
    if (nameController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your name.',
        backgroundColor: Colors.orange,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
    if (phoneController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your phone number.',
        backgroundColor: Colors.orange,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
    if (emailController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your email.',
        backgroundColor: Colors.orange,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
    if (selectedDate.value == null) {
      Get.snackbar(
        'Error',
        'Please select a booking date.',
        backgroundColor: Colors.orange,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
    final int people = int.tryParse(membersController.text) ?? 1;
    if (people <= 0 || people > hall.value!.capacity) {
      Get.snackbar(
        'Error',
        'Please choose a number between 1 and ${hall.value!.capacity}.',
        backgroundColor: Colors.orange,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
    if (selectedPaymentMethod.value == null) {
      Get.snackbar(
        'Error',
        'Please select a payment method.',
        backgroundColor: Colors.orange,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
    return true;
  }
}