import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:socialio/constants.dart';
import 'package:socialio/database.dart';
import 'package:socialio/extra/chatpage/parts/conversation_room.dart';
import 'package:socialio/helpers.dart';
import 'package:socialio/parts/input_field_box.dart';


// class to create the search functionality in the direct message page
// also creates chat rooms between 2 users

class ChatSearch extends StatefulWidget {
  @override
  _ChatSearchState createState() => _ChatSearchState();
}

String _myName;

class _ChatSearchState extends State<ChatSearch> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController searchEditingController = new TextEditingController();
  QuerySnapshot searchshot;
  


  
  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    Constants.myAppBar = await HelperFunction.getProfileBarSharedPref();
    setState(() {
      
    });
  }

  Widget listSearch() {
    return searchshot != null ? ListView.builder(
      itemCount: searchshot.docs.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return SearchTile(
          userName: searchshot.docs[index].data()["username"],
          userEmail: searchshot.docs[index].data()["email"],
        );
      }) : Container();
  }

  initSearch() {
    databaseMethods.getUsername(searchEditingController.text)
    .then((val){
      setState(() {
        searchshot = val;
        searchEditingController.clear();
      });
    });
  }

  Widget SearchTile({String userName, String userEmail}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(userName),
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              createChat(
                userName: userName,
              );
            },
            child: Container(
              color: primaryDarkColour,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Text("Message"),
            ),
          ),
        ],
      ),
    );
  }
  createChat({String userName}) {
    if (userName != Constants.myName) {
    String roomId = getRoomId(userName, Constants.myName);
    List<String> users = [userName, Constants.myName];
    Map<String, dynamic> roomMap = {
      "users": users,
      "roomId": roomId,
    };
    DatabaseMethods().createChat(roomId, roomMap);
    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => ConversationRoom(roomId)
        ),
      );
    } else {
      print("Can't chat with yourself!");
    }
  }

  returnAppBar() {
    Size size = MediaQuery.of(context).size;
    if (kIsWeb) {
      return AppBar(
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
      );
    } else {
      return AppBar(
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
        );
    }
  }
  
  
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: returnAppBar(),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: InputField(
                        color: Colors.blueGrey[200],
                        control: searchEditingController,
                        hint: "Search for users",
                        changes: (val) {
                        },
                      ),
                    ),
                    FloatingActionButton(
                      onPressed: () { 
                        initSearch();
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        padding: EdgeInsets.all(12),
                        child: Image.asset("assets/icons/ICON_search.png")),
                    ),
                  ],
                ),
              ),
              listSearch(),
            ],
          ),
        ),
      ),
    );
  }
}

getRoomId(String x, String y) {
  if (x.substring(0,1).codeUnitAt(0) > y.substring(0,1).codeUnitAt(0)) {
    return "$y\_$x";
  } else {
    return "$x\_$y";
  }
}
