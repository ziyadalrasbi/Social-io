import 'package:flutter/material.dart';
import 'package:socialio/constants.dart';
import 'package:socialio/database.dart';
import 'package:socialio/extra/chatpage/parts/background.dart';
import 'package:socialio/extra/chatpage/parts/chat_search.dart';
import 'package:socialio/extra/chatpage/parts/conversation_room.dart';
import 'package:socialio/helpers.dart';



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
        ) : SizedBox(height: 0, width: 0);
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
    Constants.myAppBar = await HelperFunction.getProfileBarSharedPref();
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
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar:AppBar(
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
      actions: <Widget>[
              FloatingActionButton(
                backgroundColor: Colors.transparent,
                child:
                  Image.asset(
                  'assets/icons/ICON_search.png',
                  
                  ),
                  onPressed: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(
                        builder: (context) => ChatSearch(),
                    ),
                  );
                },
              ),
            ],
        ),
            
        body: Background(
          
          body: roomList(),
          child: Column(
            children: [
              
            ],
          ),
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
            builder: (context) => ConversationRoom(chatRoom),
          ),
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

  












