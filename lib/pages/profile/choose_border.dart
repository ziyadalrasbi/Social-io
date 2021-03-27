import 'package:flutter/material.dart';
import 'package:socialio/constants.dart';
import 'package:socialio/helpers.dart';
import 'package:socialio/pages/profile/bannerpages/city_banners.dart';
import 'package:socialio/pages/profile/bannerpages/gamer_banners.dart';
import 'package:socialio/pages/profile/bannerpages/landscape_banners.dart';
import 'package:socialio/pages/profile/bannerpages/nightsky_banners.dart';
import 'package:socialio/pages/profile/borderpages/element_borders.dart';
import 'package:socialio/pages/profile/borderpages/prize_borders.dart';
import 'package:socialio/pages/profile/borderpages/standard_borders.dart';

class ChooseBorder extends StatefulWidget {
  @override
  _ChooseBorderState createState() => _ChooseBorderState();
}

class _ChooseBorderState extends State<ChooseBorder> {
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
                  builder: (context) => StandardBordersPage()
                  ),
                );
            },
            child: Container(
              color: Colors.transparent,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                    
                    Text(
                      "Standard", 
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
                  builder: (context) => ElementsBordersPage()
                  ),
                );
            },
            child: Container(
              color: Colors.transparent,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                    
                    Text(
                      "Elements", 
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
                  builder: (context) => PrizeBordersPage()
                  ),
                );
            },
            child: Container(
              color: Colors.transparent,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                    
                    Text(
                      "Prizes", 
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