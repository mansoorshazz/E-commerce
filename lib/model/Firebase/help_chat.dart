import 'package:cloud_firestore/cloud_firestore.dart';

class HelpChatModel {
  final String message;
  final bool isMe;
  final DateTime messageDate;
  int count = 0;

  HelpChatModel({
    required this.message,
    required this.isMe,
    required this.messageDate,
  });

  Map<String, dynamic> toMap() {
    return {
      "message": message,
      'isMe': isMe,
      'messageDate': messageDate,
    };
  }

//===============================================================================================
// This method is used to send the message to admin for order complaint.

  static sendMessage(
    String docId,
    HelpChatModel helpChat,
  ) async {
    final map =
        await FirebaseFirestore.instance.collection('Chats').doc(docId).get();

    if (map.exists == false) {
      await FirebaseFirestore.instance.collection('Chats').doc(docId).set(
        {
          'count': 1,
        },
      );
    } else {
      await FirebaseFirestore.instance.collection('Chats').doc(docId).set(
        {
          'count': map['count'] + 1,
        },
      );
    }

    await FirebaseFirestore.instance
        .collection("Chats")
        .doc(docId)
        .collection('helpchat')
        .add(
          helpChat.toMap(),
        );
  }
}
