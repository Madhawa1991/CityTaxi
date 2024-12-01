import '../config/custom_config.dart';
import 'package:http/http.dart' as http;

class Authentication {

  Future registerUser(String firstName, String lastName, String nicNo,
      String email, String password, String passwordConfirm,
      String mobileNumber, String birthDay, String address,
      String district, String city, String zipCode,String gender, String role) async {
    var headers = {
      'Accept': 'application/json'
    };
    var request = http.MultipartRequest('POST', Uri.parse(CustomConfig.EXECUTE_REGISTER));
    request.fields.addAll({
      'first_name': firstName,
      'last_name': lastName,
      'nic_no': nicNo,
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirm,
      'mobile_number': mobileNumber,
      'birth_day': birthDay,
      'address': address,
      'district': district,
      'city': city,
      'zip_code': zipCode,
      'gender': gender,
      'role': role
    });

    print("request.fields ====> " + request.fields.toString());

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 201) {
      return response.stream.bytesToString();
    }
    else {
      return response.stream.bytesToString();
    }
  }

  Future loginUser(String mobile_number, String password) async {

    var headers = {
      'Accept': 'application/json'
    };
    var request = http.MultipartRequest('POST', Uri.parse(CustomConfig.EXECUTE_LOGIN));
    request.fields.addAll({
      'mobile_number': mobile_number,
      'password': password,
    });

    request.headers.addAll(headers);

    print("request.fields ====> " + request.fields.toString());

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 201) {
      return response.stream.bytesToString();
    }
    else {
      return response.stream.bytesToString();
    }
  }

  Future updateDriverLocation(bool isOnline, String lat, String long, String id) async {

    var headers = {
      'Accept': 'application/json'
    };
    var request = http.MultipartRequest('POST', Uri.parse(CustomConfig.EXECUTE_UPDATE_DRIVER_LOCATION));
    request.fields.addAll({
      'isOnline': isOnline.toString(),
      'Lat': lat,
      'Long': long,
      'id' : id
    });

    request.headers.addAll(headers);

    print("request.fields ====> " + request.fields.toString());

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 201) {

      return response.stream.bytesToString();
    }
    else {
      return response.stream.bytesToString();
    }
  }

  Future getOnlineDrivers() async {

    var request = http.Request('GET', Uri.parse(CustomConfig.EXECUTE_GET_ONLINE_DRIVERS));


    http.StreamedResponse response = await request.send();

    if (response.statusCode == 201) {
      return response.stream.bytesToString();;
    }
    else {
      return response.stream.bytesToString();
    }
  }
}