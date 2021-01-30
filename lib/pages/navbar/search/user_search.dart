import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:login_page/constants.dart';
import 'package:login_page/database.dart';
import 'package:login_page/extra/chatpage/parts/conversation_room.dart';
import 'package:login_page/helpers.dart';
import 'package:login_page/parts/input_field_box.dart';


// class to create the search functionality in the direct message page
// also creates chat rooms between 2 users

class UserSearch extends StatefulWidget {
  @override
  _UserSearchState createState() => _UserSearchState();
}

String _myName;

class _UserSearchState extends State<UserSearch> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController searchEditingController = new TextEditingController();
  QuerySnapshot searchshot;
  


  
  @override
  void initState() {
    super.initState();
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
              Row(
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
              Text(userName),
              ],
              ),
            ],
          ),
          Spacer(),
          
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
  
  
  @override
  Widget build(BuildContext context) {
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
      body: Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: InputField(
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
