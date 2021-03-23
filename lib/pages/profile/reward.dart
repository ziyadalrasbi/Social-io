

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:socialio/parts/button.dart';

import '../../constants.dart';
import '../../helpers.dart';

class Reward extends StatefulWidget {
  @override
  _RewardState createState() => _RewardState();
}

class _RewardState extends State<Reward> {
List<String> animalprofilepics = [
  "assets/profilepics/animals/animal1.png",
  "assets/profilepics/animals/animal2.png",
  "assets/profilepics/animals/animal3.png",
  "assets/profilepics/animals/animal4.png",
  "assets/profilepics/animals/animal5.png",
  "assets/profilepics/animals/animal6.png",
  "assets/profilepics/animals/animal7.png",
  "assets/profilepics/animals/animal8.png",
  "assets/profilepics/animals/animal9.png",
  "assets/profilepics/animals/animal10.png",
  "assets/profilepics/animals/animal11.png",
];

List<String> categories = [
  "Animals"
];

String chosen = "";


@override
  void initState() {
    printImages();
    displayPics();
    super.initState();
  }

printImages() {
    return List.generate(animalprofilepics.length, (index) {
      return GestureDetector(
        onTap: () async {
          chosen = animalprofilepics[index];
          setState(() {          
          });
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: new Image.asset(
            animalprofilepics[index],
            ),
        ),
      );
    });
  }

  displayPics() {
    return GridView.count(
      childAspectRatio: 1.5,
      crossAxisCount: 3,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
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



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
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
      ),
      body: Column(
        children: <Widget>[
          Text(
            categories[0], 
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          Expanded(
          child: displayPics(),
          ),
           Container(
            alignment: Alignment.bottomCenter,
            child: MainButton(
              color: Colors.indigo[500],
              text: "Set profile picture to: "+ returnChosenImage(),
              textColor: Colors.white,
              pressed: () {
                updateProfilePic();
                updateUploadProfilePics();
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}