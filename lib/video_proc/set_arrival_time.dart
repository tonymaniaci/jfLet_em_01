import 'package:http/http.dart' as http;
import '../scdata.dart';

set_arrival_time(SCD scd) async {

  var url = 'https://developer1.itelcompanies.com/setArrivalTime.php';

  var body_params = {'schedule_id':scd.schedule_id,'attendee_id':scd.attendee_id};
  var response = await http.post(url, body: body_params );

  print("set_arrival_time error: ${response.body}");

}