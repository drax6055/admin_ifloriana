import 'package:get/get.dart';
import '../../../network/model/dashboard_model.dart';


class DashboardController extends GetxController {
  var dashboardModel = Dashboard_model().obs;

  @override
  void onInit() {
    // fetchDashboardDetails();
    super.onInit();
  }

  // void fetchDashboardDetails() async {
  //   try {
  //     final response =
  //         await dioClient.dio.get('${Apis.dashboardUrl}${Endpoints.dashboard}');
  //     if (response.statusCode == 200) {
  //       dashboardModel.value = Dashboard_model.fromJson(response.data);
  //     } else {
  //       throw Exception('Error : ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     CustomSnackbar.showError('Error', e.toString());
  //   }
  // }
}
