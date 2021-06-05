import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:phone_number/phone_number.dart';
import 'package:tuple/tuple.dart';
import 'package:verifi_mobile_firebase/pages/login/login_provider.dart';
import 'package:verifi_mobile_firebase/services/app/app_dialog.dart';
import 'package:verifi_mobile_firebase/services/app/app_loading.dart';
import 'package:verifi_mobile_firebase/services/app/locale_provider.dart';
import 'package:verifi_mobile_firebase/services/safety/page_stateful.dart';
import 'package:logger/logger.dart';
import 'package:verifi_mobile_firebase/utils/app_route.dart';
import 'package:verifi_mobile_firebase/widgets/p_appbar_transparency.dart';
import 'package:verifi_mobile_firebase/widgets/w_input_form.dart';
import 'package:verifi_mobile_firebase/widgets/w_keyboard_dismiss.dart';
import 'package:verifi_mobile_firebase/utils/app_extension.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends PageStateful<LoginPage>
    with WidgetsBindingObserver {
  final FocusNode _phoneFocus = FocusNode();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final PhoneNumberUtil _phoneNumberUtil = PhoneNumberUtil();

  LoginProvider loginProvider;
  LocaleProvider localeProvider;

  @override
  void initDependencies(BuildContext context) {
    // TODO: implement initDependencies
    super.initDependencies(context);
    loginProvider = Provider.of(context, listen: false);
    localeProvider = Provider.of(context, listen: false);
  }

  @override
  void afterFirstBuild(BuildContext context) {
    // TODO: implement afterFirstBuild
    super.afterFirstBuild(context);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    /// Log app life cycle state
    logger.d(state);
  }

  void onPressLogin() async {
    // context.select(
    //         (LoginProvider provider) => provider.formValid)
    AppLoading.show(context);
    String phone = context.read<LoginProvider>().phoneValue;

    Locale locale= localeProvider.locale;
    final String defaultLocale = Platform.localeName;
    logger.d("defaultLocale ",defaultLocale);
    PhoneNumber phoneNumber = await PhoneNumberUtil().parse(phone,regionCode:"VN");


    // int a = 0;
    await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber.e164,
        verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
          print("verificationCompleted");
          AppLoading.hide(context);
        },
        verificationFailed:
            (FirebaseAuthException firebaseAuthException) async {
          print("verificationFailed");
          logger.d(firebaseAuthException.toString());
          AppLoading.hide(context);
          AppDialog.show(context, firebaseAuthException.message);
        },
        codeSent: (String verificationId, int resendingToken) async {
          print("codeSent");
          AppLoading.hide(context);



          Navigator.pushNamed(context, AppRoute.routeOPT,arguments: verificationId );
        },
        codeAutoRetrievalTimeout: (String verificationId) async {
          print("codeAutoRetrievalTimeout");
          AppLoading.hide(context);
        },
    timeout: Duration(seconds:120 ));
    // Navigator.pushNamed(context, AppRoute.routeOPT);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return PAppBarTransparency(
      child: WKeyboardDismiss(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.W),
          child: SingleChildScrollView(
            child: Column(
              children: [
                /// Logo
                Padding(
                  padding: EdgeInsets.only(top: 100.H, bottom: 50.H),
                  child: Container(width: 150, height: 150),
                ),

                /// Login form
                /// Email + password
                Selector<LoginProvider,Tuple2<bool,String>>(
                    builder: (_,Tuple2<bool,String> data, __) {

                      bool phoneValid=data.item1;
                      String phoneError=data.item2;
                      // logger.d("phoneValid ",phoneValid);
                      return WInputForm.phone(
                        labelText: context.strings.labelPhone,
                        onChanged: (text) {
                          // logger.d("text ",text);
                          // logger.d("localeProvider.locale.countryCode ",localeProvider.locale.countryCode);
                          loginProvider.onPhoneChangeToValidateForm(
                              context, text,_phoneNumberUtil,"VN");
                        },
                        errorText:
                        !phoneValid ? phoneError: null,
                        suffixIcon: !phoneValid
                            ? const Icon(
                          Icons.error,
                          color: Colors.red,
                        )
                            : null,
                        focusNode: _phoneFocus,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (text) {},
                      );
                    },
                    selector: (_, LoginProvider provider) =>
                     Tuple2( provider.phoneValid, provider.phoneError) ),

                SizedBox(height: 30.H),
                ElevatedButton(
                    onPressed: context.select((LoginProvider loginProvider) =>
                            loginProvider.formValid)
                        ? onPressLogin
                        : null,
                    child: Text(context.strings.btnLogin))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
