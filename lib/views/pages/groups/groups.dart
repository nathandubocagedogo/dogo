// Flutter
import 'package:flutter/material.dart';

// Widgets
import 'package:dogo_final_app/views/pages/groups/widgets/groups_grid.dart';

// Services
import 'package:dogo_final_app/services/group.dart';

// Utilities
import 'package:firebase_auth/firebase_auth.dart';

class GroupsPageView extends StatefulWidget {
  const GroupsPageView({super.key});

  @override
  State<GroupsPageView> createState() => _GroupsPageViewState();
}

class _GroupsPageViewState extends State<GroupsPageView> {
  final GroupService groupService = GroupService();
  final User? user = FirebaseAuth.instance.currentUser;

  Future<void> createBottomSheet() async {
    TextEditingController groupNameController = TextEditingController();
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.8,
          child: Container(
            color: Colors.white,
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('Créer un groupe'),
                  TextField(
                    controller: groupNameController,
                    decoration:
                        const InputDecoration(hintText: "Nom du groupe"),
                  ),
                  ElevatedButton(
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
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: createBottomSheet,
            ),
          ],
          automaticallyImplyLeading: false,
          title: const Text('Groupes'),
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(
                text: 'Mes Groupes',
              ),
              Tab(
                text: 'Autres Groupes',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            GroupsGrid(
              groupsStream: groupService.getUserGroupsStream(user!.uid),
              userId: user!.uid,
            ),
            GroupsGrid(
              groupsStream: groupService.getNonUserGroupsStream(user!.uid),
              userId: user!.uid,
            ),
          ],
        ),
      ),
    );
  }
}
