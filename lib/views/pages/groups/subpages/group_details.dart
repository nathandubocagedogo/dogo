import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dogo_final_app/services/group.dart';

class GroupDetailsPageView extends StatefulWidget {
  final String groupId;

  const GroupDetailsPageView({super.key, required this.groupId});

  @override
  State<GroupDetailsPageView> createState() => _GroupDetailsPageViewState();
}

class _GroupDetailsPageViewState extends State<GroupDetailsPageView> {
  final User? user = FirebaseAuth.instance.currentUser;

  late Stream<DocumentSnapshot> groupDetailsStream;

  @override
  void initState() {
    super.initState();
    groupDetailsStream = GroupService().getGroupDetails(widget.groupId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails du groupe'),
      ),
      body: Center(
        child: StreamBuilder<DocumentSnapshot>(
          stream: groupDetailsStream,
          builder: (
            BuildContext context,
            AsyncSnapshot<DocumentSnapshot> snapshot,
          ) {
            if (snapshot.connectionState == ConnectionState.active) {
              final groupData = snapshot.data?.data() as Map<String, dynamic>?;
              final groupName = groupData?['name'] ?? 'Inconnu';
              final List<dynamic>? members = groupData?['members'];
              final bool isUserInGroup = members?.contains(user!.uid) ?? false;

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Détails du groupe ${widget.groupId} - Nom : $groupName',
                  ),
                  const SizedBox(height: 16),
                  if (isUserInGroup) ...[
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/group-chat',
                          arguments: {'groupId': widget.groupId},
                        );
                      },
                      child: const Text('Accéder au chat'),
                    ),
                  ] else ...[
                    ElevatedButton(
                      onPressed: () {
                        GroupService().joinGroup(widget.groupId, user!.uid);
                      },
                      child: const Text('Rejoindre le groupe'),
                    ),
                  ],
                ],
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
