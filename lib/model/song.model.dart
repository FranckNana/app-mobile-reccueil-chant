 
class Song {
  String type;
  String title;
  String refrain;
  List<Object?> couplet;

  Song({required this.type, required this.title, required this.refrain, this.couplet= const []});

}