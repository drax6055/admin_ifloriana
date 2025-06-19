class Apis {
  static const baseUrl = 'http://192.168.1.2:5000/api';
}

class Endpoints {
  static const String register_salon = '/auth/signup';
  static const String login = '/auth/login';
  static const String udpate_salon = '/salons';
  static const String packages = '/package';
  static const String dashboard = 'c4dbb261-e4a5-4a2e-a174-7870566dc417';
  static const String admin_forgot = '/auth/forgot-password';
  static const String salon = '/salons';
  static const String update_salon = '/salons/';
  static const String check_mailId = '/auth/check-email/';
  static const String get_register_details = '/admin/';
  static const String getStaffDetails = '/staffs?salon_id=';
  static const String postStaffDetails = '/staffs';
  static const String getCustomersDetails = '/customers';
  static const String customers = '/customers';
  static const String getBranchAllDetails = '/branches';
  static const String getBranchName = '/branches/names?salon_id=';
  static const String getServices = '/services';
  static const String getServiceNames = '/services/names?salon_id=';
  static const String postServiceDetails = '/auth/reset-password-with-old';
  static const String resetPass = '/auth/reset-password-with-old';
  static const String postServiceCategory = '/categories';
  static const String postServiceCategoryGet = '/categories?salon_id=';
  static const String getServiceCategotyName = "/categories/names?salon_id=";
  static const String getAllServices = "/services?salon_id=";
  static const String postTex = "/taxes";
  static const String getTex = "/taxes?salon_id=";
  static const String getCoupons = "/coupons?salon_id=";
  static const String coupons = "/coupons";
  static const String addSubCategory = "/subcategories";
  static const String getSubCategory = "/subcategories?salon_id=";
  static const String postBranchs = "/branches";
  static const String getBranches = "/branches?salon_id=";
  static const String addManager = "/managers";
  static const String getManager = "/managers?salon_id=";

  static const String getcommisionForStaff =
      "/revenue-commissions/names?salon_id=";

  static const String postBranchMembership = "/branch-memberships";

  static const String getBranchMembershipNames =
      "/branch-memberships/names?salon_id=";
  static const String getBranchpackagesNames =
      "/branchPackages/names?salon_id=";
  static const String branchPackages = "/branchPackages";

  static const String getBrands = "/brands?salon_id=";

  static const String postBrands = "/brands";
  static const String getProductSubCategories =
      "/productSubCategories?salon_id=";

  static const String productSubcategory = "/productSubCategories";

  static const String getBrandName = "/brands/names?salon_id=";
  static const String getproductName = "/productCategories/names?salon_id=";
  static const String postSubCategory = "/productCategories";
  static const String getAllCategory = "/productCategories?salon_id=";

  static const String getUnits = "/units?salon_id=";
  static const String postUnits = "/units";

  static const String postTags = "/tags";
  static const String getTags = "/tags/?salon_id=";
}
