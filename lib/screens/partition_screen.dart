// ignore_for_file: prefer_const_constructors, must_be_immutable, avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:song_app/commons/menu_bottom.dart';
import 'package:song_app/commons/search_form.dart';
import 'package:song_app/commons/utilsMethod.dart';
import 'package:song_app/model/partition.model.dart';
import 'package:song_app/repository/partition.repos.dart';
import 'package:song_app/screens/home_screen.dart';
import 'package:song_app/screens/takePicture_Screen.dart';

class PartitionScreen extends StatefulWidget {
  const PartitionScreen({ Key? key }) : super(key: key);

  @override
  State<PartitionScreen> createState() => _PartitionScreenState();
}

class _PartitionScreenState extends State<PartitionScreen> {

  late Future<List<dynamic>> _partitions;
  
  @override
  initState() {
    super.initState();
    PartitionsData p = PartitionsData();
    _partitions = p.getPartition();
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
          title: const Text('Partitions'),
          automaticallyImplyLeading: false,
        ),
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SearchForm(sizeX: sizeX, sizeY: sizeY, isPartition:true, parentcontext: context),
              futureBuilder(sizeX, sizeY),
            ]
          ),
        ),
        floatingActionButton : myFoatingButton(),
        bottomNavigationBar: MenuBottom(selectedPage:1),
      ),
    );
  }

  FutureBuilder<dynamic> futureBuilder(double sizeX, double sizeY) {
    return FutureBuilder<dynamic>(
        future: _partitions,
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
              return const Text('Error');
            } else if (snapshot.hasData && snapshot.data.length>0) {
              dynamic data = snapshot.data;
              return Utils().dataView(sizeX, sizeY, data);
            } else {
              return Utils().noDataFound();
            }
          } else {
            return Text('State: ${snapshot.connectionState}');
          }
        }
      );
  }

  Widget myFoatingButton(){
    return FloatingActionButton(
      elevation: 18.0,
      onPressed: () {
        Get.to(TakePictureScreen());
      },
      backgroundColor: const Color(0xFF33691E),
      child: const Icon(Icons.camera_alt_sharp),
    );
  }
  

}



