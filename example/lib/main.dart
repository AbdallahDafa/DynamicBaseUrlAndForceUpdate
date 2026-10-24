import 'package:dynamic_base_url_and_force_update/app_setting_dynamic/logic/app_setting_dynamic_notifier.dart';
import 'package:dynamic_base_url_and_force_update/app_setting_dynamic/presentation/app_setting_dynamic_run_app.dart';
import 'package:dynamic_base_url_and_force_update/app_setting_dynamic/presentation/app_setting_force_update_checker.dart';
import 'package:dynamic_base_url_and_force_update/dynamic_base_url_and_force_update.dart';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

Future<void> main() async {

  /// loads the last setting saved on the device (local read, no network):
  /// the base url is ready before the first api call, even offline
  await AppSettingDynamicNotifier.instance.setConfigBaseUrls(
    domainDefault: 'https://test4.maqsafy.com',
    firebaseBaseUrl: "https://maqsafy-egypt-default-rtdb.asia-southeast1.firebasedatabase.app",
  );

  /// (Optional In Case Use "DI") init "di" here, after setConfigBaseUrls()
  // await di.init();

  runApp( AppSettingDynamicRunApp(
    currentVersionValidateForForceUpdate: 115,
    linkUpdateApplestore: "https://apps.apple.com/ag/app/%D9%85%D9%82%D8%B5%D9%81%D9%8A/id1493287507",
    linkUpdateGoogleplay:  "https://play.google.com/store/apps/details?id=com.maqsafy",
    onNeedUpdateDioHelperBaseUrl: (){
      /// (Optional In Case Use "DI" )update "di" dependant inject of baseurl
     // di.reRegisterDependentInjectionForDioHelper();
    },
    builder: (context)   {
      return const MyApp();
    },
  ));
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}


/// Never waits for the network: same splash time with fast, slow or no internet.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    /// optional: start the download early, DON'T await it
    /// (the home page shares the same request)
    context.read<AppSettingDynamicNotifier>().download();

    /// your splash animation / video time, nothing about the network
    _timer = Timer(const Duration(seconds: 2), _navigateToHome);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _navigateToHome() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: FlutterLogo(size: 120)),
    );
  }
}


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
    /// rebuilds when the app setting finishes downloading
    final appSetting = context.watch<AppSettingDynamicNotifier>();

    /// required: downloads the app setting (or shares the splash download)
    /// and checks force update here (cache first, then the download)
    return AppSettingForceUpdateCheckerWidget(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text(
            'Running on: $_platformVersion\n'
            'Download: ${appSetting.status.name}\n'
            'Base url: ${appSetting.domain}\n'
            'Base url from: ${appSetting.domainSource.name}\n',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
