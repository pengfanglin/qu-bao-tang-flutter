import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:my_flutter/page/search.dart';
import 'package:my_flutter/utils/api.dart';
import 'package:my_flutter/utils/application.dart';
import 'package:my_flutter/utils/toast_utils.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: ListView(
          shrinkWrap: true,
          children: <Widget>[
            TopSearch(),
            Banner(),
            GoodsClass(),
            HotSales(),
            HotGoods()
          ],
        ));
  }
}

///热卖图片
class HotSales extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(height: 60, child: Image.asset('res/images/hot_sales.png'));
  }
}

///搜索框
class TopSearch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      color: Application.themeColor,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: GestureDetector(
          onTap: (){
//            Navigator.of(context).pushNamed('/search');
            Navigator.of(context).push(
                MaterialPageRoute(builder: (_) {
                  return Search();
                })
            );
          },
          child: Container(
              padding: EdgeInsets.only(left: 10),
              height: 40,
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Icon(Icons.search,color: Colors.black26),
                  Text('请输入商品名称',style: TextStyle(color: Colors.black38,fontSize: 14))
                ],
              )
          ),
        ),
      ),
    );
  }
}

///轮播图
class Banner extends StatefulWidget {
  createState() => BannerState();
}

class BannerState extends State<Banner> {
  Swiper swiper = Swiper(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Image.network(Application.IMG_URL + '/images/others/slider1.jpg', fit: BoxFit.fill);
      });

  @override
  void initState() {
    super.initState();
    Api.post<List<dynamic>>('others/homeBannerList').then((bannerList) {
      setState(() {
        swiper = Swiper(
            itemBuilder: (context, index) {
              return Image.network(
                Application.IMG_URL + bannerList[index]['bannerImg'],
                fit: BoxFit.fill,
              );
            },
            itemCount: bannerList.length,
            pagination: new SwiperPagination(builder: DotSwiperPaginationBuilder(color: Colors.white, activeColor: Colors.red)),
            scrollDirection: Axis.horizontal,
            autoplay: true,
            autoplayDelay: 2000,
            onTap: (index) => print('点击了第$index个'));
      });
    }, onError: (e) {
      RequestErrorException exception = (e as RequestErrorException);
      print('${exception.code},${exception.error}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 200.0,
      child: swiper,
    );
  }
}

///商品分裂
class GoodsClass extends StatefulWidget {
  createState() => GoodsClassState();
}

class GoodsClassState extends State<GoodsClass> {
  List<Widget> list = List<Widget>();

  @override
  void initState() {
    super.initState();
    Api.post<List<dynamic>>('goods/homeGoodsClassList').then((goodsClassList) {
      setState(() {
        list = List<Widget>();
        list.add(GestureDetector(
          onTap: () {
            goodsClassClick(0, 0);
          },
          child: CircleAvatar(radius: 50, backgroundColor: Application.themeColor, backgroundImage: AssetImage('res/images/icon/all_class.png')),
        ));
        for (int i = 0; i < goodsClassList.length; i++) {
          list.add(GestureDetector(
            onTap: () {
              goodsClassClick(i + 1, goodsClassList[i]['classId']);
            },
            child: CircleAvatar(
                backgroundColor: Colors.greenAccent, radius: 50, backgroundImage: NetworkImage(Application.IMG_URL + goodsClassList[i]['classImg'])),
          ));
        }
      });
    }, onError: (e) {
      RequestErrorException exception = (e as RequestErrorException);
      print('${exception.code},${exception.error}');
    });
  }

  void goodsClassClick(index, classId) {
    ToastUtils.show('$index,$classId',context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      color: const Color(0xFFEEEFFF),
      child: GridView(
        shrinkWrap: true,
        physics: new NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5, //每行5个
          mainAxisSpacing: 5, //主轴方向间距
          crossAxisSpacing: 10, //水平方向间距
        ),
        children: list,
      ),
    );
  }
}

///热卖商品
class HotGoods extends StatefulWidget {
  createState() => HotGoodsState();
}

class HotGoodsState extends State<HotGoods> {
  List<Widget> list = List<Widget>();

  @override
  void initState() {
    super.initState();
    Api.post<List<dynamic>>('goods/homeHotGoodsList').then((goodsList) {
      setState(() {
        list = List<Widget>();
        goodsList.forEach((goods) {
          list.add(buildItem(goods));
        });
      });
    }, onError: (e) {
      RequestErrorException exception = (e as RequestErrorException);
      print('${exception.code},${exception.error}');
    });
  }

  Widget buildItem(dynamic goods) {
    return GestureDetector(
      onTap: (){
        hotGoodsClick(goods['goodsId']);
      },
      child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
              color: Colors.white,
              child: Column(children: <Widget>[
                ListBody(mainAxis: Axis.vertical, children: <Widget>[
                  Container(
                    height: 180,
                    child: Image.network(
                      Application.IMG_URL + goods['img'],
                      fit: BoxFit.fill,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Center(
                      child: Text(goods['name'], style: TextStyle(fontSize: 15)),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('￥${goods['minPrice']}', style: TextStyle(color: Colors.red)),
                        Text('${goods['totalSales']}人付款', style: TextStyle(color: Colors.black54)),
                      ],
                    ),
                  )
                ]),
              ]))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      color: const Color(0xFFEEEFFF),
      child: GridView(
        shrinkWrap: true,
        physics: new NeverScrollableScrollPhysics(),
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 5, crossAxisSpacing: 10, childAspectRatio: 2 / 2.5),
        children: list,
      ),
    );
  }

  hotGoodsClick(goodsId) {
    print(goodsId);
  }
}
