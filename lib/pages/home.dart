import 'package:ebook_reader_mobilapp/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../services/book_loader.dart';

// Egyedi AppBar
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize; // Szukseges a prefereedSize miatt

  const CustomAppBar({super.key})
      : preferredSize =
            const Size.fromHeight(kToolbarHeight); // Fejlec magassaga

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'Ebook-HomePage',
        style: TextStyle(
          color: EbookAppColors
              .text, // Sajat szineket hasznalunk, az app_colors.dart-ban lehet modositani
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: EbookAppColors.background,
      elevation: 0.0,
      centerTitle: true,
      leading: GestureDetector(
        onTap: () {},
        child: Container(
          margin: const EdgeInsets.all(10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: EbookAppColors.secondaryBackground,
            borderRadius: BorderRadius.circular(10),
          ),
          child: SvgPicture.asset(
            'assets/icons/books.svg',
            height: 20,
            width: 20,
          ),
        ),
      ),
    );
  }
}

// HomePage foladal ami tartalmazza az importalas lehetoseget
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final bookLoader = BookLoader();

    return Scaffold(
      appBar: const CustomAppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Ebook Reader Fooldal',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                bookLoader.loadBook(context);
              },
              child: const Text('Könyv Importálása'),
            ),
          ],
        ),
      ),
    );
  }
}
