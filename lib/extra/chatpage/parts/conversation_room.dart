import 'package:flutter/material.dart';
import 'package:socialio/constants.dart';
import 'package:socialio/database.dart';
import 'package:socialio/helpers.dart';
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


class TextTile extends StatelessWidget {
  final bool sentByMe;
  final String message;
  
  TextTile(this.message, this.sentByMe);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: sentByMe ? 0: 16, right: sentByMe ? 16 : 0),
      margin: EdgeInsets.symmetric(vertical: 8),
      width: MediaQuery.of(context).size.width,
      alignment: sentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 13),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: Constants.DarkModeBool == false ? (sentByMe ? [
              Colors.indigo[600],
              Colors.indigo[600],
            ] :
            [ Colors.indigo[300],
              Colors.indigo[300],
            ]) : (sentByMe ? [
              Colors.white,
              Colors.white,
            ] :
            [ Colors.black54,
              Colors.black54,
            ]), 
          ),
          borderRadius: sentByMe ?
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
        message, 
        style: TextStyle(
          color: sentByMe ? Colors.black : Colors.white,
          fontSize: 16
          ),
      ),
      ),
    );
  }
}