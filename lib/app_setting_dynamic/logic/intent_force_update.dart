import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class IntentForceUpdate {


  static Future  openBrowser(BuildContext context, String link) async {
    bool isValidHttp = link.startsWith("http");
    if (isValidHttp == false) {
      // PopupFailure.show(context, "invalid link to can open browser".tr() );
      throw 'invalid link download applestore or google play';
      return;
    }
    try {
      await launchUrl(Uri.parse(link), mode: LaunchMode.inAppBrowserView);
    } catch (e) {
      throw 'Could not open the link.';
    }
  }
}