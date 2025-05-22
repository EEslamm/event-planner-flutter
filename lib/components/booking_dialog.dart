import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BookingRestaurantDialog extends StatelessWidget {
  final String restaurantName;

  BookingRestaurantDialog({Key? key, required this.restaurantName}) : super(key: key) {
    final controller = Get.put(RestaurantBookingController());
    controller.reset();
    controller.initialize(name: restaurantName);
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RestaurantBookingController>();

    return AlertDialog(
      title: const Text('Booking Details'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller.nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: controller.phoneController,
              decoration: const InputDecoration(labelText: 'Phone Number'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 12),
            Obx(() {
              final dateTime = controller.selectedDateTime.value;
              final formattedDate = dateTime != null
                  ? '${dateTime.day}/${dateTime.month}/${dateTime.year} - ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}'
                  : 'Select Date and Time';
              return ListTile(
                title: Text(formattedDate),
                leading: const Icon(Icons.calendar_today),
                onTap: controller.pickDateTime,
              );
            }),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('Cancel'),
        ),
        Obx(() => ElevatedButton(
          onPressed: controller.isSubmitting.value
              ? null
              : controller.submitBooking,
          child: controller.isSubmitting.value
              ? const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
              : const Text('Confirm Booking'),
        )),
      ],
    );
  }
}

class RestaurantBookingController extends GetxController {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  var selectedDateTime = Rxn<DateTime>();
  var isSubmitting = false.obs;

  late String restaurantName;

  void initialize({required String name}) {
    restaurantName = name;
  }

  void reset() {
    nameController.clear();
    phoneController.clear();
    selectedDateTime.value = null;
    isSubmitting.value = false;
  }

  Future<void> pickDateTime() async {
    final now = DateTime.now();

    final date = await showDatePicker(
      context: Get.context!,
      initialDate: now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );

    if (date == null) return;

    final time = await showTimePicker(
      context: Get.context!,
      initialTime: const TimeOfDay(hour: 18, minute: 0),
    );

    if (time == null) return;

    selectedDateTime.value = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
  }

  Future<void> submitBooking() async {
    final name = nameController.text.trim();
    final phone = phoneController.text.trim();
    final dateTime = selectedDateTime.value;

    if (name.isEmpty || phone.isEmpty || dateTime == null) {
      Get.snackbar("Error", "Please fill all required fields");
      return;
    }

    isSubmitting.value = true;

    try {
      await Supabase.instance.client.from('restaurant_bookings').insert({
        'user_name': name,
        'user_phone': phone,
        'booking_time': dateTime.toIso8601String(),
        'restaurant_name': restaurantName,
      });

      Get.back();
      Get.snackbar("Success", "Booking successful");
    } catch (e) {
      Get.snackbar("Booking Failed", "$e");
    } finally {
      isSubmitting.value = false;
    }
  }
}
