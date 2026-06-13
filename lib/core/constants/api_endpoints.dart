class ApiEndpoints {
  static const String baseUrl = 'https://cureta.onrender.com/api/';
  //Auth
  static const String register = 'auth/signup';
  static const String login = 'auth/login';
  static const String logout = 'auth/logout';
  static const String forgotPassword = 'auth/forgot-password';
  static const String resetPassword = 'auth/reset-password';
  //Profiles
  static const String profiles = 'profile';
  static const String primaryProfile = 'profile/user-profile';
  static const String familyProfile = 'profile/family-profile';
  static String profileData(String id) => "profile/$id";

  //OCR
  static const String scanPrescription = 'ocr/scan';
  static const String scannedMedicines = 'ocr/confirm';

  //Medicines
  static const String medicines = 'medicines';
  static String medicineData(String id) => "medicines/$id";
  static String medicineArchive(String id) => "medicines/$id/archive";
  static String medicineLogs(String id) => "medicines/$id/logs";
  static String profileLogs(String profileId) =>
      "medicines/profile/$profileId/logs";

  //Schedule
  static const String schedule = 'schedule';

  //QR
  static const String recordsCategories = 'qr-share/categories';
  static const String filteredRecords = 'qr-share/token';
  static String qrShare(String token) => "qr-share/$token";
}
