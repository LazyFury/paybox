import 'package:flutter/material.dart';
import 'package:paybox/paybox.dart';

// ignore: non_constant_identifier_names
void ShowDialog(BuildContext context) {
  showGeneralDialog(
      barrierColor: Colors.black.withOpacity(0.5),
      transitionBuilder: (context, a1, a2, widget) {
        final curvedValue = Curves.ease.transform(a1.value) - 1.0;
        return Transform(
          transform: Matrix4.translationValues(0.0, -curvedValue * 300, 0.0),
          child: Opacity(
            opacity: a1.value,
            child: Container(
              child: Column(
                children: [
                  Expanded(child: Container()),
                  Material(
                    child: Container(
                      width: double.infinity,
                      height: 320,
                      padding: EdgeInsets.only(top: 0, bottom: 10),
                      child: Column(
                        children: [
                          Container(
                            child: Row(
                              children: [
                                MaterialButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "取消",
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1!
                                        .copyWith(
                                            color:
                                                Theme.of(context).primaryColor),
                                  ),
                                ),
                                Text("选择支付方式"),
                              ],
                            ),
                          ),
                          Expanded(
                            child: CustomScrollView(
                              slivers: [
                                SliverList(
                                  key: ValueKey<String>("pay-list"),
                                  delegate:
                                      SliverChildBuilderDelegate((context, i) {
                                    return Column(
                                      children: [
                                        payRowView(
                                            title: "支付宝",
                                            tips: "支付宝付款",
                                            icon: Icons.adb_sharp,
                                            context: context,
                                            onPressed: () {
                                              Paybox.aliPay("orderInfo",
                                                  urlScheme: "alipaydemo");
                                            }),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        payRowView(
                                            title: "微信支付",
                                            tips: "微信app付款",
                                            context: context,
                                            icon: Icons.west_outlined,
                                            onPressed: () {
                                              Paybox.wxPay(WxPayConfig(
                                                  appId: "appId",
                                                  partnerId: "partnerId",
                                                  prepayId: "prepayId",
                                                  nonceStr: "nonceStr",
                                                  timeStamp: "123131",
                                                  sign: "sign"));
                                            })
                                      ],
                                    );
                                  }, childCount: 1),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionDuration: Duration(milliseconds: 300),
      barrierDismissible: true,
      barrierLabel: 'barrierLabel',
      context: context,
      pageBuilder: (context, animation1, animation2) {
        return Container(
          child: Text("hello world!"),
        );
      });
}

Widget payRowView(
    {required String title,
    required IconData icon,
    required Function() onPressed,
    required BuildContext context,
    String? tips}) {
  return MaterialButton(
      onPressed: onPressed,
      child: Row(
        children: [
          Icon(
            icon,
            size: 32,
          ),
          SizedBox(
            width: 10,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.subtitle1,
              ),
              Text(
                tips ?? "",
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(color: Colors.grey),
              ),
            ],
          ),
        ],
      ));
}
