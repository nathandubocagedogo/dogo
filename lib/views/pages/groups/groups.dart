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
                onPressed: () {
                  Navigator.pushNamed(context, '/group-create');
                }),
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
