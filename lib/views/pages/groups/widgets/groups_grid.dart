// Flutter
import 'package:flutter/material.dart';

// Services
import 'package:dogo_final_app/services/group.dart';

// Utilities
import 'package:firebase_auth/firebase_auth.dart';

// Models
import 'package:dogo_final_app/models/firebase/group.dart';

class GroupsGrid extends StatefulWidget {
  final Stream<List<Group>>? groupsStream;
  final String userId;

  const GroupsGrid({
    super.key,
    required this.groupsStream,
    required this.userId,
  });

  @override
  State<GroupsGrid> createState() => _GroupsGridState();
}

class _GroupsGridState extends State<GroupsGrid> {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isAndroid = Theme.of(context).platform == TargetPlatform.android;
    final User? user = FirebaseAuth.instance.currentUser;

    return StreamBuilder<List<Group>>(
      stream: widget.groupsStream,
      builder: (BuildContext context, AsyncSnapshot<List<Group>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        List<Group> groups = snapshot.data!;

        if (groups.isEmpty) {
          return const Center(
            child: Text('Aucun groupe trouvé'),
          );
        }

        return Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: screenWidth * 0.95,
            child: ListView.separated(
              separatorBuilder: (context, index) => const SizedBox(width: 10),
              padding: EdgeInsets.only(
                top: 20,
                bottom: isAndroid
                    ? kBottomNavigationBarHeight + 40
                    : kBottomNavigationBarHeight + 50,
              ),
              itemCount: groups.length,
              itemBuilder: (context, index) {
                Group group = groups[index];
                final bool isUserInGroup = group.members.contains(user!.uid);

                return Container(
                  margin: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 2,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                        child: Image.network(
                          group.picture,
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              group.name,
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              group.description,
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "${group.members.length.toString()} membre(s)",
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                if (isUserInGroup) ...[
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pushNamed(
                                        context,
                                        '/group-chat',
                                        arguments: {'groupId': group.id},
                                      );
                                    },
                                    child: const Text(
                                      'Accéder au chat',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ] else ...[
                                  ElevatedButton(
                                    onPressed: () {
                                      GroupService()
                                          .joinGroup(group.id, user.uid);
                                    },
                                    child: const Text(
                                      'Rejoindre le groupe',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
