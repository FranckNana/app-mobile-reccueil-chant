// ignore: file_names
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

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
      body: Container(
        child: const PDF().fromUrl(
          link,
          //maxAgeCacheObject: const Duration(hours: 24), 
          placeholder: (progress) => Center(child: Text('$progress %')),
          errorWidget: (error) => Center(child: Text(error.toString())),
        )
      )
    );
  }
}