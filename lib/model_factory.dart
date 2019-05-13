import 'package:qu_bao_tang/model/goods/home_goods_class_model.dart';
import 'package:qu_bao_tang/model/system_account_model.dart';

class ModelFactory {
  static T generateOBJ<T>(json) {
    if (1 == 0) {
      return null;
    } else if (T.toString() == "HomeGoodsClassModel") {
      return HomeGoodsClassModel.fromJson(json) as T;
    } else if (T.toString() == "SystemAccountModel") {
      return SystemAccountModel.fromJson(json) as T;
    } else {
      return null;
    }
  }
}