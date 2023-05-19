// Utilities
import 'package:cloud_firestore/cloud_firestore.dart';

// Models
import 'package:dogo_final_app/models/firebase/group.dart';

class GroupService {
  final CollectionReference groupsReference =
      FirebaseFirestore.instance.collection('groups');
  final CollectionReference messagesReference =
      FirebaseFirestore.instance.collection('messages');

  // Récupérer tous les groupes
  Stream<List<Group>> getGroupsStream() {
    return groupsReference.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => Group.fromMap(
            {...doc.data() as Map<String, dynamic>, 'id': doc.id}))
        .toList());
  }

  // Récupérer les groupes auxquels l'utilisateur appartient
  Stream<List<Group>> getUserGroupsStream(String userId) {
    return groupsReference
        .where('members', arrayContains: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Group.fromMap(
                {...doc.data() as Map<String, dynamic>, 'id': doc.id}))
            .toList());
  }

  // Récupérer les groupes auxquels l'utilisateur n'appartient pas
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

  // Création d'un groupe
  Future<void> createGroup(String name, String description, bool isPrivate,
      String picture, String userId) async {
    await groupsReference.add({
      'name': name,
      'description': description,
      'isPrivate': isPrivate,
      'picture': picture,
      'members': [userId],
    });
  }

  // Faire rejoindre un groupe à un utilisateur
  Future<void> joinGroup(String groupId, String userId) async {
    await groupsReference.doc(groupId).update({
      'members': FieldValue.arrayUnion([userId]),
    });
  }

  // Récupérer la liste des messages
  Stream<QuerySnapshot> getGroupMessages(String groupId) {
    return messagesReference
        .where('groupId', isEqualTo: groupId)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // Sauvegarde d'un message dans Firestore
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
