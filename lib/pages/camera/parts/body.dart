import 'dart:io';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:socialio/constants.dart';
import 'package:socialio/database.dart';
import 'package:socialio/helpers.dart';
import 'package:socialio/pages/navbar/bottombar.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socialio/parts/input_field_box.dart';

//import 'package:permission_handler/permission_handler.dart';

TextEditingController captionController = TextEditingController();
TextEditingController searchController = TextEditingController();
List<String> taggedUsers = [];
class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(brightness: Brightness.light),
      home: ImageCapture(),
    );
  }
}




//widget to capture and crop the image
class ImageCapture extends StatefulWidget {
  createState() => _ImageCaptureState();
}

class _ImageCaptureState extends State<ImageCapture> {
  //Active image file
  File _imageFile;
  
  Future<void> _pickImage(ImageSource source) async {
    final _picker = ImagePicker();
    PickedFile selected = await _picker.getImage(source: source);
    
    setState(() {
      _imageFile = File(selected.path);
    });
  }

  void _clear() {
    setState(() => _imageFile = null);
  }

  Future<void> _cropImage() async {
    File cropped = await ImageCropper.cropImage(
      sourcePath: _imageFile.path,
      //maxWidth: 512,
      //maxHeight: 512,
      androidUiSettings: AndroidUiSettings(
          toolbarColor: Colors.purple,
          toolbarWidgetColor: Colors.white,
          toolbarTitle: 'Crop It'),
    );

    setState(() {
      _imageFile = cropped ?? _imageFile;
    });
  }

  QuerySnapshot searchshot;
DatabaseMethods databaseMethods = new DatabaseMethods();

Widget listSearch() {
    return searchshot != null ? ListView.builder(
      itemCount: searchshot.docs.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return SearchTile(
          userName: searchshot.docs[index].data()["username"],
          userEmail: searchshot.docs[index].data()["email"],
        );
      }) : Container();
  }

  initSearch() {
    databaseMethods.getUsername(searchController.text)
    .then((val){
      setState(() {
        searchshot = val;
      });
    });
  }

  Widget SearchTile({String userName, String userEmail}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(userName),
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              taggedUsers.add(searchController.text);
              print(taggedUsers);
              searchController.clear();
            },
            child: Container(
              color: primaryDarkColour,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Text("Tag"),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.photo_camera),
              onPressed: () => _pickImage(ImageSource.camera),
            ),
            IconButton(
              icon: Icon(Icons.photo_library),
              onPressed: () => _pickImage(ImageSource.gallery),
            ),
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                searchController.clear();
                captionController.clear();
                taggedUsers = [];
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BottomBar()),
                );
              },
            ),
          ],
        ),
      ),
      body: ListView(
        children: <Widget>[
          if (_imageFile != null) ...[
            Image.file(_imageFile),
            InputField(
              hint: "Enter a caption (optional)",
              control: captionController,
              changes: (value) {},
            ),
            Row(
                children: [
                  Expanded(
                    child: InputField(
                      color: Colors.blueGrey[200],
                      control: searchController,
                      hint: "Search for users",
                      changes: (val) {
                      },
                    ),
                  ),
                  FloatingActionButton(
                    onPressed: () { 
                      initSearch();
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      padding: EdgeInsets.all(12),
                      child: Image.asset("assets/icons/ICON_search.png")),
                  ),
                ],
                
              ),
              listSearch(),
            Row(
              children: <Widget>[
                FlatButton(
                  child: Icon(Icons.crop),
                  onPressed: _cropImage,
                ),
                FlatButton(
                  child: Icon(Icons.refresh),
                  onPressed: _clear,
                ),
                Uploader(file: _imageFile,)
              ],
            ),
          ]
        ],
      ),
      
    );
  }
}



class Uploader extends StatefulWidget {
  final File file;
  
  
  Uploader({Key key, this.file,}) : super(key: key);

  createState() => _UploaderState();
}

class _UploaderState extends State<Uploader> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  final FirebaseStorage _storage =
      FirebaseStorage.instanceFor(bucket: 'gs://social-io-102b4.appspot.com/');
      FirebaseAuth auth = FirebaseAuth.instance;
  List<String> files;
      
  UploadTask _uploadTask;
@override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    Constants.myName = await HelperFunction.getUserNameSharedPref();
    databaseMethods.getUsername(Constants.myName).then((val){
    setState(() {  
    });
  });
  
  }
  

  void _startUpload() {
    String uid = auth.currentUser.uid.toString();
    String filePath = 'images/${DateTime.now()}.png';
    Map<String,dynamic> uploadMap = {
      "username": Constants.myName,
    };
    databaseMethods.uploadImage(Constants.myName, uploadMap);

    Map<String,dynamic> imageMap = {
      "username": Constants.myName,
      "imageid": filePath,
      "time": DateTime.now().millisecondsSinceEpoch,
      "upvotes": 0,
      "caption": captionController.text,
      "tagged": taggedUsers,
    };
    databaseMethods.addImage(Constants.myName, imageMap);

    setState(() {
      captionController.clear();
      _uploadTask = _storage.ref().child(filePath).putFile(widget.file);
      _uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) { 
        print('Snapshot state: ${snapshot.state}');
        print('Progess: ${snapshot.totalBytes / snapshot.bytesTransferred}');
      }, onError: (Object e) {
        print(e);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
        return FlatButton.icon(
        label: Text('Upload to Firebase'),
        icon: Icon(Icons.cloud_upload),
        onPressed: 
           _startUpload,
      );
  }
 
}
