import 'package:flutter/material.dart';

import 'login.dart';

class VideoDisplayPage extends StatefulWidget {
  final String uri;

  const VideoDisplayPage(String data, {Key key, this.uri}): super(key: key);

  @override
  _VideoDisplayState createState() => _VideoDisplayState();

}

//class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
class _VideoDisplayState extends State<VideoDisplayPage> {
  //AnimationController _controller;

  @override
  void initState() {

    super.initState();

    login(widget.uri);



    //var uri = "https://developer1.itelcompanies.com";

    //login(uri);

    /* _controller = new AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );*/

    //initUniLinks();
  }

  /*@override
  void dispose() {
    // _controller.dispose();
    super.dispose();
  }*/

  @override
  Widget build(context) => Container(width: 0.0, height: 0.0);

}//end _VideoDisplayState