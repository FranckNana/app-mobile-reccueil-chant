// ignore_for_file: import_of_legacy_library_into_null_safe, prefer_typing_uninitialized_variables

import 'dart:io';

import 'package:custom_alert_dialog_box/custom_alert_dialog_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker_gallery_camera/image_picker_gallery_camera.dart';
import 'package:song_app/model/partition.model.dart';
import 'package:song_app/repository/partition.repos.dart';
import 'package:song_app/screens/partition_screen.dart';

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _TakePictureScreen createState() => _TakePictureScreen();
}

class _TakePictureScreen extends State<TakePictureScreen> {
  final _formKey = GlobalKey<FormState>();
  final myController = TextEditingController();

  var _image;

  Future getImage(ImgSource source) async {
    var image = await ImagePickerGC.pickImage(
      enableCloseButton: true,
      closeIcon: const Icon(
        Icons.close,
        color: Colors.red,
        size: 12,
      ),
      context: context,
      source: source,
      barrierDismissible: true,
      cameraIcon: const Icon(
        Icons.camera_alt,
        color: Colors.red,
      ), //cameraIcon and galleryIcon can change. If no icon provided default icon will be present
      cameraText: const Text(
        "From Camera",
        style: TextStyle(color: Colors.red),
      ),
      galleryText: const Text(
        "From Gallery",
        style: TextStyle(color: Colors.blue),
      )
    );
    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ma galerie"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 300,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        //border: InputBorder.none,
                        hintText: 'Ajouter un titre',
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
                SizedBox(
                  width: 300,
                  child: ElevatedButton(
                    onPressed: () => getImage(ImgSource.Gallery),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                    ),
                    child: Text(
                      "From Gallery".toUpperCase(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  width: 300,
                  child: ElevatedButton(
                    onPressed: () => getImage(ImgSource.Camera),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.deepPurple,
                    ),
                    child: Text(
                      "From Camera".toUpperCase(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  width: 300,
                  child: ElevatedButton(
                    onPressed: () => getImage(ImgSource.Both),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                    ),
                    child: Text(
                      "Both".toUpperCase(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          if (_image!=null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Sauvegarde terminée')
                              ),
                            );
                            PartitionsData().uploadFile(File(_image.path));
                            Get.off(const PartitionScreen());
                          } else {
                            await CustomAlertDialogBox.showCustomAlertBox(
                                context: context,
                                willDisplayWidget: const Text('vous n\'avez pas choisi d\'image'),
                            );
                          }
                        }
                      },
                      child: const Text('Submit'),
                    ),
                  ),
                ),
                _image != null ? Padding(
                  padding: const EdgeInsets.only(top: 20.0, left: 30, right: 30,),
                  child: Image.file(
                    File(_image.path)
                  )
                ) : Container(),
              ],
            ),
          ),
        ),
      ),
    );

  }

}