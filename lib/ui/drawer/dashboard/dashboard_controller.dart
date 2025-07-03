import 'package:flutter_template/network/network_const.dart';
import 'package:get/get.dart';
import '../../../main.dart';
import '../../../network/model/dashboard_model.dart';
import '../../../wiget/custome_snackbar.dart';

class DashboardController extends GetxController {
  var dashboardData = DashboardData().obs;
  var chartData = ChartData().obs;
  var branchList = <Branch>[].obs;
  var selectedBranch = Rx<Branch?>(null);

  @override
  void onInit() {
    super.onInit();
    CalllApis();
  }

  void CalllApis() {
    getBranches();
    getChartData();
    getDashbordData();
  }

  Future<void> getDashbordData() async {
    try {
      final loginUser = await prefs.getUser();
      final now = DateTime.now();
      final currentMonth = now.month;
      final currentYear = now.year;

      final response = await dioClient.getData(
        '${Apis.baseUrl}/dashboard?salon_id=${loginUser!.salonId}&month=$currentMonth&year=$currentYear',
        (json) => json,
      );
      if (response != null) {
        final data = response['data'] ?? response;
        dashboardData.value = DashboardData.fromJson(data);
      }
    } catch (e) {
      CustomSnackbar.showError('Error', 'Failed to fetch branches: $e');
    }
  }

  Future<void> getBranches() async {
    try {
      final loginUser = await prefs.getUser();
      final response = await dioClient.getData(
          '${Apis.baseUrl}${Endpoints.getBranchName}${loginUser!.salonId}',
          (json) => json);
      final data = response['data'] as List;
      branchList.value = data.map((e) => Branch.fromJson(e)).toList();
    } catch (e) {
      CustomSnackbar.showError('Error', 'Failed to get branches: $e');
    }
  }

  Future<void> getChartData() async {
    try {
      final loginUser = await prefs.getUser();

      final today = DateTime.now();
      final oneWeekAgo = today.subtract(Duration(days: 7));

      final String endDate =
          "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";
      final String startDate =
          "${oneWeekAgo.year}-${oneWeekAgo.month.toString().padLeft(2, '0')}-${oneWeekAgo.day.toString().padLeft(2, '0')}";

      final response = await dioClient.getData(
        '${Apis.baseUrl}/dashboard/dashboard-summary?salon_id=${loginUser!.salonId}&startDate=$startDate&endDate=$endDate',
        (json) => json,
      );
      if (response != null) {
        final data = response['data'] ?? response;
        chartData.value = ChartData.fromJson(data);
      }
    } catch (e) {
      CustomSnackbar.showError('Error', 'Failed to fetch chart data: $e');
    }
  }
}

// New models for separation
class DashboardData {
  int? appointmentCount;
  int? customerCount;
  int? orderCount;
  int? productSales;
  int? totalCommission;
  List<Performance>? performance;
  List<UpcomingAppointments>? upcomingAppointments;
  List<AppointmentsRevenueGraph>? appointmentsRevenueGraph;
  List<TopServices>? topServices;

  DashboardData({
    this.appointmentCount,
    this.customerCount,
    this.orderCount,
    this.productSales,
    this.totalCommission,
    this.performance,
    this.upcomingAppointments,
    this.appointmentsRevenueGraph,
    this.topServices,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      appointmentCount: json['appointmentCount'] ?? json['appointment_count'],
      customerCount: json['customerCount'] ?? json['customer_count'],
      orderCount: json['orderCount'] ?? json['order_count'],
      productSales: json['productSales'] ?? json['product_sales'],
      totalCommission: json['totalCommission'] ?? json['total_commission'],
      performance: (json['performance'] as List?)
          ?.map((v) => Performance.fromJson(v))
          .toList(),
      upcomingAppointments: (json['upcomingAppointments'] as List?)
              ?.map((v) => UpcomingAppointments.fromJson(v))
              .toList() ??
          (json['upcoming_appointments'] as List?)
              ?.map((v) => UpcomingAppointments.fromJson(v))
              .toList(),
      appointmentsRevenueGraph: (json['appointmentsRevenueGraph'] as List?)
              ?.map((v) => AppointmentsRevenueGraph.fromJson(v))
              .toList() ??
          (json['appointments_revenue_graph'] as List?)
              ?.map((v) => AppointmentsRevenueGraph.fromJson(v))
              .toList(),
      topServices: (json['topServices'] as List?)
              ?.map((v) => TopServices.fromJson(v))
              .toList() ??
          (json['top_services'] as List?)
              ?.map((v) => TopServices.fromJson(v))
              .toList(),
    );
  }
}

class ChartData {
  List<LineChartDataPoint>? lineChart;
  List<BarChartDataPoint>? barChart;

  ChartData({this.lineChart, this.barChart});

  factory ChartData.fromJson(Map<String, dynamic> json) {
    return ChartData(
      lineChart: (json['lineChart'] as List?)
          ?.map((e) => LineChartDataPoint.fromJson(e))
          .toList(),
      barChart: (json['barChart'] as List?)
          ?.map((e) => BarChartDataPoint.fromJson(e))
          .toList(),
    );
  }
}

class Branch {
  final String? id;
  final String? name;

  Branch({this.id, this.name});

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      id: json['_id'],
      name: json['name'],
    );
  }
}
