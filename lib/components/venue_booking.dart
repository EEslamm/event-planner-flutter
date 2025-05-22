import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BookingBirthdayVenueDialog extends StatelessWidget {
  final int venueId;
  final String venueName;

  BookingBirthdayVenueDialog({
    Key? key,
    required this.venueId,
    required this.venueName,
  }) : super(key: key) {
    final controller = Get.put(BookingBirthdayVenueController());
    controller.reset();
    controller.initialize(venueId: venueId, venueName: venueName);
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BookingBirthdayVenueController>();

    return AlertDialog(
      title: Text('Book $venueName'),
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
              final date = controller.selectedDate.value;
              final time = controller.selectedTime.value;
              final formattedDate = date != null
                  ? '${date.day}/${date.month}/${date.year}'
                  : 'Select Date and Time';

              final formattedTime = time != null
                  ? ' - ${time.hour}:${time.minute.toString().padLeft(2, '0')}'
                  : '';

              return ListTile(
                title: Text('$formattedDate$formattedTime'),
                leading: const Icon(Icons.calendar_today),
                onTap: controller.pickDateTime,  // هنا هنستدعي اختيار التاريخ ثم الوقت مع بعض
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

class BookingBirthdayVenueController extends GetxController {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  var selectedDate = Rxn<DateTime>();
  var selectedTime = Rxn<TimeOfDay>();
  var isSubmitting = false.obs;

  late int venueId;
  late String venueName;

  void initialize({required int venueId, required String venueName}) {
    this.venueId = venueId;
    this.venueName = venueName;
  }

  Future<void> pickDateTime() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: Get.context!,
      initialDate: now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (date != null) {
      selectedDate.value = date;

      final time = await showTimePicker(
        context: Get.context!,
        initialTime: const TimeOfDay(hour: 18, minute: 0),
      );

      if (time != null) {
        selectedTime.value = time;
      } else {
        selectedDate.value = null;
      }
    }
  }
  void reset() {
    nameController.clear();
    phoneController.clear();
    selectedDate.value = null;
    selectedTime.value = null;
    isSubmitting.value = false;
  }
  Future<void> submitBooking() async {
    final name = nameController.text.trim();
    final phone = phoneController.text.trim();
    final date = selectedDate.value;
    final time = selectedTime.value;

    if (name.isEmpty || phone.isEmpty || date == null || time == null) {
      Get.snackbar("Error", "Please fill all required fields");
      return;
    }

    isSubmitting.value = true;

    final bookingDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    try {
      await Supabase.instance.client.from('birthday_booking').insert({
        'name': name,
        'phone': phone,
        'date': date.toIso8601String().substring(0, 10),
        'time': bookingDateTime.toIso8601String().substring(11, 19),
        'venue_id': venueId,
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
