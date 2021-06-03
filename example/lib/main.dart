import 'dart:async';

import 'package:flutter/material.dart';
import 'package:paybox/paybox.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Pay demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late StreamSubscription alipayListen;
  late StreamSubscription wxpayListen;
  @override
  void initState() {
    super.initState();

    // 支付宝支付回调
    alipayListen = Paybox.eventBus.on<AlipayResult>().listen((event) {
      print("ali:" + event.memo + event.status);
    });

    wxpayListen = Paybox.eventBus.on<WxPayResult>().listen((event) {
      print("wx:" + event.result + event.status);
    });

    Paybox.wxpayInit("123123132", universalLink: "");
  }

  @override
  void dispose() {
    super.dispose();
    alipayListen.cancel();
    wxpayListen.cancel();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            MaterialButton(
              onPressed: () {
                Paybox.aliPay("config", urlScheme: "alipaydemo");
              },
              child: Text("alipay"),
            ),
            MaterialButton(
              onPressed: () {
                Paybox.wxPay(WxPayConfig(
                    appId: "appId",
                    partnerId: "partnerId",
                    prepayId: "prepayId",
                    nonceStr: "nonceStr",
                    timeStamp: "123131",
                    sign: "sign"));
              },
              child: Text("wxpay"),
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
