import 'package:firebase_database/firebase_database.dart';
import 'package:song_app/model/prog.model.dart';

class ProgData{

  List<Programme> programme = [];

  void setProgrammeList(Programme p) {
    programme.add(p);
  }

  Future<List<Programme>> getProgramme() async {

    DatabaseReference database = FirebaseDatabase.instance.ref('programFiles');

    DatabaseEvent event = await database.once();
    dynamic data = event.snapshot.value;
    if(data!=null){
      for(var d in data){
        Programme programme = Programme(
                                  date: d['date'], 
                                  name: d['name'].length > 34 ? '${d['name'].substring(13, 34)}...' : d['name'].substring(13), 
                                  url: d['url']
                              );
        setProgrammeList(programme);
      }
    }
    return programme;

  }

}