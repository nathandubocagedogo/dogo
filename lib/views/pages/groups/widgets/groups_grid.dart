import 'package:flutter/material.dart';
import 'package:dogo_final_app/models/firebase/group.dart';

class GroupsGrid extends StatelessWidget {
  final Stream<List<Group>>? groupsStream;
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

    return StreamBuilder<List<Group>>(
      stream: groupsStream,
      builder: (BuildContext context, AsyncSnapshot<List<Group>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        List<Group> groups = snapshot.data!;

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
              itemCount: groups.length,
              itemBuilder: (context, index) {
                Group group = groups[index];

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
