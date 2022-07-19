// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:song_app/commons/menu_bottom.dart';
import 'package:song_app/commons/pdfview_screen.dart';
import 'package:song_app/commons/search_form.dart';
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
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
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
              SearchForm(Parentcontext: context),
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
        initialData: 'Chargement...',
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot){

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Padding(
              padding: EdgeInsets.only(top: 180.0),
              child: Column(
                children: [
                  Center(child: const CircularProgressIndicator()),
                  Visibility(
                    visible: snapshot.hasData,
                    child: Text(
                      snapshot.data,
                      style: const TextStyle(color: Colors.black, fontSize: 24),
                    ),
                  )
                ],
              )
            );
          } 
          else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return const Text('Error');
            } else if (snapshot.hasData && snapshot.data.length>0) {
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
              return Padding(
                padding: EdgeInsets.only(top: 180, left: 80.0, right: 80),
                child: Center(
                  child: Column(
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        Center(
                          child: ListTile(
                              leading: Icon(Icons.music_note_sharp),
                              title: Text(
                                "Pas de partitions",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                        ),
                      ],
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
    for (var p in partitions) {  
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
                    p.name,
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
        onTap: () {
          Get.to(PdfViewScreen(link:p.url, titre: p.name,));
        },
      );
      partitionsToSend.add(partition);
    }
    return partitionsToSend;
  }

}



