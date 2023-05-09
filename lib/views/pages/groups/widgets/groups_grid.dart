import 'package:flutter/material.dart';
import 'package:dogo_final_app/models/firebase/group.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GroupsGrid extends StatelessWidget {
  final Stream<QuerySnapshot> groupsStream;
  final String userId;

  const GroupsGrid({
    super.key,
    required this.groupsStream,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isAndroid = Theme.of(context).platform == TargetPlatform.android;

    return StreamBuilder<QuerySnapshot>(
      stream: groupsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        return Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: screenWidth * 0.95,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 10,
                crossAxisCount: 2,
                mainAxisSpacing: 10,
              ),
              padding: EdgeInsets.only(
                top: 20,
                bottom: isAndroid
                    ? kBottomNavigationBarHeight + 40
                    : kBottomNavigationBarHeight + 50,
              ),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot document = snapshot.data!.docs[index];
                Group group = Group.fromMap({
                  ...document.data() as Map<String, dynamic>,
                  'id': document.id
                });
                bool isMember = group.members.contains(userId);

                return InkWell(
                  onTap: () => Navigator.pushNamed(
                    context,
                    '/group-details',
                    arguments: {'groupId': group.id},
                  ),
                  child: Card(
                    elevation: 0.5,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(group.name),
                          if (!isMember)
                            ElevatedButton(
                              child: const Text("Rejoindre"),
                              onPressed: () {},
                            )
                        ],
                      ),
                    ),
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
