import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/network/network_const.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../route/app_route.dart';
import 'getOrderListController.dart';

class Getorderlistscreen extends StatelessWidget {
  Getorderlistscreen({super.key});
  final Getorderlistcontroller controller = Get.put(Getorderlistcontroller());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Order List'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    onChanged: (value) => controller.updateSearchQuery(value),
                    decoration: const InputDecoration(
                      labelText: 'Search by Client Name',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Obx(
                    () => DropdownButtonFormField<String>(
                      value: controller.selectedPaymentMethod.value,
                      decoration: const InputDecoration(
                        labelText: 'Filter by Payment Method',
                        border: OutlineInputBorder(),
                      ),
                      items: controller.paymentMethods
                          .map((method) => DropdownMenuItem(
                                value: method,
                                child: Text(method),
                              ))
                          .toList(),
                      onChanged: (value) {
                        controller.updatePaymentMethodFilter(value);
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.orderReports.isEmpty) {
                  return const Center(child: Text('No data available'));
                }
                if (controller.filteredOrderReports.isEmpty) {
                  return const Center(
                      child: Text('No orders found matching the criteria.'));
                }
                return RefreshIndicator(
                  onRefresh: controller.getOrderReports,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DataTable(
                            columns: const [
                              DataColumn(label: Text('Client')),
                              // DataColumn(label: Text('Email')),
                              DataColumn(label: Text('Phone')),
                              DataColumn(label: Text('Places On')),
                              DataColumn(label: Text('Item')),
                              DataColumn(label: Text('Payment Method')),
                              DataColumn(label: Text('Total Price')),
                              DataColumn(label: Text('Action')),
                            ],
                            rows: controller.filteredOrderReports.map((report) {
                              return DataRow(cells: [
                                DataCell(
                                    Text(report.customerId?.fullName ?? '')),
                                // DataCell(Text(report.customerId?.email ?? '')),
                                DataCell(
                                    Text(report.customerId?.phoneNumber ?? '')),
                                DataCell(Text(report.createdAt != null
                                    ? DateFormat('yyyy-MM-dd').format(
                                        DateTime.parse(report.createdAt!))
                                    : '')),
                                DataCell(Text(
                                    report.productCount?.toString() ?? '0')),
                                DataCell(Text(report.paymentMethod ?? '')),
                                DataCell(
                                    Text(report.totalPrice?.toString() ?? '0')),
                                DataCell(Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.remove_red_eye),
                                      onPressed: () {
                                        String pdfUrl =
                                            '${Apis.pdfUrl}${report.invoice_pdf_url}';
                                        controller.openPdf(pdfUrl);
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        if (report.order_code != null) {
                                          controller.deleteOrder(report.id!);
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                    'Order code not found.')),
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ))
                              ]);
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final result = await Get.toNamed(Routes.placeOrder);
            if (result == true) {
              controller.getOrderReports();
            }
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
