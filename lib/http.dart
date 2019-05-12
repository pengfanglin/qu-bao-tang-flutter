import 'package:my_flutter/utils/api.dart';
import 'model/goods/home_goods_class_model.dart';
import 'model/system_account_model.dart';

main(){
  Api.post<SystemAccountModel>('goods/homeGoodsClassList')
      .then((systemAccount){
    print(systemAccount.username);
  },onError: (e){
        print(e.runtimeType);
        RequestErrorException exception=(e as RequestErrorException);
        print('${exception.code},${exception.error}');
  });
}
