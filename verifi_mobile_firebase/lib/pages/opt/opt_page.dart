import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:tuple/tuple.dart';
import 'package:verifi_mobile_firebase/pages/opt/opt_provider.dart';
import 'package:verifi_mobile_firebase/services/app/app_dialog.dart';
import 'package:verifi_mobile_firebase/services/app/app_loading.dart';
import 'package:verifi_mobile_firebase/services/safety/page_stateful.dart';
import 'package:verifi_mobile_firebase/utils/app_route.dart';
import 'package:verifi_mobile_firebase/widgets/p_appbar_transparency.dart';
import 'package:verifi_mobile_firebase/widgets/w_input_form.dart';
import 'package:verifi_mobile_firebase/widgets/w_keyboard_dismiss.dart';
import 'package:verifi_mobile_firebase/utils/app_extension.dart';

class OptPage extends StatefulWidget {
  final String verificationId;

  OptPage({this.verificationId});

  @override
  _OptPageState createState() => _OptPageState();
}

class _OptPageState extends PageStateful<OptPage> with WidgetsBindingObserver,CodeAutoFill {
  final FocusNode _otpFocus = FocusNode();
  OptProvider _optProvider;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  TextEditingController _optController=new TextEditingController();


  /// end fill sms

  @override
  void initDependencies(BuildContext context) {
    // TODO: implement initDependencies
    super.initDependencies(context);
    _optProvider = Provider.of<OptProvider>(context, listen: false);
  }

  @override
  void afterFirstBuild(BuildContext context) {
    // TODO: implement afterFirstBuild

    super.afterFirstBuild(context);
    listenForCode();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listenForCode();

    SmsAutoFill().getAppSignature.then((signature) {

    });
  }

  @override
  void codeUpdated() {
    // TODO: implement codeUpdated
    logger.d("code ",code);
    _optController.text=code;
    _optProvider.onOPTChangeToValidateForm(context, code);
  }
  @override
  void dispose() {
    // TODO: implement dispose


    super.dispose();
    cancel();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    /// Log app life cycle state
    logger.d(state);
  }

  void onPressOPT() async {
    String opt = context.read<OptProvider>().optValue;
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId, smsCode: opt);
    signInWithPhoneAuthCredential(phoneAuthCredential);
  }

  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    AppLoading.show(context);

    try {
      final authCredential =
          await _auth.signInWithCredential(phoneAuthCredential);

      AppLoading.hide(context);

      if (authCredential?.user != null) {
        Navigator.pushNamedAndRemoveUntil(
            context, AppRoute.routeHome, (Route<dynamic> route) => false);
      }
    } on FirebaseAuthException catch (e) {
      AppLoading.hide(context);
      AppDialog.show(context, e.message);
    }
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

                Selector<OptProvider, Tuple2<bool, String>>(
                    builder: (_, Tuple2<bool, String> data, __) {
                      bool optValid = data.item1;
                      String optError = data.item2;

                      // logger.d("phoneValid ",phoneValid);
                      return WInputForm.number(
                        labelText: context.strings.labelOPT,
                        controller: _optController,

                        onChanged: (text) {
                          _optProvider.onOPTChangeToValidateForm(context, text);
                        },
                        errorText: !optValid ? optError : null,
                        suffixIcon: !optValid
                            ? const Icon(
                                Icons.error,
                          color: Colors.red,
                              )
                            : null,
                        focusNode: _otpFocus,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (text) {
                          onPressOPT();
                        },
                      );
                    },
                    selector: (_, OptProvider provider) =>
                        Tuple2(provider.optValid, provider.optError)),

                SizedBox(height: 30.H),
                ElevatedButton(
                    onPressed: context.select(
                            (OptProvider optProvider) => optProvider.formValid)
                        ? onPressOPT
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
