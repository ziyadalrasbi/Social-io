import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_page/constants.dart';
import 'package:login_page/database.dart';
import 'package:login_page/extra/chatpage/parts/background.dart';
import 'package:login_page/extra/chatpage/parts/chat_search.dart';
import 'package:login_page/extra/chatpage/parts/conversation_room.dart';
import 'package:login_page/helpers.dart';
import 'package:login_page/pages/signup/sign_up_first.dart';
import 'package:login_page/parts/account_recheck.dart';
import 'package:login_page/parts/button.dart';
import 'package:login_page/parts/input_field_box.dart';
import 'package:login_page/parts/password_field_box.dart';



class Body extends StatefulWidget {
 @override
 _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {

  DatabaseMethods databaseMethods = new DatabaseMethods();
  Stream roomStream;

  Widget roomList() {
    return StreamBuilder(
      stream: roomStream,
      builder: (context, snapshot) {
        return snapshot.hasData ? ListView.builder(
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index) {
            return RoomTile(
             snapshot.data.docs[index].data()["roomId"]
             .toString().replaceAll("_", "").replaceAll(Constants.myName, ""),
             snapshot.data.docs[index].data()["roomId"]
            );
          }
        ) : Container();
      },
    );
  }
  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    Constants.myName = await HelperFunction.getUserNameSharedPref();
    databaseMethods.getRooms(Constants.myName).then((val){
      setState(() {
        roomStream = val;        
      });
    });
    setState(() {  
    });
  }

  @override
  Widget build(BuildContext context) {
    return Background(
      body: roomList(),
      child: Column(
        children: [
          FloatingActionButton(
            child:
              Image.asset(
              'assets/icons/ICON_search.png',
              ),
              onPressed: () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (context) => ChatSearch(),
                ));
              },
          ),
        ],
      ),
    );
  }
}

class RoomTile extends StatelessWidget {
  final String userName;
  final String chatRoom;
  RoomTile(this.userName, this.chatRoom);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(
          context, 
          MaterialPageRoute(
            builder: (context) => ConversationRoom(chatRoom)
          )
        );
      },
      child: Container(
        color: Colors.black26,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: primaryDarkColour,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Text(
                "${userName.substring(0,1).toUpperCase()}", 
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  ),
              ),
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                userName, 
                style: TextStyle(
                  fontSize: 16
                ),
              ),
          ],
        ),
      ),
    );
  }
}

  












