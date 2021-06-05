import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:verifi_mobile_firebase/services/safety/page_stateful.dart';
import 'package:verifi_mobile_firebase/utils/route_aware_analytics.dart';
class CrashPage extends StatefulWidget {
  @override
  _CrashPageState createState() => _CrashPageState();
}

class _CrashPageState extends PageStateful<CrashPage>  with WidgetsBindingObserver,RouteAwareAnalytics{

  @override
  void initDependencies(BuildContext context) {
    // TODO: implement initDependencies
    super.initDependencies(context);
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


  @override
  Widget build(BuildContext context) {

    super.build(context);
    return Scaffold(

      appBar: AppBar( title: Text("Test Crash "),),
      body: Container(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: Icon(Icons.add,color: Colors.white,size: 30,),
        onPressed: (){
          FirebaseCrashlytics.instance.crash();
        },

      ),

    );
  }

  @override
  // TODO: implement route
  AnalyticsRoute get route => AnalyticsRoute.example;
}
