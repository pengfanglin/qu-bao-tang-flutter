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
              child: GoodsClassBody(),
            )
          ],
        )));
  }
}

class GoodsClassBody extends StatefulWidget {
  @override
  createState() => GoodsClassBodyState();
}

class GoodsClassBodyState extends State<GoodsClassBody> {
  int clickIndex=0;
  List<dynamic> leftGoodsClassList = List<dynamic>();
  List<dynamic> rightGoodsClassList = List<dynamic>();
  List<Widget> leftClassWidget = List<Widget>();
  List<Widget> rightClassWidget = List<Widget>();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          color: Application.themeColor,
          constraints: BoxConstraints(maxWidth: 110),
          child: ListView(shrinkWrap: true, children: leftClassWidget),
        ),
        Expanded(
          flex: 1,
          child: Container(
            child: GridView(
              padding: EdgeInsets.only(top: 10,left: 10,right: 10),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, //每行5个
                  mainAxisSpacing: 10, //主轴方向间距
                  crossAxisSpacing: 10, //水平方向间距
                  childAspectRatio: 2 / 2.5),
              children: rightClassWidget,
            ),
          ),
        )
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    Api.post<List<dynamic>>('goods/goodsClassTree').then((goodsClassTree) {
      setState(() {
        leftGoodsClassList = goodsClassTree;
        buildLeftClassWidgetList();
        if (leftGoodsClassList.length > 0) {
          this.buildRightClassWidgetList(0);
        }
      });
    }, onError: (e) {
      RequestErrorException exception = (e as RequestErrorException);
      ToastUtils.show('${exception.code},${exception.error}', context: context);
    });
  }

  void buildLeftClassWidgetList() {
    leftClassWidget=List<Widget>();
    for (int i = 0; i < leftGoodsClassList.length; i++) {
      leftClassWidget.add(GestureDetector(
          onTap: () {
            setState(() {
              rightGoodsClassList = leftGoodsClassList[i]['goodsClassModels'];
              clickIndex=i;
              buildLeftClassWidgetList();
              buildRightClassWidgetList(i);
            });
          },
          child: Container(
            decoration: clickIndex==i?ShapeDecoration(
                color: Colors.white,
                shape: Border(left: BorderSide(color: Colors.red,width: 5))
            ):BoxDecoration(
                color: Application.themeColor
            ),
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Center(
              child: Text(
                  leftGoodsClassList[i]['className'],
                  softWrap: false,
                  style: TextStyle(
                      color: clickIndex==i?Application.themeColor:Colors.white,
                      fontSize: 20
                  )),
            ),
          )));
    }
  }

  void buildRightClassWidgetList(index) {
    rightClassWidget = List<Widget>();
    rightGoodsClassList = (leftGoodsClassList[index]['goodsClassModels'] as List<dynamic>);
    rightGoodsClassList.forEach((goodsClass) {
      rightClassWidget.add(buildItem(goodsClass));
    });
  }

  Widget buildItem(dynamic goodsClass) {
    return GestureDetector(
      onTap: () {
        ToastUtils.show(goodsClass['className']);
      },
      child: ClipRRect(
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
