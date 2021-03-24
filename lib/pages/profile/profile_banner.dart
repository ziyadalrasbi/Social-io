import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:socialio/constants.dart';
import 'package:socialio/helpers.dart';
import 'package:socialio/parts/button.dart';


class ProfileBanner extends StatefulWidget {
  @override
  _ProfileBannerState createState() => _ProfileBannerState();
}

class _ProfileBannerState extends State<ProfileBanner> {
  List<String> bannerscity = [
  "assets/banners/city/city1.png",
  "assets/banners/city/city2.png",
  "assets/banners/city/city3.png",
  "assets/banners/city/city4.png",
  "assets/banners/city/city5.png",
];

List<String> categories = [
  "Cities",
  "Gamers",
  "Landscapes",
  "Night Skies"
];

String chosen = "";


@override
  void initState() {
    getUserInfo();
    printImagesCity();
    displayPicsCity();
    super.initState();
  }

  getUserInfo() async {
    Constants.myAppBar = await HelperFunction.getProfileBarSharedPref();
  }

printImagesCity() {
    return List.generate(bannerscity.length, (index) {
      return GestureDetector(
        onTap: () async {
          chosen = bannerscity[index];
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
            bannerscity[index],
            ),
        ),
      );
    });
  }

  displayPicsCity() {
    return GridView.count(
      childAspectRatio: 1.5,
      crossAxisCount: 2,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      physics: BouncingScrollPhysics(),
      children:  printImagesCity(), 
      
    );
  }

returnChosenImage() {
  if (chosen.length > 2) {
    return chosen.substring(15, chosen.length-4);
  } else {
    return "";
  }
}

updateProfileBanner() async {
 FirebaseFirestore.instance
    .collection('users')
    .where('username', isEqualTo: Constants.myName)
    .get()
    .then((querySnapshot) {
      querySnapshot.docs.forEach((result) async {      
          FirebaseFirestore.instance
          .collection('users')
          .doc(result.id)
          .update({'banner': chosen,});   
          setState(() {
          }); 
          HelperFunction.saveProfileBannerSharedPref(chosen);
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
          SizedBox(height: 10,),
          Expanded(
          child: displayPicsCity(),
          ),
          SizedBox(height: 10,),
          Text(
            categories[0], 
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10,),
          Expanded(
          child: displayPicsCity(),
          ),
          SizedBox(height: 10,),
           Container(
            alignment: Alignment.bottomCenter,
            child: MainButton(
              color: Colors.indigo[500],
              text: "Set profile picture to: "+ returnChosenImage(),
              textColor: Colors.white,
              pressed: () {
                updateProfileBanner();
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}