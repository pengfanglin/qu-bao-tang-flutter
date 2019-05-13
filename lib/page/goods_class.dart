import 'package:flutter/material.dart';
import 'package:qu_bao_tang/utils/api.dart';
import 'package:qu_bao_tang/utils/application.dart';
import 'package:qu_bao_tang/utils/toast_utils.dart';

class GoodsClassRoot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFEEEFFF),
        body: SafeArea(
            child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            TopTitle(),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  LeftGoodsClass(),
                  Expanded(
                    flex: 1,
                    child: RightGoodsClass(),
                  )
                ],
              ),
            )
          ],
        )));
  }
}

///顶部标题栏
class TopTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
      color: Application.themeColor,
      child: Center(
        child: Container(child: Text('商品分类', style: TextStyle(color: Colors.white, fontSize: 20))),
      ),
    );
  }
}

///左边商品分类树
class LeftGoodsClass extends StatefulWidget {
  createState() => LeftGoodsClassState();
}

class LeftGoodsClassState extends State<LeftGoodsClass> {
  List<Widget> list = List<Widget>();

  @override
  void initState() {
    super.initState();
    Api.post<List<dynamic>>('goods/goodsClassTree').then((goodsClassTree) {
      setState(() {
        list = List<Widget>();
        goodsClassTree.forEach((goodsClass) {
          list.add(GestureDetector(
              onTap: () {
                ToastUtils.show(goodsClass['className']);
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Center(
                  child: Text(goodsClass['className'], softWrap: false, style: TextStyle(color: Colors.white, fontSize: 20)),
                ),
              )));
        });
      });
    }, onError: (e) {
      RequestErrorException exception = (e as RequestErrorException);
      ToastUtils.show('${exception.code},${exception.error}', context: context);
    });
  }

  void searchHistoryClick(id) {
    ToastUtils.show('$id', context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Application.themeColor,
      constraints: BoxConstraints(maxWidth: 110),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: ListView(shrinkWrap: true, children: list),
    );
  }
}

///右边商品分类
class RightGoodsClass extends StatefulWidget {
  createState() => RightGoodsClassState();
}

class RightGoodsClassState extends State<RightGoodsClass> {
  List<Widget> list = List<Widget>();

  @override
  void initState() {
    super.initState();
    Api.post<List<dynamic>>('goods/goodsClassTree').then((goodsClassTree) {
      setState(() {
        list = List<Widget>();
        goodsClassTree.forEach((goodsClass) {
          list.add(buildItem(goodsClass));
        });
      });
    }, onError: (e) {
      RequestErrorException exception = (e as RequestErrorException);
      ToastUtils.show('${exception.code},${exception.error}', context: context);
    });
  }

  void searchHistoryClick(id) {
    ToastUtils.show('$id', context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 150),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: GridView(
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, //每行5个
          mainAxisSpacing: 10, //主轴方向间距
          crossAxisSpacing: 10, //水平方向间距
          childAspectRatio: 2 / 2.5
        ),
        children: list,
      ),
    );
  }

  Widget buildItem(dynamic goodsClass) {
    return GestureDetector(
      onTap: () {
        ToastUtils.show(goodsClass['className']);
      },
      child:ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Application.themeColor, width: 1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(children: <Widget>[
              Expanded(
                  flex: 1,
                  child: Container(
                    child: Image.network(
                      Application.IMG_URL + goodsClass['classImg'],
                      fit: BoxFit.cover,
                    ),
                  )),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                child: Center(
                  child: Text(goodsClass['className'], softWrap: false, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 14)),
                ),
              )
            ])),
      ),
    );
  }
}
