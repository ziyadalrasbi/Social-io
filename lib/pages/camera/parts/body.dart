import 'dart:io';
import 'dart:ui' as ui;
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:socialio/constants.dart';
import 'package:socialio/database.dart';
import 'package:socialio/helpers.dart';


import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socialio/pages/navbar/parts/bottombar.dart';
import 'package:socialio/parts/input_field_box.dart';

//import 'package:permission_handler/permission_handler.dart';
bool faceDetected;
TextEditingController captionController = TextEditingController();
TextEditingController searchController = TextEditingController();
List<String> taggedUsers = [];



//widget to capture and crop the image
class ImageCapture extends StatefulWidget {
  createState() => _ImageCaptureState();
}

class _ImageCaptureState extends State<ImageCapture> {
  //Active image file
  File _imageFile;
  List<Face> _faces;
  ui.Image _image;
  final _picker = ImagePicker();
  bool isLoading = false;
  
  Future<void> _pickImage(ImageSource source) async {
    
    final imageFile = await _picker.getImage(source: source);
    setState(() {
      isLoading = true;
    });
    final image = FirebaseVisionImage.fromFile(File(imageFile.path));
    final faceDetector = FirebaseVision.instance.faceDetector();
    List<Face> faces = await faceDetector.processImage(image);
    
    if (mounted) {
      setState(() {
        _imageFile = File(imageFile.path);
        _faces = faces;
        _loadImage(File(imageFile.path));
        if (faces.length > 0) {
          faceDetected = true;
        } else {
          faceDetected = false;
        }
      });
    }
      
    

  }

  _loadImage(File file) async {
    final data = await file.readAsBytes();
    await decodeImageFromList(data).then((value) => setState((){
      _image = value;
      isLoading = false;
    }));
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
      resizeToAvoidBottomInset: false,
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
          if (isLoading == false) ...[
          if (_imageFile != null) ...[
            GestureDetector(
              onTap: () {
                print(faceDetected);
              },
              child: FittedBox(
                child: SizedBox(
                  width: _imageFile != null ? _image.width.toDouble() : Container(),
                  height: _imageFile != null ? _image.height.toDouble(): Container(),
                  child: CustomPaint(
                    painter: FacePainter(_image, _faces),
                    ),
                  ),
                ),
            ),
            InputField(
              hint: "Enter a caption (optional)",
              control: captionController,
              changes: (value) {},
            ),
            Expanded(
              child: InputField(
                color: Colors.blueGrey[200],
                control: searchController,
                hint: "Tag your post with a # (optional)",
                changes: (val) {},
              ),
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
          ] else ... [
            Container(),
          ]
        ] else ...[
          Center(child: CircularProgressIndicator(),),
        ],
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
  }

   List<String> badges = [];

  uploadMissionComplete() async {
    FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: Constants.myName)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) async {
        FirebaseFirestore.instance
            .collection('users')
            .doc(result.id)
            .update({'rewards': FieldValue.arrayUnion(['assets/badges/1.png'])});
      });
    });
  }

  cowMissionComplete() async {
    FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: Constants.myName)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) async {
        FirebaseFirestore.instance
            .collection('users')
            .doc(result.id)
            .update({'rewards': FieldValue.arrayUnion(['assets/badges/2.png'])});
      });
    });
  }

  tigerMissionComplete() async {
    FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: Constants.myName)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) async {
        FirebaseFirestore.instance
            .collection('users')
            .doc(result.id)
            .update({'rewards': FieldValue.arrayUnion(['assets/badges/5.png'])});
      });
    });
  }

  giraffeMissionComplete() async {
    FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: Constants.myName)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) async {
        FirebaseFirestore.instance
            .collection('users')
            .doc(result.id)
            .update({'rewards': FieldValue.arrayUnion(['assets/badges/3.png'])});
      });
    });
  }

  List elephant = ['assets/badges/4.png'];
  // String elephant = 'assets/badges/4.png';
  elephantMissionComplete() async {
    FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: Constants.myName)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) async {
        FirebaseFirestore.instance
            .collection('users')
            .doc(result.id)
            .update({'rewards': FieldValue.arrayUnion(['assets/badges/4.png'])});

      });
    });
  }
  

  void _startUpload() {
    String uid = auth.currentUser.uid.toString();
    String filePath = 'images/${DateTime.now()}.png';
    String profilepic;
    Map<String,dynamic> uploadMap = {
      "username": Constants.myName,
    };
    databaseMethods.uploadImage(Constants.myName, uploadMap);

    Map<String,dynamic> imageMap = {
      "username": Constants.myName,
      "imageid": filePath,
      "upvotes": 0,
      "caption": captionController.text,
      "tagged": searchController.text,
      "profilepic": Constants.myProfilePic,
      "time": DateTime.now().millisecondsSinceEpoch,
    };
    databaseMethods.addImage(Constants.myName, imageMap);

    if ( searchController.text == "cow" ) {
      cowMissionComplete();
    }
    if ( searchController.text == "giraffe") {
      giraffeMissionComplete();
    }
    if (searchController.text == "tiger" ) {
      tigerMissionComplete();
    }
    if (searchController.text == "elephant") {
      elephantMissionComplete();//4.png
    }
    if (true) {
      uploadMissionComplete();//1.png
    }
    setState(() {
      captionController.clear();
      _uploadTask = _storage.ref().child(filePath).putFile(widget.file);
      _uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) { 
        print('Snapshot state: ${snapshot.state}');
        print('Progess: ${snapshot.totalBytes / snapshot.bytesTransferred}');
        if (snapshot.totalBytes / snapshot.bytesTransferred == 1.0) {
          Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BottomBar()),
          );
        } else {
          return Center(child: CircularProgressIndicator(),);
        }
      }, onError: (Object e) {
        print(e);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if ( faceDetected == false) {
        return FlatButton.icon(
        label: Text('Post Image'),
        icon: Icon(Icons.cloud_upload),
        onPressed: 
           _startUpload,
      );
    } else {
      return Container(
        child: Expanded(
          child: RichText(
            overflow: TextOverflow.visible,
              text: TextSpan(
                
                  style:
                      TextStyle(color: Colors.black, fontSize: 12.0),
                  children: <TextSpan>[
                TextSpan(
                    text:
                        'Face detected. Please choose another picture.', //will be a username from firebase
                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                   
          )])),
        ),
      );
    }
  }
 
}

class FacePainter extends CustomPainter {
  final ui.Image image;
  final List<Face> faces;
  final List<Rect> rects = [];

  FacePainter(this.image, this.faces) {
    for (var i = 0; i < faces.length; i++) {
      rects.add(faces[i].boundingBox);
    }
  }

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.yellow;

    canvas.drawImage(image, Offset.zero, Paint());
    for (var i = 0; i < faces.length; i++) {
      canvas.drawRect(rects[i], paint);
      
      
    }
  }

  @override
  bool shouldRepaint(FacePainter old) {
    return image != old.image || faces != old.faces;
  }
}