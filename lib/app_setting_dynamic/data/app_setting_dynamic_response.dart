

class AppSettingDynamicResponse {

  String? baseUrlDynamic;
  int? minVersionAndroid;
  int? minVersionIos;



  AppSettingDynamicResponse.fromJson(Map<String, dynamic> json) {
    baseUrlDynamic = json['base_url_dynamic'];
    minVersionAndroid = json['min_version_android'];
    minVersionIos = json['min_version_ios'];

  }

  @override
  String toString() {
    return 'AppSettingDynamicResponse{baseUrlDynamic: $baseUrlDynamic, minVersionAndroid: $minVersionAndroid, minVersionIos: $minVersionIos}';
  }

}