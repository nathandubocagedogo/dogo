// Utilities
import 'package:cloud_firestore/cloud_firestore.dart';

// Models
import 'package:dogo_final_app/models/firebase/group.dart';

class GroupService {
  final CollectionReference groupsReference =
      FirebaseFirestore.instance.collection('groups');
  final CollectionReference messagesReference =
      FirebaseFirestore.instance.collection('messages');

  Stream<List<Group>> getGroupsStream() {
    return groupsReference.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => Group.fromMap(
            {...doc.data() as Map<String, dynamic>, 'id': doc.id}))
        .toList());
  }

  Stream<List<Group>> getUserGroupsStream(String userId) {
    return groupsReference
        .where('members', arrayContains: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Group.fromMap(
                {...doc.data() as Map<String, dynamic>, 'id': doc.id}))
            .toList());
  }

  Stream<List<Group>> getNonUserGroupsStream(String userId) {
    return groupsReference.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => Group.fromMap(
            {...doc.data() as Map<String, dynamic>, 'id': doc.id}))
        .where((group) => !group.members.contains(userId))
        .toList());
  }

  Stream<DocumentSnapshot> getGroupDetails(String groupId) {
    return groupsReference.doc(groupId).snapshots();
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
