// Flutter
import 'package:flutter/material.dart';

// Models
import 'package:dogo_final_app/models/firebase/group.dart';

// Widgets
import 'package:dogo_final_app/views/pages/groups/widgets/group_chat.dart';

// Services
import 'package:dogo_final_app/services/group.dart';

// Firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GroupsPageView extends StatefulWidget {
  const GroupsPageView({super.key});

  @override
  State<GroupsPageView> createState() => _GroupsPageViewState();
}

class _GroupsPageViewState extends State<GroupsPageView> {
  final GroupService groupService = GroupService();
  final User? user = FirebaseAuth.instance.currentUser;

  Future<void> createGroupDialog() async {
    TextEditingController groupNameController = TextEditingController();

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Créer un groupe'),
          content: TextField(
            controller: groupNameController,
            decoration: const InputDecoration(hintText: "Nom du groupe"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Créer'),
              onPressed: () async {
                String groupName = groupNameController.text.trim();

                if (groupName.isNotEmpty) {
                  await groupService.createGroup(groupName, user!.uid);
                }

                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Groupes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: createGroupDialog,
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: groupService.getGroupsStream(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Erreur: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            children: snapshot.data!.docs.map(
              (DocumentSnapshot document) {
                Group group = Group.fromMap({
                  ...document.data() as Map<String, dynamic>,
                  'id': document.id
                });
                bool isMember = group.members.contains(user!.uid);

                return ListTile(
                  title: Text(group.name),
                  trailing: isMember
                      ? null
                      : ElevatedButton(
                          onPressed: () async {
                            await groupService.joinGroup(group.id, user!.uid);
                          },
                          child: const Text('Rejoindre'),
                        ),
                  onTap: () {
                    if (isMember) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              GroupChatPageView(groupId: group.id),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text('Rejoignez le groupe pour accéder au chat.'),
                        ),
                      );
                    }
                  },
                );
              },
            ).toList(),
          );
        },
      ),
    );
  }
}
