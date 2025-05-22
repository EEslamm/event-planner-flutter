import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../components/ideaBotController.dart';

class IdeaScreen extends StatelessWidget {
  final IdeaBotController controller = Get.put(IdeaBotController());

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.9,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [

              Obx(() => ListView.builder(
                shrinkWrap: true,
                itemCount: controller.messages.length,
                itemBuilder: (_, index) {
                  final msg = controller.messages[index];
                  return ListTile(
                    title: Text(msg['user'] ?? '', style: const TextStyle(color: Colors.blue)),
                    subtitle: Text(msg['bot'] ?? '', style: const TextStyle(color: Colors.green)),
                  );
                },
              )),

              const SizedBox(height: 16),

              TextFormField(
                controller: controller.capacityController,
                decoration: const InputDecoration(labelText: 'Number of People'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),

              Obx(() => DropdownButtonFormField<String>(
                value: controller.selectedLocation.value.isNotEmpty
                    ? controller.selectedLocation.value
                    : null,
                items: controller.selectedLocationList
                    .map((loc) => DropdownMenuItem(child: Text(loc), value: loc))
                    .toList(),
                onChanged: (val) => controller.selectedLocation.value = val ?? '',
                decoration: const InputDecoration(labelText: 'Location'),
              )),
              const SizedBox(height: 12),

              Obx(() => DropdownButtonFormField<String>(
                value: controller.photographerAvailability.value,
                items: ['Yes', 'No'].map((val) => DropdownMenuItem(child: Text(val), value: val)).toList(),
                onChanged: (val) => controller.photographerAvailability.value = val ?? 'No',
                decoration: const InputDecoration(labelText: 'Photographer Included?'),
              )),
              const SizedBox(height: 12),

              Obx(() => DropdownButtonFormField<String>(
                value: controller.makeup.value,
                items: ['Yes', 'No'].map((val) => DropdownMenuItem(child: Text(val), value: val)).toList(),
                onChanged: (val) => controller.makeup.value = val ?? 'No',
                decoration: const InputDecoration(labelText: 'Makeup Included?'),
              )),
              const SizedBox(height: 12),

              Obx(() => DropdownButtonFormField<String>(
                value: controller.cake.value,
                items: ['Yes', 'No'].map((val) => DropdownMenuItem(child: Text(val), value: val)).toList(),
                onChanged: (val) => controller.cake.value = val ?? 'No',
                decoration: const InputDecoration(labelText: 'Cake Included?'),
              )),
              const SizedBox(height: 12),

              Obx(() => DropdownButtonFormField<String>(
                value: controller.food.value,
                items: ['Yes', 'No'].map((val) => DropdownMenuItem(child: Text(val), value: val)).toList(),
                onChanged: (val) => controller.food.value = val ?? 'No',
                decoration: const InputDecoration(labelText: 'Food Included?'),
              )),
              const SizedBox(height: 12),

              Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Rating: ${controller.rating.value.toStringAsFixed(1)}"),
                  Slider(
                    value: controller.rating.value,
                    min: 1.0,
                    max: 4.0,
                    divisions: 6,
                    label: controller.rating.value.toStringAsFixed(1),
                    onChanged: (val) => controller.rating.value = val,
                  ),
                ],
              )),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final price = controller.predictPrice();

                        controller.messages.clear();
                        controller.messages.add({
                          'bot': price,
                        });
                      },
                      child: const Text('Predict Price'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    onPressed: controller.clearAllData,
                    icon: const Icon(Icons.refresh),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
