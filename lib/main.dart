import 'package:camera/camera.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:jam_app/model/db/database_helper.dart';

import 'package:jam_app/model/local/pref.dart';
import 'package:jam_app/model/repo/shop_repository.dart';
import 'package:jam_app/model/repo/user_repository.dart';
import 'package:jam_app/presentation/custom_ui/hex_color.dart';
import 'package:jam_app/presentation/router.dart';
import 'package:jam_app/presentation/screen/auth/age_confirm/age_confirm_screen.dart';
import 'package:jam_app/presentation/screen/auth/confirm_code/confirm_code_page.dart';
import 'package:jam_app/presentation/screen/auth/register_name/register_name_page.dart';
import 'package:jam_app/presentation/screen/auth/registration/registration_page.dart';
import 'package:jam_app/presentation/screen/home/bottom_navigation.dart';
import 'package:jam_app/presentation/screen/home/features/history/history_bloc.dart';
import 'package:jam_app/presentation/screen/home/features/profile/bloc/city_bloc.dart';
import 'package:jam_app/presentation/screen/home/features/profile/bloc/profile_bloc.dart';
import 'package:jam_app/presentation/screen/home/features/scan/bloc/scan_bloc.dart';
import 'package:jam_app/presentation/screen/home/features/shop/bloc/counter_product.dart';
import 'package:jam_app/presentation/screen/home/features/shop/bloc/shop_bloc.dart';
import 'package:jam_app/presentation/screen/home/features/shop/detail/product_bloc.dart';

import 'package:jam_app/presentation/screen/splash/sc_splash.dart';
import 'package:jam_app/utils/my_const/COLOR_CONST.dart';
import 'package:jam_app/utils/styles.dart';
import 'package:jam_app/widgets/dialog.dart';

import 'app/app_config.dart';
import 'app/auth_bloc/authentication_bloc.dart';
import 'app/auth_bloc/authentication_event.dart';
import 'app/auth_bloc/authentication_state.dart';
import 'app/main_bloc/main_bloc.dart';

import 'package:flutter_localizations/flutter_localizations.dart';

List<CameraDescription> cameras;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  MyApp.initSystemDefault();
  cameras = await availableCameras();

  setupLocator();
  themeSetup();

  runApp(
    EasyLocalization(
      supportedLocales: [Locale('ru', 'RU'), Locale('kk', 'KZ')],
      path: 'assets/langs',
      saveLocale: true,
      child: AppConfig(
          appName: "Jameson Dev",
          debugTag: true,
          flavorName: "dev",
          initialRoute: AppRouter.REGISTER,
          child: MyApp.runWidget(),
          ),
    ),
  );
}

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();
  Future<dynamic> navigateTo(String routeName) {
    return navigatorKey.currentState.pushNamed(routeName);
  }
}

var locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => FirebaseMessaging());
}

void themeSetup() {
  //CHANGE DATE AND ID PROMO LOGO IN HOME PAGE
  var date = DateTime.now();
  var d1 = DateTime(2021, 9, 14);
  var d2 = DateTime(2021, 11, 1);

  if (d1.isBefore(date) && d2.isAfter(date)) {
    GREEN = HexColor("#7F6955");
    GREEN_DARKER = HexColor("#301E0E");
    backgroundImage = 'assets/images/back.jpg';
    backgroundImageHome = 'assets/images/first_back.jpg';
    logoImage = 'assets/images/logo.svg';
    coldBrew = true;
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final config = AppConfig.of(context);

    return MaterialApp(
      navigatorKey: locator<NavigationService>().navigatorKey,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        EasyLocalization.of(context).delegate,
      ],
      supportedLocales: EasyLocalization.of(context).supportedLocales,
      locale: EasyLocalization.of(context).locale,
      debugShowCheckedModeBanner: config.debugTag,
      theme: ThemeData(
        textTheme: textGlobalTheme,
        brightness: Brightness.light,
        primaryColor: COLOR_CONST.DEFAULT,
        // ignore: deprecated_member_use
        accentColor: COLOR_CONST.DEFAULT,
        hoverColor: GREEN,
        unselectedWidgetColor: COLOR_CONST.DEFAULT,
        fontFamily: 'jj2',
      ),
      onGenerateRoute: AppRouter.generateRoute,
      home: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(backgroundImage),
            fit: BoxFit.fill,
          ),
        ),
        child: BlocConsumer<AuthenticationBloc, AuthenticationState>(
          buildWhen: (previous, current) {
            if (current is ShowAlert) {
              return false;
            }
            if (current is ClearAuthState) {
              return false;
            }
            if (current is ShowAlertCityNotAvailable) {
              return false;
            }
            return true;
          },
          listener: (context, state) {
            if (state is ShowAlert) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return CustomDialogBox(
                      title: state.title,
                      descriptions: state.description,
                      text: state.text,
                      doIt: state.doIt,
                    );
                  });
            }
            if (state is ShowAlertCityNotAvailable) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return NoLoyaltyDialogBox(
                      title: state.title,
                      descriptions: state.description,
                      text: state.text,
                      cancel: state.cancel,
                      data: state.data,
                    );
                  });
            }
          },
          builder: (context, state) {
            if (state is Uninitialized) {
              return SplashScreen();
            } else if (state is ConfirmAgeState) {
              return AgeConfirmScreen();
            } else if (state is RegistrationState) {
              return RegistrationPage();
            } else if (state is CheckCodeState) {
              return ConfirmCodePage(state.phone, state.isNewUser);
            } else if (state is Authenticated) {
              return new BottomNavigation(isAuth: true);
            } else if (state is RegisterNameAuthState) {
              return RegisterNamePage(state.cities, state.phone);
            } else if (state is Unauthenticated) {
              return new BottomNavigation(isAuth: false);
            }

            return Container(
              child: Center(child: Text('Unhandle State ')),
            );
          },
        ),
      ),
    );
  }

  static Widget runWidget() {
    WidgetsFlutterBinding.ensureInitialized();
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.portraitDown,
    // ]);
    DatabaseHelper().initDb();
    Firebase.initializeApp();

    // PushNotificationsManager().init();

    final UserRepository userRepository = UserRepository(pref: LocalPref());
    final ShopRepository shopRepository = ShopRepository(pref: LocalPref());

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<UserRepository>(create: (context) => userRepository),
        RepositoryProvider<ShopRepository>(create: (context) => shopRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthenticationBloc(
              userRepository: userRepository,
            )..add(AppStarted()),
          ),
          BlocProvider(create: (context) => ProfileBloc(userRepository)),
          BlocProvider(create: (context) => CityBloc(userRepository)),
          BlocProvider(create: (context) => HistoryBloc(userRepository)),
          BlocProvider(create: (context) => ShopBloc(shopRepository)),
          BlocProvider(create: (context) => BasketBloc()),
          BlocProvider(create: (context) => ProductBloc(shopRepository)),
          BlocProvider(create: (context) => ScanBloc(shopRepository)),
          BlocProvider(create: (context) => CounterProductBloc()),
          BlocProvider(create: (context) => CounterBloc()),
          BlocProvider(create: (context) => CheckOutBloc(shopRepository)),
          BlocProvider(
              create: (context) => MainBloc(userRepository: userRepository)),
        ],
        child: MyApp(),
      ),
    );
  }

  static void initSystemDefault() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: COLOR_CONST.STATUS_BAR,
      ),
    );
  }
}
