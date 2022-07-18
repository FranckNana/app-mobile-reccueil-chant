// ignore_for_file: annotate_overrides, overridden_fields

import 'package:song_app/model/partition.model.dart';

class Programme extends Partition{
  String date;
  Programme({this.date='', required String name, required String url}) : super(name: name, url: url);

}