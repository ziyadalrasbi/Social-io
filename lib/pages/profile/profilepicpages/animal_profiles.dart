import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:socialio/pages/camera/parts/body.dart';
import 'package:socialio/parts/button.dart';

import '../../../constants.dart';
import '../../../helpers.dart';

class AnimalProfilePicPage extends StatefulWidget {
  @override
  _AnimalProfilePicPageState createState() => _AnimalProfilePicPageState();
}

class _AnimalProfilePicPageState extends State<AnimalProfilePicPage> {


Map<String,int> banners = {
  "assets/profilepics/animals/animal1.png": 0,
  "assets/profilepics/animals/animal2.png": 7,
  "assets/profilepics/animals/animal3.png": 10,
  "assets/profilepics/animals/animal4.png": 11,
  "assets/profilepics/animals/animal5.png": 12,
  "assets/profilepics/animals/animal6.png": 13,
  "assets/profilepics/animals/animal7.png": 15,
  "assets/profilepics/animals/animal8.png": 20,
  "assets/profilepics/animals/animal9.png": 25,
  "assets/profilepics/animals/animal10.png": 30,
  "assets/profilepics/animals/animal11.png": 50,
};


List<String> categories = [
  "Animals"
];

String chosen = "";
int totallikes = 0;
var bannernames;
var bannervalues;
bool requiredPointsBool;
@override
  void initState() {
    requiredPointsBool = true;
    getUserInfo();
    getTotalLikes();
    printImages();
    displayPics();
    super.initState();
  }

  getUserInfo() async {
    Constants.myAppBar = await HelperFunction.getProfileBarSharedPref();
    Constants.myTotalLikes = await HelperFunction.getTotalLikesSharedPref();
  }

  getTotalLikes() async {
    FirebaseFirestore.instance
    .collection('uploads')
    .doc(Constants.myName)
    .collection('images').where('username', isEqualTo: Constants.myName)
    .get()
    .then((querySnapshot) {
      querySnapshot.docs.forEach((result) async {
        totallikes+= result.data()['upvotes'];
      setState(() {
        
      });
      });
    });
  }

  returnImageColor(int index) {
    if (totallikes < bannervalues[index]) {
      return Colors.grey;
    } else {
      return Colors.transparent;
    }
  }

  checkLikes(int index) {

  }

printImages() {
  bannernames = banners.keys.toList(); 
  bannervalues = banners.values.toList();
    return List.generate(banners.length, (index) {
      print(requiredPointsBool);
      return GestureDetector(
        onTap: () async {
          chosen = bannernames[index];
          if (totallikes < bannervalues[index]) {
              requiredPointsBool = false;
          } else {
              requiredPointsBool = true;
          }
          setState(() {          
          });
        },
        child: Column(
          children:[ 
            Container(
            foregroundDecoration: BoxDecoration(
              color: returnImageColor(index),
              backgroundBlendMode: BlendMode.saturation,
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: new Image.asset(
             bannernames[index],
             
              ),
          ),
          Text(bannervalues[index].toString()),
          ]),
      );
    });
  }

  displayPics() {
    return GridView.count(
      childAspectRatio: 0.7,
      crossAxisCount: 3,
      crossAxisSpacing: 8,
      mainAxisSpacing: 4,
      physics: BouncingScrollPhysics(),
      children: printImages(),
    );
  }

returnChosenImage() {
  if (chosen.length > 2) {
    return chosen.substring(27, chosen.length-4);
  } else {
    return "";
  }
}

updateProfilePic() async {
 FirebaseFirestore.instance
    .collection('users')
    .where('username', isEqualTo: Constants.myName)
    .get()
    .then((querySnapshot) {
      querySnapshot.docs.forEach((result) async {      
          FirebaseFirestore.instance
          .collection('users')
          .doc(result.id)
          .update({'profilepic': chosen,});   
          setState(() {
          }); 
          HelperFunction.saveProfilePicSharedPref(chosen);
    });
  });
}

updateUploadProfilePics() async {
  FirebaseFirestore.instance
    .collection("uploads")
    .doc(Constants.myName)
    .collection('images')
    .get()
    .then((querySnapshot) {
  querySnapshot.docs.forEach((result) async {
    FirebaseFirestore.instance
        .collection("uploads")
        .doc(Constants.myName)
        .collection("images")
        .doc(result.id)
        .update({'profilepic': chosen,});
      });
    });
}



  returnAppBar() {
    Size size = MediaQuery.of(context).size;
    if (kIsWeb) {
      return AppBar(
          backgroundColor: Colors.blue,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
              "assets/icons/LOGONEW.png", 
              height: 50, 
              alignment: Alignment.center,
            ),
          ],
        ),
      );
    } else {
      return AppBar(
          centerTitle: true,
          flexibleSpace: Container(
            width: size.width * 0.5,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(Constants.myAppBar.toString()),
                fit: BoxFit.fill,
              ),
            ),
          ),
          backgroundColor: Colors.transparent,
        );
    }
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: returnAppBar(),
      body: Column(
        children: <Widget>[
          SizedBox(height: 10,),
          Text(
            "Your total likes: " + totallikes.toString(), 
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 10,
          ),

          Expanded(
          child: displayPics(),
          ),
           Container(
            alignment: Alignment.bottomCenter,
            child: MainButton(
              color: Colors.indigo[500],
              text: requiredPointsBool == true ? "Set profile picture to: "+ returnChosenImage() : "Not enough points for this image. Please select another.",
              textColor: requiredPointsBool == true ? Colors.white : Colors.red,
              pressed: () {
                if (requiredPointsBool == true && chosen.length>2) {
                updateProfilePic();
                updateUploadProfilePics();
                Navigator.pop(context);
                } 
              },
            ),
          ),
        ],
      ),
    );
  }
}