import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String id;
  final String content;
  final String userId;
  final String userName;
  final DateTime timestamp;

  Message({
    required this.id,
    required this.content,
    required this.userId,
    required this.userName,
    required this.timestamp,
  });

  Message.fromMap(Map<String, dynamic> map)
      : id = map['id'] as String? ?? '',
        content = map['content'] as String? ?? '',
        userId = map['userId'] as String? ?? '',
        userName = map['userName'] as String? ?? 'Inconnu',
        timestamp =
            (map['timestamp'] as Timestamp? ?? Timestamp.now()).toDate();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'userId': userId,
      'userName': userName,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}
