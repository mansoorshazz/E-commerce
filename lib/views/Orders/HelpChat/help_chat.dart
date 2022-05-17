import 'package:clay_containers/clay_containers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/core/colors.dart';
import 'package:e_commerce_app/model/Firebase/help_chat.dart';
import 'package:e_commerce_app/views/Orders/HelpChat/widgets/message_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// import 'package:group';

class HelpChat extends StatelessWidget {
  HelpChat({
    Key? key,
    required this.docId,
  }) : super(key: key);

  TextEditingController chatController = TextEditingController();
  String docId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder<Object>(
          stream: null,
          builder: (context, snapshot) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Chats')
                      .doc(docId)
                      .collection('helpchat')
                      .orderBy('messageDate')
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Expanded(
                        child: Center(
                          child: CupertinoActivityIndicator(),
                        ),
                      );
                    }

                    if (snapshot.data!.docs.isEmpty) {
                      return Expanded(
                          child: Center(child: Text('Send a message!!')));
                    }

                    return Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final chatMap = snapshot.data!.docs[index];
                          print(
                            chatMap['message'],
                          );

                          return MessageBox(
                            isMe: chatMap['isMe'],
                            message: chatMap['message'],
                          );
                        },
                      ),
                    );
                  },
                ),
                buildMessageSendWidget(context)
              ],
            );
          }),
    );
  }

// ===========================================================================================
// This method is return the message send button and textfield in flutter.

  Padding buildMessageSendWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Flexible(
            child: ClayContainer(
              emboss: true,
              color: Colors.white30,
              borderRadius: 10,
              child: TextField(
                controller: chatController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Send a message',
                  contentPadding: EdgeInsets.only(left: 10),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          GestureDetector(
            onTap: () {
              HelpChatModel helpChatModel = HelpChatModel(
                message: chatController.text,
                isMe: true,
                messageDate: DateTime.now(),
              );

              HelpChatModel.sendMessage(
                docId,
                helpChatModel,
              );
              chatController.clear();
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: themeColor.withOpacity(0.1),
              ),
              height: MediaQuery.of(context).size.height * 0.064,
              width: MediaQuery.of(context).size.width * 0.15,
              child: Center(
                child: Icon(Icons.send),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
