import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/widgets.dart';

// A Navigator observer that notifies RouteAwares of changes to state of their Route
final routeObserver = RouteObserver<PageRoute>();

mixin RouteAwareAnalytics<T extends StatefulWidget> on State<T>
implements RouteAware {
  AnalyticsRoute get route;

  @override
  void didChangeDependencies() {
    routeObserver.subscribe(this, ModalRoute.of(context));
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPop() {}

  @override
  void didPopNext() {
    // Called when the top route has been popped off,
    // and the current route shows up.
    _setCurrentScreen(route);
  }

  @override
  void didPush() {
    // Called when the current route has been pushed.
    _setCurrentScreen(route);
  }

  @override
  void didPushNext() {}

  Future<void> _setCurrentScreen(AnalyticsRoute analyticsRoute) {
    print('Setting current screen to $analyticsRoute');
    print("screenName(analyticsRoute) "+screenName(analyticsRoute));
    print("screenClass(analyticsRoute) "+screenClass(analyticsRoute));
    return FirebaseAnalytics().setCurrentScreen(
      screenName: screenName(analyticsRoute),
      screenClassOverride: screenClass(analyticsRoute),

    );
  }
}

enum AnalyticsRoute { example }

String screenClass(AnalyticsRoute route) {
  switch (route) {
    case AnalyticsRoute.example:
      return 'ExampleRoute';
  }
  throw ArgumentError.notNull('route');
}

String screenName(AnalyticsRoute route) {
  switch (route) {
    case AnalyticsRoute.example:
      return '/example';
  }
  throw ArgumentError.notNull('route');
}