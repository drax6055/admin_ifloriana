import 'package:flutter/material.dart';
import 'package:flutter_template/ui/drawer/products/brand/get/getBrandsController.dart';
import 'package:flutter_template/utils/colors.dart';
import 'package:get/get.dart';

import '../../../../../route/app_route.dart';

class Getbrandsscreen extends StatelessWidget {
  Getbrandsscreen({super.key});
  final Getbrandscontroller getController = Get.put(Getbrandscontroller());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Obx(
        () => getController.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: getController.brands.length,
                itemBuilder: (context, index) {
                  final brand = getController.brands[index];
                  return Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border(
                            right:
                                BorderSide(color: secondaryColor, width: 3))),
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      leading: brand.image.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                brand.image,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 50,
                                    height: 50,
                                    color: Colors.grey[300],
                                    child:
                                        const Icon(Icons.image_not_supported),
                                  );
                                },
                              ),
                            )
                          : Container(
                              width: 50,
                              height: 50,
                              color: Colors.grey[300],
                              child: const Icon(Icons.image_not_supported),
                            ),
                      title: Text(
                        brand.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(
                        'Branches: ${brand.branchId.length}',
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              icon: const Icon(Icons.delete_outline),
                              color: Colors.red,
                              onPressed: () =>
                                  getController.deleteBrand(brand.id)),
                        ],
                      ),
                    ),
                  );
                },
              ),
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(Routes.postBranchs);
        },
        child:Icon(Icons.add, color: white),
        backgroundColor: primaryColor,
      ),
    );
  }
}
