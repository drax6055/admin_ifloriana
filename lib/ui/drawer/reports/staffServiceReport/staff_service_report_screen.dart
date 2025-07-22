import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/ui/drawer/reports/staffServiceReport/staff_service_report_controller.dart';
import 'package:flutter_template/wiget/appbar/commen_appbar.dart';
import 'package:flutter_template/wiget/custome_text.dart';
import 'package:get/get.dart';

class StaffServiceReportScreen extends StatelessWidget {
  const StaffServiceReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final StaffServiceReportController controller =
        Get.put(StaffServiceReportController());

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                onChanged: (value) => controller.updateSearchQuery(value),
                decoration: const InputDecoration(
                  labelText: 'Search by Staff Name',
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
                if (controller.staffServiceReports.isEmpty) {
                  return const Center(child: Text('No data available'));
                }
                if (controller.filteredStaffServiceReports.isEmpty) {
                  return const Center(
                      child: Text('No staff found with that name.'));
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
                            DataColumn(label: Text('Staff')),
                            DataColumn(label: Text('Services')),
                            DataColumn(label: Text('Commission')),
                            DataColumn(label: Text('Tips')),
                            DataColumn(label: Text('Total Earning')),
                            // DataColumn(label: Text('Total Amount')),
                          ],
                          rows: controller.filteredStaffServiceReports
                              .map((report) {
                            return DataRow(cells: [
                              DataCell(
                                Row(
                                  children: [
                                    if (report.staffImage != null)
                                      CircleAvatar(
                                        backgroundImage:
                                            NetworkImage(report.staffImage!),
                                      ),
                                    const SizedBox(width: 8),
                                    Text(report.staffName ?? ''),
                                  ],
                                ),
                              ),
                              DataCell(
                                  Text(report.services?.toString() ?? '0')),
                              DataCell(Text(
                                  report.commissionEarn?.toString() ?? '0')),
                              DataCell(
                                  Text(report.tipsEarn?.toString() ?? '0')),
                              DataCell(
                                  Text(report.totalEarning?.toString() ?? '0')),
                              // DataCell(
                              //     Text(report.totalAmount?.toString() ?? '0')),
                            ]);
                          }).toList(),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Text('Total: ',
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
