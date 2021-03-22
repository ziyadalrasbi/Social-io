

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
List<String> images = [
  "assets/images/wrestler.png",
  "assets/images/beach.png",
  "assets/images/bee.png",
  "assets/images/dog.png",
  "assets/images/glacier.png",
  "assets/images/penguin.png",
  "assets/images/rainbow.png",
  "assets/images/sloth.png",
  "assets/images/waterfall.png",
];

String chosen = "";


@override
  void initState() {
    printImages();
    displayPics();
    super.initState();
  }

printImages() {
    return List.generate(images.length, (index) {
      return GestureDetector(
        onTap: () async {
          chosen = images[index];
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
            images[index],
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
    return chosen.substring(14, chosen.length-4);
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
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}