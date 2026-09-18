import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/models/parsed_nutrition_label.dart';
import '../../domain/parsing/nutrition_label_parser.dart';

part 'nutrition_label_ocr_service.g.dart';

/// Drives the "Scan nutrition label" flow's photo capture and OCR steps.
/// Cropping tightly around the label — which specifically improves OCR
/// accuracy — happens separately in the presentation layer (a custom
/// screen with draggable crop-corner handles) and via [ImageCropService],
/// since it needs a live screen the user drags on; this service only picks
/// the raw photo and, once a cropped file exists, runs recognition on it.
class NutritionLabelOcrService {
  NutritionLabelOcrService(this._picker);

  final ImagePicker _picker;

  /// Returns the picked file's path, or null if the user cancels.
  Future<String?> pickPhoto({required ImageSource source}) async {
    final picked = await _picker.pickImage(source: source);
    return picked?.path;
  }

  /// Runs on-device text recognition on an already-cropped image and hands
  /// the recognized lines — with their on-image position, not just
  /// flattened text — to the pure [NutritionLabelParser]. Position matters:
  /// a nutrition table's labels and values are separate OCR blocks that
  /// only line up by row, not by text adjacency.
  Future<ParsedNutritionLabel> recognizeLabel({required String imagePath}) async {
    final recognizer = TextRecognizer(script: TextRecognitionScript.latin);
    try {
      final recognized = await recognizer.processImage(
        InputImage.fromFilePath(imagePath),
      );
      final lines = [
        for (final block in recognized.blocks)
          for (final line in block.lines)
            OcrLine(
              text: line.text,
              top: line.boundingBox.top,
              bottom: line.boundingBox.bottom,
              left: line.boundingBox.left,
            ),
      ];
      return NutritionLabelParser.parseLines(lines);
    } finally {
      await recognizer.close();
    }
  }
}

@Riverpod(keepAlive: true)
NutritionLabelOcrService nutritionLabelOcrService(Ref ref) {
  return NutritionLabelOcrService(ImagePicker());
}
