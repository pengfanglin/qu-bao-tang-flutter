import 'package:my_flutter/utils/api.dart';
import 'package:my_flutter/utils/toast_utils.dart';
import 'model/system_account_model.dart';

main(){
  Api.post<SystemAccountModel>('goods/homeGoodsClassList')
      .then((systemAccount){
    print(systemAccount.username);
  },onError: (e){
        print(e.runtimeType);
        RequestErrorException exception=(e as RequestErrorException);
        ToastUtils.show('${exception.code},${exception.error}');
  });
}
