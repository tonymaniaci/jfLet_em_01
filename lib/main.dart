import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'bloc.dart';
import 'poc.dart';


void main() => runApp(PocApp());

class PocApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    DeepLinkBloc _bloc = DeepLinkBloc();
    return MaterialApp(
        /*title: 'Flutter and Deep Linsk PoC',
        theme: ThemeData(
            primarySwatch: Colors.blue,
            textTheme: TextTheme(
              title: TextStyle(
                fontWeight: FontWeight.w300,
                color: Colors.blue,
                fontSize: 25.0,
              ),
            )),*/
        home: Scaffold(
          appBar: AppBar(title: Text("Poc Screen"),),
            body: Provider<DeepLinkBloc>(
                create: (context) => _bloc,
                dispose: (context, bloc) => bloc.dispose(),
                child: PocWidget())));
  }
}//end PocApp












/*class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MyHomePage();
    /*return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );*/
  }
}


 class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();

}

//class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
class _MyHomePageState extends State<MyHomePage> {
  //AnimationController _controller;

  @override
  void initState() {
    super.initState();

     _controller = new AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    //initUniLinks();
  }

  @override
  void dispose() {
    // _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(context) => Container(width: 0.0, height: 0.0);

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Moose"),
        ),
        body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text("Eat Shit"),
          ],
    ),

    )
    );
  }

@override
  Widget build(BuildContext context) {
    return SpinKitRing(
        color: Colors.white,
        size: 50.0,
        controller: _controller
    );
  }*/

