import 'package:flutter/material.dart';
import 'package:flutter_template/ui/drawer/products/category/CategoryController.dart';
import 'package:flutter_template/utils/colors.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Categoryscreen extends StatelessWidget {
  Categoryscreen({super.key});
  final Categorycontroller getController = Get.put(Categorycontroller());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Categories'),
        backgroundColor: primaryColor,
        foregroundColor: white,
      ),
      body: Obx(() {
        if (getController.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              color: primaryColor,
            ),
          );
        }

        if (getController.categories.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.category_outlined,
                  size: 64,
                  color: Colors.grey[400],
                ),
                SizedBox(height: 16),
                Text(
                  'No categories found',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: getController.categories.length,
          itemBuilder: (context, index) {
            final category = getController.categories[index];
            return Card(
              margin: EdgeInsets.only(bottom: 12),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.all(16),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 60,
                    height: 60,
                    color: Colors.grey[300],
                    child: Icon(
                      Icons.category,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                title: Text(
                  category.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 4),
                    Text(
                      'Branches: ${category.branchId.length}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      'Brands: ${category.brandId.length}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 4),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: category.status == 1
                            ? Colors.green[100]
                            : Colors.red[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        category.status == 1 ? 'Active' : 'Inactive',
                        style: TextStyle(
                          fontSize: 12,
                          color: category.status == 1
                              ? Colors.green[700]
                              : Colors.red[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to add category screen
        },
        child: Icon(Icons.add, color: white),
        backgroundColor: primaryColor,
      ),
    );
  }
}
