import 'dart:convert';


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:tuple/tuple.dart';
import 'package:verifi_mobile_firebase/services/safety/change_notifier_safety.dart';
import 'package:verifi_mobile_firebase/utils/app_extension.dart';

class OptProvider extends ChangeNotifierSafety {

  OptProvider();

  ///#region PRIVATE PROPERTIES
  /// -----------------
  /// Store  value


  String _optValue;
  /// Flag to check email is valid or not
  bool _optValid = false;
  String _optError;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get optValue=>_optValue;
  bool get optValid=>_optValid;
  String get optError=>_optError;
  ///#endregion
  ///#region METHODS
  /// -----------------
  /// Reset state
  @override
  void resetState() {
    _optValid=false;
    _optError='';
    notifyListeners();
  }

  Tuple2<bool, String> checkValidOPT(
      final BuildContext context, final String opt) {
    String optError="";
    bool optValid = true;
    if (opt.isEmpty == true) {
      optError = context.strings.phoneEmpty;
      optValid = false;
      return Tuple2(optValid, optError);
    }


    return Tuple2(optValid, optError);
  }

  /// On email input change listener to validate form
  void onOPTChangeToValidateForm(final BuildContext context,final String opt) async{
    // List<RegionInfo> regions = await _phoneNumberUtil.allSupportedRegions();

    _optValue=opt;
    Tuple2<bool, String>data= checkValidOPT(context, opt);


    _optValid=data.item1;
    _optError=data.item2;
    notifyListeners();
    // emailValid = _phoneNumberUtil.validate(_emailValue,);


  }


  // void verifyPhoneNumber() async{
  //
  //
  //
  //   _auth.verifyPhoneNumber(phoneNumber: _phoneValue, verificationCompleted: verificationCompleted, verificationFailed: verificationFailed, codeSent: codeSent, codeAutoRetrievalTimeout: codeAutoRetrievalTimeout)
  // }

  bool get formValid=>_optValid==true;




///#endregion
}