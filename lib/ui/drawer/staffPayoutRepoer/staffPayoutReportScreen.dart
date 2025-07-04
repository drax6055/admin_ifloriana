import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/ui/drawer/staffPayoutRepoer/staffPayoutReoirtController.dart';
import 'package:flutter_template/ui/splash/splash_controller.dart';
import 'package:flutter_template/utils/colors.dart';
import 'package:get/get.dart';
import 'staff_payout_model.dart';

class Staffpayoutreportscreen extends StatelessWidget {
  const Staffpayoutreportscreen({super.key});

  @override
  Widget build(BuildContext context) {
    final StatffearningReportcontroller getController =
        Get.put(StatffearningReportcontroller());

    return Scaffold(
      appBar: AppBar(title: Text('Staff Payout Report')),
      body: Obx(() {
        if (getController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        if (getController.payouts.isEmpty) {
          return Center(
              child: Text('No payout data available',
                  style: TextStyle(color: Colors.red)));
        }
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Filter by Staff Name',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => getController.filterText.value = value,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Payment Date')),
                    DataColumn(label: Text('Staff')),
                    DataColumn(label: Text('Commission Amount')),
                    DataColumn(label: Text('Tips Amount')),
                    DataColumn(label: Text('Payment Type')),
                    DataColumn(label: Text('Total Pay')),
                  ],
                  rows: getController.filteredPayouts.map((payout) {
                    return DataRow(cells: [
                      DataCell(Text(payout.formattedDate)),
                      DataCell(Text(payout.staffName)),
                      DataCell(Text(payout.commissionAmount.toString())),
                      DataCell(Text(payout.tips.toString())),
                      DataCell(Text(payout.paymentType)),
                      DataCell(Text(payout.totalPay.toString())),
                    ]);
                  }).toList(),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
