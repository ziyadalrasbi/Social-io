import 'package:flutter/material.dart';
import 'package:socialio/extra/chatpage/chat_page.dart';
import 'package:socialio/extra/chatpage/parts/chat_search.dart';



class TargetPage extends StatefulWidget {
  @override
  _TargetPageState createState() => _TargetPageState();
}

class _TargetPageState extends State<TargetPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Container(
        child: ListView(
      children:[ 
        AppBar(
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
        actions: <Widget>[
          FlatButton(
                child:
                  Image.asset(
                  'assets/icons/ICON_inbox.png',
                  width: 45,
                  height: 45,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(
                        builder: (context) => ChatPage(),
                    ),
                  );
                },
              ),
        ],
      ),
      
      ]
      ),
      ),
    );
  }
}