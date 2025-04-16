# Wildlife Guardian

A Flutter application for forest officers to monitor wildlife and forest activities.

## Getting Started

This application requires a Google Maps API key to display maps properly.

### Setting up Google Maps API Key

1. Go to the [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select an existing one
3. Enable the Google Maps Android API and Google Maps iOS SDK
4. Create an API key from the "Credentials" section
5. Restrict the API key to your Android and iOS applications

### Android Configuration

1. Open `android/app/src/main/AndroidManifest.xml`
2. Replace `YOUR_API_KEY_HERE` with your actual Google Maps API key:

```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_API_KEY_HERE" />
```

### iOS Configuration

1. Open `ios/Runner/AppDelegate.swift` (create it if it doesn't exist)
2. Add the following code:

```swift
import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("YOUR_API_KEY_HERE")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

## Features

- Wildlife tracking and reporting
- Illegal activity detection
- Offline maps for remote areas
- Target spot navigation
- Alerts for critical environmental events
- News feed for conservation updates
