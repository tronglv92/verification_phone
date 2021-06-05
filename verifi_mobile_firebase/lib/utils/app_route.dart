import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:verifi_mobile_firebase/pages/crash_test/crash_page.dart';
import 'package:verifi_mobile_firebase/pages/home/home_page.dart';
import 'package:verifi_mobile_firebase/pages/login/login_page.dart';
import 'package:verifi_mobile_firebase/pages/login/login_provider.dart';
import 'package:verifi_mobile_firebase/pages/opt/opt_page.dart';
import 'package:verifi_mobile_firebase/pages/opt/opt_provider.dart';

class AppRoute {
  factory AppRoute() => _instance;

  AppRoute._private();

  ///#region ROUTE NAMES
  /// -----------------
  static const String routeRoot = '/';
  static const String routeHome = '/home_page';
  static const String routeLogin = '/login_page';
  static const String routeOPT = '/opt_page';
  static const String routeCrash = '/crash_page';
  ///#endregion
  static final AppRoute _instance = AppRoute._private();

  static AppRoute get I => _instance;

  /// Create local provider
  // MaterialPageRoute<dynamic>(
  //             settings: settings,
  //             builder: (_) => AppRoute.createProvider(
  //                 (_) => HomeProvider(),
  //                 HomePage(
  //                   status: settings.arguments as bool,
  //                 )))
  static Widget createProvider<P extends ChangeNotifier>(
    P Function(BuildContext context) provider,
    Widget child,
  ) {
    return ChangeNotifierProvider<P>(
      create: provider,
      builder: (_, __) {
        return child;
      },
    );
  }

  /// Create multi local provider
  // MaterialPageRoute<dynamic>(
  //             settings: settings,
  //             builder: (_) => AppRoute.createProviders(
  //                 <SingleChildWidget>[
  //                     ChangeNotifierProvider<HomeProvider>(
  //                         create: (BuildContext context) => HomeProvider()),
  //                 ],
  //                 HomePage(
  //                   status: settings.arguments as bool,
  //                 )))
  static Widget createProviders(
    List<SingleChildWidget> providers,
    Widget child,
  ) {
    return MultiProvider(
      providers: providers ?? <SingleChildWidget>[],
      child: child,
    );
  }

  /// App route observer
  final RouteObserver<Route<dynamic>> routeObserver =
      RouteObserver<Route<dynamic>>();

  /// App global navigator key
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// Get app context
  BuildContext get appContext => navigatorKey.currentContext;

  /// Generate route for app here
  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case routeRoot:
        return MaterialPageRoute<dynamic>(
            settings: settings,
            builder: (_) => AppRoute.createProvider(
                  (_) => LoginProvider(),
              LoginPage(),
            ));

      case routeLogin:
        return MaterialPageRoute<dynamic>(
            settings: settings,
            builder: (_) => AppRoute.createProvider(
                  (_) => LoginProvider(),
                  LoginPage(),
                ));
      case routeOPT:
        String verificationId = settings.arguments;

        return MaterialPageRoute<dynamic>(
            settings: settings,
            builder: (_) => AppRoute.createProvider(
                  (_) => OptProvider(),
                  OptPage(verificationId: verificationId),
                ));
      case routeHome:
        return MaterialPageRoute<dynamic>(
            settings: settings, builder: (_) => HomePage());
      case routeCrash:
        return MaterialPageRoute<dynamic>(
            settings: settings, builder: (_) => CrashPage());
      default:
        return null;
    }
  }
}
