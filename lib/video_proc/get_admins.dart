import 'package:http/http.dart' as http;
import 'dart:convert';
import '../scdata.dart';

get_admins(SCD scd) async {

  String itelurl = "https://developer1.itelcompanies.com";
  String url_php = "/session/getAdmins.php";
  String url_params = "?clinician_id=" + scd.provider_id;
  String url = itelurl + url_php + url_params;

  var response = await http.get(url);

  print("Response status: ${response.statusCode}");
  //print("Response body: ${response.body}");

  final JsonDecoder decoder = const JsonDecoder();
  var JsonDecode = decoder.convert(response.body);

  print("JsonDecode: ${JsonDecode}");

  //**** Need to put for loop for multiple admins ***
  var parts = JsonDecode["members"];
  print("parts = ${parts}");

  var participants = new List();

  var part_length = parts.length;
  print("part_length =  ${part_length}");

  for (var i = 0; i < part_length; i++) {
    participants.add({"users":parts[i]["admin_id"]});
  }

  print("participants: ${participants}");

  scd.partpants = participants;

}