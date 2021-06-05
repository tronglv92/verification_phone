import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:verifi_mobile_firebase/utils/app_extension.dart';
import 'package:verifi_mobile_firebase/utils/app_theme.dart';

import 'package:verifi_mobile_firebase/utils/app_theme.dart';

import 'p_material.dart';

class PAppBarTransparency extends StatelessWidget {
  const PAppBarTransparency(
      {this.body, this.child, this.forceStatusIconLight, Key key})
      : super(key: key);

  final Widget child;
  final Widget body;
  final bool forceStatusIconLight;

  @override
  Widget build(BuildContext context) {
    final AppTheme theme = context.appTheme();
    final SystemUiOverlayStyle uiOverlayStyle = forceStatusIconLight == null
        ? (theme.isDark
        ? SystemUiOverlayStyle.dark
        : SystemUiOverlayStyle.light)
        : forceStatusIconLight == true
        ? SystemUiOverlayStyle.light
        : SystemUiOverlayStyle.dark;
    return PMaterial(
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: uiOverlayStyle.copyWith(statusBarColor: Colors.transparent),
        child: body ??
            Scaffold(
              backgroundColor: theme.backgroundColor ?? Colors.transparent,
              body: child,
            ),
      ),
    );
  }
}
