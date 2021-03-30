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
  
Map<String, int> appbars = {
    "assets/appbars/Original.png" : 0,
    "assets/appbars/Plain.png": 10,
    "assets/appbars/Green.png": 50,
    "assets/appbars/Orange.png": 50,
    "assets/appbars/Red.png": 50,
    "assets/appbars/Inverted.png": 100,
    "assets/appbars/Black and White.png": 500,
  };



String chosen = "";
int totallikes = 0;
var appbarvalues;
var appbarnames;
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
    if (totallikes < appbarvalues[index]) {
      return Colors.grey;
    } else {
      return Colors.transparent;
    }
  }

  checkLikes(int index) {

  }

printImages() {
  appbarnames = appbars.keys.toList(); 
  appbarvalues = appbars.values.toList();
    return List.generate(appbars.length, (index) {
      return GestureDetector(
        onTap: () async {
          chosen = appbarnames[index];
          if (totallikes < appbarvalues[index]) {
            
              requiredPointsBool = false;
            
          } else {
            
              requiredPointsBool = true;
           
          }
          setState(() {          
          });
        },
        child: Column(
          children:[ 
            Text(
              appbarnames[index].toString().substring(15, appbarnames[index].toString().length-4),
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),

            Container(
            foregroundDecoration: BoxDecoration(
              color: returnImageColor(index),
              backgroundBlendMode: BlendMode.saturation,
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: new Image.asset(
             appbarnames[index],
             
              ),
          ),
          Text(appbarvalues[index].toString()),
          ]),
      );
    });
  }

  displayPics() {
    return GridView.count(
      childAspectRatio: 1.5,
      crossAxisCount: 1,
      crossAxisSpacing: 8,
      mainAxisSpacing: 4,
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
              text: requiredPointsBool == true ? "Set profile appbar to: "+ returnChosenImage() : "Not enough points for this image. Please select another.",
              textColor: requiredPointsBool == true ? Colors.white : Colors.red,
              pressed: () {
                if (requiredPointsBool == true && chosen.length>2) {
                updateProfileAppbar();
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