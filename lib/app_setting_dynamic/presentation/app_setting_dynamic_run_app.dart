import 'dart:io';

import 'package:dynamic_base_url_and_force_update/app_setting_dynamic/data/app_setting_dynamic_response.dart';
import 'package:dynamic_base_url_and_force_update/app_setting_dynamic/logic/app_setting_dynamic_installer.dart';
import 'package:dynamic_base_url_and_force_update/app_setting_dynamic/logic/intent_force_update.dart';
import 'package:flutter/material.dart';

typedef OnNeedUpdateDioHelperBaseUrl = Function();

class AppSettingDynamicRunApp  extends StatefulWidget {

  final int currentVersionValidateForForceUpdate;
  final WidgetBuilder builder;
  final OnNeedUpdateDioHelperBaseUrl onNeedUpdateDioHelperBaseUrl;


  String linkUpdateApplestore;
  String linkUpdateGoogleplay;
  String? titleForceUpdate ;
  String? messageForceUpdate;
  String? buttonForceUpdate;


  AppSettingDynamicRunApp( {
    required this.builder,

    /// feature:  base url dynamic
    required  this.currentVersionValidateForForceUpdate,
    required this.onNeedUpdateDioHelperBaseUrl,

    /// feature: force-update
    required this.linkUpdateApplestore,
    required this.linkUpdateGoogleplay,

    /// content dialog force-update
    this.titleForceUpdate ,
    this.messageForceUpdate,
    this.buttonForceUpdate

  });


  @override
  State<StatefulWidget> createState()  => _AppSettingDynamicRunAppState();

}

class _AppSettingDynamicRunAppState extends State<AppSettingDynamicRunApp> {

  AppSettingDynamicResponse? response;
  bool isValidNoNeedForceUpdate = true ;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback( (t ) async {

      await AppSettingDynamicInstaller.download();
      await AppSettingDynamicInstaller.addOnCompleteRunApp(   (res) async {
            this.response = res;
          widget.onNeedUpdateDioHelperBaseUrl();
            validateNeedToShowModeForceUpdate();
      } );
    });
  }


  ///------------------------------------------------------------ logic

  void _chooseDownloadLinkByPlatform() {
    //check mobile
    if (Platform.isAndroid) {
      IntentForceUpdate.openBrowser( context, widget.linkUpdateGoogleplay );

    } else if (Platform.isIOS) {
      IntentForceUpdate.openBrowser( context, widget.linkUpdateApplestore);
    } else {
      IntentForceUpdate.openBrowser( context, widget.linkUpdateGoogleplay);
    }
  }

  void validateNeedToShowModeForceUpdate() {
    if( response != null  ) {

      isValidNoNeedForceUpdate = AppSettingDynamicInstaller.isValidVersionMinAllowed(  widget.currentVersionValidateForForceUpdate );

      if( isValidNoNeedForceUpdate == false  ){
        setState(() {

        });
      }
    }
  }

  ///------------------------------------------------------------ ui

  @override
  Widget build(BuildContext context) {
    if( isValidNoNeedForceUpdate ) {
      return Builder(
        builder: (context) {
          final app = widget.builder(context);
          return app;
        },
      );
    } else {
      return dialogForceUpdateFullScreenShape();
    }
  }



  Widget dialogForceUpdateFullScreenShape( ) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      home:  Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color:  Color(0x99000000), //shadow
        child: _dialogUI(),
      ),
    ));
  }



  _dialogUI( ) {
    return WillPopScope(
      onWillPop: () async => false, // Prevent back button dismiss
      child: Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 40),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                /// icon
                SizedBox( height: 10,),
                Icon( Icons.update,  size: 180, color: Colors.black ,),
                SizedBox( height: 10,),

                /// info
                Text(widget.titleForceUpdate??'Force Update' ),
                SizedBox( height: 20,),
                Text(widget.messageForceUpdate??'Your Have Old Version, You need to update from store'),
                SizedBox( height: 40,),

                /// update btn
                TextButton(
                  onPressed: () async {

                    _chooseDownloadLinkByPlatform();

                  },
                  child: Text(widget.buttonForceUpdate??'Update'),
                ),
              ]),
        ),
      ),
    );
  }





}

