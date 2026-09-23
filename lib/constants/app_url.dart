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
}
