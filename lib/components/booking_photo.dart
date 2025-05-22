import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BookingPhotographerDialog extends StatelessWidget {
  final String photographerName;
  final double hourlyRate;

  BookingPhotographerDialog({
    Key? key,
    required this.photographerName,
    required this.hourlyRate,
  }) : super(key: key) {
    final controller = Get.put(BookingPhotographerController());
    controller.reset();
    controller.initialize(rate: hourlyRate, name: photographerName);
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BookingPhotographerController>();

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
            const SizedBox(height: 12),
            Row(
              children: [
                const Text('Hours:'),
                const SizedBox(width: 10),
                Obx(() => DropdownButton<int>(
                  value: controller.selectedHours.value,
                  items: List.generate(6, (index) => index + 1)
                      .map((e) =>
                      DropdownMenuItem(value: e, child: Text('$e')))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) controller.selectedHours.value = value;
                  },
                )),
              ],
            ),
            const SizedBox(height: 12),
            Obx(() => Text(
                'Total Price: ${controller.totalPrice.toStringAsFixed(2)} EGP')),
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

class BookingPhotographerController extends GetxController {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  var selectedDateTime = Rxn<DateTime>();
  var selectedHours = 1.obs;
  var isSubmitting = false.obs;

  late double hourlyRate;
  late String photographerName;

  void initialize({required double rate, required String name}) {
    hourlyRate = rate;
    photographerName = name;
  }

  double get totalPrice => selectedHours.value * hourlyRate;

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

  void reset() {
    nameController.clear();
    phoneController.clear();
    selectedDateTime.value = null;
    selectedHours.value = 1;
    isSubmitting.value = false;
  }

  Future<void> submitBooking() async {
    final name = nameController.text.trim();
    final phone = phoneController.text.trim();
    final dateTime = selectedDateTime.value;
    final hours = selectedHours.value;
    final totalPrice = hours * hourlyRate;

    if (name.isEmpty || phone.isEmpty || dateTime == null) {
      Get.snackbar("Error", "Please fill all required fields");
      return;
    }

    isSubmitting.value = true;

    final endTime = dateTime.add(Duration(hours: hours));
    final startOfDay = DateTime(dateTime.year, dateTime.month, dateTime.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    try {
      final existingBookings = await Supabase.instance.client
          .from('photographers_booking')
          .select()
          .eq('photographer_name', photographerName)
          .gte('booking_time', startOfDay.toIso8601String())
          .lt('booking_time', endOfDay.toIso8601String());

      for (var booking in existingBookings) {
        final existingStart = DateTime.parse(booking['booking_time']);
        final existingEnd = existingStart.add(Duration(hours: booking['hours']));

        final bool isOverlapping = dateTime.isBefore(existingEnd) && endTime.isAfter(existingStart);
        if (isOverlapping) {
          final suggestedStart = existingEnd;
          final suggestedHour = suggestedStart.hour.toString().padLeft(2, '0');
          final suggestedMinute = suggestedStart.minute.toString().padLeft(2, '0');

          Get.snackbar(
            "Booking Rejected",
            "This time overlaps with another booking. Try after ${suggestedHour}:${suggestedMinute}",
          );
          isSubmitting.value = false;
          return;
        }
      }

      await Supabase.instance.client.from('photographers_booking').insert({
        'user_name': name,
        'user_phone': phone,
        'booking_time': dateTime.toIso8601String(),
        'photographer_name': photographerName,
        'hours': hours,
        'total_price': totalPrice,
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
