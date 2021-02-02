import 'package:flutter/material.dart';
import 'package:socialio/constants.dart';
import 'package:socialio/extra/chatpage/parts/conversation_room.dart';
import 'package:socialio/helpers.dart';


class Profile extends StatefulWidget {
  @override
  _Profile1State createState() => _Profile1State();
}

class _Profile1State extends State<Profile> {

  int listCount = 0;
  bool listWanted = false;
  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    Constants.myName = await HelperFunction.getUserNameSharedPref();
    Constants.accType = await HelperFunction.getUserTypeSharedPref();
    
      setState(() {       
      });

  }
  

  printImages() {
    return List.generate(12, (index) {
        return GestureDetector(
          onTap: () {
            return ThemeData.from(colorScheme: ColorScheme.dark());
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
              
              image: DecorationImage(
                
                image: AssetImage("assets/images/pic" +
                    index.toString() +
                    ".jpg"),
                    
                fit: BoxFit.cover,
                
              ),
            ),
          ),
        );
      });
  }

  displayPics() {
    return GridView.count(
      crossAxisCount: 3,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      physics: BouncingScrollPhysics(),
      children: printImages(),
    );
  }

  

  displayPicsList() {
    return GridView.count(
      crossAxisCount: 1,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      physics: BouncingScrollPhysics(),
      children: printImages(),
    );
  }

  



  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
      
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                Container(
                  height: size.height * 0.40,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/background.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 36,
                      ),
                      CircleAvatar(
                        radius: 48,
                        backgroundImage:
                            AssetImage("assets/images/wrestler.png"),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        Constants.myName,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        "Flutter " + Constants.accType,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      Container(
                        height: 64,
                        color: Colors.black.withOpacity(0.4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Expanded(
                              child: Container(),
                            ),
                            
                            Container(
                              width: 110,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "FOLLOWING",
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    "364",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 110,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "FOLLOWERS",
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    "175",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Container(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Material(
                  elevation: 1,
                  child: Container(
                    
                    height: 56,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            listCount++;
                            setState(() {
                                listWanted = false;                          
                            });
                          },
                          child: Icon(
                          Icons.grid_view,
                          color: listWanted ? Colors.grey : Colors.black,
                          size: 28,
                          ),
                        ),
                        
                        
                        
                        GestureDetector(
                          onTap: () {
                            setState(() {
                                listWanted = true;                      
                            });
                            
                          },
                          child: Icon(
                          Icons.view_list,
                          color: listWanted ? Colors.black : Colors.grey,
                          size: 30,
                          ),
                        ),
                        
                      ],
                    ),
                  ),
                ),
                Container(
                  height: size.height * 0.60 - 56,
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 0,
                    bottom: 24,
                  ),
                  child: listWanted ? displayPicsList() : displayPics(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
