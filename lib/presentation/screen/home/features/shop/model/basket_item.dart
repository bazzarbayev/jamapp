import 'package:jam_app/presentation/screen/home/features/shop/model/shop_item.dart';

class BasketItem {
  ShopItem item;
  int count = 1;

  BasketItem({this.item, this.count = 1});
}
