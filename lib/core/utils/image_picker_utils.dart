import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quan_ly_nha_tro/core/resources/string_manager.dart';

/// Shows a bottom sheet with options to pick an image from camera or gallery.
/// Returns the picked [XFile] or null if cancelled.
Future<XFile?> showImageSourceOptions(BuildContext context) async {
  final ImageSource? source = await showModalBottomSheet<ImageSource>(
    context: context,
    builder:
        (context) => SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: Text(AppStrings.takePhoto),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: Text(AppStrings.chooseFromGallery),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
            ],
          ),
        ),
  );

  if (source != null) {
    final ImagePicker picker = ImagePicker();
    return await picker.pickImage(source: source);
  }
  return null;
}
