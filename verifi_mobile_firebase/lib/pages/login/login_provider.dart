import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:phone_number/phone_number.dart';
import 'package:tuple/tuple.dart';
import 'package:verifi_mobile_firebase/services/safety/change_notifier_safety.dart';
import 'package:verifi_mobile_firebase/utils/app_extension.dart';

class LoginProvider extends ChangeNotifierSafety {
  LoginProvider();

  ///#region PRIVATE PROPERTIES
  /// -----------------
  /// Store  value

  String _phoneValue;

  /// Flag to check email is valid or not
  bool _phoneValid = false;
  String _phoneError;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get phoneValue => _phoneValue;

  String get phoneError => _phoneError;

  bool get phoneValid => _phoneValid;

  ///#endregion
  ///#region METHODS
  /// -----------------
  /// Reset state
  @override
  void resetState() {
    _phoneValid = false;
    _phoneError = '';
    notifyListeners();
  }

  Future<Tuple2<bool, String>> checkValidPhone(
      final BuildContext context, final String phone,PhoneNumberUtil phoneNumberUtil,String regionCode) async{
    String phoneError="";
    bool phoneValid = true;
    if (phone.isEmpty == true) {
      phoneError = context.strings.phoneEmpty;
      phoneValid = false;
      return Tuple2(phoneValid, phoneError);
    }

    bool isValid=await phoneNumberUtil.validate(phone, regionCode);
    if(isValid==false)
      {
        phoneError = context.strings.phoneNotValid;
        phoneValid = false;
        return Tuple2(phoneValid, phoneError);
      }
    return Tuple2(phoneValid, phoneError);
  }

  /// On email input change listener to validate form
  void onPhoneChangeToValidateForm(
      final BuildContext context, final String phone,PhoneNumberUtil phoneNumberUtil,String regionCode) async {
    // List<RegionInfo> regions = await _phoneNumberUtil.allSupportedRegions();

    _phoneValue = phone;

    Tuple2<bool, String> data =await checkValidPhone(context, phone,phoneNumberUtil,regionCode);
    _phoneValid=data.item1;
    _phoneError=data.item2;
    notifyListeners();
    // emailValid = _phoneNumberUtil.validate(_emailValue,);
  }

  // void verifyPhoneNumber() async{
  //
  //
  //
  //   _auth.verifyPhoneNumber(phoneNumber: _phoneValue, verificationCompleted: verificationCompleted, verificationFailed: verificationFailed, codeSent: codeSent, codeAutoRetrievalTimeout: codeAutoRetrievalTimeout)
  // }

  bool get formValid => _phoneValid == true;

  ///#endregion
}
