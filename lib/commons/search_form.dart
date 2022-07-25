// ignore_for_file: no_logic_in_create_state, empty_constructor_bodies

import 'package:flutter/material.dart';
import 'package:search_page/search_page.dart';
import 'package:song_app/commons/utilsMethod.dart';
import 'package:song_app/model/partition.model.dart';
import 'package:song_app/model/song.model.dart';
import 'package:song_app/repository/partition.repos.dart';
import 'package:song_app/repository/song.repos.dart';

class SearchForm extends StatefulWidget {
  final BuildContext parentcontext;
  final double sizeX;
  final double sizeY;
  final bool isPartition;
  final String categorie;
  const SearchForm({required this.sizeX, required this.sizeY ,required this.isPartition, this.categorie="", required this.parentcontext, Key? key}) : super(key: key);

  @override
  State<SearchForm> createState() => _SearchFormState();
}

class _SearchFormState extends State<SearchForm> {

  final _formKey = GlobalKey<FormState>();
  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      child: Form(
          key: _formKey,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0, right:8.0),
                  child: TextFormField(
                    controller: myController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Recherche',
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Ecrivez quelque chose...';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              TextButton(
                child: const Icon(Icons.search_rounded),
                onPressed: () async {
                  // Validate will return true if the form is valid, or false if
                  // the form is invalid.
                  if (_formKey.currentState!.validate()) {
                    if(widget.isPartition){
                      await searchInPartitions();
                    }else{
                      await searchInSong();
                    }                     
                  }
                }
              ),
            ],
          ),
        ),
    );
  }

  Future<void> searchInPartitions() async {
    PartitionsData p = PartitionsData();
    List<Partition> partitions = await p.getPartition();
    
    ScaffoldMessenger.of(widget.parentcontext).showSnackBar(
      const SnackBar(
        duration: Duration(microseconds: 1000),
        content: Text('Recherche en cours...')
      ),
      
    );
    
    Future.delayed(const Duration(milliseconds: 1500), () { 
        setState(() { 
          showSearch(
            query: myController.text,
            context: widget.parentcontext,
            delegate: SearchPage<Partition>(
              //onQueryUpdate: (s) => print(s),
              items: partitions,
              searchLabel: 'Rechercher vos partitions',
              suggestion: const Center(
                child: Text('filtrer par le titre de la partitions'),
              ),
              failure: const Center(
                child: Text('Aucune Partition trouvée :('),
              ),
              filter: (partition) => [
                partition.name,
              ],
              builder: (partition) {
                return Utils().singleDataView(widget.sizeX, widget.sizeY, [partition]);
              } 
            )
          );
        }); 
    });
  }

  Future<void> searchInSong() async {
    SongData song = SongData();
    List<Song> songs = await song.getSongsByType(widget.categorie);
    
    ScaffoldMessenger.of(widget.parentcontext).showSnackBar(
      const SnackBar(
        duration: Duration(microseconds: 1000),
        content: Text('Recherche en cours...')
      ),
      
    );
    
    Future.delayed(const Duration(milliseconds: 1500), () { 
      // Here you can write your code 
        setState(() { 
          showSearch(
            query: myController.text,
            context: widget.parentcontext,
            delegate: SearchPage<Song>(
              //onQueryUpdate: (s) => print(s),
              items: songs,
              searchLabel: 'Rechercher vos chants',
              suggestion: const Center(
                child: Text('filtrer par le titre du chant'),
              ),
              failure: const Center(
                child: Text('Aucun chant trouvé :('),
              ),
              filter: (song) => [
                song.title,
              ],
              builder: (song) => Utils().songLine(song: song),
            )
          );
        }); 
    });
  }

  
}