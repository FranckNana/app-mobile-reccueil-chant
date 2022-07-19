
import 'package:flutter/material.dart';
import 'package:song_app/model/song.model.dart';

class FutureBuild extends StatelessWidget {
  final double sizeX;
  final double sizeY;
  final String message;
  final Future<List<Song>> futureObj;
  final Icon icon;

  const FutureBuild({required this.sizeX, required this.sizeY, required this.message, 
                      required this.futureObj, required this.icon, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
        future: futureObj,
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
              return Column(children: [const Text("TEST CENTER FUTURE BUILDER")]);
            } else {
              return Padding(
                padding: EdgeInsets.only(top: 180, left: 100.0, right: 100),
                child: Center(
                  child: Column(
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        Center(
                          child: ListTile(
                              leading: icon,
                              title: Text(
                                message,
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