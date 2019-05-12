import 'package:flutter/material.dart';
import 'find.dart' show Find;
import 'home.dart' show Home;
import 'my.dart' show My;
import 'order.dart' show Order;
import 'shop_car.dart' show ShopCar;
import 'search.dart' show Search;

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: TableMenu(),
    routes: <String,WidgetBuilder>{
      '/search': (_) => Search()
    },
  ));
}

class TableMenu extends StatefulWidget {
  createState() => TableMenuState();
}

class TableMenuState extends State<TableMenu> {
  List<Widget> pages = List<Widget>();
  int index = 0;
  List<String> menuImages = ['home', 'shop_car', 'order', 'find', 'my'];
  List<String> menuTitles = ['首页', '购物车', '订单', '发现', '我的'];

  @override
  void initState() {
    super.initState();
    pages..add(Home())..add(ShopCar())..add(Order())..add(Find())..add(My());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: buildMenus(),
        currentIndex: index,
        onTap: (nowIndex) {
          setState(() {
            index = nowIndex;
          });
        },
        backgroundColor: Color(0xFFEEEFFF),
        type: BottomNavigationBarType.fixed
      ),
      body: pages[index]
    );
  }

  List<BottomNavigationBarItem> buildMenus() {
    List<BottomNavigationBarItem> menuItems = List<BottomNavigationBarItem>();
    for (int i = 0; i < menuImages.length; i++) {
      menuItems.add(BottomNavigationBarItem(
        icon: Image.asset('res/images/icon/${menuImages[i]}.png', width: 30, height: 30),
        activeIcon: Image.asset('res/images/icon/${menuImages[i]}_hover.png', width: 30, height: 30),
        title: Text(menuTitles[i]),
      ));
    }
    return menuItems;
  }
}
