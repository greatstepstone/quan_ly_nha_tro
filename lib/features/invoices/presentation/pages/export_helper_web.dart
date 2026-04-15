/// Web implementation — uses dart:html Blob + AnchorElement to trigger downloads.
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:typed_data';

/// Downloads bytes as a file in the browser.
Future<void> downloadBytes(Uint8List bytes, String fileName, String mimeType) async {
  final blob = html.Blob([bytes], mimeType);
  final url = html.Url.createObjectUrlFromBlob(blob);
  html.AnchorElement(href: url) // ignore: unused_local_variable
    ..setAttribute('download', fileName)
    ..click();
  html.Url.revokeObjectUrl(url);
}

/// On web there is no native share sheet — just download instead.
Future<void> shareBytes(Uint8List bytes, String fileName, String mimeType, String shareText) async {
  await downloadBytes(bytes, fileName, mimeType);
}
