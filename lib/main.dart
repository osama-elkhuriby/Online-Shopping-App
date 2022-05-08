
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:os_project/remoteNetwork/cacheHelper.dart';
import 'package:os_project/remoteNetwork/dioHelper.dart';
import 'package:os_project/shared/bloc_observer.dart';
import 'package:os_project/shared/constants.dart';
import 'package:os_project/shared/themes.dart';

import 'Layouts/shopLayout.dart';
import 'cubit/appCubit.dart';
import 'cubit/shopCubit.dart';
import 'cubit/states.dart';
import 'modules/LoginScreen.dart';
import 'modules/OnBoardingScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();


  Widget widget;

  bool ?isDark = CacheHelper.getData('isDark');
  bool? showOnBoard = CacheHelper.getData('ShowOnBoard');
  token = CacheHelper.getData('token');

  if(showOnBoard == false) {
    if (token != null)
      widget = ShopLayout();
    else
      widget = LoginScreen();
  }
  else
    widget = OnBoarding();
  runApp(MyApp(
    isDark: isDark,
    startWidget: widget,
  ));



}

class MyApp extends StatelessWidget {
  final bool? isDark;
  late final Widget startWidget;
  MyApp({this.isDark, required this.startWidget});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create:(context) =>AppCubit()),
          BlocProvider(create:(context)
          => ShopCubit()
            ..getHomeData()
            ..getCategoryData()
            ..getFavoriteData()
            ..getProfileData()
            ..getCartData()
            ..getAddresses()
          ),
        ],
        child: BlocConsumer<AppCubit,ShopStates>(
            listener:(context,state){},
            builder: (context,state) {
              AppCubit cubit = AppCubit.get(context);
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                home: startWidget,
                theme: lightMode(),
                darkTheme: darkMode(),
                themeMode: cubit.appMode,
              );
            }
        )
    );
  }
}