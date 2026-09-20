import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/painting.dart' show Rect;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'image_crop_service.g.dart';

/// Crops an image file to an arbitrary pixel rectangle and writes the
/// result to a new file. Pure pixel manipulation via `dart:ui` — the
/// user picks that rectangle in the presentation layer by dragging each
/// corner independently, rather than through a native cropper's preset
/// aspect ratios.
class ImageCropService {
  Future<String> cropToFile({
    required String sourcePath,
    required Rect cropRect,
  }) async {
    final bytes = await File(sourcePath).readAsBytes();
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    final source = frame.image;

    final left = cropRect.left.clamp(0, source.width.toDouble()).toDouble();
    final top = cropRect.top.clamp(0, source.height.toDouble()).toDouble();
    final right = cropRect.right.clamp(0, source.width.toDouble()).toDouble();
    final bottom = cropRect.bottom.clamp(0, source.height.toDouble()).toDouble();
    final clamped = Rect.fromLTRB(left, top, right, bottom);

    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);
    canvas.drawImageRect(
      source,
      clamped,
      Rect.fromLTWH(0, 0, clamped.width, clamped.height),
      ui.Paint(),
    );
    final picture = recorder.endRecording();
    final cropped = await picture.toImage(
      clamped.width.round(),
      clamped.height.round(),
    );
    final pngBytes = await cropped.toByteData(format: ui.ImageByteFormat.png);

    final tempDir = await getTemporaryDirectory();
    final destination = p.join(
      tempDir.path,
      'label_crop_${DateTime.now().microsecondsSinceEpoch}.png',
    );
    await File(destination).writeAsBytes(
      pngBytes!.buffer.asUint8List(),
      flush: true,
    );
    return destination;
  }
}

@Riverpod(keepAlive: true)
ImageCropService imageCropService(Ref ref) {
  return ImageCropService();
}
