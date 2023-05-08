// Flutter
import 'package:flutter/material.dart';

// Widgets
import 'package:dogo_final_app/views/pages/groups/widgets/groups_grid.dart';

// Services
import 'package:dogo_final_app/services/group.dart';

// Firebase
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
      body: GroupsGrid(
        groupsStream: groupService.getGroupsStream(),
        userId: user!.uid,
      ),
    );
  }
}
