import 'package:qu_bao_tang/utils/api.dart';

main(){
  Api.post<List<dynamic>>('others/homeBannerList').then((bannerList) {
    print(bannerList.length);
  }, onError: (e) {
    String content;
    if(e is NoSuchMethodError){
      content=(e as NoSuchMethodError).toString();
    }else if(e is RequestErrorException){
      RequestErrorException exception = (e as RequestErrorException);
      content='${exception.code},${exception.error}';
    }else{
      content=e.toString();
    }
    print(content);
  });
}
