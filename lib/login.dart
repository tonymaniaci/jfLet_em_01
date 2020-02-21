import 'package:http/http.dart' as http;
import 'dart:convert';
import 'scdata.dart';
import 'video_proc/video_prep.dart';

void login(url_let) async {

  /*String URL = url_let + "&androidApp=Y";
  print('URL = $URL');

  http.Response response = await http.get(URL);

  var resultJson = jsonDecode(response.body);
  print("click resultJson == $resultJson");*/

  /* var action = resultJson["action"];          */     var action = "SESSION";
  /* var attendee_id = resultJson["username"];   */     var attendee_id = "tmaniaci";
  /*var schedule_id = resultJson["schedule_id"]; */     var schedule_id = "6053";
  /* var autoLogin = resultJson["autoLogin"];    */     var autoLogin = "1";
  /* var server = resultJson["server"];          */     var server = "https://developer1.itelcompanies.com";

  var sched_date = null;
  var provider_id = null;
  var doctor_name = null;
  var tokapikey = null;
  var partpants = [null];
  var toksessionid = null;
  var toktoken = null;

  /* var device = null;                            */    var device = "Android";

  /*if(resultJson["androidApp"] == 'Y') {
    device = "Android";
    }
  else {
    print('Not Android');
    }*/


  var url = server + "/process_login.php";

  var body_params = {'username':attendee_id, 'device':device ,'action':action,'schedule_id':schedule_id,'autoLogin':autoLogin};

  var resp = await http.post(url, body: body_params );

  var respJson = jsonDecode(resp.body);
  print("processLogin respJson == $respJson");

  var practice_id = respJson["practice_id"];
  var ws_server = respJson["WEBSOCKETSERVER"];

  print("practice_id == $practice_id");
  print("ws_server == $ws_server");

  var scd = SCD(server, attendee_id, sched_date, practice_id, ws_server, provider_id, doctor_name, schedule_id, tokapikey, partpants, toksessionid, toktoken);

  video_prep(scd);

}