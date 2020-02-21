import 'dart:io';
import '../scdata.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

send_initial_ws(SCD scd, String wsurl, String origin, IOWebSocketChannel channel) async {

  print("channel send initial ws = $channel");

  //sock.add(scd.attendee_id);

  /*WebSocket.connect(wsurl, headers: {'Origin': origin})
      .then((socket) {
    socket.add(scd.attendee_id);
  })
      .catchError(print);*/

  channel.sink.add(scd.attendee_id);

}