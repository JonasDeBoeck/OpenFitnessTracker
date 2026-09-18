import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/models/parsed_nutrition_label.dart';
import '../../domain/parsing/nutrition_label_parser.dart';

part 'nutrition_label_ocr_service.g.dart';

/// Drives the "Scan nutrition label" flow: pick a photo, let the user crop
/// tightly around the label (crop only ever happens here, never for the
/// general food photo — a tight frame is specifically what improves OCR
/// accuracy), run on-device text recognition, then hand the recognized
/// lines — with their on-image position, not just flattened text — to the
/// pure [NutritionLabelParser]. Position matters: a nutrition table's
/// labels and values are separate OCR blocks that only line up by row, not
/// by text adjacency. Returns null if the user cancels picking or cropping
/// at any step.
class NutritionLabelOcrService {
  NutritionLabelOcrService(this._picker);

  final ImagePicker _picker;

  Future<ParsedNutritionLabel?> captureAndScan({required ImageSource source}) async {
    final picked = await _picker.pickImage(source: source);
    if (picked == null) return null;

    final cropped = await ImageCropper().cropImage(
      sourcePath: picked.path,
      uiSettings: [
        AndroidUiSettings(toolbarTitle: 'Crop nutrition label'),
        IOSUiSettings(title: 'Crop nutrition label'),
      ],
    );
    if (cropped == null) return null;

    final recognizer = TextRecognizer(script: TextRecognitionScript.latin);
    try {
      final recognized = await recognizer.processImage(
        InputImage.fromFilePath(cropped.path),
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
