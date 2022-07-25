// ignore_for_file: non_constant_identifier_names, avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';
import 'package:song_app/commons/menu_bottom.dart';
import 'package:song_app/model/song.model.dart';

class ViewSong extends StatelessWidget {
  final Song song;

  const ViewSong({required this.song, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(song.title),
      ),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
          child: Column(
            children: printSong(),
          ),
        ),
      bottomNavigationBar: MenuBottom(selectedPage:0),
    );
  }

  List<Widget> printSong(){
    List<Widget> CoupletToSend = [
      Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: Text(
          "\n"+song.refrain.toString()+"\n",
          textAlign: TextAlign.justify,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
    ];

    Widget couplet;

    song.couplet.forEach((c) {
      couplet = InkWell(
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: SizedBox(
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: [
                Text(
                  c.toString()+"\n",
                  textAlign: TextAlign.justify,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      CoupletToSend.add(couplet);
    });

    return CoupletToSend;
  }

}