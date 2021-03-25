import 'package:flutter/material.dart';
import 'package:socialio/constants.dart';
import 'package:socialio/helpers.dart';
import 'package:socialio/pages/profile/profile_appbar.dart';
import 'package:socialio/pages/profile/profile_banner.dart';
import 'package:socialio/pages/profile/profile_pic.dart';



class ProfileSettings extends StatefulWidget {
  @override
  _ProfileSettingsState createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
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
                  builder: (context) => ProfilePicPage()
                  ),
                );
            },
            child: Container(
              color: Colors.transparent,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                    
                    Text(
                      "Edit Profile Picture", 
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
          GestureDetector(
            onTap: (){
              Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (context) => ProfileBanner()
                  ),
                );
            },
            child: Container(
              color: Colors.transparent,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                    
                    Text(
                      "Edit Profile Banner", 
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
          
          GestureDetector(
            onTap: (){
            },
            child: Container(
              color: Colors.transparent,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                    Text(
                      "Edit Profile Border", 
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
          
          GestureDetector(
            onTap: (){
              Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (context) => ProfileAppBar()
                  ),
                );
            },
            child: Container(
              color: Colors.transparent,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                    
                    Text(
                      "Edit Appbar", 
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