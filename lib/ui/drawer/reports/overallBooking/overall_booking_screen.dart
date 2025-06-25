import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/ui/drawer/reports/overallBooking/overall_booking_controller.dart';
import 'package:flutter_template/wiget/appbar/commen_appbar.dart';
import 'package:flutter_template/wiget/custome_text.dart';
import 'package:get/get.dart';

class OverallBookingScreen extends StatelessWidget {
  const OverallBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final OverallBookingController controller =
        Get.put(OverallBookingController());

    return SafeArea(
      child: Scaffold(
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.overallBookings.isEmpty) {
            return const Center(child: Text('No data available'));
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
                      DataColumn(label: Text('Appointment Date')),
                      DataColumn(label: Text('Service Count')),
                      DataColumn(label: Text('Service Amount')),
                      DataColumn(label: Text('Tax')),
                      DataColumn(label: Text('Tips')),
                      DataColumn(label: Text('Total Amount')),
                      DataColumn(label: Text('Invoice ID')),
                    ],
                    rows: controller.overallBookings.map((booking) {
                      return DataRow(cells: [
                        DataCell(
                          Row(
                            children: [
                              if (booking.staffImage != null)
                                CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(booking.staffImage!),
                                ),
                              const SizedBox(width: 8),
                              Text(booking.staffName ?? ''),
                            ],
                          ),
                        ),
                        DataCell(Text(booking.appointmentDate ?? '')),
                        DataCell(Text(booking.serviceCount?.toString() ?? '0')),
                        DataCell(Text(
                            booking.totalServiceAmount?.toString() ?? '0')),
                        DataCell(Text(booking.taxAmount?.toString() ?? '0')),
                        DataCell(Text(booking.tipsAmount?.toString() ?? '0')),
                        DataCell(Text(booking.totalAmount?.toString() ?? '0')),
                        DataCell(Text(booking.invoiceId ?? '')),
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
      ),
    );
  }
}
