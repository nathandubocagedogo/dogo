import 'package:cloud_firestore/cloud_firestore.dart';

class GroupService {
  final CollectionReference groupsReference =
      FirebaseFirestore.instance.collection('groups');
  final CollectionReference messagesReference =
      FirebaseFirestore.instance.collection('messages');

  Stream<QuerySnapshot> getGroupsStream() {
    return groupsReference.snapshots();
  }

  Future<void> createGroup(String name, String userId) async {
    await groupsReference.add({
      'name': name,
      'members': [userId],
    });
  }

  Future<void> joinGroup(String groupId, String userId) async {
    await groupsReference.doc(groupId).update({
      'members': FieldValue.arrayUnion([userId]),
    });
  }

  Stream<QuerySnapshot> getUserGroupsStream(String userId) {
    return groupsReference.where('members', arrayContains: userId).snapshots();
  }

  Stream<QuerySnapshot> getGroupMessages(String groupId) {
    return messagesReference
        .where('groupId', isEqualTo: groupId)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<void> sendMessage(
      String groupId, String senderId, String content) async {
    await messagesReference.add({
      'groupId': groupId,
      'senderId': senderId,
      'content': content,
      'timestamp': Timestamp.fromDate(DateTime.now()),
    });
  }
}
