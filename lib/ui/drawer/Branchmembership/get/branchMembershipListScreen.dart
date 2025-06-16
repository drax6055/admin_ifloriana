import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'branchMembershipListController.dart';

class BranchMembershipListScreen extends StatelessWidget {
  final controller = Get.put(BranchMembershipListController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Branch Memberships'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => controller.fetchMemberships(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (controller.memberships.isEmpty) {
          return Center(child: Text('No memberships found'));
        }

        return ListView.builder(
          itemCount: controller.memberships.length,
          itemBuilder: (context, index) {
            final membership = controller.memberships[index];
            return Card(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                title: Text(
                  membership.membershipName,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Plan: ${membership.subscriptionPlan}'),
                    Text('Amount: ₹${membership.membershipAmount}'),
                    Text(
                        'Discount: ${membership.discount}${membership.discountType == 'percentage' ? '%' : ' ₹'}'),
                    Text(
                        'Status: ${membership.status == 1 ? 'Active' : 'Inactive'}'),
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Delete Membership'),
                        content: Text(
                            'Are you sure you want to delete "${membership.membershipName}"?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              controller.deleteMembership(membership.id);
                            },
                            child: Text('Delete',
                                style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
