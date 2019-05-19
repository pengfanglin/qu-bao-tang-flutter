import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:qu_bao_tang/component/top.dart';
import 'package:qu_bao_tang/component/widgets.dart';
import 'package:qu_bao_tang/utils/api.dart';
import 'package:qu_bao_tang/utils/application.dart';
import 'package:qu_bao_tang/utils/toast_utils.dart';

EventBus eventBus;

class Goods extends StatefulWidget{
  final int id;

  Goods(this.id);

  createState()=>GoodsState();
}

class GoodsState extends State<Goods>{
  Map goods;
  Swiper swiper;

  @override
  void initState() {
    super.initState();
    eventBus=new EventBus();
    swiper=Swiper(
        itemCount: 1,
        itemBuilder: (context, index) {
          return Image.asset('res/images/loading.gif');
        });
    Api.post<dynamic>('goods/goodsDetail', params: {"id": widget.id}).then((data) {
      goods=data;
      setState(() {
        banner();
      });
    }, onError: (e) {
      ToastUtils.show(e.toString());
    });
  }
  @override
  void dispose() {
    super.dispose();
    eventBus.destroy();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Top(),
            Expanded(
              flex: 1,
              child: ListView(
                children: <Widget>[
                  Container(
                    color: Colors.red,
                      height: 300,
                      child: swiper
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }


  void banner(){
    List<String> bannerImages=goods['bannerImages'].toString().split(',');
    print(bannerImages);
    swiper=Swiper(
        itemBuilder: (context, index) {
          return ImgCache(Application.STATIC_URL + bannerImages[index]);
        },
        itemCount: bannerImages.length,
        pagination: SwiperPagination(builder: DotSwiperPaginationBuilder(color: Colors.white, activeColor: Colors.red)),
        scrollDirection: Axis.horizontal,
        autoplay: true,
        autoplayDelay: 2000);
  }
}