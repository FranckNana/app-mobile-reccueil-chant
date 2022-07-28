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
        mainAxisSpacing: 5.0,
        crossAxisSpacing: 10.0,
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
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(), //desactiver le scroll
        child: Column(
          children: [
            Card(
              elevation: 18.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))
              ),
              child: Image.asset(
                imageUrl,
                fit: BoxFit.cover,
                height: 130.0,
                width: 160.0,
              ),
              clipBehavior: Clip.antiAlias,
            ),
            Text(
              categorie,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),                                        
          ],
        ),
      ),
    );
    images.add(image);
  });
  return images;
}
