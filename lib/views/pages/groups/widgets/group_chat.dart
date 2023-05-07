// Flutter
import 'package:flutter/material.dart';

// Services
import 'package:dogo_final_app/services/group.dart';

// Models
import 'package:dogo_final_app/models/firebase/message.dart';

// Firebase
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GroupChatPageView extends StatefulWidget {
  final String groupId;

  const GroupChatPageView({super.key, required this.groupId});

  @override
  State<GroupChatPageView> createState() => _GroupChatPageViewState();
}

class _GroupChatPageViewState extends State<GroupChatPageView> {
  final GroupService groupService = GroupService();
  final User? user = FirebaseAuth.instance.currentUser;
  final TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat de groupe'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: groupService.getGroupMessages(widget.groupId),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Erreur: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    Message message = Message.fromMap(snapshot.data!.docs[index]
                        .data() as Map<String, dynamic>);

                    return ListTile(
                      title: Text(message.content),
                      subtitle: Text(message.userId),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration:
                        const InputDecoration(hintText: "Écrire un message"),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () async {
                    String messageContent = messageController.text.trim();
                    if (messageContent.isNotEmpty) {
                      await groupService.sendMessage(
                          widget.groupId, user!.uid, messageContent);
                      messageController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
