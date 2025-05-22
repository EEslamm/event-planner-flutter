import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../components/halls_booking_controller.dart';
import '../models/hall_model.dart';

class BookingScreen extends StatelessWidget {
  final HallModel hall;
  
  const BookingScreen({
    super.key,
    required this.hall,
  });

  @override
  Widget build(BuildContext context) {
    final BookingController controller = Get.put(BookingController());
    // Set the selected hall
    controller.hall.value = hall;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          "Book ${hall.name}",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black
          )
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Obx(
            () => Column(
              children: [
                // Name
                TextField(
                  controller: controller.nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                // Phone Number
                TextField(
                  controller: controller.phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                // Email
                TextField(
                  controller: controller.emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                // Booking Date
                ListTile(
                  title: Text(
                    controller.selectedDate.value == null
                        ? 'Select Booking Date'
                        : 'Date: ${controller.selectedDate.value!.toLocal().toString().split(' ')[0]}',
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (picked != null) {
                      controller.selectedDate.value = picked;
                    }
                  },
                ),
                const SizedBox(height: 16),
                // Members
                TextField(
                  controller: controller.membersController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Number of People',
                    border: const OutlineInputBorder(),
                    helperText: 'Maximum capacity: ${hall.capacity} people',
                  ),
                ),
                const SizedBox(height: 16),
                // Payment Method
                DropdownButtonFormField<String>(
                  value: controller.selectedPaymentMethod.value,
                  decoration: const InputDecoration(
                    labelText: 'Payment Method',
                    border: OutlineInputBorder(),
                  ),
                  items: controller.paymentMethods.map((String method) {
                    return DropdownMenuItem<String>(
                      value: method,
                      child: Text(method),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    controller.selectedPaymentMethod.value = newValue;
                  },
                ),
                const SizedBox(height: 32),
                // Book Now Button
                SizedBox(
                  width: double.infinity,
                  child: Obx(() => ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : () {
                      if (controller.validateForm()) {
                        controller.createBooking();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                      shadowColor: Colors.green.withOpacity(0.3),
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    child: controller.isLoading.value
                        ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                        : const Text('Book Now'),
                  )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
