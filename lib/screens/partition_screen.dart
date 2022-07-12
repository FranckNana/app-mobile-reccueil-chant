// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:song_app/commons/menu_bottom.dart';
import 'package:song_app/model/partition.model.dart';
import 'package:song_app/repository/partition.repos.dart';
import 'package:song_app/screens/home_screen.dart';

class PartitionScreen extends StatefulWidget {
  const PartitionScreen({ Key? key }) : super(key: key);

  @override
  State<PartitionScreen> createState() => _PartitionScreenState();
}

class _PartitionScreenState extends State<PartitionScreen> {

  late Future<List<Partition>> _partitions;
  
  @override
  initState() {
    super.initState();
    PartitionsData p = PartitionsData();
    _partitions = p.getPartition();
  }

  @override
  Widget build(BuildContext context) {
    final sizeX = MediaQuery.of(context).size.width;
    final sizeY = MediaQuery.of(context).size.height;

    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    return WillPopScope(

      onWillPop: () async { 
        Get.off(HomeScreen());
        return true;
      },

      child: Scaffold(
        appBar: AppBar(
          title: const Text('Partitions'),
          automaticallyImplyLeading: false,
        ),
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Column(
            children: [
              searchForm(formKey: _formKey),
              futureBuilder(sizeX, sizeY)
            ]
          ),
        ),
        bottomNavigationBar: MenuBottom(selectedPage:2),
      ),
    );
  }

  FutureBuilder<dynamic> futureBuilder(double sizeX, double sizeY) {
    return FutureBuilder<dynamic>(
        future: _partitions,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot){

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } 
          else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return const Text('Error');
            } else if (snapshot.hasData) {
              dynamic data = snapshot.data;
              return Container(
                margin: EdgeInsets.only(left: 15, right: 15, top: 10),
                width: sizeX,
                height: sizeY*5/6,
                child: GridView.count(
                  scrollDirection: Axis.vertical,
                  crossAxisCount: 2,
                  children: _createCardView(partitions: data),
                  mainAxisSpacing: 5.0,
                  crossAxisSpacing: 5.0,
                ),
              );
            } else {
              return Center(
                child: const Text(
                  'Empty data', 
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic
                  ),
                ),
              );
            }
          } else {
            return Text('State: ${snapshot.connectionState}');
          }
        }
      );
  }


  List<Widget> _createCardView({required List<Partition> partitions}) {
    List<Widget> partitionsToSend = [];

    Widget partition;
    partitions.forEach((p) {  
      partition = InkWell(
        child: Card(
          elevation: 0,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image:AssetImage('images/pdf.png'),
                fit: BoxFit.fitHeight, 
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: SizedBox(
              child: Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  Text(
                    p.name.substring(13),
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic
                    ),
                  ),
                ],
              )
            ),
          ),
        ),
        onTap: () async {
          print("here "+p.url);
          PDFDocument document = await PDFDocument.fromURL(p.url);
          PDFViewer(
            document: document
          );
        },
      );
      partitionsToSend.add(partition);
    });
    return partitionsToSend;
  }


  Widget searchForm({required GlobalKey<FormState> formKey}){
  return Form(
      key: formKey,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right:8.0),
              child: TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Recherche',
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Ecrivez quelque chose...';
                  }
                  return null;
                },
              ),
            ),
          ),
          TextButton(
            child: const Icon(Icons.search_rounded),
            onPressed: () {
              // Validate will return true if the form is valid, or false if
              // the form is invalid.
              if (formKey.currentState!.validate()) {
                // Process data.
              }
            }
          ),
        ],
      ),
    );
  }

}



