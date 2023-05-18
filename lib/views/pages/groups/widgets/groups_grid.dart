// Flutter
import 'package:flutter/material.dart';

// Models
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
                  child: Container(
                    margin: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                          10), // Change this to modify the border radius
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 0.5,
                          blurRadius: 3,
                          offset:
                              const Offset(0, 2), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                          child: Image.network(
                            group.picture,
                            width: double.infinity,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(group.name),
                            ],
                          ),
                        ),
                      ],
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
