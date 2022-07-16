
import 'package:firebase_database/firebase_database.dart';
import 'package:song_app/model/infos.model.dart';

class InfosData {

  List<Infos> infos= [];

  void setInfosList(Infos i) {
    infos.add(i);
  }

  Future<List<Infos>> getAllInfos() async{
    DatabaseReference database = FirebaseDatabase.instance.ref('Infos');
    DatabaseEvent event = await database.once();
    dynamic data = event.snapshot.value;

    if(data!=null){
      for(var d in data){
          Infos infos = Infos(title: d['title'], content: d['content']);
          setInfosList(infos);
      }
    }

    return infos;

  }

}