# paybox

A new Flutter plugin.

## Getting Started

### Android支付宝
1.由于alipay sdk使用的本地依赖，而且近期的gradle版本不推荐将android modules内的本地依赖直接编译到app工程中，所以需要配合修改原生工程

    1.1 打开目录./flutterappxx/android/app/,并创建目录/libs

    1.2 下载 https://github.com/LazyFury/paybox/blob/master/android/libs/alipaysdk-15.8.03.210428205839.aar?raw=true 或在支付宝官方网站下载 alipaysdk-15.8.03.210428205839
    并且拷贝到libs目录

    1.3 在/app/build.gradle中添加如下代码


``` gradle
//替换
android{
    defaultConfig{
        //minSdkVersion 16
        minSdkVersion 19
    }
}


//添加
//表示使用libs中到库
repositories {
    flatDir(
            dirs: "libs"
    )
}
```

