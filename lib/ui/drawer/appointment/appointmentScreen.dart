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
                    DataCell(a.membership == '-'
                        ? Text('-', style: TextStyle(color: Colors.black))
                        : Chip(
                            label: Text('Yes'),
                            backgroundColor: Colors.grey[700],
                            labelStyle: TextStyle(color: Colors.black))),
                    DataCell(a.package == '-'
                        ? Text('-', style: TextStyle(color: Colors.black))
                        : Chip(
                            label: Text('Yes'),
                            backgroundColor: Colors.grey[700],
                            labelStyle: TextStyle(color: Colors.black))),
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
                      GestureDetector(
                        onTap: a.paymentStatus != 'Paid'
                            ? () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.grey[900],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(16)),
                                  ),
                                  builder: (context) {
                                    final state =
                                        getController.paymentSummaryState;
                                    // Set initial values for this appointment
                                    state.tips.value = '0';
                                    state.paymentMethod.value = 'UPI';
                                    state.couponCode.value = '';
                                    state.appliedCoupon.value = null;
                                    state.addAdditionalDiscount.value = false;
                                    state.discountType.value = 'percentage';
                                    state.discountValue.value = '0';
                                    state.selectedTax.value =
                                        getController.taxes.isNotEmpty
                                            ? getController.taxes.first
                                            : null;
                                    getController.calculateGrandTotal(
                                        a.amount.toDouble());
                                    return Padding(
                                      padding: EdgeInsets.only(
                                        left: 24,
                                        right: 24,
                                        top: 24,
                                        bottom: MediaQuery.of(context)
                                                .viewInsets
                                                .bottom +
                                            24,
                                      ),
                                      child: Obx(() => SingleChildScrollView(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text('Payment Summary',
                                                    style: TextStyle(
                                                        fontSize: 22,
                                                        color:
                                                            Color(0xFFD2BBA0),
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                SizedBox(height: 16),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text('Date: ${a.date}',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500)),
                                                    Text(
                                                        'Customer: ${a.clientName} - 918787787787',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500)),
                                                  ],
                                                ),
                                                SizedBox(height: 8),
                                                Text(
                                                    'Service Amount: ₹ ${a.amount}',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w500)),
                                                Divider(
                                                    color: Colors.grey[700],
                                                    height: 32),
                                                Text('Billing Details',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18)),
                                                SizedBox(height: 12),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child:
                                                          DropdownButtonFormField<
                                                              TaxModel>(
                                                        value: state
                                                            .selectedTax.value,
                                                        dropdownColor:
                                                            Colors.grey[850],
                                                        decoration:
                                                            InputDecoration(
                                                          labelText: 'Tax',
                                                          labelStyle: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                          filled: true,
                                                          fillColor:
                                                              Colors.grey[800],
                                                          border:
                                                              OutlineInputBorder(),
                                                        ),
                                                        items: getController
                                                            .taxes
                                                            .map((tax) =>
                                                                DropdownMenuItem<
                                                                    TaxModel>(
                                                                  value: tax,
                                                                  child: Text(
                                                                      '${tax.title} (${tax.value.toStringAsFixed(0)}%)',
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white)),
                                                                ))
                                                            .toList(),
                                                        onChanged: (tax) {
                                                          state.selectedTax
                                                              .value = tax;
                                                          getController
                                                              .calculateGrandTotal(a
                                                                  .amount
                                                                  .toDouble());
                                                        },
                                                      ),
                                                    ),
                                                    SizedBox(width: 16),
                                                    Expanded(
                                                      child: TextFormField(
                                                        initialValue:
                                                            state.tips.value,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                        decoration:
                                                            InputDecoration(
                                                          labelText: 'Tips',
                                                          labelStyle: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                          filled: true,
                                                          fillColor:
                                                              Colors.grey[800],
                                                          border:
                                                              OutlineInputBorder(),
                                                        ),
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        onChanged: (val) {
                                                          state.tips.value =
                                                              val;
                                                          getController
                                                              .calculateGrandTotal(a
                                                                  .amount
                                                                  .toDouble());
                                                        },
                                                      ),
                                                    ),
                                                    SizedBox(width: 16),
                                                    Expanded(
                                                      child:
                                                          DropdownButtonFormField<
                                                              String>(
                                                        value: state
                                                            .paymentMethod
                                                            .value,
                                                        dropdownColor:
                                                            Colors.grey[850],
                                                        decoration:
                                                            InputDecoration(
                                                          labelText:
                                                              'Payment Method *',
                                                          labelStyle: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                          filled: true,
                                                          fillColor:
                                                              Colors.grey[800],
                                                          border:
                                                              OutlineInputBorder(),
                                                        ),
                                                        items: [
                                                          'UPI',
                                                          'Cash',
                                                          'Card'
                                                        ]
                                                            .map((method) =>
                                                                DropdownMenuItem<
                                                                    String>(
                                                                  value: method,
                                                                  child: Text(
                                                                      method,
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white)),
                                                                ))
                                                            .toList(),
                                                        onChanged: (val) {
                                                          state.paymentMethod
                                                                  .value =
                                                              val ?? 'UPI';
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 24),
                                                Text('Discounts',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18)),
                                                SizedBox(height: 12),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: TextFormField(
                                                        initialValue: state
                                                            .couponCode.value,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                        decoration:
                                                            InputDecoration(
                                                          labelText:
                                                              'Coupon Code',
                                                          labelStyle: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                          filled: true,
                                                          fillColor:
                                                              Colors.grey[800],
                                                          border:
                                                              OutlineInputBorder(),
                                                        ),
                                                        onChanged: (val) {
                                                          state.couponCode
                                                              .value = val;
                                                        },
                                                      ),
                                                    ),
                                                    SizedBox(width: 8),
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        getController
                                                            .applyCoupon(state
                                                                .couponCode
                                                                .value);
                                                        getController
                                                            .calculateGrandTotal(a
                                                                .amount
                                                                .toDouble());
                                                      },
                                                      child: Text('Apply'),
                                                    ),
                                                    SizedBox(width: 16),
                                                    if (a.membership == '-')
                                                      Text(
                                                          'Customer has no membership',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.amber,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                  ],
                                                ),
                                                SizedBox(height: 12),
                                                Row(
                                                  children: [
                                                    Checkbox(
                                                      value: state
                                                          .addAdditionalDiscount
                                                          .value,
                                                      onChanged: (val) {
                                                        state.addAdditionalDiscount
                                                                .value =
                                                            val ?? false;
                                                        getController
                                                            .calculateGrandTotal(a
                                                                .amount
                                                                .toDouble());
                                                      },
                                                      activeColor: Colors.amber,
                                                    ),
                                                    Text(
                                                        'Want to add additional discount?',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white)),
                                                  ],
                                                ),
                                                if (state.addAdditionalDiscount
                                                    .value)
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child:
                                                            DropdownButtonFormField<
                                                                String>(
                                                          value: state
                                                              .discountType
                                                              .value,
                                                          dropdownColor:
                                                              Colors.grey[850],
                                                          decoration:
                                                              InputDecoration(
                                                            labelText:
                                                                'Discount Type',
                                                            labelStyle:
                                                                TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                            filled: true,
                                                            fillColor: Colors
                                                                .grey[800],
                                                            border:
                                                                OutlineInputBorder(),
                                                          ),
                                                          items: [
                                                            DropdownMenuItem(
                                                                value:
                                                                    'percentage',
                                                                child: Text(
                                                                    'Percentage (%)',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white))),
                                                            DropdownMenuItem(
                                                                value: 'amount',
                                                                child: Text(
                                                                    'Amount',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white))),
                                                          ],
                                                          onChanged: (val) {
                                                            state.discountType
                                                                    .value =
                                                                val ??
                                                                    'percentage';
                                                            getController
                                                                .calculateGrandTotal(a
                                                                    .amount
                                                                    .toDouble());
                                                          },
                                                        ),
                                                      ),
                                                      SizedBox(width: 16),
                                                      Expanded(
                                                        child: TextFormField(
                                                          initialValue: state
                                                              .discountValue
                                                              .value,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                          decoration:
                                                              InputDecoration(
                                                            labelText:
                                                                'Discount Value',
                                                            labelStyle:
                                                                TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                            filled: true,
                                                            fillColor: Colors
                                                                .grey[800],
                                                            border:
                                                                OutlineInputBorder(),
                                                          ),
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          onChanged: (val) {
                                                            state.discountValue
                                                                .value = val;
                                                            getController
                                                                .calculateGrandTotal(a
                                                                    .amount
                                                                    .toDouble());
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                SizedBox(height: 24),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text('Grand Total',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 18)),
                                                    Text(
                                                        '₹ ${state.grandTotal.value.toStringAsFixed(2)}',
                                                        style: TextStyle(
                                                            color: Colors
                                                                .greenAccent,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 22)),
                                                  ],
                                                ),
                                                SizedBox(height: 24),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    OutlinedButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context),
                                                      style: OutlinedButton
                                                          .styleFrom(
                                                        side: BorderSide(
                                                            color: Colors
                                                                .redAccent),
                                                      ),
                                                      child: Text('Cancel',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .redAccent)),
                                                    ),
                                                    SizedBox(width: 16),
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        // TODO: Implement bill generation logic
                                                        Navigator.pop(context);
                                                      },
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            Color(0xFF8C6E54),
                                                      ),
                                                      child:
                                                          Text('Generate Bill'),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 8),
                                              ],
                                            ),
                                          )),
                                    );
                                  },
                                );
                              }
                            : null,
                        child: Chip(
                          label: Text(a.paymentStatus,
                              style: TextStyle(color: Colors.black)),
                          backgroundColor: a.paymentStatus == 'Paid'
                              ? Colors.green
                              : Colors.orange,
                        ),
                      ),
                    ),
                    DataCell(Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.receipt,
                              color: a.paymentStatus == 'Paid'
                                  ? Colors.blue
                                  : Colors.grey),
                          onPressed: a.paymentStatus == 'Paid' ? () {} : null,
                        ),
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
