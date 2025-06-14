import 'package:flutter/material.dart';
import 'package:flutter_template/ui/drawer/manager/getManager/getmanagerController.dart';
import 'package:flutter_template/wiget/appbar/commen_appbar.dart';
import 'package:get/get.dart';
import 'package:flutter_template/ui/drawer/manager/addManager/managerScreen.dart';

class Getmanagerscreen extends StatelessWidget {
  Getmanagerscreen({super.key});
  final Getmanagercontroller getController = Get.put(Getmanagercontroller());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "done",
      ),
      body: Obx(() {
        if (getController.managers.isEmpty) {
          return Center(child: Text("No managers found"));
        }
        return ListView.builder(
          itemCount: getController.managers.length,
          itemBuilder: (context, index) {
            final manager = getController.managers[index];
            return ExpansionTile(
              shape: Border.all(color: Colors.transparent),
              title: Text('${manager.firstName} ${manager.lastName}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => Managerscreen(manager: manager),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      getController.deleteManager(manager.id);
                    },
                  ),
                ],
              ),
              children: [
                Text('Email: ${manager.email}'),
                Text('Contact: ${manager.contactNumber}'),
                Text('Branch: ${manager.branchName}'),
              ],
            );
          },
        );
      }),
    );
  }
}
