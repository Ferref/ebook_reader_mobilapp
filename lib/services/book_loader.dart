import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:epub_view/epub_view.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'dart:io';

class BookLoader {
  Future<void> loadBook(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom, allowedExtensions: ['epub', 'pdf', 'prc']);

    if (result != null) {
      String? filePath = result.files.single.path;
    }
  }
}
