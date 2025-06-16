import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_template/utils/colors.dart';
import 'package:flutter_template/ui/drawer/branchPackages/branchPackagesController.dart';
import '../../../wiget/Custome_textfield.dart';

class DynamicInputScreen extends StatelessWidget {
  final DynamicInputController controller = Get.put(DynamicInputController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dynamic Service Inputs')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: controller.addContainer,
              child: Text('Add Container'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Obx(() => ListView.builder(
                    itemCount: controller.containerList.length,
                    itemBuilder: (context, index) {
                      final data = controller.containerList[index];
                      return Obx(() => Container(
                            margin: EdgeInsets.only(bottom: 16),
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.blue),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Container ${index + 1}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    IconButton(
                                      icon: Icon(Icons.delete,
                                          color: primaryColor),
                                      onPressed: () =>
                                          controller.removeContainer(index),
                                    ),
                                  ],
                                ),
                             DropdownButtonFormField<Service>(
                                  value: data.selectedService.value,
                                  items: controller.serviceList
                                      .map((service) => DropdownMenuItem(
                                            value: service,
                                            child: Text(service.name ?? ''),
                                          ))
                                      .toList(),
                                  onChanged: (newService) {
                                    if (newService != null) {
                                      data.selectedService.value = newService;

                                 
                                      final regularPrice =
                                          newService.regularPrice ?? 0;
                                      data.discountedPriceController.text =
                                          regularPrice.toString();

                                      // Trigger total update
                                      controller.updateTotal(data);
                                    }
                                  },
                                  decoration: InputDecoration(
                                    labelText: "Select Service",
                                    border: OutlineInputBorder(),
                                  ),
                                ),

                                SizedBox(height: 10),
                                CustomTextFormField(
                                  controller: data.discountedPriceController,
                                  labelText: 'Discounted Price',
                                  hintText: 'Enter Discounted Price',
                                  keyboardType: TextInputType.number,
                                ),
                                SizedBox(height: 10),
                                CustomTextFormField(
                                  controller: data.quantityController,
                                  labelText: 'Quantity',
                                  hintText: 'Enter Quantity',
                                  keyboardType: TextInputType.number,
                                ),
                                SizedBox(height: 10),
                                Text("Total: ₹${data.total.value}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green)),
                              ],
                            ),
                          ));
                    },
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
