import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/ui/drawer/appointment/appointmentController.dart';
import 'package:flutter_template/utils/colors.dart';
import 'package:get/get.dart';

class Appointmentscreen extends StatelessWidget {
  Appointmentscreen({super.key});
  final AppointmentController getController = Get.put(AppointmentController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Obx(() {
            if (getController.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            }
            if (getController.appointments.isEmpty) {
              return Center(
                  child: Text('No appointments found',
                      style: TextStyle(color: Colors.black)));
            }
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: MaterialStateProperty.all(secondaryColor),
                columns: const [
                  DataColumn(
                      label: Text('Date & Time',
                          style: TextStyle(color: Colors.black))),
                  DataColumn(
                      label: Text('Client',
                          style: TextStyle(color: Colors.black))),
                  DataColumn(
                      label: Text('Amount',
                          style: TextStyle(color: Colors.black))),
                  DataColumn(
                      label: Text('Staff Name',
                          style: TextStyle(color: Colors.black))),
                  DataColumn(
                      label: Text('Services',
                          style: TextStyle(color: Colors.black))),
                  DataColumn(
                      label: Text('Membership',
                          style: TextStyle(color: Colors.black))),
                  DataColumn(
                      label: Text('Package',
                          style: TextStyle(color: Colors.black))),
                  DataColumn(
                      label: Text('Status',
                          style: TextStyle(color: Colors.black))),
                  DataColumn(
                      label: Text('Payment Status',
                          style: TextStyle(color: Colors.black))),
                  DataColumn(
                      label: Text('Action',
                          style: TextStyle(color: Colors.black))),
                ],
                rows: getController.appointments.map((a) {
                  return DataRow(cells: [
                    DataCell(Text('${a.date} - ${a.time}',
                        style: TextStyle(color: Colors.black))),
                    DataCell(Row(
                      children: [
                        CircleAvatar(
                          backgroundImage:
                              a.clientImage != null && a.clientImage!.isNotEmpty
                                  ? NetworkImage(a.clientImage!)
                                  : null,
                          child:
                              (a.clientImage == null || a.clientImage!.isEmpty)
                                  ? Icon(Icons.person, color: Colors.black)
                                  : null,
                        ),
                        SizedBox(width: 8),
                        Flexible(
                            child: Text(a.clientName,
                                style: TextStyle(color: Colors.black))),
                      ],
                    )),
                    DataCell(Text('₹ ${a.amount}',
                        style: TextStyle(color: Colors.black))),
                    DataCell(Row(
                      children: [
                        CircleAvatar(
                          backgroundImage:
                              a.staffImage != null && a.staffImage!.isNotEmpty
                                  ? NetworkImage(a.staffImage!)
                                  : null,
                          child: (a.staffImage == null || a.staffImage!.isEmpty)
                              ? Icon(Icons.person, color: Colors.black)
                              : null,
                        ),
                        SizedBox(width: 8),
                        Flexible(
                            child: Text(a.staffName,
                                style: TextStyle(color: Colors.black))),
                      ],
                    )),
                    DataCell(Text(a.serviceName,
                        style: TextStyle(color: Colors.black))),
                    DataCell(a.membership == 'Yes'
                        ? Chip(
                            label: Text('Yes'),
                            backgroundColor: Colors.grey[700],
                            labelStyle: TextStyle(color: Colors.black))
                        : Text('-', style: TextStyle(color: Colors.black))),
                    DataCell(a.package == 'Yes'
                        ? Chip(
                            label: Text('Yes'),
                            backgroundColor: Colors.grey[700],
                            labelStyle: TextStyle(color: Colors.black))
                        : Text('-', style: TextStyle(color: Colors.black))),
                    DataCell(
                      Chip(
                        label: Text(
                          a.status == 'upcoming'
                              ? 'Upcoming'
                              : a.status == 'cancelled'
                                  ? 'Cancelled'
                                  : 'Check-out',
                          style: TextStyle(color: Colors.black),
                        ),
                        backgroundColor: a.status == 'upcoming'
                            ? Colors.purple
                            : a.status == 'cancelled'
                                ? Colors.red
                                : Colors.green,
                      ),
                    ),
                    DataCell(
                      Chip(
                        label: Text(a.paymentStatus,
                            style: TextStyle(color: Colors.black)),
                        backgroundColor: a.paymentStatus == 'Paid'
                            ? Colors.green
                            : Colors.orange,
                      ),
                    ),
                    DataCell(Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.cyanAccent),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.redAccent),
                          onPressed: () {},
                        ),
                      ],
                    )),
                  ]);
                }).toList(),
              ),
            );
          }),
        ),
      ),
    );
  }
}
