import 'package:flutter/material.dart';
import 'package:socialio/constants.dart';
import 'package:socialio/database.dart';
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
    return StreamBuilder(
      stream: textStream,
      builder: (context, snapshot) {
        return snapshot.hasData ? ListView.builder(
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index){
            return TextTile(snapshot.data.docs[index].data()["message"],
            snapshot.data.docs[index].data()["sentBy"] == Constants.myName);          
            }) : Container();
      },
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
      super.initState();
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                      child: InputField(
                        color: Colors.blueGrey[200],
                        control: messageController,
                        hint: "Message...",
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
      padding: EdgeInsets.only(left: sentByMe ? 0: 24, right: sentByMe ? 24 : 0),
      margin: EdgeInsets.symmetric(vertical: 8),
      width: MediaQuery.of(context).size.width,
      alignment: sentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: sentByMe ? [
              primaryDarkColour,
              Colors.white,
            ] :
            [ primaryDarkColour,
              Colors.white,
            ],
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
          fontSize: 16
          ),
      ),
      ),
    );
  }
}