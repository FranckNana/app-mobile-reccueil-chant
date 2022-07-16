import 'package:firebase_database/firebase_database.dart';
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
                                name: d['name'].length > 34 ? '${d['name'].substring(13, 34)}...' : d['name'].substring(13),  
                                url: d['url']);
        setPartitionsList(partition);
      }
    }
    return partitions;

  }

}