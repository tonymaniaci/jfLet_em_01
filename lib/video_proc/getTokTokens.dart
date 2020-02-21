import 'package:http/http.dart' as http;
import 'dart:convert';
import '../scdata.dart';

getTokTokens(SCD scd)  async {

  String itelurl = scd.server;
  String url_php = "/getTokTokens.php";
  String url_params = "?schedule_id=" + scd.schedule_id;
  String url_timer = "&user_id=" + scd.attendee_id;
  String url = itelurl + url_php + url_params + url_timer;

  var response = await http.get(url);
  //print("Response status: ${response.statusCode}");
  //print("Response body: ${response.body}");

  var respJson = jsonDecode(response.body);
  //print("respJson =  ${respJson}");

  var appts = respJson["appointments"];
  //print("appts =  ${appts}");

  /*var numberOfappts = appts.length;
  print("numberOfappts =  ${numberOfappts}");*/

  for (var appt in appts) {
    //for (var i = 0; i <= appts.length; i++) {

    /*print("appts *************************************************************");
    print("appts =  ${appts}");

    print("appt *************************************************************");
    print("appt =  ${appt}");*/

    scd.tokapikey = appt["tokapikey"];
    scd.toksessionid = appt["toksessionid"];
    scd.toktoken = appt["toktoken"];
    scd.provider_id = appt["host_id"];
    scd.doctor_name = appt["doctor_name"]["name"];

    print("tokapikey =  ${scd.tokapikey}");
    print("toksessionid =  ${scd.toksessionid}");
    print("toktoken =  ${scd.toktoken}");
    print("provider_id =  ${scd.provider_id}");
    print("doctor_name =  ${scd.doctor_name}");

    print("scd.schedule_id = ${scd.schedule_id}");
    var schedule_id2 = appt["schedule_id"];
    print("schedule_id2 = $schedule_id2");

  }

}