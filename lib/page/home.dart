import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:qu_bao_tang/page/search.dart' show Search;
import 'package:qu_bao_tang/utils/api.dart';
import 'package:qu_bao_tang/utils/application.dart';
import 'package:qu_bao_tang/utils/toast_utils.dart';

import 'goods_class.dart' show GoodsClassRoot;

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TopSearch(),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                physics: AlwaysScrollableScrollPhysics(),
                children: <Widget>[Banner(), GoodsClass(), HotSales(), HotGoods()],
              ),
            )
          ],
        )));
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
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) {
              return Search();
            }));
          },
          child: Container(
              padding: EdgeInsets.only(left: 10),
              height: 40,
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[Icon(Icons.search, color: Colors.black26), Text('请输入商品名称', style: TextStyle(color: Colors.black38, fontSize: 14))],
              )),
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
      String content;
      if (e is NoSuchMethodError) {
        content = (e as NoSuchMethodError).toString();
      } else if (e is RequestErrorException) {
        RequestErrorException exception = (e as RequestErrorException);
        content = '${exception.code},${exception.error}';
      } else {
        content = e.toString();
      }
      print(content);
      ToastUtils.show(content, context: context);
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
    list.add(GestureDetector(
      onTap: () {
        goodsClassClick(0, 0);
      },
      child: CircleAvatar(radius: 50, backgroundColor: Application.themeColor, backgroundImage: AssetImage('res/images/icon/all_class.png')),
    ));
    for (int i = 0; i < 9; i++) {
      list.add(GestureDetector(
        onTap: () {
          goodsClassClick(i + 1, -1);
        },
        child: CircleAvatar(backgroundColor: Colors.greenAccent, radius: 50, backgroundImage: AssetImage('res/images/loading.gif')),
      ));
    }
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
      String content;
      if (e is NoSuchMethodError) {
        content = (e as NoSuchMethodError).toString();
      } else if (e is RequestErrorException) {
        RequestErrorException exception = (e as RequestErrorException);
        content = '${exception.code},${exception.error}';
      } else {
        content = e.toString();
      }
      print(content);
      ToastUtils.show(content, context: context);
    });
  }

  void goodsClassClick(index, classId) {
    if(index==0){
      Navigator.of(context).push(MaterialPageRoute(builder: (_) {
        return GoodsClassRoot();
      }));
    }else{
      ToastUtils.show('$index,$classId', context: context);
    }
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
  List<Widget> list;

  @override
  void initState() {
    super.initState();
    list = List<Widget>();
    for (int i = 0; i < 6; i++) {
      list.add(buildItem({"goodsId": -1, "name": "加载中。。。。。", "imgType": 'asset', "img": "res/images/loading.gif", "minPrice": "0", "totalSales": 0}));
    }
    Api.post<List<dynamic>>('goods/homeHotGoodsList').then((goodsList) {
      setState(() {
        list = List<Widget>();
        goodsList.forEach((goods) {
          goods['imgType'] = 'network';
          list.add(buildItem(goods));
        });
      });
    }, onError: (e) {
      String content;
      if (e is NoSuchMethodError) {
        content = (e as NoSuchMethodError).toString();
      } else if (e is RequestErrorException) {
        RequestErrorException exception = (e as RequestErrorException);
        content = '${exception.code},${exception.error}';
      } else {
        content = e.toString();
      }
      print(content);
      ToastUtils.show(content, context: context);
    });
  }

  Widget buildItem(dynamic goods) {
    return GestureDetector(
      onTap: () {
        hotGoodsClick(goods['goodsId']);
      },
      child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
              color: Colors.white,
              child: Column(children: <Widget>[
                Expanded(
                    flex: 1,
                    child: Container(
                      child: goods['imgType'] == 'asset'
                          ? Image.asset(
                              goods['img'],
                              fit: BoxFit.fill,
                            )
                          : Image.network(
                              Application.IMG_URL + goods['img'],
                              fit: BoxFit.fill,
                            ),
                    )),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  child: Center(
                    child: Text(goods['name'], softWrap: false, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 14)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Expanded(
                        child: Text('￥${goods['minPrice']}',
                            softWrap: false, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12, color: Colors.red)),
                        flex: 1,
                      ),
                      Expanded(
                        child: Text('${goods['totalSales']}人付款',
                            softWrap: false, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 11, color: Colors.black54)),
                        flex: 1,
                      ),
                    ],
                  ),
                )
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
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 5, crossAxisSpacing: 10, childAspectRatio: 2 / 2.8),
        children: list,
      ),
    );
  }

  hotGoodsClick(goodsId) {
    print(goodsId);
  }
}
