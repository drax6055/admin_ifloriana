import 'package:flutter_template/main.dart';
import 'package:flutter_template/network/network_const.dart';
import 'package:flutter_template/wiget/custome_snackbar.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class Staffdetailscontroller extends GetxController {
  var staffList = [].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getCustomerDetails();
  }

  Future<void> getCustomerDetails() async {
    isLoading.value = true;
    try {
      final response = await dioClient.getData(
        '${Apis.baseUrl}${Endpoints.getStaffDetails}',
        (json) => json,
      );
      staffList.value = response['data'] ?? [];
    } catch (e) {
      CustomSnackbar.showError('Error', 'Failed to check email: $e');
    } finally {
      isLoading.value = false;
    }
  }
}

// Widget for expandable staff list
class StaffExpandableList extends StatelessWidget {
  final List staffList;
  const StaffExpandableList({super.key, required this.staffList});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: staffList.length,
      itemBuilder: (context, index) {
        final staff = staffList[index];
        return ExpansionTile(
          title: Text(staff['full_name'] ?? 'No Name'),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Email: 	${staff['email'] ?? ''}'),
                  Text('Phone: 	${staff['phone_number'] ?? ''}'),
                  // Add more fields as needed
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
