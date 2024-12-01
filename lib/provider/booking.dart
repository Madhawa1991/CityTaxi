import '../config/custom_config.dart';
import 'package:http/http.dart' as http;

class Booking {

  Future createBooking(String id, double pickUpLat, double pickUpLong, double dropLat, double dropLong, String driver, String user) async {

    var headers = {
      'Accept': 'application/json'
    };
    var request = http.MultipartRequest('POST', Uri.parse(CustomConfig.EXECUTE_CREATE_BOOKING));
    request.fields.addAll({
      'id': id,
      'pickUpLat': pickUpLat.toString(),
      'pickUpLong': pickUpLong.toString(),
      'dropLat': dropLat.toString(),
      'dropLong': dropLong.toString(),
      'driver': driver,
      'user': user
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


}