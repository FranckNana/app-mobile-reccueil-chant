
import 'package:firebase_database/firebase_database.dart';
import 'package:song_app/model/song.model.dart';

class SongData {

  List<Song> songs= [];

  void setPartitionsList(Song s) {
    songs.add(s);
  }

  Future<List<Song>> getSongsByType(String type) async{
    DatabaseReference database = FirebaseDatabase.instance.ref('Songs');
    DatabaseEvent event = await database.once();
    dynamic data = event.snapshot.value;

    if(data!=null){
      for(var d in data){
        if(d['type']==type){
          Song song = Song(
                    type: d['type'], 
                    title: d['title'], 
                    refrain: d['refrain'], 
                    couplet: d['couplet'] ?? []
                  );
          setPartitionsList(song);
        }
      }
    }

    return songs;

  }

}