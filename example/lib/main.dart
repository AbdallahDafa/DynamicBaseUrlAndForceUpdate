import 'package:dynamic_base_url_and_force_update/app_setting_dynamic/logic/app_setting_dynamic_installer.dart';
import 'package:dynamic_base_url_and_force_update/app_setting_dynamic/presentation/app_setting_dynamic_run_app.dart';
import 'package:dynamic_base_url_and_force_update/dynamic_base_url_and_force_update.dart';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';

void main() {

  AppSettingDynamicInstaller.setConfigBaseUrls(
    domainDefault: 'https://test4.maqsafy.com',
    firebaseBaseUrl: "https://maqsafy-egypt-default-rtdb.asia-southeast1.firebasedatabase.app",
  );

  runApp( AppSettingDynamicRunApp(
    currentVersionValidateForForceUpdate: 115,
    linkUpdateApplestore: "https://apps.apple.com/ag/app/%D9%85%D9%82%D8%B5%D9%81%D9%8A/id1493287507",
    linkUpdateGoogleplay:  "https://play.google.com/store/apps/details?id=com.maqsafy",
    onNeedUpdateDioHelperBaseUrl: (){
      /// (Optional In Case Use "DI" )update "di" dependant inject of baseurl
     // di.reRegisterDependentInjectionForDioHelper();
    },
    builder: (context)   {
      return MyApp();
    },
  ));
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _dynamicChnageBaseUrlAndForceUpdatePlugin = DynamicBaseUrlAndForceUpdate();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await _dynamicChnageBaseUrlAndForceUpdatePlugin.getPlatformVersion() ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on: $_platformVersion\n'),
        ),
      ),
    );
  }
}
