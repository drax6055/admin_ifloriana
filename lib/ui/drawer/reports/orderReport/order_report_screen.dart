import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/ui/drawer/reports/orderReport/order_report_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class OrderReportScreen extends StatelessWidget {
  const OrderReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final OrderReportController controller = Get.put(OrderReportController());

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Order Report'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                onChanged: (value) => controller.updateSearchQuery(value),
                decoration: const InputDecoration(
                  labelText: 'Search by Client Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                ),
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
                      child: Text('No client found with that name.'));
                }
                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DataTable(
                          columns: const [
                            DataColumn(label: Text('Client')),
                            DataColumn(label: Text('Email')),
                            DataColumn(label: Text('Phone')),
                            DataColumn(label: Text('Created At')),
                            DataColumn(label: Text('Product Count')),
                            DataColumn(label: Text('Payment Method')),
                            DataColumn(label: Text('Total Price')),
                          ],
                          rows: controller.filteredOrderReports.map((report) {
                            return DataRow(cells: [
                              DataCell(Text(report.customerId?.fullName ?? '')),
                              DataCell(Text(report.customerId?.email ?? '')),
                              DataCell(
                                  Text(report.customerId?.phoneNumber ?? '')),
                              DataCell(Text(report.createdAt != null
                                  ? DateFormat('yyyy-MM-dd')
                                      .format(DateTime.parse(report.createdAt!))
                                  : '')),
                              DataCell(
                                  Text(report.productCount?.toString() ?? '0')),
                              DataCell(Text(report.paymentMethod ?? '')),
                              DataCell(
                                  Text(report.totalPrice?.toString() ?? '0')),
                            ]);
                          }).toList(),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Text('Grand Total: ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.sp)),
                              Text('${controller.grandTotal.value}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.sp)),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
