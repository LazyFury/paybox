package dev.lazyfury.paybox;


import android.annotation.SuppressLint;
import android.app.Activity;
import android.os.Handler;
import android.os.Message;
import android.text.TextUtils;
import android.widget.Toast;

import androidx.annotation.NonNull;

import com.alipay.sdk.app.PayTask;

import java.util.Map;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

class AliPay{
    private FlutterActivity flutterView;
    private MethodChannel channel;

    AliPay(FlutterActivity flutterView,MethodChannel channel){
        this.flutterView = flutterView;
        this.channel = channel;
    }

    private static final int SDK_PAY_FLAG = 1;
    private static final int SDK_AUTH_FLAG = 2;
    public void Pay(@NonNull MethodCall call, @NonNull MethodChannel.Result result){
        final String orderInfo = (String)call.arguments;

        final Runnable payRunnable = new Runnable() {

            @Override
            public void run() {
                PayTask alipay = new PayTask((Activity)flutterView);
                Map<String, String> result = alipay.payV2(orderInfo, true);

                Message msg = new Message();
                msg.what = SDK_PAY_FLAG;
                msg.obj = result;
                mHandler.sendMessage(msg);
            }
        };

        // 必须异步调用
        Thread payThread = new Thread(payRunnable);
        payThread.start();

        result.success("success");
    }

    @SuppressLint("HandlerLeak")
    private Handler mHandler = new Handler() {
        @SuppressWarnings("unused")
        public void handleMessage(Message msg) {
            switch (msg.what) {
                case SDK_PAY_FLAG: {
                    @SuppressWarnings("unchecked")
                    PayResult payResult = new PayResult((Map<String, String>) msg.obj);
                    /**
                     * 对于支付结果，请商户依赖服务端的异步通知结果。同步通知结果，仅作为支付结束的通知。
                     */
                    String resultInfo = payResult.getResult();// 同步返回需要验证的信息
                    String resultStatus = payResult.getResultStatus();
                    // 判断resultStatus 为9000则代表支付成功
                    if (TextUtils.equals(resultStatus, "9000")) {
                        // 该笔订单是否真实支付成功，需要依赖服务端的异步通知。
//            showAlert(PayDemoActivity.this, getString(R.string.pay_success) + payResult);
                        Toast.makeText(flutterView.getContext(), payResult.getMemo(), 1).show();
                    } else {
                        // 该笔订单真实的支付结果，需要依赖服务端的异步通知。
//            showAlert(PayDemoActivity.this, getString(R.string.pay_failed) + payResult);
                    }
                    System.out.println(payResult);
                    channel.invokeMethod("payResult",payResult.toString());
                    break;
                }
                default:
                    break;
            }
        };
    };

}