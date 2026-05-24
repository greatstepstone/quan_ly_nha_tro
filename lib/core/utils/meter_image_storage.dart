import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Saves a meter reading image to the app's local documents directory.
///
/// Naming convention: `{readingId}_electric_old_{MM_YYYY}.jpg`
/// The month string (e.g. "05/2026") has its slash replaced with underscore.
///
/// Returns the absolute path of the saved file, or null if saving fails.
Future<String?> saveMeterImage(
  XFile file, {
  required String readingId,
  required String
  type, // e.g. 'electric_old', 'electric_new', 'water_old', 'water_new'
  required String month, // e.g. '05/2026'
}) async {
  try {
    final dir = await getApplicationDocumentsDirectory();
    final imagesDir = Directory(p.join(dir.path, 'meter_images'));
    if (!await imagesDir.exists()) {
      await imagesDir.create(recursive: true);
    }

    final monthSafe = month.replaceAll('/', '_');
    final ext =
        p.extension(file.path).isNotEmpty ? p.extension(file.path) : '.jpg';
    final fileName = '${readingId}_${type}_$monthSafe$ext';
    final destPath = p.join(imagesDir.path, fileName);

    await File(file.path).copy(destPath);
    return destPath;
  } catch (e) {
    return null;
  }
}
