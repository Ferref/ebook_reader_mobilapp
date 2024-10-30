import 'package:flutter/material.dart';
import 'package:epub_view/epub_view.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class BookLoader {
  // Fajl betoltese es megnyitasa a megfelelo olvasoval
  Future<void> loadBook(BuildContext context) async {
    // Fajlvalaszto ablak megjelenitese
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['epub', 'pdf'], // EPUB es PDF fajlokat engedelyezunk
    );

    if (result != null) {
      // Ha a felhasznalo valasztott fajlt
      final file = result.files.first;
      final filePath = file.path!; // Fajl eleresi utja

      if (file.extension == 'epub') {
        _openEpubReader(context, filePath); // EPUB olvaso megnyitasa
      } else if (file.extension == 'pdf') {
        _openPdfReader(context, filePath); // PDF olvaso megnyitasa
      } else {
        _showUnsupportedFileDialog(context); // Uzenet nem tamogatott fajlra
      }
    }
  }

  // EPUB olvaso oldal megnyitasa
  void _openEpubReader(BuildContext context, String filePath) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EpubReaderPage(filePath: filePath),
      ),
    );
  }

  // PDF olvaso oldal megnyitasa
  void _openPdfReader(BuildContext context, String filePath) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PdfReaderPage(filePath: filePath),
      ),
    );
  }

  // Nem tamogatott fajltipus eseten megjeleno uzenet
  void _showUnsupportedFileDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nem tamogatott fajltipus'),
        content: const Text('Kerjuk, valasszon egy EPUB vagy PDF fajlt'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(), // Dialogus bezarasa
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

// EPUB olvaso oldal
class EpubReaderPage extends StatefulWidget {
  final String filePath;

  EpubReaderPage({super.key, required this.filePath});

  @override
  _EpubReaderPageState createState() => _EpubReaderPageState();
}

class _EpubReaderPageState extends State<EpubReaderPage> {
  late EpubController _epubController;

  @override
  void initState() {
    super.initState();
    _epubController = EpubController(
      document:
          EpubDocument.openFile(File(widget.filePath)), // EPUB fajl megnyitasa
    );
    _loadBookmark(); // Korabbi konyvjelzo betoltese, ha van
  }

  // Konyvjelzo mentese
  Future<void> _saveBookmark() async {
    final prefs = await SharedPreferences.getInstance();
    final currentLocation = await _epubController.generateEpubCfi();
    if (currentLocation != null) {
      await prefs.setString('bookmark_${widget.filePath}', currentLocation);
    }
  }

  // Konyvjelzo betoltese
  Future<void> _loadBookmark() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLocation = prefs.getString('bookmark_${widget.filePath}');
    if (savedLocation != null) {
      _epubController.gotoEpubCfi(savedLocation);
    }
  }

  @override
  void dispose() {
    _epubController.dispose(); // Felszabaditja a controller eroforrasait
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Aktualis fejezet neve (Appbar)
        title: EpubViewActualChapter(
          controller: _epubController,
          builder: (chapterValue) => Text(
            chapterValue?.chapter?.Title?.replaceAll('\n', '').trim() ?? '',
            textAlign: TextAlign.start,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark),
            onPressed: _saveBookmark, // Konyvjelzo mentese
          ),
        ],
      ),
      // Tartalomjegyzek mint oldalso menu
      drawer: Drawer(
        child: EpubViewTableOfContents(controller: _epubController),
      ),
      body: EpubView(
        controller: _epubController,
      ),
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
        enableSwipe:
            true, // Engedelyezi a lapozast oldalra (suhintassal/pockolessel)
        swipeHorizontal: true, // Vízszintes lapozas
        onError: (error) {
          print(error); // Hibauzenet a konzolon
        },
        onRender: (pages) {
          print("Total pages: $pages"); // Oldalak szamanak kiirasa
        },
      ),
    );
  }
}
