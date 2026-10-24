/// State of downloading the app setting from firebase.
enum AppSettingDynamicStatus {
  /// `download()` not called yet.
  initial,

  /// Request in progress.
  loading,

  /// Downloaded: dynamic base url + min versions are available (and cached).
  loaded,

  /// No internet / timeout / bad data: the app keeps working with the
  /// cached setting, or `domainDefault` when nothing is cached.
  failed,
}
