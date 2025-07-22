import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/route/app_route.dart';
import 'package:flutter_template/utils/colors.dart';
import 'package:flutter_template/wiget/appbar/commen_appbar.dart';
import 'package:get/get.dart';
import 'customerController.dart';

class CustomersScreen extends StatelessWidget {
  CustomersScreen({super.key});
  final CustomerController customerController = Get.put(CustomerController());
                       
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Customers"),
      body: Obx(() => customerController.customerList.isEmpty
          ? Center(
              child: Text(
                "No customers available.",
                style: TextStyle(fontSize: 16.sp),
              ),
            )
          : ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: customerController.customerList.length,
              itemBuilder: (context, index) {
                final customer = customerController.customerList[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Icon(Icons.person),
                    ),
                    title: Text(customer.fullName),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text(customer.email),
                        Text(customer.phoneNumber),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            Get.toNamed(
                              Routes.editCustomer,
                              arguments: customer,
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            customerController.deleteCustomer(customer.id);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(Routes.addCustomer);
        },
        child: Icon(Icons.add),
        backgroundColor: primaryColor,
      ),
    );
  }
}
