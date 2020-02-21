import 'dart:async';
import 'package:flutter/foundation.dart';

import '../scdata.dart';
import 'getTokTokens.dart';
import 'send_initial_ws.dart';
import 'set_arrival_time.dart';
import 'get_admins.dart';
import 'sendJoinMessage.dart';

import 'wss.dart';
import 'wss_old.dart';
import 'dart:io';

import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

import 'package:flutter/services.dart';

//const CHANNEL = "id.pahlevikun.native_communication.channel";

const VIDEO_CHANNEL = "itel.build6x.video_channel";
const KEY_NATIVE = "showNativeView";

video_prep(SCD scd) async {

  const platform = const MethodChannel(VIDEO_CHANNEL);

  //wss_old(scd);
  //wssc(scd);

  //var wsurl = 'wss://echo.websocket.org';
  //var origin = 'https:/echo.websocket.org/';  //Change Hard Coded
  var wsurl = scd.ws_server + "/PubSub";
  var origin = scd.ws_server;

  final channel = IOWebSocketChannel.connect(wsurl, headers: {'Origin': origin});

  print("channel = $channel");

  channel.stream.listen(
        (message){
      print("message = $message");
    },
  );

  await getTokTokens(scd);

  await send_initial_ws(scd, wsurl, origin, channel);

  await set_arrival_time(scd);

  await get_admins(scd);

  await sendJoinMessage(scd, wsurl, origin, channel);

  await showNativeView(platform, scd);

  await videoExit(platform, scd);



}

Future<Null> showNativeView(platform, SCD scd) async {
  var response = null;
  try {
    final result = await platform.invokeMethod(KEY_NATIVE, {"tokapikey":scd.tokapikey,"toksessionid":scd.toksessionid,"toktoken":scd.toktoken });
    response = result;
    print("channel result = $result");
  } on PlatformException catch (e) {
    response = "Failed to Invoke: '${e.message}'.";
  }
}



Future<Null> videoExit(platform, SCD scd) async {
  var response = null;
  try {
    //final result = await platform.invokeMethod(KEY_NATIVE, {"tokapikey":scd.tokapikey,"toksessionid":scd.toksessionid,"toktoken":scd.toktoken });
    platform.setMethodCallHandler(_handleMethod);
    //response = result;
    //print("channel result = $result");
  } on PlatformException catch (e) {
    response = "Failed to Invoke: '${e.message}'.";
  }
}

Future<dynamic> _handleMethod(MethodCall call) async {
  switch(call.method) {
    case "message":
      debugPrint(call.arguments);
      SystemNavigator.pop();
      return new Future.value("");
  }
}



/*Future<Null> showNativeView(platform, SCD scd) async {
  await platform.invokeMethod(KEY_NATIVE, {"tokapikey":scd.tokapikey,"toksessionid":scd.toksessionid,"toktoken":scd.toktoken });
}*/

