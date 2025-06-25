import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../ui/drawer/reports/dailyBooking/dailyBookingController.dart';

class DailybookingScreen extends StatelessWidget {
  const DailybookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Dailybookingcontroller controller = Get.put(Dailybookingcontroller());

    return SafeArea(child: Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.dailyReports.isEmpty) {
          return Center(child: Text('No data available'));
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
                    DataColumn(label: Text('Date')),
                    DataColumn(label: Text('Appointments')),
                    DataColumn(label: Text('Services')),
                    DataColumn(label: Text('Service Amount')),
                    DataColumn(label: Text('Tax')),
                    DataColumn(label: Text('Tips')),
                    DataColumn(label: Text('Discount')),
                    DataColumn(label: Text('Final Amount')),
                  ],
                  rows: controller.dailyReports.map((report) {
                    return DataRow(cells: [
                      DataCell(Text(report.date ?? '')),
                      DataCell(
                          Text(report.appointmentsCount?.toString() ?? '0')),
                      DataCell(Text(report.servicesCount?.toString() ?? '0')),
                      DataCell(Text(report.serviceAmount?.toString() ?? '0')),
                      DataCell(Text(report.taxAmount?.toString() ?? '0')),
                      DataCell(Text(report.tipsEarning?.toString() ?? '0')),
                      DataCell(
                          Text(report.additionalDiscount?.toString() ?? '0')),
                      DataCell(Text(report.finalAmount?.toString() ?? '0')),
                    ]);
                  }).toList(),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Text('Grand Total: ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16.sp)),
                      Text('${controller.grandTotal.value}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16.sp)),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      }),
    ));
  }
}
