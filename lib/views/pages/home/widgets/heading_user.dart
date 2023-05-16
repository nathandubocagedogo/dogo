// Flutter
import 'package:flutter/material.dart';

// Utils
import 'package:dogo_final_app/utils/manipulate_string.dart';

// Utilities
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HeadingUserWidget extends StatefulWidget {
  final Function() onAvatarTap;

  const HeadingUserWidget({
    super.key,
    required this.onAvatarTap,
  });

  @override
  State<HeadingUserWidget> createState() => _HeadingUserWidgetState();
}

class _HeadingUserWidgetState extends State<HeadingUserWidget> {
  late Future<DocumentSnapshot<Map<String, dynamic>>> userData;

  @override
  void initState() {
    super.initState();
    userData = getUserData();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserData() async {
    final User? user = FirebaseAuth.instance.currentUser;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    return await firestore.collection("users").doc(user?.uid).get();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          width: screenWidth * 0.9,
          child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            future: userData,
            builder: (
              BuildContext context,
              AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot,
            ) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 50,
                          height: 18,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: 100,
                          height: 18,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.grey[300],
                      radius: 25,
                    ),
                  ],
                );
              } else {
                final String name = convertFullNameInFirstName(
                  name: snapshot.data?.data()?['name'],
                );
                final String? picture = snapshot.data?.data()?['picture'];
                final String firstLetter =
                    name.isNotEmpty ? name[0].toUpperCase() : "";

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Bonjour,",
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          "$name 👋",
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: widget.onAvatarTap,
                      child: CircleAvatar(
                        backgroundColor: Colors.grey[300],
                        radius: 25,
                        child: picture != null && picture.isNotEmpty
                            ? ClipOval(
                                child: Image.network(
                                  picture,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Text(
                                firstLetter,
                                style: const TextStyle(
                                  fontSize: 24,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    )
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
