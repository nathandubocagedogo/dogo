import 'package:cloud_firestore/cloud_firestore.dart';

class GroupService {
  final CollectionReference _groupsRef =
      FirebaseFirestore.instance.collection('groups');
  final CollectionReference _messagesRef =
      FirebaseFirestore.instance.collection('messages');

  Stream<QuerySnapshot> getGroupsStream() {
    return _groupsRef.snapshots();
  }

  Future<void> createGroup(String name, String userId) async {
    DocumentReference groupRef = await _groupsRef.add({
      'name': name,
      'members': [userId],
    });
  }

  Future<void> joinGroup(String groupId, String userId) async {
    await _groupsRef.doc(groupId).update({
      'members': FieldValue.arrayUnion([userId]),
    });
  }

  Stream<QuerySnapshot> getGroupMessagesStream(String groupId) {
    return _messagesRef
        .where('groupId', isEqualTo: groupId)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<void> sendMessage(
      String groupId, String senderId, String content) async {
    await _messagesRef.add({
      'groupId': groupId,
      'senderId': senderId,
      'content': content,
      'timestamp': Timestamp.fromDate(DateTime.now()),
    });
  }
}
