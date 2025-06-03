
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dynamic_chnage_base_url_and_force_update/app_setting_dynamic/data/app_setting_dynamic_response.dart';



/**
 * call back with result
 */
typedef AppSettingResultOnComplete = Function( AppSettingDynamicResponse? response );


/**
 * ----------------------- how to use
  1- inside main() :

    /// app setting dynamic
    ///   >>> get base url
    ///   >>> get min version to force update
    AppSettingDynamicController.setup(
    domainDefault: 'https://test4.maqsafy.com',
    firebaseBaseUrl: "https://maqsafy-egypt-default-rtdb.asia-southeast1.firebasedatabase.app",
    );

 2- in splash screen video


 */
class AppSettingDynamicInstaller {


  /**
   * exmaple
   *
   * String domainDefault = 'https://test4.maqsafy.com';
   */
  static  String? domainDefault;

  /**
   * example:
   *   // String firebaseBaseUrl = "https://maqsafy-egypt-default-rtdb.asia-southeast1.firebasedatabase.app";

   */
  static String? firebaseBaseUrl;

  static AppSettingResultOnComplete? onCompleteSplash;
  static AppSettingResultOnComplete? onCompleteRunApp;
  static bool  _isCompleteLoading = false;

  static AppSettingDynamicResponse? _response;


  ///------------------------------------------------------------------ public setup

  static  setConfigBaseUrls(   {
    required String domainDefault,
    required String firebaseBaseUrl,
  })  {
    print("setConfigUrls()");
    AppSettingDynamicInstaller.domainDefault = domainDefault;
    AppSettingDynamicInstaller.firebaseBaseUrl = firebaseBaseUrl;
  }


  static Future<AppSettingDynamicResponse?> download( )  async {
    await _downloadSettingData();
    return _response;
  }

  static Future addOnCompleteRunApp( AppSettingResultOnComplete  onComplete)  async {
    print("AppSettingResultOnComplete - addOnCompleteRunApp()");
    AppSettingDynamicInstaller.onCompleteRunApp = onComplete;

    if( isCompleteDownloadData() ) onComplete( _response);
  }

  static Future addOnCompleteSplash( AppSettingResultOnComplete  onComplete)  async {
    print("AppSettingResultOnComplete - addOnCompleteSplash()");
    AppSettingDynamicInstaller.onCompleteSplash = onComplete;

    if( isCompleteDownloadData() ) onComplete( _response);
  }

  ///-----------------------------------------------------------------  public methods utils

  static bool isCompleteDownloadData() =>   _isCompleteLoading;


  /// in case not valid, means it's need to forceUpdate
  static bool isValidVersionMinAllowed( int currentVersion )  {
    //check mobile
    if (Platform.isAndroid) {
      var minAllowed =     AppSettingDynamicInstaller._response?.minVersionAndroid??0;
      if( minAllowed == currentVersion ) return true;
      return  minAllowed <  currentVersion;
    } else if (Platform.isIOS) {
      var minAllowed =     AppSettingDynamicInstaller._response?.minVersionIos??0;
      if( minAllowed == currentVersion ) return true;
      return  minAllowed < currentVersion ;
    }
    return true;
  }

//-----------------------------------------------------------------------------  domains

  static String getDomain() {
    //print("AppSettingDynamicController - getDomain() - start ");
    if(AppSettingDynamicInstaller._response != null  ){
      var result = AppSettingDynamicInstaller._response?.baseUrlDynamic??domainDefault??"";
      //print("AppSettingDynamicController - getDomain() - result: $result");
      return result ;
    } else {
      //print("AppSettingDynamicController - getDomain() - domainDefault: $domainDefault");
      return domainDefault??"";
    }
  }

  ///--------------------------------------------------------------------- setup

  static _downloadSettingData() async {
    final dio = Dio();
    final responseDio = await dio.get('$firebaseBaseUrl/app_setting.json');
    // print('AppSettingDynamic -  _downloadSettingData() - json: ${responseDio.data}');
    _response = AppSettingDynamicResponse.fromJson(responseDio.data);
    _isCompleteLoading = true;
    print('AppSettingDynamic -  _downloadSettingData() - AppSettingDynamicResponse: ${_response}');
    if(onCompleteRunApp != null )onCompleteRunApp!(_response);
    if(onCompleteSplash != null )onCompleteSplash!(_response);
  }

}
