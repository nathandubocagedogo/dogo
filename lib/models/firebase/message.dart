import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String id;
  final String content;
  final DateTime timestamp;
  final String userId;
  final String userName;

  Message({
    required this.id,
    required this.content,
    required this.timestamp,
    required this.userId,
    required this.userName,
  });

  Message.fromMap(Map<String, dynamic> map)
      : id = map['id'] as String? ?? '',
        content = map['content'] as String? ?? '',
        timestamp =
            (map['timestamp'] as Timestamp? ?? Timestamp.now()).toDate(),
        userId = map['userId'] as String? ?? '',
        userName = map['userName'] as String? ?? 'Inconnu';

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'timestamp': Timestamp.fromDate(timestamp),
      'userId': userId,
      'userName': userName,
    };
  }
}
