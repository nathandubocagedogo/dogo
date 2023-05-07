import 'package:dogo_final_app/models/firebase/group.dart';
import 'package:dogo_final_app/views/pages/groups/widgets/group_chat.dart';
import 'package:flutter/material.dart';
import 'package:dogo_final_app/services/group.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GroupsPageView extends StatefulWidget {
  const GroupsPageView({super.key});

  @override
  State<GroupsPageView> createState() => _GroupsPageViewState();
}

class _GroupsPageViewState extends State<GroupsPageView> {
  final GroupService _groupService = GroupService();

  Future<void> _showCreateGroupDialog() async {
    TextEditingController groupNameController = TextEditingController();

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Créer un groupe'),
          content: TextField(
            controller: groupNameController,
            decoration: InputDecoration(hintText: "Nom du groupe"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Créer'),
              onPressed: () async {
                String groupName = groupNameController.text.trim();
                if (groupName.isNotEmpty) {
                  // Créez le groupe en utilisant _groupService
                  // Ici, utilisez l'ID de l'utilisateur connecté à la place de "userId"
                  await _groupService.createGroup(groupName, "userId");
                }
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
        title: Text('Groupes'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _showCreateGroupDialog,
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _groupService.getGroupsStream(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Erreur: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Group group =
                  Group.fromMap(document.data() as Map<String, dynamic>);

              return ListTile(
                title: Text(group.name),
                onTap: () {
                  // Naviguer vers GroupChatPageView pour afficher les messages de ce groupe
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          GroupChatPageView(groupId: group.id),
                    ),
                  );
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
