import 'package:flutter/material.dart';
import 'package:flutter_template/ui/drawer/coupons/couponsController.dart';
import 'package:get/get.dart';

class CouponsScreen extends StatelessWidget {
  const CouponsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CouponsController getController = Get.put(CouponsController());


    return SafeArea(
        child: Scaffold(
      body: Obx(() {
        if (getController.couponList.isEmpty) {
          return const Center(child: Text("No coupons available"));
        }
        return ListView.builder(
          itemCount: getController.couponList.length,
          itemBuilder: (context, index) {
            final coupon = getController.couponList[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: ListTile(
                title: Text(coupon.name ?? '-', style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Type: ${coupon.type ?? '-'}"),
                    Text("Discount Type: ${coupon.discountType ?? '-'}"),
                    Text("Use Limit: ${coupon.useLimit ?? 0}"),
                    Text("Status: ${coupon.status == 1 ? 'Active' : 'Deactive'}",
                        style: TextStyle(
                          color: coupon.status == 1 ? Colors.green : Colors.red,
                          fontWeight: FontWeight.w500,
                        )),
                  ],
                ),
              ),
            );
          },
        );
      }),
    ));
  }
}
