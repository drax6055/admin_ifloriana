import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/utils/app_images.dart';
import 'package:flutter_template/utils/colors.dart';
import 'package:flutter_template/utils/custom_text_styles.dart';
import 'package:flutter_template/wiget/custome_text.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'dashboard_controller.dart';
import 'package:flutter_template/ui/drawer/dashboard/upcoming_bookings_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DashboardController controller = Get.put(DashboardController());

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Obx(() => Column(
                    children: [
                      performce_widget(controller),
                      lineChart(),
                      upcomming_booking(controller),
                      combinedChart(),
                      total_revenue(controller),
                      SizedBox(height: 10.h),
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }

  Widget performce_widget(DashboardController controller) {
    final dashboard = controller.dashboardModel.value;
    // Use root-level fields from the API response
    final List<Map<String, dynamic>> items = [
      {'label': 'Appointments', 'value': dashboard.appointmentCount ?? 0},
      {'label': 'Total Commission', 'value': dashboard.totalCommission ?? 0},
      {'label': 'New Customers', 'value': dashboard.customerCount ?? 0},
      {'label': 'Orders', 'value': dashboard.orderCount ?? 0},
      {'label': 'Products', 'value': dashboard.productSales ?? 0},
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextWidget(
            text: 'Performance',
            textStyle:
                CustomTextStyles.textFontSemiBold(size: 15.sp, color: black)),
        SizedBox(height: 8.h),
        SizedBox(
          height: 70.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (context, index) {
              return Container(
                width: 120.w,
                decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: AssetImage(AppImages.cardbg),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomTextWidget(
                      text: items[index]['value'].toString(),
                      textStyle: CustomTextStyles.textFontBold(
                          size: 22.sp, color: black),
                    ),
                    CustomTextWidget(
                      text: items[index]['label'],
                      textStyle: CustomTextStyles.textFontMedium(size: 12.sp),
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) => SizedBox(width: 5.w),
          ),
        ),
      ],
    );
  }

  Widget lineChart() {
    final List<Map<String, dynamic>> revenueData = [
      {"date": "2025-04-30", "revenue": 4325},
      {"date": "2025-05-01", "revenue": 1289},
      {"date": "2025-05-03", "revenue": 6794},
      {"date": "2025-05-05", "revenue": 3579},
      {"date": "2025-05-06", "revenue": 1567},
    ];

    final List<String> dateLabels =
        revenueData.map((e) => e["date"] as String).toList();

    final List<FlSpot> spots = List.generate(
      revenueData.length,
      (index) => FlSpot(
        index.toDouble(),
        (revenueData[index]["revenue"] as num).toDouble(),
      ),
    );

    return Container(
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(10),
      ),
      height: 150.h,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
        child: LineChart(
          LineChartData(
            gridData: FlGridData(
              show: true,
              drawVerticalLine: true,
              drawHorizontalLine: true,
              getDrawingVerticalLine: (_) => FlLine(
                color: Colors.white.withOpacity(0.2),
                strokeWidth: 1,
              ),
              getDrawingHorizontalLine: (_) => FlLine(
                color: Colors.white.withOpacity(0.2),
                strokeWidth: 1,
              ),
            ),
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 32,
                  interval: 1,
                  getTitlesWidget: (value, meta) {
                    int index = value.toInt();
                    if (index >= 0 && index < dateLabels.length) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: CustomTextWidget(
                          text: dateLabels[index],
                          textStyle: CustomTextStyles.textFontMedium(
                              size: 10.sp, color: black),
                        ),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            lineTouchData: LineTouchData(
              enabled: true,
              touchTooltipData: LineTouchTooltipData(
                getTooltipColor: (touchedSpot) => primaryColor,
                tooltipRoundedRadius: 8,
                getTooltipItems: (touchedSpots) {
                  return touchedSpots.map((LineBarSpot spot) {
                    return LineTooltipItem(
                      // Custom text format
                      'Revenue: ₹${spot.y.toInt()}',
                      const TextStyle(
                        color: white,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }).toList();
                },
              ),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                color: Colors.brown,
                barWidth: 3,
                isStrokeCapRound: true,
                belowBarData: BarAreaData(show: false),
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) {
                    return FlDotCirclePainter(
                      radius: 4,
                      color: Colors.white,
                      strokeWidth: 2,
                      strokeColor: Colors.brown,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget upcomming_booking(DashboardController controller) {
    final dashboard = controller.dashboardModel.value;
    final items = dashboard.upcomingAppointments ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomTextWidget(
              text: 'Upcoming Booking',
              textStyle: CustomTextStyles.textFontSemiBold(
                size: 15.sp,
                color: black,
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.to(
                    () => UpcomingBookingsScreen(upcomingAppointments: items));
              },
              child: CustomTextWidget(
                text: 'View All',
                textStyle: CustomTextStyles.textFontRegular(
                  size: 14.sp,
                  color: primaryColor,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Container(
          height: 230.h,
          decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListView.builder(
            itemCount: items.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final item = items[index];
              String formattedDate = '';
              if (item.appointmentDate != null &&
                  item.appointmentDate!.isNotEmpty) {
                try {
                  final dt = DateTime.parse(item.appointmentDate!);
                  formattedDate = DateFormat('yyyy-MM-dd').format(dt);
                } catch (e) {
                  formattedDate = item.appointmentDate!;
                }
              }
              return Column(
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.account_circle,
                      size: 35.h,
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 15.h,
                      color: primaryColor,
                    ),
                    title: CustomTextWidget(
                        text: item.customerName ?? '-',
                        textStyle: CustomTextStyles.textFontBold(
                            size: 14.sp, color: black)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextWidget(
                            text:
                                '$formattedDate | ${item.appointmentTime ?? ''} | ${item.serviceName ?? ''}',
                            textStyle: CustomTextStyles.textFontRegular(
                                size: 12.sp, color: grey)),
                        Row(
                          children: [
                            Icon(Icons.timer_outlined,
                                size: 12.h, color: primaryColor),
                            CustomTextWidget(
                                text: '', // You can add time diff logic here
                                textStyle: CustomTextStyles.textFontMedium(
                                    size: 12.sp, color: primaryColor)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget combinedChart() {
    final List<Map<String, dynamic>> data = [
      {"date": "2025-04-30", "revenue": 4325, "sales": 2600},
      {"date": "2025-05-01", "revenue": 1289, "sales": 50},
      {"date": "2025-05-03", "revenue": 6794, "sales": 2750},
      {"date": "2025-05-05", "revenue": 3579, "sales": 200},
      {"date": "2025-05-06", "revenue": 1567, "sales": 2100},
    ];
    final List<String> dateLabels =
        data.map((e) => e["date"] as String).toList();
    final List<BarChartGroupData> barGroups = data.asMap().entries.map((entry) {
      int index = entry.key;
      final sales = (entry.value["sales"] as num).toDouble(); // ✅ Fix here
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: sales,
            color: primaryColor,
            width: 12,
          ),
        ],
      );
    }).toList();

    final List<FlSpot> lineSpots = data
        .asMap()
        .entries
        .where((entry) => entry.value["revenue"] != 0)
        .map((entry) {
      return FlSpot(
        entry.key.toDouble(),
        (entry.value["revenue"] as num).toDouble(),
      );
    }).toList();

    return Container(
      height: 210.h,
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: CustomTextWidget(
              text: 'Revenue & Sales',
              textStyle:
                  CustomTextStyles.textFontSemiBold(size: 15.sp, color: black),
            ),
          ),
          SizedBox(height: 8.h),
          SizedBox(
            height: 160.h,
            child: Stack(
              children: [
                BarChart(
                  BarChartData(
                    barGroups: barGroups,
                    gridData: FlGridData(show: false),
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 32,
                          interval: 1,
                          getTitlesWidget: (value, meta) {
                            int index = value.toInt();
                            if (index >= 0 && index < dateLabels.length) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: CustomTextWidget(
                                  text: dateLabels[index],
                                  textStyle: CustomTextStyles.textFontMedium(
                                      size: 10.sp, color: black),
                                ),
                              );
                            } else {
                              return const SizedBox.shrink();
                            }
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                  ),
                ),
                LineChart(LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: lineSpots,
                      isCurved: true,
                      color: secondaryColor,
                      barWidth: 4,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: Colors.white,
                            strokeWidth: 2,
                            strokeColor: Colors.brown,
                          );
                        },
                      ),
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    enabled: true,
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipColor: (touchedSpot) => primaryColor,
                      tooltipRoundedRadius: 8,
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((LineBarSpot spot) {
                          return LineTooltipItem(
                            // Custom text format
                            'Revenue: ₹${spot.y.toInt()}',
                            const TextStyle(
                              color: white,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }).toList();
                      },
                    ),
                  ),
                  gridData: FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 32,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          int index = value.toInt();
                          if (index >= 0 && index < dateLabels.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: CustomTextWidget(
                                text: dateLabels[index],
                                textStyle: CustomTextStyles.textFontMedium(
                                    size: 10.sp, color: Colors.transparent),
                              ),
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget total_revenue(DashboardController controller) {
    final dashboard = controller.dashboardModel.value;
    final List<String> headers = ['Service', 'Total Count', 'Total Amount'];
    final List<dynamic> services = dashboard.topServices ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextWidget(
            text: 'Toal Revenue',
            textStyle:
                CustomTextStyles.textFontSemiBold(size: 15.sp, color: black)),
        SizedBox(height: 8.h),
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Container(
                color: primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: headers.map((header) {
                    return Expanded(
                      flex: 1,
                      child: Center(
                        child: CustomTextWidget(
                          text: header,
                          textStyle: CustomTextStyles.textFontRegular(
                            size: 13.sp,
                          ).copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 5),

              // Data Rows
              ...services.map((service) {
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: CustomTextWidget(
                          textAlign: TextAlign.center,
                          text: service.serviceName ?? '-',
                          textStyle:
                              CustomTextStyles.textFontRegular(size: 12.sp),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: CustomTextWidget(
                            textAlign: TextAlign.center,
                            text: (service.count ?? service.totalCount ?? '-')
                                .toString(),
                            textStyle:
                                CustomTextStyles.textFontRegular(size: 12.sp),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: CustomTextWidget(
                          textAlign: TextAlign.center,
                          text: (service.totalAmount ?? '-').toString(),
                          textStyle:
                              CustomTextStyles.textFontRegular(size: 12.sp),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ],
    );
  }
}
