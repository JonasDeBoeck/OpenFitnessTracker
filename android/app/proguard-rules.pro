# google_mlkit_text_recognition's Android plugin code references the
# Chinese/Devanagari/Japanese/Korean script recognizer classes, but only the
# Latin text-recognition artifact is on the classpath (that's all this app
# uses), so those classes genuinely don't exist for R8 to find. Without this
# it treats the reference as an error and fails the release build.
# https://github.com/flutter-ml/google_ml_kit_flutter/issues
-dontwarn com.google.mlkit.vision.text.chinese.**
-dontwarn com.google.mlkit.vision.text.devanagari.**
-dontwarn com.google.mlkit.vision.text.japanese.**
-dontwarn com.google.mlkit.vision.text.korean.**
