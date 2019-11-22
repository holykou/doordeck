import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:doordeck/doordeck.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> implements DoordeckCallbackClass {
  String _platformVersion = 'Unknown';
  Doordeck deck;
  @override
  void initState() {
    super.initState();
    initPlatformState();
    deck = Doordeck(this);
    deck.initDoordeck(
        "eyJraWQiOiJkZWZhdWx0IiwiYWxnIjoiRVMyNTYifQ.eyJzdWIiOiIxMGI4ZmIwMC0wYWI4LTExZWEtOGQwNy0wNTRhYjA1YjVlMjAiLCJlbWFpbF92ZXJpZmllZCI6dHJ1ZSwic2Vzc2lvbiI6ImE5MTQxNGQwLTBjMWEtMTFlYS1hMjhjLTBiMmY5ZDEwNTM3NSIsImlzcyI6Imh0dHBzOlwvXC9hcGkuZG9vcmRlY2suY29tXC8iLCJyZWZyZXNoIjpmYWxzZSwiZXhwIjoxNTc0NDk3MjA2LCJpYXQiOjE1NzQ0MTA4MDYsImVtYWlsIjoia291c2hpa0B0ZW5naW8uY29tIiwic2lkIjoiYTkxNDE0ZDAtMGMxYS0xMWVhLWEyOGMtMGIyZjlkMTA1Mzc1In0.8A62xZzFOy_8NFQEwJypY41BZLq4fvJjxAWJAOHqF8nznoLLg7JkSl-jMD_8hRzxRJV7D6lO9U0usSgi2iTyaw");
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await Doordeck.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  void authenticated() {
    // TODO: implement authenticated
  }
  @override
  void invalidAuthToken() {
    // TODO: implement invalidAuthToken
  }
  @override
  void unlockFailed() {
    // TODO: implement unlockFailed
  }
  @override
  void unlockSuccessful() {
    // TODO: implement unlockSuccessful
  }
  @override
  void verificationNeeded() {
    // TODO: implement verificationNeeded
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: FlatButton(
              onPressed: () {
                deck.showUnlock();
              },
              child: Text("Unlock")),
        ),
      ),
    );
  }
}
