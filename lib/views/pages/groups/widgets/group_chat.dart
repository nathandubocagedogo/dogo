import 'package:dogo_final_app/models/firebase/message.dart';
import 'package:dogo_final_app/services/group.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GroupChatPageView extends StatefulWidget {
  final String groupId;

  const GroupChatPageView({Key? key, required this.groupId}) : super(key: key);

  @override
  State<GroupChatPageView> createState() => _GroupChatPageViewState();
}

class _GroupChatPageViewState extends State<GroupChatPageView> {
  final GroupService _groupService = GroupService();
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat de groupe'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _groupService.getGroupMessagesStream(widget.groupId),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Erreur: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
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
                    controller: _messageController,
                    decoration: InputDecoration(hintText: "Écrire un message"),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () async {
                    String messageContent = _messageController.text.trim();
                    if (messageContent.isNotEmpty) {
                      // Envoyer le message en utilisant _groupService
                      // Ici, utilisez l'
                      // ID de l'utilisateur connecté à la place de "senderId"
                      await _groupService.sendMessage(
                          widget.groupId, "senderId", messageContent);
                      _messageController.clear();
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
