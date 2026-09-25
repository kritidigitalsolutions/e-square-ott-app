class AppUrl {
  static const baseUrl = "http://192.168.1.5:5001/api/v1";
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
  static String allNotification({
    required int page,
    required int size,
    String? type,
    bool? unreadOnly,
  }) {
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
  static String privacyPolicy = "$baseUrl/legal/privacy-policy";
  static String termAndCondition = "$baseUrl/legal/terms-and-conditions";
  static String allPlans = "$baseUrl/subscriptions/plans";
  static String planStatus = "$baseUrl/subscriptions/my-status";
  static String createOrder = "$baseUrl/subscriptions/initiate";
  static String verifyOrder = "$baseUrl/subscriptions/verify";
  static String upgradePlan = "$baseUrl/subscriptions/upgrade";
  static String allDrama({required int pageNo, required int limit}) {
    return "$baseUrl/dramas?page=$pageNo&limit=$limit";
  }

  static String dramaDetail({required String id}) => "$baseUrl/dramas/$id";
  static String allEpisode({
    required String dramaId,
    required int pageNo,
    required int limit,
    int? current,
  }) {
    String url = "$baseUrl/player/episodes/$dramaId?page=$pageNo&limit=$limit";
    if (current != null) url += "&current=$current";
    return url;
  }

  static String episodeAccess({
    required String dramaId,
    required int episodeNo,
  }) => "$baseUrl/player/access/$dramaId/$episodeNo";
  static String playBackProgress = "$baseUrl/player/progress";
  static String searchLanding =
      "$baseUrl/search/landing?popularLimit=3&recommendedLimit=6";
  static String search({required String title, required int limit}) =>
      "$baseUrl/search/suggestions?q=$title&limit=$limit";
  static String homeAllContent({required int pageNo, required int size}) =>
      "$baseUrl/home/content?page=$pageNo&limit=$size&genre=&sortOrder=asc";
  static String countinueWatching({required int pageNo, required int limit}) =>
      "$baseUrl/home/continue-watching?page=$pageNo&limit=$limit";
}
