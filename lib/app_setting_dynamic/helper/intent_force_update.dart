import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Opens the store page (Google Play / App Store) of the new version.
class IntentForceUpdate {
  /// Opens [link] in the browser.
  ///
  /// Throws when [link] doesn't start with "http" or can't be opened.
  static Future openBrowser(BuildContext context, String link) async {
    bool isValidHttp = link.startsWith("http");
    if (isValidHttp == false) {
      // PopupFailure.show(context, "invalid link to can open browser".tr() );
      throw 'invalid link download applestore or google play';
    }
    try {
      await launchUrl(Uri.parse(link), mode: LaunchMode.inAppBrowserView);
    } catch (e) {
      throw 'Could not open the link.';
    }
  }
}
