
class Partition {
  String date;
  String name;
  String url;

  Partition({this.date='', required this.name, required this.url});

  Map<String, dynamic> toJson(){
    return {
      'date': date,
      'name': name,
      'url' : url,
    };
  }

  factory Partition.fromJson(Map<String, dynamic> json){
    return Partition(date: json['date'], name: json['name'], url: json['url']);
  }

}