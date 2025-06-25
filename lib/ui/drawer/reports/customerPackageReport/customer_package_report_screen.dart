import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/ui/drawer/reports/customerPackageReport/customer_package_report_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CustomerPackageReportScreen extends StatelessWidget {
  const CustomerPackageReportScreen({super.key});

  String getStatusText(int? status) {
    switch (status) {
      case 1:
        return 'Active';
      case 0:
        return 'Inactive';
      default:
        return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    final CustomerPackageReportController controller =
        Get.put(CustomerPackageReportController());

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Customer Package Report'),
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.customerPackages.isEmpty) {
            return const Center(child: Text('No customers with packages.'));
          }
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Customer Name')),
                  DataColumn(label: Text('Email')),
                  DataColumn(label: Text('Package Name')),
                  DataColumn(label: Text('Package Price')),
                  DataColumn(label: Text('Valid Till')),
                  DataColumn(label: Text('Status')),
                ],
                rows: controller.customerPackages.expand((customer) {
                  return customer.branchPackage!.map((pkg) {
                    return DataRow(cells: [
                      DataCell(Text(customer.fullName ?? '')),
                      DataCell(Text(customer.email ?? '')),
                      DataCell(Text(pkg.packageName ?? '')),
                      DataCell(Text(pkg.packagePrice?.toString() ?? '')),
                      DataCell(Text(customer.branchPackageValidTill != null
                          ? DateFormat('yyyy-MM-dd').format(
                              DateTime.parse(customer.branchPackageValidTill!))
                          : '')),
                      DataCell(Text(getStatusText(pkg.status))),
                    ]);
                  });
                }).toList(),
              ),
            ),
          );
        }),
      ),
    );
  }
}
