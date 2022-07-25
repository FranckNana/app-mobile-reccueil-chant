// ignore_for_file: unused_element, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:song_app/commons/menu_bottom.dart';
import 'package:song_app/commons/search_form.dart';
import 'package:song_app/commons/utilsMethod.dart';
import 'package:song_app/model/song.model.dart';
import 'package:song_app/repository/song.repos.dart';

class SongListCathegorieScreen extends StatefulWidget {
  final String categorie;
  const SongListCathegorieScreen({this.categorie="", Key? key }) : super(key: key);

  @override
  State<SongListCathegorieScreen> createState() => _SongListCathegorieScreenState();
}

class _SongListCathegorieScreenState extends State<SongListCathegorieScreen> {

  late Future<List<Song>> _songs;
  
  @override
  initState() {
    super.initState();
    SongData s = SongData();
    _songs = s.getSongsByType(widget.categorie);
  }
  
  @override
  Widget build(BuildContext context) {
    final sizeX = MediaQuery.of(context).size.width;
    final sizeY = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categorie),
      ),
      body: SingleChildScrollView(
          child: Column(
            children: [
              SearchForm(sizeX: sizeX, sizeY: sizeY, isPartition:false, categorie: widget.categorie, parentcontext: context),
              futureBuilder(sizeX, sizeY)
            ]
          ),
        ),
       bottomNavigationBar: MenuBottom(),
    );
  }


  FutureBuilder<dynamic> futureBuilder(double sizeX, double sizeY) {
    return FutureBuilder<dynamic>(
        future: _songs,
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
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return const Text('Error');
            } else if (snapshot.hasData && snapshot.data.length>0) {
              dynamic data = snapshot.data;
              return Column(children: Utils().createSongList(songs: data));
            } else {
              return Padding(
                padding: EdgeInsets.only(top: 180, left: 100.0, right: 100),
                child: Center(
                  child: Column(
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        Center(
                          child: ListTile(
                              leading: Icon(Icons.list_sharp),
                              title: Text(
                                "Empty data",
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


}



