import 'dart:io';
import 'dart:convert';
import '../scdata.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;


sendJoinMessage(SCD scd, String wsurl, String origin, IOWebSocketChannel channel) async {

  final JsonEncoder encoder = const JsonEncoder();

  Map m_payload = new Map();
  m_payload = {"schedule_id": scd.schedule_id, "session_id": "","url": "","full_name": scd.doctor_name,"msg":"", "participants":scd.partpants, "appfunc":{"opcode": "","params":[{"key": "","value": ""}]} };
  var j_payload = encoder.convert(m_payload);

  Map m_head = new Map();
  m_head = {"messagetype": "join_session", "key": "", "from": scd.attendee_id, "to": scd.provider_id, "payload": m_payload};
  var j_header = encoder.convert(m_head);

  /*WebSocket.connect(wsurl, headers: {'Origin': origin})
      .then((socket) {
    socket.add(j_header);
  })
      .catchError(print);*/

  channel.sink.add(j_header);

}
