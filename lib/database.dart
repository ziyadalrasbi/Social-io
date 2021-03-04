import 'package:cloud_firestore/cloud_firestore.dart';


class DatabaseMethods {


  getUsername(String userName) async {
      return await FirebaseFirestore.instance.collection('users')
        .where('username',isEqualTo: userName)
        .get();
  }

  getEmail(String email) async {
      return await FirebaseFirestore.instance.collection('users')
        .where('email',isEqualTo: email)
        .get();
  }


    uploadImage(String filePath, uploadMap) {
    FirebaseFirestore.instance.collection('uploads')
    .doc(filePath).set(uploadMap).catchError((e) {
      print(e.toString());
    });
  }

  addImage(String roomId, textMap) {
    FirebaseFirestore.instance.collection('uploads')
    .doc(roomId).collection('images').add(textMap)
    .catchError((e){print(e.toString());});
  }
  
  getImage(String imageId) async {
    return await FirebaseFirestore.instance.collection('uploads')
    .doc(imageId).collection('images').orderBy("time", descending: true).snapshots();
  }

  createChat(String roomId, chatMap) {
    FirebaseFirestore.instance.collection('chatroom')
    .doc(roomId).set(chatMap).catchError((e) {
      print(e.toString());
    });
  }



  getConvoText(String roomId) async {
    return await FirebaseFirestore.instance.collection('chatroom')
    .doc(roomId).collection('chats').orderBy("time", descending: false).snapshots();
  }

  addConvoText(String roomId, textMap) {
    FirebaseFirestore.instance.collection('chatroom')
    .doc(roomId).collection('chats').add(textMap)
    .catchError((e){print(e.toString());});
  }

  getRooms(String userName) async {
    return await FirebaseFirestore.instance.collection('chatroom').where("users", arrayContains: userName)
    .snapshots();
  }

  
  
}