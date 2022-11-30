import 'package:jam_app/model/api/response/city_response.dart';
import 'package:jam_app/model/api/response/home_response.dart';
import 'package:jam_app/model/api/response/response_message.dart';
import 'package:jam_app/model/entity/history.dart';
import 'package:jam_app/model/entity/history_order.dart';
import 'package:jam_app/model/entity/sales_department.dart';
import 'package:jam_app/model/entity/user.dart';
import 'package:jam_app/presentation/screen/home/features/shop/model/product_item.dart';
import 'package:jam_app/presentation/screen/home/features/shop/model/shop_item.dart';
import 'package:jam_app/utils/const.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'rest_client.g.dart';

@RestApi(baseUrl: API_SETTINGS.BASE_URL)
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @GET("/home.json")
  Future<HomeResponse> getHomeData();

  @POST("register")
  @FormUrlEncoded()
  Future<MessageResponse> postRegisterPhone(@Field("phone") String phone);

  @POST("check")
  @FormUrlEncoded()
  Future<MessageResponse> postCheckCode(
    @Field("phone") String phone,
    @Field("code") String code,
  );

  @POST("saveDeviceToken")
  @FormUrlEncoded()
  Future<MessageResponse> postSaveToken({
    @Field("phone") String phone,
    @Field("token") String token,
  });

  @GET("citiesList")
  Future<List<CityResponse>> getCities();

  @POST("userUpdate")
  @FormUrlEncoded()
  Future<MessageResponse> userUpdate(
      {@Field("phone") String phone,
      @Field("loyal") String loyalty,
      @Field("name") String name,
      @Field("instagram") String instagram,
      @Field("facebook") String facebook,
      @Field("city") String city});

  @GET("profile")
  Future<User> getProfile(
    @Query("phone") String phone,
  );

  @GET("salesdeparments")
  Future<List<SalesDepartment>> getSalesDepartments();

  @GET("checkForUpdate")
  Future<MessageResponse> checkForBonus(
    @Query("phone") String phone,
  );

  @GET("history_order")
  Future<List<HistoryOrder>> getMyOrders(
    @Query("phone") String phone,
  );

  @GET("history_order/{id}")
  Future<HistoryOrder> getMyOrder(
    @Path("id") int id,
    @Query("phone") String phone,
  );

  @GET("history")
  Future<List<History>> getAllHistory(@Query("phone") String phone,
      {@Query("language") String lang});

  @POST("userUpdate")
  Future<User> userUpdateFull(@Body() User user);

  //START SHOP
  @GET("catalog-list")
  Future<List<ShopItem>> getCatalogList();

  @GET("catalog-list")
  Future<List<ShopItem>> getCatalogListFilter({
    @Query("filter") String type,
    @Query("price") String order,
  });

  @GET("catalog-list/{id}")
  Future<List<ProductItem>> getCatalogWithID(
    @Path("id") int id,
  );

  @POST("order")
  @FormUrlEncoded()
  Future<MessageResponse> doOrder(@Body() Map map);

  @GET("storeCheck")
  Future<MessageResponse> saveCheck(
      @Query("id") String id, @Query("uuid") String uuid,
      {@Query("platform") String platform});

  //  @POST("apmCheck")
  //  @MultiPart()
  // Future<MessageResponse> sendPhotos(@Field("phone") String phone, @Part(contentType:'application/json')  );
}
