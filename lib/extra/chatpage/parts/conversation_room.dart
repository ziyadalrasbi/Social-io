import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:socialio/constants.dart';
import 'package:socialio/database.dart';
import 'package:socialio/helpers.dart';
import 'package:socialio/pages/profile/post_page.dart';
import 'package:socialio/parts/input_field_box.dart';
import 'package:flutter/widgets.dart';

class ConversationRoom extends StatefulWidget {
final String roomId;
ConversationRoom(this.roomId);

  @override
  _ConversationRoomState createState() => _ConversationRoomState();
}

TextEditingController messageController = new TextEditingController();
DatabaseMethods databaseMethods = new DatabaseMethods();
Stream textStream;




class _ConversationRoomState extends State<ConversationRoom> {
  
  


  Widget MessageList() {
    return Container(
      margin: EdgeInsets.only(bottom: 80),
      child: StreamBuilder(
        stream: textStream,
        builder: (context, snapshot) {
          return snapshot.hasData ? ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index){
              return TextTile(snapshot.data.docs[index].data()["message"],
              snapshot.data.docs[index].data()["sentBy"] == Constants.myName);          
              }) : Container();
        },
      ),
    );
  }


  sendMessage() {
    if(messageController.text.isNotEmpty) {
    Map<String,dynamic> textMap = {
      "message": messageController.text,
      "sentBy": Constants.myName,
      "time": DateTime.now().millisecondsSinceEpoch,
    };
    databaseMethods.addConvoText(widget.roomId, textMap);
    messageController.clear();
    }
  }

  @override
    void initState() {
      databaseMethods.getConvoText(widget.roomId).then((val){
        setState(() {
          textStream = val;        
        });
      });
      getUserInfo();
      super.initState();
    }

  getUserInfo() async {
    Constants.myAppBar = await HelperFunction.getProfileBarSharedPref();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
      body: Container(
        
        child: Stack(
          children: [
            MessageList(),
            
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  children: [
                    
                    Expanded(
                      child: TextField(
                        controller: messageController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Message...",
                          hintStyle: TextStyle(color: Colors.white54),
                          border: InputBorder.none
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () { 
                       sendMessage();
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        padding: EdgeInsets.all(12),
                        child: Image.asset("assets/icons/ICON_send.png")
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}


class TextTile extends StatefulWidget {
  final bool sentByMe;
  final String message;
  
  TextTile(this.message, this.sentByMe);

  @override
  _TextTileState createState() => _TextTileState();

}

class _TextTileState extends State<TextTile> {

var url;
String image = "";
  printImage() async {
    final ref =
                FirebaseStorage.instance.ref().child(widget.message.toString());
            url = await ref.getDownloadURL();
            setState(() {
              image = url.toString();
            });
  } 

  
  @override
  Widget build(BuildContext context) {
     
    if (!widget.message.startsWith("images/")) {
    return Container(
      padding: EdgeInsets.only(left: widget.sentByMe ? 0: 16, right: widget.sentByMe ? 16 : 0),
      margin: EdgeInsets.symmetric(vertical: 8),
      width: MediaQuery.of(context).size.width,
      alignment: widget.sentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 13),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: Constants.DarkModeBool == false ? (widget.sentByMe ? [
              Colors.indigo[600],
              Colors.indigo[600],
            ] :
            [ Colors.indigo[300],
              Colors.indigo[300],
            ]) : (widget.sentByMe ? [
              Colors.white,
              Colors.white,
            ] :
            [ Colors.black54,
              Colors.black54,
            ]), 
          ),
          borderRadius: widget.sentByMe ?
          BorderRadius.only(
            topLeft: Radius.circular(23),
            topRight: Radius.circular(23),
            bottomLeft: Radius.circular(23),
          ) :
          BorderRadius.only(
            topLeft: Radius.circular(23),
            topRight: Radius.circular(23),
            bottomRight: Radius.circular(23),
        )
      ),
      child: Text(
        widget.message, 
        style: TextStyle(
          color: widget.sentByMe ? Colors.black : Colors.white,
          fontSize: 16
          ),
      ),
      ),
    );
  } else {
     printImage();
      if (url != null) {
    return Container(
      padding: EdgeInsets.only(left: widget.sentByMe ? 0: 16, right: widget.sentByMe ? 16 : 0),
      margin: EdgeInsets.symmetric(vertical: 8),
      width: MediaQuery.of(context).size.width,
      alignment: widget.sentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: Constants.DarkModeBool == false ? (widget.sentByMe ? [
              Colors.indigo[600],
              Colors.indigo[600],
            ] :
            [ Colors.indigo[300],
              Colors.indigo[300],
            ]) : (widget.sentByMe ? [
              Colors.white,
              Colors.white,
            ] :
            [ Colors.black54,
              Colors.black54,
            ]), 
          ),
          borderRadius: widget.sentByMe ?
          BorderRadius.only(
            topLeft: Radius.circular(23),
            topRight: Radius.circular(23),
            bottomLeft: Radius.circular(23),
          ) :
          BorderRadius.only(
            topLeft: Radius.circular(23),
            topRight: Radius.circular(23),
            bottomRight: Radius.circular(23),
        )
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PostPage(widget.message.toString())),
                );
        },
        child: Container(
          height: 300,
          width: 300,
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 0,
            bottom: 24,
          ),
          // constraints: BoxConstraints(maxHeight: 50),

          decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill,
                image: NetworkImage(image)),
          )
          
          ),
      ),
      ),
    );
  } else {
    return Container();
  }
  }
  } 
}