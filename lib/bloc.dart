import 'dart:async';

import 'package:flutter/services.dart';
//import 'package:uni_links/uni_links.dart';
import 'package:flutter/services.dart' show PlatformException;

import 'login.dart';

abstract class Bloc {
  void dispose();
}

class DeepLinkBloc extends Bloc {

  //Method channel creation
  static const LINK_CHANNEL = "itel.build6x.link_channel";
  static const platform = const MethodChannel(LINK_CHANNEL);

  //Event Channel creation
  static const LINK_EVENTS = "itel.build6x.link_events";
  static const stream = const EventChannel(LINK_EVENTS);

  StreamController<String> _stateController = StreamController();

  Stream<String> get state => _stateController.stream;

  Sink<String> get stateSink => _stateController.sink;


  //Adding the listener into contructor
  DeepLinkBloc() {

    //print("stream = ${stream}");

    //Checking application start by deep link
    startUri().then(_onRedirected);

    //Checking broadcast stream, if deep link was clicked in opened appication
    stream.receiveBroadcastStream().listen((d) => _onRedirected(d));
  }


  _onRedirected(String uri) {
    // Here can be any uri analysis, checking tokens etc, if it’s necessary
    // Throw deep link URI into the BloC's stream

    print("_onRedirected uri = ${uri}");
    //uri = "MOOSE";
    //print("uri = ${uri}");

    stateSink.add(uri);

    //login(uri);
  }


  @override
  void dispose() {
    _stateController.close();
  }


  Future<String> startUri() async {
    try {
      return platform.invokeMethod('initialLink');
    } on PlatformException catch (e) {
      return "Failed to Invoke: '${e.message}'.";
    }
  }

}//end Bloc