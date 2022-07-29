import 'dart:io';

import 'package:date_format/date_format.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:song_app/model/partition.model.dart';

class PartitionsData{

  List<Partition> partitions = [];

  void setPartitionsList(Partition p) {
    partitions.add(p);
  }

  Future<List<Partition>> getPartition() async {

    DatabaseReference database = FirebaseDatabase.instance.ref('partitionsFiles');

    DatabaseEvent event = await database.once();
    dynamic data = event.snapshot.value;
    if(data!=null){
      for(var d in data){
        Partition partition = Partition(
                                date: d['date'], 
                                name: d['name'],  
                                url: d['url']);
        setPartitionsList(partition);
      }
    }
    return partitions;

  }

   uploadFile(File file) async {
    String almostUniqueFileName = formatDate(DateTime.now(), [yyyy,  mm,  dd]);
    Reference reference = FirebaseStorage.instance.ref();
    final uploadTask = reference.child('files/partitions/'+almostUniqueFileName+file.path.split('/').last).putFile(file);
    var imageUrl = await (await uploadTask).ref.getDownloadURL();
    print("*************************** URL ==> "+imageUrl);
                               
   }

} 