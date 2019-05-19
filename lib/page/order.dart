import 'package:flutter/material.dart';
import 'package:qu_bao_tang/utils/application.dart';

class Order extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Container(
              height: 50,
                child: TextField(
                  controller: TextEditingController(),
                  maxLines: 1,
                  onChanged: (value) {

                  },
                  onSubmitted: (value) {},
                  style: TextStyle(color: Colors.black54),
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(Icons.search, color: Colors.black26),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide(color: Application.themeColor))),
                )
            ),
          )
      ),
    );
  }
}