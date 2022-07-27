// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:song_app/commons/song_list_cathegorie_screen.dart';
import 'package:song_app/screens/prog_screen.dart';

class CardViewScreen extends StatelessWidget {
  final Map<String, String> map;
  const CardViewScreen({required this.map, Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sizeX = MediaQuery.of(context).size.width;
    final sizeY = MediaQuery.of(context).size.height;
    
    return Container(
      margin: EdgeInsets.only(left: 15, right: 15, top: 10),
      width: sizeX,
      height: sizeY*4/5,
      child: GridView.count(
        scrollDirection: Axis.vertical,
        crossAxisCount: 2,
        children: _createCardView(map),
        mainAxisSpacing: 15.0,
        crossAxisSpacing: 5.0,
      ),
    );
  }
}

List<Widget> _createCardView(Map<String, String> map){
  List<Widget> images = [];
  Widget image;
  map.forEach((imageUrl, categorie) {   // key = imageUrl et value = title
    image = InkWell(
      onTap: () {
        if(imageUrl.contains("divers.jpg")){
          categorie="Divers";
          Get.to(SongListCathegorieScreen(categorie: categorie)); 
        }else if(imageUrl.contains("programme.jpg")){
          categorie="Programme";
          Get.to(ProgrammeScreen()); 
        }else{
          Get.to(SongListCathegorieScreen(categorie: categorie));
        }
        
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Card(
            elevation: 18.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))
            ),
            child: Image.asset(
              imageUrl,
              fit: BoxFit.cover,
              height: 135.0,
              width: 160.0,
            ),
            clipBehavior: Clip.antiAlias,
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Text(
              categorie,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ]
      ),
    );
    images.add(image);
  });
  return images;
}
