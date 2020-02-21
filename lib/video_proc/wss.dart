import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;
import '../scdata.dart';

wssc(SCD scd) async {

  var wsurl = scd.ws_server + "/PubSub";
  var origin = scd.ws_server;

  //final channel = IOWebSocketChannel.connect('wss://echo.websocket.org');
  final channel = IOWebSocketChannel.connect(wsurl, headers: {'Origin': origin});
  //final channel = IOWebSocketChannel.connect('wss://ws-dev.itelcompanies.com:9032/PubSub');

  print("channel = $channel");


  /*channel.stream.listen((message) {
      channel.sink.add("received!");
      channel.sink.close(status.goingAway);
  });*/

  channel.stream.listen(
          (message){
            print("message = $message");
      },
  );

  channel.sink.add("received!");

  //channel.sink.close(status.goingAway);

  /*channel.stream.listen(
          (message){
        // handling of the incoming messages
      },
      onError: function(error, StackTrace stackTrace){
      // error handling
  },
      onDone: function(){
      // communication has been closed
  }
  );*/


}