import 'package:flutter/material.dart';
import 'package:qu_bao_tang/component/widgets.dart';
import 'package:qu_bao_tang/utils/api.dart';
import 'package:qu_bao_tang/utils/application.dart';
import 'package:qu_bao_tang/utils/toast_utils.dart';

class ShopCar extends StatefulWidget {
  createState()=>ShopCarState();
}

class ShopCarState extends State<ShopCar> with AutomaticKeepAliveClientMixin{
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
            child: Column(
              children: <Widget>[
                Top(),
                Expanded(
                  child: Container(
                    color: Color(0xFFEEEFFF),
                    child: ShopCarList(),
                  ),
                )
              ],
            )));
  }

  @override
  bool get wantKeepAlive => false;
}

///顶部栏
class Top extends StatefulWidget {
  createState()=>TopState();
}

class TopState extends State<Top>{
  bool _topRightClick=false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      color: Application.themeColor,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('购物车', style: TextStyle(color: Colors.white, fontSize: 18)),
          GestureDetector(
            onTap: (){
             setState(() {
               _topRightClick=!_topRightClick;
             });
            },
            child: Image.asset('res/images/icon/'+(_topRightClick?'complete.png':'operation.png'),width: 25,height: 25),
          ),
        ]
      ),
    );
  }
}

///购物车列表
class ShopCarList extends StatefulWidget{
  createState()=>ShopCarListState();
}

class ShopCarListState extends State<ShopCarList>{
  List<Widget> _list;
  Set<int> _carIds=Set<int>();

  @override
  void initState() {
    super.initState();
    _list=List<Widget>();
    Api.post<Map>('user/shopCarList').then((data) {
      setState(() {
        _list = List<Widget>();
        data['data'].forEach((item) {
          _list.add(buildItem(item));
        });
      });
    }, onError: (e) {
      ToastUtils.show(e.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: AlwaysScrollableScrollPhysics(),
      children: _list
    );
  }

  Widget buildItem(data) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10)
      ),
      margin:EdgeInsets.symmetric(horizontal:10,vertical: 5),
      padding:EdgeInsets.symmetric(vertical: 10),
      height: 120,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: 40,
            child: Radio(
                value: data['id'],
                groupValue: _carIds,
                activeColor: Application.themeColor,
                onChanged: (value){
                  this._carIds.add(int.parse(value));
                }
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: ImgCache(Application.IMG_URL+data['img'])
                ),
                Container(
                  padding: EdgeInsets.only(left: 10),
                  child: Container(
                    width: 130,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(data['goodsName'],maxLines:2,overflow: TextOverflow.ellipsis),
                        Text(data['specificationName'],softWrap: false,overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.black54)),
                        Text('￥'+data['specificationPrice'].toString(),softWrap: false,overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.red))
                      ],
                    )
                  ),
                )
              ],
            )
          ),
          Container(
            alignment: Alignment.bottomCenter,
            padding: EdgeInsets.only(right: 10),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black54, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 20,
                    height: 20,
                    child: Center(
                      child: Text('-',softWrap:false,style: TextStyle(fontSize: 18,color: Colors.black54)),
                    )
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    width: 40,
                    height: 20,
                    child: Center(
                      child: Text('888',softWrap:false,style: TextStyle(fontSize: 13,color: Colors.black54)),
                    ),
                    decoration: ShapeDecoration(
                        shape: Border(
                          left: BorderSide(color: Colors.black54, width: 1),
                          right: BorderSide(color: Colors.black54, width: 1)
                        ))
                  ),
                  Container(
                    width: 20,
                    height: 20,
                    child: Center(
                      child: Text('+',softWrap:false,style: TextStyle(fontSize: 16,color: Colors.black54)),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

}