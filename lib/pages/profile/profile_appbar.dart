import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:socialio/constants.dart';
import 'package:socialio/helpers.dart';
import 'package:socialio/parts/button.dart';


class ProfileAppBar extends StatefulWidget {
  @override
  _ProfileAppBarState createState() => _ProfileAppBarState();
}

class _ProfileAppBarState extends State<ProfileAppBar> {
  List<String> appbars = [
  "assets/appbars/Original.png",
  "assets/appbars/Black and White.png",
  "assets/appbars/Green.png",
  "assets/appbars/Inverted.png",
  "assets/appbars/Orange.png",
  "assets/appbars/Plain.png",
  "assets/appbars/Red.png",
  ];

List<String> categories = [
  "Appbars"
];

String chosen = "";


@override
  void initState() {
    getUserInfo();
    printImages();
    displayPics();
    super.initState();
  }

  getUserInfo() async {
    Constants.myAppBar = await HelperFunction.getProfileBarSharedPref();
  }

printImages() {
    return List.generate(appbars.length, (index) {
      return GestureDetector(
        onTap: () async {
          chosen = appbars[index];
          setState(() {          
          });
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(40),
            ),
          ),
          child: new Image.asset(
            appbars[index],
            ),
        ),
      );
    });
  }

  displayPics() {
    return GridView.count(
      childAspectRatio: 2,
      crossAxisCount: 1,
      crossAxisSpacing: 6,
      mainAxisSpacing: 8,
      physics: BouncingScrollPhysics(),
      children: printImages(),
    );
  }

returnChosenImage() {
  if (chosen.length > 2) {
    return chosen.substring(15, chosen.length-4);
  } else {
    return "";
  }
}

updateProfileAppbar() async {
 FirebaseFirestore.instance
    .collection('users')
    .where('username', isEqualTo: Constants.myName)
    .get()
    .then((querySnapshot) {
      querySnapshot.docs.forEach((result) async {      
          FirebaseFirestore.instance
          .collection('users')
          .doc(result.id)
          .update({'appbar': chosen,});   
          setState(() {
          }); 
          HelperFunction.saveProfileBarSharedPref(chosen);
    });
  });
}



  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
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
              text: "Set appbar to: "+ returnChosenImage(),
              textColor: Colors.white,
              pressed: () {
                updateProfileAppbar();
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}