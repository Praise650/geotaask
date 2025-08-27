import 'dart:io';

import 'package:url_launcher/url_launcher.dart';

// callDriver(phoneNumber) async {
//   final call = Uri.parse('tel: $phoneNumber');
//   if (await canLaunchUrl(call)) {
//   launchUrl(call);
//   } else {
//   throw 'Could not launch $call';
//   }
// }

Future<void> launchURL(String url) async {
  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url));
  } else {
    throw 'Could not launch $url';
  }
}

Future<void> launchPhoneDialer(String contactNumber) async {
  final Uri phoneUri = Uri(scheme: "tel", path: contactNumber);
  try {
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  } catch (error) {
    // AppResponse.showError("Cannot Dial");
    throw ("Cannot dial");
  }
}

Future<void> sendEmail() async {
  final Uri emailLaunchUri = Uri(
    scheme: 'mailto',
    path: 'support@enviablelogistics.com',
    queryParameters: {'subject': '', 'body': ''},
  );
  try {
    if (await canLaunchUrl(emailLaunchUri)) {
      launchUrl(emailLaunchUri);
    }
  } catch (error) {
    // AppResponse.showError("Cannot Dial");
    throw ("Cannot dial");
  }
}


Future<void> openAppStore() async {
  try {
    if (Platform.isAndroid) {
      await _openPlayStore();
    } else if (Platform.isIOS) {
      await _openAppStore();
    } else {
      // AppResponse.showError("Platform not supported");
      throw ("Platform not supported");
    }
  } catch (error) {
    // AppResponse.showError("Cannot open app store: $error");
    throw ("Cannot open app store: $error");
  }
}

Future<void> _openPlayStore() async {
  try {
    // Replace 'com.your.package' with your app's package name
    await launchUrl(Uri.parse('market://details?id=com.quickconnect.quickconnect'));
  } catch (error) {
    try {
      // Fallback to browser if Play Store app is not installed
      await launchUrl(Uri.parse('https://play.google.com/store/apps/details?id=com.quickconnect.quickconnect'));
    } catch (fallbackError) {
      // AppResponse.showError("Cannot open Play Store");
      throw ("Cannot open Play Store");
    }
  }
}

Future<void> _openAppStore() async {
  try {
    // Replace '123456789' with your app's App Store ID
    await launchUrl(Uri.parse('itms-apps://itunes.apple.com/app/id123456789'));
  } catch (error) {
    try {
      // Fallback to browser if App Store app is not installed
      await launchUrl(Uri.parse('https://apps.apple.com/app/id123456789'));
    } catch (fallbackError) {
      // AppResponse.showError("Cannot open App Store");
      throw ("Cannot open App Store");
    }
  }
}

// Alternative method with more specific parameters
Future<void> openAppStoreWithDetails({
  String? androidPackageName,
  String? iosAppId,
}) async {
  try {
    if (Platform.isAndroid && androidPackageName != null) {
      await _openPlayStoreWithPackage(androidPackageName);
    } else if (Platform.isIOS && iosAppId != null) {
      await _openAppStoreWithId(iosAppId);
    } else {
      // AppResponse.showError("Platform not supported or missing parameters");
      throw ("Platform not supported or missing parameters");
    }
  } catch (error) {
    // AppResponse.showError("Cannot open app store: $error");
    throw ("Cannot open app store: $error");
  }
}

Future<void> _openPlayStoreWithPackage(String packageName) async {
  try {
    await launchUrl(Uri.parse('market://details?id=$packageName'));
  } catch (error) {
    try {
      await launchUrl(Uri.parse('https://play.google.com/store/apps/details?id=$packageName'));
    } catch (fallbackError) {
      throw ("Cannot open Play Store");
    }
  }
}

Future<void> _openAppStoreWithId(String appId) async {
  try {
    await launchUrl(Uri.parse('itms-apps://itunes.apple.com/app/id$appId'));
  } catch (error) {
    try {
      await launchUrl(Uri.parse('https://apps.apple.com/app/id$appId'));
    } catch (fallbackError) {
      throw ("Cannot open App Store");
    }
  }
}
