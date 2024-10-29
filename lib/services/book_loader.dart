import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:epub_view/epub_view.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'dart:io';

class BookLoader {
  Future<void> loadBook(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['epub', 'pdf', 'prc'],
    );

    if (result != null) {
      final file = result.files.first;
      final filePath = file.path!;

      if (file.extension == 'epub') {
        _openEpubReader(context, filePath);
      } else if (file.extension == 'pdf') {
        _openReader(context, filePath);
      } else {
        _showUnsupportedFileDialog(context);
      }
    }
  }
}
