import 'package:dynamic_base_url_and_force_update/app_setting_dynamic/data/app_setting_force_update_config.dart';
import 'package:dynamic_base_url_and_force_update/app_setting_dynamic/logic/app_setting_dynamic_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

typedef OnNeedUpdateDioHelperBaseUrl = Function();

/// Provides [AppSettingDynamicNotifier] and the force-update settings to the
/// whole app (`context.read<AppSettingDynamicNotifier>()` works under [builder]).
///
/// Nothing is downloaded here and nothing blocks the app start:
/// the download starts only from screens: the splash screen (optional) and
/// the home page with `AppSettingForceUpdateChecker` (required), which also
/// checks force update.
class AppSettingDynamicRunApp extends StatefulWidget {

  final int currentVersionValidateForForceUpdate;
  final WidgetBuilder builder;

  /// Called only when the base url changes while the app is running
  /// (example: a new url downloaded from firebase), to re-create your
  /// dio helper / "di" with `AppSettingDynamicNotifier.instance.domain`.
  final OnNeedUpdateDioHelperBaseUrl onNeedUpdateDioHelperBaseUrl;


  final String linkUpdateApplestore;
  final String linkUpdateGoogleplay;
  final String? titleForceUpdate ;
  final String? messageForceUpdate;
  final String? buttonForceUpdate;


  const AppSettingDynamicRunApp( {
    super.key,
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

  final AppSettingDynamicNotifier _notifier = AppSettingDynamicNotifier.instance;
  late AppSettingForceUpdateConfig _forceUpdateConfig;

  /// the base url your dio helper / "di" was created with in main()
  late String _lastDomain;

  @override
  void initState() {
    super.initState();
    _forceUpdateConfig = _createForceUpdateConfig();
    _lastDomain = _notifier.domain;
    _notifier.addListener(_onAppSettingChanged);
  }

  @override
  void didUpdateWidget(covariant AppSettingDynamicRunApp oldWidget) {
    super.didUpdateWidget(oldWidget);
    _forceUpdateConfig = _createForceUpdateConfig();
  }

  @override
  void dispose() {
    // _notifier.removeListener(_onAppSettingChanged);
    super.dispose();
  }


  ///------------------------------------------------------------ logic

  AppSettingForceUpdateConfig _createForceUpdateConfig() {
    return AppSettingForceUpdateConfig(
      currentVersion: widget.currentVersionValidateForForceUpdate,
      linkUpdateApplestore: widget.linkUpdateApplestore,
      linkUpdateGoogleplay: widget.linkUpdateGoogleplay,
      title: widget.titleForceUpdate,
      message: widget.messageForceUpdate,
      button: widget.buttonForceUpdate,
    );
  }

  /// the dio helper is re-created only when the base url really changed
  void _onAppSettingChanged() {
    final domain = _notifier.domain;
    if (domain == _lastDomain) return;
    _lastDomain = domain;
    widget.onNeedUpdateDioHelperBaseUrl();
  }

  ///------------------------------------------------------------ ui

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppSettingDynamicNotifier>.value(
      value: _notifier,
      child: Provider<AppSettingForceUpdateConfig>.value(
        value: _forceUpdateConfig,
        child: Builder(builder: widget.builder),
      ),
    );
  }

}
