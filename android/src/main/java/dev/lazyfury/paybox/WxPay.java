package dev.lazyfury.paybox;


import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;

import androidx.annotation.NonNull;

import com.tencent.mm.opensdk.modelpay.PayReq;
import com.tencent.mm.opensdk.openapi.IWXAPI;
import com.tencent.mm.opensdk.openapi.WXAPIFactory;

import net.sourceforge.simcpux.WxConstants;

import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class WxPay  {
    private final FlutterActivity flutterView;
    public static String filterName = "wxpayCallback";

    private static class XBroadcastReceiver extends BroadcastReceiver {
        private final MethodChannel channel;

        public XBroadcastReceiver(MethodChannel channel){
            this.channel = channel;
        }

        @Override
        public void onReceive(Context context, Intent intent) {
            System.out.println(intent.getStringExtra("result"));
            String result = intent.getStringExtra("result");
            int status = intent.getIntExtra("errCode",0);
            String memo = intent.getStringExtra("memo");
            PayResult payResult = new PayResult(result,String.valueOf(status),memo);
            System.out.println(payResult);
            try {
                channel.invokeMethod("wxpayResult",payResult.toMap());
            }catch (Exception e){
                System.out.println(e);
            }
//        if(instance!=null)instance.channel.invokeMethod("wxpayResult",);
        }
    }

    public static XBroadcastReceiver broadcastReceiver;



    IWXAPI api;
    WxPay(FlutterActivity flutterView,MethodChannel channel){
        this.flutterView = flutterView;
        broadcastReceiver = new XBroadcastReceiver(channel);
    }

    public  void register(@NonNull MethodCall call, @NonNull MethodChannel.Result result){
        HashMap config = (HashMap)call.arguments;
//        set appid
        String appid = (String) config.get("appid");
        WxConstants.APP_ID = appid;
//        init wx api
        api = WXAPIFactory.createWXAPI(flutterView, WxConstants.APP_ID, true);
//        reg wx app
        api.registerApp(WxConstants.APP_ID);

//        注册广播，接受支付回调
        IntentFilter intentFilter = new IntentFilter(filterName);
        flutterView.registerReceiver(broadcastReceiver,intentFilter);
        result.success("ok");
    }

     public  void  unregisterReceiver(){
        flutterView.unregisterReceiver(broadcastReceiver);
    }

    public void Pay(@NonNull MethodCall call, @NonNull MethodChannel.Result result){
        HashMap<String,String> config = (HashMap<String,String>)call.arguments;
        PayReq req = new PayReq();
        req.appId           = config.get("appId");//你的微信appid
        req.partnerId       = config.get("partnerId");//商户号
        req.prepayId        = config.get("prepayId");//预支付交易会话ID
        req.nonceStr        = config.get("nonceStr");//随机字符串
        req.timeStamp       = config.get("timeStamp");//时间戳
        req.packageValue    = config.get("package");//"Sign=WXPay" //扩展字段,这里固定填写Sign=WXPay
        req.sign            = config.get("sign");//签名
        api.sendReq(req);
    }
}
