

import 'package:flutter/material.dart';
import 'package:verifi_mobile_firebase/utils/app_extension.dart';
import 'package:verifi_mobile_firebase/services/safety/page_stateful.dart';
import 'package:verifi_mobile_firebase/utils/app_route.dart';
import 'package:verifi_mobile_firebase/widgets/p_appbar_transparency.dart';
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends PageStateful<HomePage> with WidgetsBindingObserver{
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
        child: Icon(Icons.navigate_next,color: Colors.white,size: 30,),
        onPressed: (){
          Navigator.pushNamed(context, AppRoute.routeCrash);
        },

      ),
    );
  }
}
