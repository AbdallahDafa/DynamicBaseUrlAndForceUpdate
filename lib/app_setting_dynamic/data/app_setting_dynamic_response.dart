

class AppSettingDynamicResponse {

  String? baseUrlDynamic;
  // String? linkUpdateApplestore;
  // String? linkUpdateGoogleplay;
  int? minVersionAndroid;
  int? minVersionIos;



  AppSettingDynamicResponse.fromJson(Map<String, dynamic> json) {
    baseUrlDynamic = json['base_url_dynamic'];
    // linkUpdateApplestore = json['link_update_applestore'];
    // linkUpdateGoogleplay = json['link_update_googleplay'];
    minVersionAndroid = json['min_version_android'];
    minVersionIos = json['min_version_ios'];

  }


}