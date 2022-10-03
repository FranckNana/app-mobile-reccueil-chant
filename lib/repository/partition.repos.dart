import 'dart:convert';
import 'dart:io';

import 'package:date_format/date_format.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:song_app/model/partition.model.dart';

class PartitionsData{

  List<dynamic> partitions = [];

  void setPartitionsList(dynamic p) {
    partitions.add(p);
  }

  Future<List<dynamic>> getPartition() async {

    DatabaseReference database = FirebaseDatabase.instance.ref('partitionsFiles');

    DatabaseEvent event = await database.once();
    dynamic data = event.snapshot.value;
    if(data!=null){
      for(var d in data){
        Partition partition = Partition(
          date: d['date'], 
          name: d['name'],  
          url: d['url']
        );
        setPartitionsList(partition);
      }
    }
    return partitions;

  }

  Future<String> uploadFile(File file, String almostUniqueFileName) async {
    Reference reference = FirebaseStorage.instance.ref();
    final uploadTask = reference.child('files/partitions/'+almostUniqueFileName).putFile(file);
    Future<String> imageUrl = (await uploadTask).ref.getDownloadURL();
    return imageUrl;                             
  }

  Future<void> saveFile(File file, String name) async {
    DatabaseReference database = FirebaseDatabase.instance.ref('partitionsFiles');
    String almostUniqueFileName = formatDate(DateTime.now(), [yyyy,  mm,  dd, HH, nn, ss]) +"##"+ name;
    final imgUrl = await uploadFile(file, almostUniqueFileName);
    var partition = Partition(date: DateTime.now().toUtc().toString(), name: almostUniqueFileName, url : imgUrl);
    print(partition.toString());
    /*getPartition().then((value) {
      value.add(partition);
      database.set(value);
    });*/
  }

} 