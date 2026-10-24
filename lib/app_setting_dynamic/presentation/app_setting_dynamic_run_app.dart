import 'package:dynamic_base_url_and_force_update/app_setting_dynamic/logic/app_setting_dynamic_notifier.dart';
import 'package:dynamic_base_url_and_force_update/app_setting_dynamic/presentation/app_setting_force_update_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

typedef OnNeedUpdateDioHelperBaseUrl = Function();

/// Provides [AppSettingDynamicNotifier] to the whole app
/// (`context.read<AppSettingDynamicNotifier>()` works under [builder])
/// and the force-update screen when the app version is too old.
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

  /// false (default): no download here, call
  /// `context.read<AppSettingDynamicNotifier>().download()` from your splash
  /// screen (or let `AppSettingForceUpdateChecker` start it in the home page).
  /// true: start downloading as soon as the app opens.
  final bool downloadOnStart;

  /// true (default): the whole app is replaced by the force-update screen
  /// as soon as it is needed (even on the splash screen).
  /// false: put `AppSettingForceUpdateChecker` inside your home page,
  /// the check happens there and the splash screen is never blocked.
  final bool checkForceUpdateOnRoot;

  /// true (default): the last downloaded setting saved on the device is used
  /// for the force-update check right away, even offline.
  /// false: only a download of this session can force update, so an
  /// offline-first app keeps working offline.
  final bool forceUpdateFromCache;


  const AppSettingDynamicRunApp( {
    super.key,
    required this.builder,
    this.downloadOnStart = false,
    this.checkForceUpdateOnRoot = true,
    this.forceUpdateFromCache = true,

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

    if (widget.downloadOnStart) {
      WidgetsBinding.instance.addPostFrameCallback( (t ) {
        _notifier.download(); // background: never throws / hangs
      });
    }
  }

  @override
  void didUpdateWidget(covariant AppSettingDynamicRunApp oldWidget) {
    super.didUpdateWidget(oldWidget);
    _forceUpdateConfig = _createForceUpdateConfig();
  }

  @override
  void dispose() {
    _notifier.removeListener(_onAppSettingChanged);
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
      fromCache: widget.forceUpdateFromCache,
    );
  }

  /// side effect only, the ui (force update) is rebuilt by the Selector in build()
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
        child: widget.checkForceUpdateOnRoot
            ? Selector<AppSettingDynamicNotifier, bool>(
                selector: (_, setting) => _forceUpdateConfig.isNeedForceUpdate(setting),
                builder: (context, isNeedForceUpdate, _) {
                  if( isNeedForceUpdate ) {
                    // may come from the cache and the splash screen won't run:
                    // refresh it here (closes this screen if no update needed)
                    WidgetsBinding.instance.addPostFrameCallback( (t ) {
                      _notifier.download(retryIfFailed: true);
                    });
                    return dialogForceUpdateFullScreenShape();
                  }
                  return widget.builder(context);
                },
              )
            : Builder(builder: widget.builder),
      ),
    );
  }



  Widget dialogForceUpdateFullScreenShape( ) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      home:  Scaffold(
      body: SizedBox.expand(
        child: ColoredBox(
          color:  const Color(0x99000000), //shadow
          child: AppSettingForceUpdateDialog(config: _forceUpdateConfig),
        ),
      ),
    ));
  }

}
