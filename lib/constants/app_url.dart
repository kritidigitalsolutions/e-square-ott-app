class AppUrl {
  static const baseUrl = "http://192.168.1.46:5001/api/v1";
  static const requestOtp = "$baseUrl/auth/request-otp";
  static const verifyOtp = "$baseUrl/auth/verify-otp";
  static const resendOtp = "$baseUrl/auth/resend-otp";
  static const completeProfile = "$baseUrl/auth/profile";
  static const getProfile = "$baseUrl/auth/me";
  static const logoutProfile = "$baseUrl/auth/logout";
  static const getGenre = "$baseUrl/auth/genres";
  static const selectGenre = "$baseUrl/auth/interests";
  static const refreshToken = "$baseUrl/auth/refresh-token";
  static const deleteAccount = "$baseUrl/auth/profile";
  static const uploadFileSingle = "$baseUrl/upload/single";
  static const editProfile = "$baseUrl/auth/profile";
  static const updateNotficationsetting = "$baseUrl/notifications/settings";
  static const getNotificationSetting = "$baseUrl/notifications/settings";
  static String allNotification({required int page, required int size, String? type, bool? unreadOnly}) {
    String url = "$baseUrl/notifications?page=$page&limit=$size";
    if (type != null) url += "&type=$type";
    if (unreadOnly != null) url += "&unreadOnly=$unreadOnly";
    return url;
  }
  static String allUnreadNotification = "$baseUrl/notifications/unread-count";
  static String markedSingleNotification({required String id}) =>
      "$baseUrl/notifications/$id/read";
  static String markAllNotification = "$baseUrl/notifications/read-all";
  static String deleteSingleNotification({required String id}) =>
      "$baseUrl/notifications/$id";
  static String deleteAllNotification = "$baseUrl/notifications/clear-all";
  static String registerFcm = "$baseUrl/notifications/register-device";
  static String deleteFcm = "$baseUrl/notifications/unregister-device";
  static String seedNotifications({bool reset = true}) =>
      "$baseUrl/notifications/seed?reset=$reset";
}
