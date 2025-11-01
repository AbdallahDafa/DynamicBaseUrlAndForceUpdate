

class AppSettingDynamicResponse {

  String? baseUrlDynamic;
  int? minVersionAndroid;
  int? minVersionIos;
  int? minVersionWeb;




  AppSettingDynamicResponse.fromJson(Map<String, dynamic> json) {
    baseUrlDynamic = json['base_url_dynamic'];
    minVersionAndroid = json['min_version_android'];
    minVersionIos = json['min_version_ios'];
    minVersionWeb = json['min_version_web'];

  }

  @override
  String toString() {
    return 'AppSettingDynamicResponse{baseUrlDynamic: $baseUrlDynamic, minVersionAndroid: $minVersionAndroid, minVersionIos: $minVersionIos, minVersionWeb: $minVersionWeb}';
  }

}