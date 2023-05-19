// Flutter
import 'package:flutter/material.dart';

// Services
import 'package:dogo_final_app/services/group.dart';

// Models
import 'package:dogo_final_app/models/firebase/message.dart';

// Components
import 'package:dogo_final_app/components/buttons/button_back.dart';

// Utilities
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

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

  Future<DocumentSnapshot> getUserInfo(String uid) async {
    return FirebaseFirestore.instance.collection('users').doc(uid).get();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return StreamProvider<QuerySnapshotWrapper>(
      create: (_) => groupService
          .getGroupMessages(widget.groupId)
          .map((snapshot) => QuerySnapshotWrapper(snapshot: snapshot)),
      initialData: QuerySnapshotWrapper(),
      child: _buildChatScreen(screenWidth),
    );
  }

  Widget _buildChatScreen(double screenWidth) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const ButtonBack(),
        title: const Text("Chat"),
      ),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: screenWidth * 0.90,
            child: Column(
              children: [
                Expanded(
                  child: _buildMessageList(),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 8.0),
                    child: _buildInputField(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMessageList() {
    return Consumer<QuerySnapshotWrapper>(
      builder: (context, snapshotWrapper, _) {
        if (snapshotWrapper.snapshot == null) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshotWrapper.snapshot!.docs.isEmpty) {
          return const Center(child: Text("Aucun message pour le moment."));
        }

        return ListView.builder(
          itemCount: snapshotWrapper.snapshot!.docs.length,
          itemBuilder: (BuildContext context, int index) {
            Message message = Message.fromMap(
              snapshotWrapper.snapshot!.docs[index].data()
                  as Map<String, dynamic>,
            );

            bool isMyMessage = message.senderId == user!.uid;

            return Row(
              mainAxisAlignment:
                  isMyMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                if (!isMyMessage)
                  message.userPhotoUrl == ""
                      ? const CircleAvatar(
                          child: Icon(Icons.person),
                        )
                      : CircleAvatar(
                          backgroundImage: NetworkImage(message.userPhotoUrl),
                        ),
                const SizedBox(width: 10.0),
                Flexible(
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 10.0,
                    ),
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: isMyMessage ? Colors.blue : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      crossAxisAlignment: isMyMessage
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Text(
                          message.userName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isMyMessage ? Colors.white : Colors.black,
                          ),
                        ),
                        Text(
                          message.content,
                          style: TextStyle(
                            color: isMyMessage ? Colors.white : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (isMyMessage) const SizedBox(width: 10.0),
                if (isMyMessage)
                  message.userPhotoUrl == ""
                      ? const CircleAvatar(
                          child: Icon(Icons.person),
                        )
                      : CircleAvatar(
                          backgroundImage: NetworkImage(message.userPhotoUrl),
                        ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildInputField() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: messageController,
            decoration: const InputDecoration(
              hintText: "Écrire un message",
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.send),
          onPressed: () async {
            String messageContent = messageController.text.trim();
            if (messageContent.isNotEmpty) {
              DocumentSnapshot userDoc = await getUserInfo(user!.uid);
              Map<String, dynamic> userData =
                  userDoc.data() as Map<String, dynamic>;

              String userName = userData['name'];
              String? userPhotoUrl = userData['picture'];

              await groupService.sendMessage(
                widget.groupId,
                user!.uid,
                messageContent,
                userName,
                userPhotoUrl,
              );

              messageController.clear();
            }
          },
        ),
      ],
    );
  }
}

class QuerySnapshotWrapper {
  final QuerySnapshot? snapshot;

  QuerySnapshotWrapper({this.snapshot});
}
