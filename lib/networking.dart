import 'package:http/http.dart';
import 'dart:convert';

class NetworkHelp {
  NetworkHelp(this.uri);
  var decoded;
  final String uri;
  Future getData() async {
    Response response = await get(Uri.parse(uri));
    if (response.statusCode == 200) {
      String data = response.body;
      print(data);
      return decoded = jsonDecode(data);
    } else {
      print(response.statusCode);
    }
  }
}
