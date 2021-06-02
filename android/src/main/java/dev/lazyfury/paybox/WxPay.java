package dev.lazyfury.paybox;


import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;

import androidx.annotation.NonNull;

import com.tencent.mm.opensdk.modelpay.PayReq;
import com.tencent.mm.opensdk.openapi.IWXAPI;
import com.tencent.mm.opensdk.openapi.WXAPIFactory;

import net.sourceforge.simcpux.Constants;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class WxPay  {
    private FlutterActivity flutterView;
    public static String filterName = "wxpayCallback";
    public static BroadcastReceiver broadcastReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            System.out.println(intent.getStringExtra("result"));
        }
    };

    IWXAPI api;
    WxPay(FlutterActivity flutterView){
        this.flutterView = flutterView;
        api = WXAPIFactory.createWXAPI(flutterView, Constants.APP_ID,false);
        api.registerApp(Constants.APP_ID);

        IntentFilter intentFilter = new IntentFilter(filterName);
        flutterView.registerReceiver(broadcastReceiver,intentFilter);
    }

     public  void  unregisterReceiver(){
        flutterView.unregisterReceiver(broadcastReceiver);
    }

    public void Pay(@NonNull MethodCall call, @NonNull MethodChannel.Result result){
        PayReq req = new PayReq();
        req.appId           = "wx8888888888888888";//你的微信appid
        req.partnerId       = "1900000109";//商户号
        req.prepayId        = "WX1217752501201407033233368018";//预支付交易会话ID
        req.nonceStr        = "5K8264ILTKCH16CQ2502SI8ZNMTM67VS";//随机字符串
        req.timeStamp       = "1412000000";//时间戳
        req.packageValue    = "Sign=WXPay";//扩展字段,这里固定填写Sign=WXPay
        req.sign            = "C380BEC2BFD727A4B6845133519F3AD6";//签名
        api.sendReq(req);
    }
}
