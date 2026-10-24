import 'package:dynamic_base_url_and_force_update/app_setting_dynamic/logic/app_setting_dynamic_notifier.dart';
import 'package:dynamic_base_url_and_force_update/app_setting_dynamic/presentation/app_setting_force_update_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Required in your home page: the home page is where the app setting is
/// downloaded and force update is checked, so the splash screen never waits
/// for the network.
///
/// Put it inside the home page (under your `MaterialApp`), under
/// `AppSettingDynamicRunApp`:
/// ```dart
/// @override
/// Widget build(BuildContext context) {
///   return AppSettingForceUpdateChecker(
///     child: Scaffold(...),
///   );
/// }
/// ```
///
/// - checks right away with the cached setting (nothing to wait for)
/// - starts the download in background when the home page opens (or shares the
///   one the splash screen started), then checks again when it finishes
/// - tries again a failed download (app opened offline) when the app comes
///   back to the foreground
/// - shows the force-update dialog above all pages (back button can't close
///   it), and closes it by itself when the new download says no update needed
class AppSettingForceUpdateCheckerWidget extends StatefulWidget {
  const AppSettingForceUpdateCheckerWidget({super.key, required this.child});

  /// Your home page content.
  final Widget child;

  @override
  State<AppSettingForceUpdateCheckerWidget> createState() =>
      _AppSettingForceUpdateCheckerWidgetState();
}

class _AppSettingForceUpdateCheckerWidgetState extends State<AppSettingForceUpdateCheckerWidget>
    with WidgetsBindingObserver {
  /// Shared by all checkers: the dialog is never shown twice.
  static Route<void>? _dialogRoute;

  late final AppSettingDynamicNotifier _setting;

  @override
  void initState() {
    super.initState();
    _setting = context.read<AppSettingDynamicNotifier>();
    _setting.addListener(_check);
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _check(); // cached setting: available right away
      _setting.download(retryIfFailed: true); // background, never awaited
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // app opened offline: try again when the user comes back
    if (state == AppLifecycleState.resumed) {
      _setting.download(retryIfFailed: true);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _setting.removeListener(_check);
    super.dispose();
  }

  void _check() {
    if (!mounted) return;
    if (_dialogRoute?.isActive ?? false) return;

    final config = context.read<AppSettingForceUpdateConfig>();
    if (!config.isNeedForceUpdate(_setting)) return;

    final route = DialogRoute<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: const Color(0x99000000), // shadow
      builder: (_) => _AutoCloseForceUpdateDialog(setting: _setting, config: config),
    );
    _dialogRoute = route;
    Navigator.of(context, rootNavigator: true).push(route);
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

/// Content of the force-update dialog route: closes itself when the new
/// download (after the cached setting) says no update is needed.
class _AutoCloseForceUpdateDialog extends StatefulWidget {
  const _AutoCloseForceUpdateDialog({required this.setting, required this.config});

  final AppSettingDynamicNotifier setting;
  final AppSettingForceUpdateConfig config;

  @override
  State<_AutoCloseForceUpdateDialog> createState() => _AutoCloseForceUpdateDialogState();
}

class _AutoCloseForceUpdateDialogState extends State<_AutoCloseForceUpdateDialog> {
  @override
  void initState() {
    super.initState();
    widget.setting.addListener(_closeIfNotNeeded);
  }

  @override
  void dispose() {
    widget.setting.removeListener(_closeIfNotNeeded);
    super.dispose();
  }

  void _closeIfNotNeeded() {
    if (!mounted || widget.config.isNeedForceUpdate(widget.setting)) return;
    final route = ModalRoute.of(context);
    if (route == null || !route.isActive) return;
    widget.setting.removeListener(_closeIfNotNeeded); // close once
    if (route.isCurrent) {
      Navigator.of(context).pop(); // PopScope doesn't block a direct pop()
    } else {
      route.navigator?.removeRoute(route);
    }
  }

  @override
  Widget build(BuildContext context) => AppSettingForceUpdateDialog(config: widget.config);
}
