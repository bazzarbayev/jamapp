import 'dart:async';
import 'package:jam_app/presentation/screen/home/features/shop/model/basket_item.dart';
import 'package:jam_app/presentation/screen/home/features/shop/model/shop_item.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:jam_app/utils/my_formatter.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;

  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    var databasesPath = await getDatabasesPath();
    String path = p.join(databasesPath, "main.db");
    var ourDb = await openDatabase(path,
        version: 4,
        onCreate: _onCreate); //added markAmount to table checklist_marks
    return ourDb;
  }

  void _onCreate(Database db, int version) async {
    await db.execute("""
    create table basket
(
    id            INTEGER primary key AUTOINCREMENT NOT NULL,
    fk_id INTEGER,
    main_image          varchar(255),
    price_in_points          varchar(255),
    name_ru        varchar(255),
    options     varchar(255),
    name_kz varchar(255),
    uuid        varchar(255)    not null
);    
    """);
  }

  //insertion
  Future<int> addShopItem(ShopItem item) async {
    var dbClient = await db;
    int res = await dbClient.insert("basket", item.toLocalJson());
    return res;
  }

  Future<List<BasketItem>> getAllBasket() async {
    var dbClient = await db;
    List<Map<String, dynamic>> response =
        await dbClient.query("basket", orderBy: 'fk_id DESC', whereArgs: []);

    var group = response.groupBy((m) => m['fk_id']);

    List<BasketItem> baskets = [];

    print("good" + group.toString());

    group.forEach((key, value) {
      if (value.isNotEmpty) {
        var item = ShopItem.fromLocalJson(value.first);
        baskets.add(BasketItem(item: item, count: value.length));
      }
    });

    return baskets;
  }

  Future<List<BasketItem>> getAllCheckOutBasket() async {
    var dbClient = await db;
    List<Map<String, dynamic>> response =
        await dbClient.query("basket", orderBy: 'fk_id DESC', whereArgs: []);

    var group = response.groupBy((m) => m['fk_id']);

    List<BasketItem> baskets = [];

    print("check out || " + group.toString());

    group.forEach((key, value) {
      var indexWithOption = -1;
      var i = -1;

      if (value.isNotEmpty) {
        value.forEach((element) {
          ++i;
          var item = ShopItem.fromLocalJson(element);
          if (item.options.isNotEmpty) {
            indexWithOption = i;
          }
        });

        if (indexWithOption == -1) {
          var item = ShopItem.fromLocalJson(value.first);
          baskets.add(BasketItem(item: item, count: value.length));
        } else {
          var item = ShopItem.fromLocalJson(value[indexWithOption]);
          baskets.add(BasketItem(item: item, count: value.length));
        }
      }
    });

    return baskets;
  }

  Future<int> removeItem(int id) async {
    var dbClient = await db;
    return await dbClient.delete("basket", where: 'id = ?', whereArgs: [id]);
  }

  Future<int> removeAll() async {
    var dbClient = await db;
    await dbClient.delete("basket");
    return 1;
  }

  // Future<int> removeWholePosition(int id) async {
  //   var dbClient = await db;
  //   return await dbClient.rawDelete('DELETE FROM basket WHERE fk_id = ?', ['another name']);
  // }

  Future<int> getSizeBasket() async {
    var dbClient = await db;

    var count = Sqflite.firstIntValue(
        await dbClient.rawQuery('SELECT COUNT(*) FROM basket'));
    return count;
  }

  Future<List<ShopItem>> getAll() async {
    var dbClient = await db;
    List<Map<String, dynamic>> response =
        await dbClient.query("basket", orderBy: 'id DESC', whereArgs: []);

    return response.map((e) => ShopItem.fromLocalJson(e)).toList();
  }

  Future<List<ShopItem>> getAllWithID(String id) async {
    var dbClient = await db;
    List<Map<String, dynamic>> response = await dbClient.query("basket",
        orderBy: 'id DESC', where: 'fk_id = ?', whereArgs: [id]);

    return response.map((e) => ShopItem.fromLocalJson(e)).toList();
  }
}
