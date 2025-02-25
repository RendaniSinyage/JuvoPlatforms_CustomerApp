# Keep device_info plugin classes
-keep class io.flutter.plugins.deviceinfo.** { *; }

# Keep plugin classes in general
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.plugin.**  { *; }

# Additional common rules for Flutter apps
-keep class androidx.lifecycle.** { *; }
-keep class androidx.core.** { *; }
-keep class androidx.fragment.** { *; }