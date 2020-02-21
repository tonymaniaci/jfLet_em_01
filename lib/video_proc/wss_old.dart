import 'dart:io';

import '../scdata.dart';
import 'dart:async';

wss_old(SCD scd) async {

  //wss_server =  wss://ws-dev.itelcompanies.com:9032/PubSub

  var wsurl = scd.ws_server + "/PubSub";
  var origin = scd.ws_server;

  //var origin = 'https://ws-dev.itelcompanies.com/';  //Change Hard Coded
  //var wsurl = 'wss://echo.websocket.org';
  //var origin = 'https:/echo.websocket.org/';  //Change Hard Coded

  void onMessage(msg){
    print("Return Message: ${msg}");
  }

  void connectionClosed() {
    print('Connection to server closed');
  }

  WebSocket.connect(wsurl, headers: {'Origin': origin})
  //WebSocket.connect(wsurl)
  .then((socket) {
  socket.listen(onMessage, onDone: connectionClosed);
  print("socket wss old = $socket");
  //socket.add(scd.attendee_id);
  })
  .catchError(print);

}