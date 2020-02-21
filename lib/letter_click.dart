import 'dart:async';
import 'dart:io';

import 'package:uni_links/uni_links.dart';
import 'package:flutter/services.dart' show PlatformException;

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'login.dart';
import 'bloc.dart';



import 'opening_alert.dart';
import 'package:flutter/material.dart';

import 'opening_alert.dart';

initUniLinks() async {
  // Platform messages may fail, so we use a try/catch PlatformException.
  try {
    String initialLink = await getInitialLink();
    // Parse the link and warn the user, if it is not correct,
    // but keep in mind it could be `null`.

    initialLink = "MOOSE";
    print("initialLink = ${initialLink}");

    if (initialLink != null) {

      print("Redirect = ${initialLink}");

      login(initialLink);

    } else {
      print("No Redirect = ${initialLink}");
    }

  } on PlatformException {
    // Handle exception by warning the user their action did not succeed
    // return?
  }


}

/*void _show_opening_alert() {
  Future<void> _show_opening_alert() async {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          Future.delayed(Duration(seconds: 5), () {
            Navigator.of(context).pop(true);
          });
          return AlertDialog(
            title: Text('Title'),
          );
        });
  }*/

