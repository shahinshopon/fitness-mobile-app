import 'package:flutter/foundation.dart';

class ApiKeys {
  static late String appID;
  static late String apiKey ;
  static String messagingSenderId = "987453190322";
  static String projectId = "fitness-mobile-app-de0be";
  static String storageBucket = "fitness-mobile-app-de0be.appspot.com";

  collectAppID() {
    if (defaultTargetPlatform == TargetPlatform.android) {
      appID = "1:987453190322:android:0d406d3b808dbf6da1d9ab";
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      appID = "1:987453190322:ios:2002fb5951adea4ca1d9ab";
    }
  }

  collectApiKey() {
    if (defaultTargetPlatform == TargetPlatform.android) {
      apiKey = "AIzaSyArQqBB8-xH5sgINHot0qRrK0hhthLnrcE";
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      apiKey = "AIzaSyBhe3foXQy86z1UZQZD3EP3dxMhHAqW0Ew";
    }
  }


}
