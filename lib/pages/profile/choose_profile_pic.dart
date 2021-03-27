import 'package:flutter/material.dart';
import 'package:socialio/constants.dart';
import 'package:socialio/pages/profile/profilepicpages/animal_profiles.dart';

import '../../helpers.dart';

class ChooseProfilePic extends StatefulWidget {
  @override
  _ChooseProfilePicState createState() => _ChooseProfilePicState();
}

class _ChooseProfilePicState extends State<ChooseProfilePic> {
  @override
  void initState() {
    getUserInfo();
    super.initState();
  }
  getUserInfo() async {
    Constants.myAppBar = await HelperFunction.getProfileBarSharedPref();
  }
  @override
  Widget build(BuildContext context) {
    Size dimensions = MediaQuery.of(context).size;
    return Scaffold(
      
      appBar: AppBar(
        centerTitle: true,
        flexibleSpace: Container(
          width: dimensions.width * 0.5,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(Constants.myAppBar.toString()),
              fit: BoxFit.fill,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
      ),

      // 6 navigate botton
      body: Center(
        
          child: Column(
        children: [
          Container(
            color: Colors.black,
            width: dimensions.width,
            height: 2,
          ),
          GestureDetector(
            onTap: (){
              Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (context) => AnimalProfilePicPage()
                  ),
                );
            },
            child: Container(
              color: Colors.transparent,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                    
                    Text(
                      "Animals", 
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    Container(
                      
                      alignment: Alignment.centerRight,
                    child: Icon(Icons.keyboard_arrow_right_rounded),
                    ),
                    
                ],
              ),
            ),
          ),
          Container(
            color: Colors.black,
            width: dimensions.width,
            height: 2,
          ),
        ],
      )),
    );
  }
}