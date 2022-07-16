// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:song_app/commons/menu_bottom.dart';
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
    
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
          title: Text(widget.categorie),
      ),
      body: SingleChildScrollView(
          child: Column(
            children: [
              searchForm(formKey: _formKey),
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
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot){

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Padding(
              padding: EdgeInsets.only(top: 180.0),
              child: Center(child: CircularProgressIndicator())
            );
          } 
          else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return const Text('Error');
            } else if (snapshot.hasData) {
              dynamic data = snapshot.data;
              return Column(children: _createSongList(songs: data));
            } else {
              return const Center(
                child: Text(
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


  Widget _songLine({required String id, required String title, Widget? screen}){

  return TextButton(
    child: ListTile(
      horizontalTitleGap: 0.0,
      leading: Text(
        id+"-",
        style: const TextStyle(
          fontSize: 16,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
        ),
      ),
      minVerticalPadding: 0,
    ),
    onPressed: (){},
  );
}

List<Widget> _createSongList({required List<Song> songs, Widget? screen}){
  List<Widget> listOfSong = [];

  var i=0;
  songs.forEach((s){
      i++;
      var songLine = _songLine(id: i.toString() ,title: s.title);
      listOfSong.add(songLine);
  });

  return listOfSong;
}

Widget searchForm({required GlobalKey<FormState> formKey}){
  return Form(
      key: formKey,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right:8.0),
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



