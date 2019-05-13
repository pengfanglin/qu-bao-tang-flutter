import 'package:flutter/material.dart';
import 'package:qu_bao_tang/utils/api.dart';
import 'package:qu_bao_tang/utils/application.dart';
import 'package:qu_bao_tang/utils/toast_utils.dart';

class Search extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: ListView(
          shrinkWrap: true,
          children: <Widget>[
            TopSearch(),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Text(
                  '搜索记录',
                  style: TextStyle(color: Colors.black),
                )),
            SearchHistory(),
            Container(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10), child: Text('热门搜索')),
            HotSearch()
          ],
        ));
  }
}

///搜索框
class TopSearch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      color: Application.themeColor,
      child: Container(
        height: 40,
        child: TextField(
          controller: controller,
          onChanged: (value) {},
          onSubmitted: (value) {},
          style: TextStyle(color: Colors.black54),
          decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              prefixIcon: Icon(Icons.search, color: Colors.black26),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none)),
        ),
      ),
    );
  }
}

///搜索记录
class SearchHistory extends StatefulWidget {
  createState() => SearchHistoryState();
}

class SearchHistoryState extends State<SearchHistory> {
  List<Widget> list = List<Widget>();

  @override
  void initState() {
    super.initState();
    Api.post<List<dynamic>>('user/userSearchHistoryList').then((searchHistoryList) {
      setState(() {
        list = List<Widget>();
        searchHistoryList.forEach((searchHistory) {
          list.add(GestureDetector(
            onTap: () {
              searchHistoryClick(searchHistory['id']);
            },
            child: Container(
                constraints: BoxConstraints(maxWidth: 150),
                decoration: BoxDecoration(
                  border: Border.all(color: Application.themeColor, width: 2),
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Text(searchHistory['content'],softWrap: false,
                    overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black54, fontSize: 16))),
          ));
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Wrap(spacing: 20, runSpacing: 10, children: list),
    );
  }
}

///热门搜索
class HotSearch extends StatefulWidget {
  createState() => HotSearchState();
}

class HotSearchState extends State<HotSearch> {
  List<Widget> list = List<Widget>();

  @override
  void initState() {
    super.initState();
    Api.post<List<dynamic>>('user/hostSearchList').then((hotSearchList) {
      setState(() {
        list = List<Widget>();
        hotSearchList.forEach((hotSearch) {
          list.add(GestureDetector(
            onTap: () {
              searchHistoryClick(hotSearch['id']);
            },
            child: Container(
                constraints: BoxConstraints(maxWidth: 150),
                decoration: BoxDecoration(
                  border: Border.all(color: Application.themeColor, width: 2),
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Text(
                  hotSearch['content'],
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.black54, fontSize: 16),
                )),
          ));
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Wrap(spacing: 20, runSpacing: 10, children: list),
    );
  }
}
