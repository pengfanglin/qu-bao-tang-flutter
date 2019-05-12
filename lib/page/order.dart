import 'package:flutter/material.dart';

class Order extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan,
      body: Center(
        child: GestureDetector(
          onTap: (){
            print(1);
          },
           child: Text('订单',style: TextStyle(color: Colors.white),
        ))
      )
    );
  }
}