import 'package:flutter/material.dart';
import 'package:my_flutter/utils/application.dart';

class ToastUtils {
  static void show(String message, {int duration,BuildContext context}) {
    OverlayEntry entry = OverlayEntry(builder: (context) {
      return Container(
        color: Colors.transparent,
        margin: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.8,
        ),
        child: Center(
            child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Container(
                    color: Color(0xFF666666),
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      message,
                      style: TextStyle(fontSize: 14, color: Colors.white, decoration: TextDecoration.none),
                    )))),
      );
    });
    Overlay.of(context==null?Application.context:context).insert(entry);
    Future.delayed(Duration(seconds: duration ?? 1)).then((value) {
      // 移除层可以通过调用OverlayEntry的remove方法。
      entry.remove();
    });
  }
}
