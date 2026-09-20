import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'food_photo_service.g.dart';

/// Wraps the platform photo picker for the general food-photo field. Copies
/// the picked file into this app's own documents directory so it survives
/// the OS clearing whatever cache/temp location the picker returned it
/// from, and returns that persisted path for storage on a [Food].
class FoodPhotoService {
  FoodPhotoService(this._picker);

  final ImagePicker _picker;

  Future<String?> pickPhoto({required ImageSource source}) async {
    final picked = await _picker.pickImage(source: source);
    if (picked == null) return null;

    final documentsDir = await getApplicationDocumentsDirectory();
    final photosDir = Directory(p.join(documentsDir.path, 'food_photos'));
    await photosDir.create(recursive: true);

    final fileName = '${DateTime.now().microsecondsSinceEpoch}${p.extension(picked.path)}';
    final destination = p.join(photosDir.path, fileName);
    await File(picked.path).copy(destination);
    return destination;
  }
}

@Riverpod(keepAlive: true)
FoodPhotoService foodPhotoService(Ref ref) {
  return FoodPhotoService(ImagePicker());
}
