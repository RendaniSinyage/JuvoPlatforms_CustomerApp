# Juvo Customer app 

Juvo is a multi store marketplace.

## Requirements
*  Flutter SDK setup (version 3.24.0 Stable)
*  Java setup (version 23)
*  Gradle (version 8.10)
*  JDK with path setup (only for vs code)
*  Xcode for IPA file build
*  State management -> riverpod

## Default Setup
Run an existing flutter project on IDE

#### Change App Logo

You can generate app icon using this website https://icon.kitchen
* Then go to /android/app/src/main/resand replace all mipmap folder with your /android folder
*  Again go to /ios/Runner and replace Assets.xcassets with your generated Assets.xcassets folder

#### Change App Name

1. Change the value of label from/android/app/src/main/AndroidManifest.xml
 `android:label="My App"`
2. Change the value of CFBundleName from /iOS/Runner/info.plist
 `<key>CFBundleName</key><string>My App</string>`

## Change Base URL

Please do NOT put slash ( / ) at the end of your base url. Use your admin url as base url. First you have to install your admin panel. For example: If your admin url is https://admin.your_domain.com base url will be https://your_domain.com. Open `/lib/app_constants.dart` and replace baseUrl variable value with your own URL.

`static const String baseUrl='https://your_domain.com'`


### Change App Package
Firstly, find out the existing package name. You can find it out from top of `/app/src/main/AndroidManifest.xml` file. Then right click on project folder from android studio and click onreplace in path. You will see a popup window with two input boxes. In first box you have to put existing package name that you saw in `AndroidManifest.xml` file previously and then write down your preferred package name in second box and then click on Replace All button.
