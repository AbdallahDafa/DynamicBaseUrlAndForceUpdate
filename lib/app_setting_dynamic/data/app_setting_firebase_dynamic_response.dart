

class AppSettingFirebaseDynamicResponse {

  String? baseUrlDynamic;
  int? minVersionAndroid;
  int? minVersionIos;
  int? minVersionWeb;




  AppSettingFirebaseDynamicResponse.fromJson(Map<String, dynamic> json) {
    baseUrlDynamic = json['base_url_dynamic'];
    minVersionAndroid = json['min_version_android'];
    minVersionIos = json['min_version_ios'];
    minVersionWeb = json['min_version_web'];

  }

  /// Same keys as firebase, used to save the setting on the device (cache).
  Map<String, dynamic> toJson() => {
        'base_url_dynamic': baseUrlDynamic,
        'min_version_android': minVersionAndroid,
        'min_version_ios': minVersionIos,
        'min_version_web': minVersionWeb,
      };

  @override
  String toString() {
    return 'AppSettingDynamicResponse{baseUrlDynamic: $baseUrlDynamic, minVersionAndroid: $minVersionAndroid, minVersionIos: $minVersionIos, minVersionWeb: $minVersionWeb}';
  }

}