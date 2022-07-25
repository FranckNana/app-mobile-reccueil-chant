// ignore: file_names
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

// ignore: must_be_immutable
class PdfViewScreen extends StatelessWidget {
  late String link;
  late String titre;
  PdfViewScreen({required this.link, required this.titre, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( 
        title: Text(titre),
      ),
      body: SfPdfViewer.network(link)
    );
  }
}