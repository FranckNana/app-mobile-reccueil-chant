
import 'dart:convert';
import 'dart:ffi';

import 'package:firebase_database/firebase_database.dart';
import 'package:song_app/model/partition.model.dart';

getPartition()async{
  DatabaseReference database = FirebaseDatabase.instance.ref('Songs');
  DatabaseEvent event = await database.once();
  print(event.snapshot.value);

  database.onValue.listen((DatabaseEvent event) {
    jsonDecode(event.snapshot.value.toString());
    dynamic data = event.snapshot.value;
    print("-----------------------\n");
    for(var d in data){
      print(d['type']);
      print(d['title']);
      print(d['refrain']);
      print(d['couplet']);
      print("-----------------------\n");
    }
});
}