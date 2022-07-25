// ignore_for_file: prefer_const_constructors, must_be_immutable, avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:song_app/commons/menu_bottom.dart';
import 'package:song_app/commons/pdfview_screen.dart';
import 'package:song_app/model/prog.model.dart';
import 'package:song_app/repository/prog.repos.dart';
import 'package:song_app/screens/home_screen.dart';

class ProgrammeScreen extends StatefulWidget {
  const ProgrammeScreen({ Key? key }) : super(key: key);

  @override
  State<ProgrammeScreen> createState() => _ProgrammeScreen();
}

class _ProgrammeScreen extends State<ProgrammeScreen> {

  late Future<List<Programme>> _programme;
  
  @override
  initState() {
    super.initState();
    ProgData p = ProgData();
    _programme = p.getProgramme();
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
          title: const Text('Feuilles de chants'),
        ),
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Column(
            children: [
              futureBuilder(sizeX, sizeY)
            ]
          ),
        ),
        bottomNavigationBar: MenuBottom(selectedPage:0),
      ),
    );
  }

  FutureBuilder<dynamic> futureBuilder(double sizeX, double sizeY) {
    return FutureBuilder<dynamic>(
        future: _programme,
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
              return Center(
                child: const Text(
                  'Error',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic
                  ),
                ),
              );
            } else if (snapshot.hasData && snapshot.data.length>0) {
              dynamic data = snapshot.data;
              return Container(
                margin: EdgeInsets.only(left: 15, right: 15, top: 10),
                width: sizeX,
                height: sizeY*5/6,
                child: GridView.count(
                  scrollDirection: Axis.vertical,
                  crossAxisCount: 2,
                  children: _createCardView(programmes: data),
                  mainAxisSpacing: 5.0,
                  crossAxisSpacing: 5.0,
                ),
              );
            } else {
              return Padding(
                padding: EdgeInsets.only(top: 180, left: 60.0, right: 60),
                child: Center(
                  child: Column(
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        Center(
                          child: ListTile(
                              leading: Icon(Icons.book_sharp),
                              title: Text(
                                "Pas de programme",
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


  List<Widget> _createCardView({required List<Programme> programmes}) {
    List<Widget> programmeToSend = [];

    Widget programme;
    programmes.forEach((p) {  
      programme = InkWell(
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
      programmeToSend.add(programme);
    });
    return programmeToSend;
  }

}



