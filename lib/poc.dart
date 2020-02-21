import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'bloc.dart';

import 'video_display.dart';

class PocWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DeepLinkBloc _bloc = Provider.of<DeepLinkBloc>(context);
    return StreamBuilder<String>(
      stream: _bloc.state,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
              child: Center(
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      new Text('Snap NO DATA, No deep link, ${snapshot.data}',
                          style: TextStyle(fontSize: 20.0, color: Colors.red,fontWeight: FontWeight.w600),),
                      //new VideoDisplayPage(snapshot.data),
                      new VideoDisplayPage("https://developer1.itelcompanies.com"),
                    ],
                ),),);

        } else {
          return Container(
              child: Center(
                  child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text('Snap DATA, Redirected, ${snapshot.data}',
                        style: TextStyle(fontSize: 20.0, color: Colors.blue,fontWeight: FontWeight.w600),))));

        }
      },
    );
  }
}
