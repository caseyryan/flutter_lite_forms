Automatic unregistering removed fields
Async validators
Unified styling for all forms
Seamless working with native formatters and flutter_multi_formatter


iOS 
Starting with version 0.8.1 the iOS implementation uses PHPicker to pick (multiple) images on iOS 14 or higher. As a result of implementing PHPicker it becomes impossible to pick HEIC images on the iOS simulator in iOS 14+. This is a known issue. Please test this on a real device, or test with non-HEIC images until Apple solves this issue. 

Add the following keys to your Info.plist file, located in <project root>/ios/Runner/Info.plist:

```
<key>CFBundleDevelopmentRegion</key>
<string>$(DEVELOPMENT_LANGUAGE)</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>This is used to allow users to attach images</string>
<key>NSCameraUsageDescription</key>
<string>This is used to allow users to take pictures if they need to attach anything</string>
<key>NSMicrophoneUsageDescription</key>
<string>Microphone is required for a camera</string>
```

Android #
Starting with version 0.8.1 the Android implementation support to pick (multiple) images on Android 4.3 or higher.

No configuration required - the plugin should work out of the box. It is however highly recommended to prepare for Android killing the application when low on memory. How to prepare for this is discussed in the Handling MainActivity destruction on Android section.

It is no longer required to add `android:requestLegacyExternalStorage="true"`` as an attribute to the <application> tag in AndroidManifest.xml, as image_picker has been updated to make use of scoped storage.