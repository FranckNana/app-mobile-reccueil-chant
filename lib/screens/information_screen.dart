// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:song_app/commons/menu_bottom.dart';
import 'package:song_app/model/infos.model.dart';
import 'package:song_app/repository/infos.repos.dart';
import 'package:song_app/screens/home_screen.dart';

class InformationScreen extends StatefulWidget {
  const InformationScreen({ Key? key }) : super(key: key);

  @override
  State<InformationScreen> createState() => _InformationScreenState();
}

class _InformationScreenState extends State<InformationScreen> {
  late Future<List<Infos>> _infos;

  @override
  initState() {
    super.initState();
    InfosData i = InfosData();
    _infos = i.getAllInfos();
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
          title: const Text('Informations'),
          automaticallyImplyLeading: false,
        ),
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 90.0),
            child: Column(
              children: [
                futureBuilder(sizeX, sizeY)
              ]
            ),
          ),
        ),
        bottomNavigationBar: MenuBottom(selectedPage:3),
      ),
    );
  }

  FutureBuilder<dynamic> futureBuilder(double sizeX, double sizeY) {
    return FutureBuilder<dynamic>(
        future: _infos,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot){

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Padding(
              padding: EdgeInsets.only(top: 180.0),
              child: Center(child: CircularProgressIndicator())
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
                height: sizeY/2,
                child: GridView.count(
                  scrollDirection: Axis.horizontal,
                  crossAxisCount: 1,
                  children: _InfosContent(infos: data),
                  mainAxisSpacing: 5.0,
                  crossAxisSpacing: 5.0,
                ),
              );
            } else {
              return Padding(
                padding: EdgeInsets.only(top: 150, left: 60.0, right: 60),
                child: Column(
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      Center(
                        child: ListTile(
                            leading: Icon(Icons.info_sharp),
                            title: Text(
                              "Pas d'informations",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                      ),
                    ],
                ),
              );
            }
          } else {
            return Text('State: ${snapshot.connectionState}');
          }
        }
      );
  }

  List<Widget> _InfosContent({required List<Infos> infos}) {
    List<Widget> infosToSend = [];
    Widget inf;

    for (var info in infos) {
      inf = InkWell(
        child: Card (
          //color: Color.fromARGB(255, 222, 240, 250),
          elevation: 10,
          clipBehavior: Clip.antiAlias,
          child: SingleChildScrollView(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.info_sharp),
                  title: Text(
                    info.title,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    info.content, textAlign: TextAlign.justify,
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.6),
                      fontSize: 16,
                    ),
                  ),
                ),
              ]
            ),
          )
        )
      );
      infosToSend.add(inf);
    }
    
    return infosToSend; 

  }

}