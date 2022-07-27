// ignore_for_file: file_names, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:song_app/commons/pdfview_screen.dart';
import 'package:song_app/commons/view_song.dart';
import 'package:song_app/model/partition.model.dart';
import 'package:song_app/model/song.model.dart';

class Utils {

  /// ************************** PARTITION UTILS ***********************/

  Widget dataView(double sizeX, double sizeY, dynamic data){
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
      width: sizeX,
      height: sizeY*3/4,
      child: GridView.count(
        scrollDirection: Axis.vertical,
        crossAxisCount: 2,
        children: _createCardView(partitions: data),
        mainAxisSpacing: 3.0,
        crossAxisSpacing: 3.0,
      ),
    );
  }


  Widget singleDataView(double sizeX, double sizeY, dynamic data){
    var partitionName = data[0].name.length > 34 ? data[0].name.substring(13, 26)+'...' : data[0].name.substring(13);
    return Column(
        children: [
          secondCustomCard(data[0]),
          Text(
            partitionName,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ]
    );
  }

  Widget noDataFound(){
    return Padding(
      padding: const EdgeInsets.only(top: 180, left: 80.0, right: 80),
      child: Center(
        child: Column(
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              const Center(
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

  List<Widget> _createCardView({required List<Partition> partitions}) {
    List<Widget> partitionsToSend = [];

    Widget partition;
    for (var p in partitions) {
      var partitionName = p.name.length > 34 ? p.name.substring(13, 26)+'...' : p.name.substring(13);  
      partition = InkWell(
        child: Column(
          children: [
            customCard(p),
            Text(
              partitionName,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ]
        ),
        onTap: () {
          Get.to(PdfViewScreen(link:p.url, titre: partitionName));
        },
      );
      partitionsToSend.add(partition);
    }
    return partitionsToSend;
  }
  

  Widget customCard(Partition p){
    
    return Card(
      elevation: 18.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.0))
      ),
      child: Image.asset(
          'images/pdf.png',
          fit: BoxFit.cover,
          height: 135.0,
          width: 160.0,
        ),
        clipBehavior: Clip.antiAlias,
      );
  }


  Widget secondCustomCard(Partition p){
    var partitionName = p.name.length > 34 ? p.name.substring(13, 26)+'...' : p.name.substring(13); 
    return InkWell(
      child: Padding(
        padding: EdgeInsets.only(top: 15.0),
        child: SizedBox(
          width: 300,
          height: 200,
          child: Card(
            elevation: 18.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))
            ),
            child: Image.asset(
                'images/pdf.png',
                fit: BoxFit.cover,
                height: 160.0,
                width: 160.0,
              ),
              clipBehavior: Clip.antiAlias,
            ),
        ),
      ),
        onTap: () {
          Get.to(PdfViewScreen(link:p.url, titre: partitionName));
        },
    );
  }


/// ************************** SONGS UTILS ***********************/

  List<Widget> createSongList({required List<Song> songs}){
    List<Widget> listOfSong = [];

    var i=0;
    for (var s in songs) {
        i++;
        var songL = songLine(id: i.toString() ,song: s);
        listOfSong.add(songL);
    }

    return listOfSong;
  }

  Widget songLine({String id="", required Song song}){
    song.title = song.title.length > 13 ? song.title.substring(0, 13)+'...' : song.title;

    return TextButton(
      child: ListTile(
        horizontalTitleGap: 0.0,
        leading: SizedBox(
          height: 24,
          child: CircleAvatar(
            backgroundColor: Colors.blueGrey,
            child: Icon(
              Icons.chevron_right_rounded
            )
          ),
        ),
        title: Text(
          song.title,
          style: const TextStyle(
            color: Colors.blueGrey,
            fontSize: 16,
          ),
        ),
        minVerticalPadding: 0,
      ),
      onPressed: (){
        Get.to(ViewSong(song: song,));
      },
    );
  }

}