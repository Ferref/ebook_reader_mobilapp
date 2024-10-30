import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:epub_view/epub_view.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'dart:io';

class BookLoader {
  // Future azaz kesobb fejezodik be
  Future<void> loadBook(BuildContext context) async {
    // Megjelenitunk egy fajlvalaszto ablakot
    final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['epub', 'pdf'] // Majd prc is lesz benne
        );

    if (result != null) {
      // Ha a felhasznalo valasztott fajlt
      final file =
          result.files.first; // Csak egy fajlt tud kivalasztani egyszerre
      final filePath = file.path!; // Nem null ertek (!)

      if (file.extension == 'epub') {
        _openEpubReader(context, filePath);
      } else if (file.extension == 'pdf') {
        _openPdfReader(context, filePath);
      }
      // else if(file.extension == 'prc'){
      // _openPrcReader(context, filePath);
      //}
      else {
        _showUnsupportedFileDialog(context);
      }
    }
  }

  // Itt nincs private metodus igy ezt imitaljuk a '_' jelolessel a metodusok elott
  void _openEpubReader(BuildContext context, String filePath) {
    Navigator.push(
      context, // Az aktualis context ahol a navigacio megtortenik
      MaterialPageRoute(
        builder: (context) => EpubReaderPage(filePath: filePath),
      ),
    );
  }

  // PDF olvaso elinditasa/megnyitasa
  void _openPdfReader(BuildContext context, String filePath) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PdfReaderPage(filePath: filePath),
      ), // PDF olvaso oldal felepitese
    );
  }

  // Nem tamogatott fajltipus kezelo
  void _showUnsupportedFileDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nem tamogatott fajltipus'),
        content: const Text('Kerjuk, valasszon egy EPUB vagy PDF fajlt'),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.of(context).pop(), // Dialogus bezarasa (OK)
            child: const Text('OK'), // OK text
          ),
        ],
      ),
    );
  }
}

// EPUB olvaso oldal
class EpubReaderPage extends StatelessWidget {
  final String filePath;
  final EpubController _epubController;

  EpubReaderPage({super.key, required this.filePath})
      : _epubController =
            EpubController(document: EpubDocument.openFile(File(filePath)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            "EPUB Olvaso"), // Fejlec, ahol az EPUB olvaso neve jelenik meg
      ),
      body: EpubView(
          controller:
              _epubController), // EPUB megjelenitese az EpubView widgettel
    );
  }
}

// PDF olvaso oldal
class PdfReaderPage extends StatelessWidget {
  final String filePath;

  PdfReaderPage({super.key, required this.filePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            "PDF Olvaso"), // Fejlec, ahol a PDF olvaso neve jelenik meg
      ),
      body: PDFView(
        filePath: filePath, // A PDF fajl megjelenitese a PDFView widgetben
      ),
    );
  }
}
