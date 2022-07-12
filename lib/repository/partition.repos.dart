import 'package:firebase_database/firebase_database.dart';
import 'package:song_app/model/partition.model.dart';

class PartitionsData{

  List<Partition> partitions = [];

  init() {
    partitions = [];
    getPartition();
  }

  void setPartitionsList(Partition p) {
    partitions.add(p);
  }

  List<Partition> getPartitionsList() {
    return partitions;
  }

  Future<List<Partition>> getPartition() async {

    DatabaseReference database = FirebaseDatabase.instance.ref('partitionsFiles');

    /*database.onValue.listen((DatabaseEvent event) {
      dynamic data = event.snapshot.value;
      for(var d in data){
        Partition partition = Partition(date: d['date'], name: d['name'], url: d['url']);
        setPartitionsList(partition);
        //partitions.add(partition);
      }
    });
    print("SIZE "+partitions.length.toString());*/

    DatabaseEvent event = await database.once();
    dynamic data = event.snapshot.value;
    if(data!=null){
      for(var d in data){
        Partition partition = Partition(date: d['date'], name: d['name'], url: d['url']);
        setPartitionsList(partition);
      }
    }
    return partitions;

  }

  DatabaseReference getPartitionsRef(){
    DatabaseReference database = FirebaseDatabase.instance.ref('partitionsFiles');
    return database;
  }



}