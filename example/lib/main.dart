import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:paybox/paybox.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  late StreamSubscription _onPay;
  @override
  void initState() {
    super.initState();
    initPlatformState();
    _onPay = Paybox.eventBus.on<alipayResult>().listen((event) {
      print(event.memo);
    });
  }

  @override
  void dispose(){
    super.dispose();
    _onPay.cancel();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await Paybox.platformVersion ?? 'Unknown platform version';
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
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              MaterialButton(child: Text("支付宝支付"),onPressed: (){
                Paybox.AliPay("suke=1");
              },),
              MaterialButton(child: Text("微信支付"),onPressed: (){
                Paybox.WxPay("config=7&sdsd=12");
              },),
              Text('Running 1 on: $_platformVersion\n'),
            ],
          ),
        ),
      ),
    );
  }
}
