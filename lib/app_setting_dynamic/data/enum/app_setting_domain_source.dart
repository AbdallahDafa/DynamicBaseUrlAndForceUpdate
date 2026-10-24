/// Where `AppSettingDynamicNotifier.domain` comes from right now.
enum AppSettingDomainSource {
  /// 1- downloaded from firebase in this session.
  remote,

  /// 2- last successful download, saved on the device.
  cache,

  /// 3- `domainDefault` passed to `setConfigBaseUrls()`.
  domainDefault,
}
