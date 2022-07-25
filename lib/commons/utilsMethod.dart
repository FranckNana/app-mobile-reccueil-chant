// ignore_for_file: file_names

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
      margin: const EdgeInsets.only(left: 15, right: 15, top: 10),
      width: sizeX,
      height: sizeY*3/4,
      child: GridView.count(
        scrollDirection: Axis.vertical,
        crossAxisCount: 2,
        children: _createCardView(partitions: data),
        mainAxisSpacing: 5.0,
        crossAxisSpacing: 5.0,
      ),
    );
  }

  Widget singleDataView(double sizeX, double sizeY, dynamic data){
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15, top: 10),
      width: sizeX,
      height: sizeY/2 ,
      child: GridView.count(
        scrollDirection: Axis.horizontal,
        crossAxisCount: 1,
        children: _createCardView(partitions: data),
        mainAxisSpacing: 5.0,
        crossAxisSpacing: 5.0,
      ),
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
      partition = InkWell(
        child: customCard(p),
        onTap: () {
          Get.to(PdfViewScreen(link:p.url, titre: p.name,));
        },
      );
      partitionsToSend.add(partition);
    }
    return partitionsToSend;
  }

  Widget customCard(Partition p){
    return Card(
      elevation: 0,
      child: Container(
        decoration: BoxDecoration(
          image: const DecorationImage(
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
                style: const TextStyle(
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
          song.title,
          style: const TextStyle(
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