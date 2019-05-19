import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:qu_bao_tang/utils/application.dart';

class WebView extends StatefulWidget{
  final String  url;
  final String title;
  final bool full;

  WebView(this.url,{this.title,this.full=false});

  @override
  State<StatefulWidget> createState()=>MyWebViewState();
}
class MyWebViewState extends State<WebView>{
  // 标记是否是加载中
  bool loading = true;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  // WebView加载状态变化监听器
  StreamSubscription<WebViewStateChanged> stateChanged;
  // 插件提供的对象，该对象用于WebView的各种操作
  FlutterWebviewPlugin flutterWebViewPlugin = FlutterWebviewPlugin();

  @override
  void initState() {
    super.initState();
    stateChanged = flutterWebViewPlugin.onStateChanged.listen((WebViewStateChanged state){
      switch (state.type) {
        case WebViewState.shouldStart:
        // 准备加载
          setState(() {
            loading = true;
          });
          break;
        case WebViewState.startLoad:
        // 开始加载
          break;
        case WebViewState.finishLoad:
        // 加载完成
          setState(() {
            loading = false;
          });
          break;
        case WebViewState.abortLoad:
          print('终止加载');
          //终止加载
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> titleContent = [];
    if (widget.full&&loading) {
      // 如果还在加载中，就在标题栏上显示一个圆形进度条
      titleContent.add(CupertinoActivityIndicator());
    }
    if(!widget.full&&widget.title!=null){
      titleContent.add(Text(widget.title,style: TextStyle(color: Colors.white)));
    }
    return WebviewScaffold(
      key: scaffoldKey,
      url:widget.url,
      appBar: widget.full?null:AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: titleContent
              )
            ),
            GestureDetector(
              onTap: (){
                flutterWebViewPlugin.reload();
              },
              child: Icon(Icons.refresh,color: Colors.white,size: 25)
            )
          ]
        ),
        backgroundColor: Application.themeColor,
        iconTheme: IconThemeData(color: Colors.white)
      ),
      //禁止网页缩放
      withZoom: false,
      //允许LocalStorage
      withLocalStorage: true,
      //允许执行js代码
      withJavascript: true
    );
  }

  @override
  void dispose() {
    stateChanged.cancel();
    flutterWebViewPlugin.dispose();
    super.dispose();
  }
}