class Dashboard_model {
  List<Performance>? performance;
  List<UpcomingAppointments>? upcomingAppointments;
  List<AppointmentsRevenueGraph>? appointmentsRevenueGraph;
  List<TopServices>? topServices;

  Dashboard_model(
      {this.performance,
      this.upcomingAppointments,
      this.appointmentsRevenueGraph,
      this.topServices});

  Dashboard_model.fromJson(Map<String, dynamic> json) {
    if (json['performance'] != null) {
      performance = <Performance>[];
      json['performance'].forEach((v) {
        performance!.add(new Performance.fromJson(v));
      });
    }
    if (json['upcoming_appointments'] != null) {
      upcomingAppointments = <UpcomingAppointments>[];
      json['upcoming_appointments'].forEach((v) {
        upcomingAppointments!.add(new UpcomingAppointments.fromJson(v));
      });
    }
    if (json['appointments_revenue_graph'] != null) {
      appointmentsRevenueGraph = <AppointmentsRevenueGraph>[];
      json['appointments_revenue_graph'].forEach((v) {
        appointmentsRevenueGraph!.add(new AppointmentsRevenueGraph.fromJson(v));
      });
    }
    if (json['top_services'] != null) {
      topServices = <TopServices>[];
      json['top_services'].forEach((v) {
        topServices!.add(new TopServices.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.performance != null) {
      data['performance'] = this.performance!.map((v) => v.toJson()).toList();
    }
    if (this.upcomingAppointments != null) {
      data['upcoming_appointments'] =
          this.upcomingAppointments!.map((v) => v.toJson()).toList();
    }
    if (this.appointmentsRevenueGraph != null) {
      data['appointments_revenue_graph'] =
          this.appointmentsRevenueGraph!.map((v) => v.toJson()).toList();
    }
    if (this.topServices != null) {
      data['top_services'] = this.topServices!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Performance {
  String? name;
  int? appointmentNumber;
  int? totalRevenueAmt;
  double? totalSalesCommissionsAmt;
  int? newCustomersNum;
  int? totalOrdersNum;
  int? totalProductSalesNum;
  int? totalValue;

  Performance(
      {this.name,
      this.appointmentNumber,
      this.totalRevenueAmt,
      this.totalSalesCommissionsAmt,
      this.newCustomersNum,
      this.totalOrdersNum,
      this.totalProductSalesNum,
      this.totalValue});

  Performance.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    appointmentNumber = json['appointment_number'];
    totalRevenueAmt = json['total_revenue_amt'];
    totalSalesCommissionsAmt = json['total_sales_commissions_amt'];
    newCustomersNum = json['new_customers_num'];
    totalOrdersNum = json['total_orders_num'];
    totalProductSalesNum = json['total_product_sales_num'];
    totalValue = json['total_value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['appointment_number'] = this.appointmentNumber;
    data['total_revenue_amt'] = this.totalRevenueAmt;
    data['total_sales_commissions_amt'] = this.totalSalesCommissionsAmt;
    data['new_customers_num'] = this.newCustomersNum;
    data['total_orders_num'] = this.totalOrdersNum;
    data['total_product_sales_num'] = this.totalProductSalesNum;
    data['total_value'] = this.totalValue;
    return data;
  }
}

class UpcomingAppointments {
  String? name;
  String? date;
  String? time;
  String? location;
  String? status;
  int? totalAppointments;

  UpcomingAppointments(
      {this.name,
      this.date,
      this.time,
      this.location,
      this.status,
      this.totalAppointments});

  UpcomingAppointments.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    date = json['date'];
    time = json['time'];
    location = json['location'];
    status = json['status'];
    totalAppointments = json['total_appointments'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['date'] = this.date;
    data['time'] = this.time;
    data['location'] = this.location;
    data['status'] = this.status;
    data['total_appointments'] = this.totalAppointments;
    return data;
  }
}

class AppointmentsRevenueGraph {
  String? date;
  int? appointments;
  int? revenue;
  String? name;
  int? totalAppointments;
  int? totalRevenue;

  AppointmentsRevenueGraph(
      {this.date,
      this.appointments,
      this.revenue,
      this.name,
      this.totalAppointments,
      this.totalRevenue});

  AppointmentsRevenueGraph.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    appointments = json['appointments'];
    revenue = json['revenue'];
    name = json['name'];
    totalAppointments = json['total_appointments'];
    totalRevenue = json['total_revenue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['appointments'] = this.appointments;
    data['revenue'] = this.revenue;
    data['name'] = this.name;
    data['total_appointments'] = this.totalAppointments;
    data['total_revenue'] = this.totalRevenue;
    return data;
  }
}

class TopServices {
  String? service;
  int? totalCount;
  int? totalAmount;
  String? name;
  int? totalServicesCount;
  int? totalServicesAmount;

  TopServices(
      {this.service,
      this.totalCount,
      this.totalAmount,
      this.name,
      this.totalServicesCount,
      this.totalServicesAmount});

  TopServices.fromJson(Map<String, dynamic> json) {
    service = json['service'];
    totalCount = json['total_count'];
    totalAmount = json['total_amount'];
    name = json['name'];
    totalServicesCount = json['total_services_count'];
    totalServicesAmount = json['total_services_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['service'] = this.service;
    data['total_count'] = this.totalCount;
    data['total_amount'] = this.totalAmount;
    data['name'] = this.name;
    data['total_services_count'] = this.totalServicesCount;
    data['total_services_amount'] = this.totalServicesAmount;
    return data;
  }
}
