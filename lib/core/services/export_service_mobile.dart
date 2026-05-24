/// Mobile implementation — uses share_plus to open the native OS share sheet
/// (Zalo, Messenger, Gmail, Save to Files, etc.)
library;

import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// On mobile, saving to a temp file and then sharing via the OS sheet.
Future<void> downloadBytes(
  Uint8List bytes,
  String fileName,
  String mimeType,
) async {
  await shareBytes(bytes, fileName, mimeType, '');
}

/// Opens the native OS share sheet with the file attached.
/// The user can choose Zalo, Messenger, Gmail, WhatsApp, etc.
Future<void> shareBytes(
  Uint8List bytes,
  String fileName,
  String mimeType,
  String shareText,
) async {
  final tempDir = await getTemporaryDirectory();
  final file = File('${tempDir.path}/$fileName');
  await file.writeAsBytes(bytes);

  final xFile = XFile(file.path, mimeType: mimeType, name: fileName);
  await Share.shareXFiles(
    [xFile],
    text: shareText.isNotEmpty ? shareText : null,
    subject: fileName,
  );
}
