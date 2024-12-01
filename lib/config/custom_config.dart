class CustomConfig {

  static const String apiBaseUrl = "http://127.0.0.1:8000/api/";

  static const String EXECUTE_REGISTER = apiBaseUrl + "register";
  static const String EXECUTE_LOGIN = apiBaseUrl + "login";
  static const String EXECUTE_UPDATE_DRIVER_LOCATION = apiBaseUrl + "updateDriverLocation";

  static const String EXECUTE_CREATE_BOOKING = apiBaseUrl + "createBooking";
  static const String EXECUTE_GET_ONLINE_DRIVERS = apiBaseUrl + "drivers/online";
}