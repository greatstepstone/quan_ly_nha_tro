/// Fallback stub — never used at runtime, but required so the analyzer
/// is happy when neither dart:html nor dart:io is available (e.g. in tests).
import 'dart:typed_data';

Future<void> downloadBytes(Uint8List bytes, String fileName, String mimeType) async {
  throw UnsupportedError('downloadBytes is not supported on this platform.');
}

Future<void> shareBytes(Uint8List bytes, String fileName, String mimeType, String shareText) async {
  throw UnsupportedError('shareBytes is not supported on this platform.');
}
