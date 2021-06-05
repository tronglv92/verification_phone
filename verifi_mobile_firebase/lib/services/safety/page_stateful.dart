import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'base_stateful.dart';
import 'package:logger/logger.dart';

abstract class PageStateful<T extends StatefulWidget> extends BaseStateful<T> {
  // LocaleProvider localeProvider;
  // AuthProvider authProvider;
  var logger = Logger(
    printer: PrettyPrinter(),
  );

  @mustCallSuper
  @override
  void initDependencies(BuildContext context) {
    super.initDependencies(context);
    // localeProvider = Provider.of(context, listen: false);
    // authProvider = Provider.of(context, listen: false);
  }

// @override
// Future<int> onApiError(dynamic error) async {
//   final ApiErrorType errorType = parseApiErrorType(error);
//   if (errorType.message != null && errorType.message.isNotEmpty) {
//     await AppDialog.show(context, errorType.message, title: 'Error');
//   }
//   if (errorType.code == ApiErrorCode.unauthorized) {
//     await logout(context);
//     return 1;
//   }
//   return 0;
// }

// /// Logout function
// Future<void> logout(BuildContext context) async {
//   await apiCallSafety(
//     authProvider.logout,
//     onStart: () async {
//       AppLoading.show(context);
//     },
//     onFinally: () async {
//       AppLoading.hide(context);
//       context
//           .navigator()
//           ?.pushNamedAndRemoveUntil(AppRoute.routeRoot, (_) => false);
//     },
//     skipOnError: true,
//   );
// }
}
