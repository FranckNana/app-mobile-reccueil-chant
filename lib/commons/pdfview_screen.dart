// ignore: file_names
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

// ignore: must_be_immutable
class PdfViewScreen extends StatelessWidget {
  late dynamic file;
  PdfViewScreen({required this.file, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( 
        title: Text(file.name),
      ),
      body: viewPartition(file)
    );
  }

  Widget viewPartition(dynamic file){
    if(file.name.toUpperCase().contains('.pdf')){
      return SfPdfViewer.network(file.url);
    }else{
      return Image.network(
        file.url,
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
        alignment: Alignment.center,
      );
    }
  }


}