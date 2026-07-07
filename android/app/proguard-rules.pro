# Preserve all ML Kit text recognition classes
-keep class com.google.mlkit.vision.text.** { *; }
-dontwarn com.google.mlkit.vision.text.**

# Keep general ML Kit classes
-keep class com.google.mlkit.** { *; }
-dontwarn com.google.mlkit.**

# Optional: Flutter plugin related rules
-keep class io.flutter.** { *; }
-dontwarn io.flutter.embedding.**

# Optional: Kotlin
-dontwarn kotlin.**
-keep class kotlin.** { *; }
