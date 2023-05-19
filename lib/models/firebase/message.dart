// Utilities
import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String id;
  final String content;
  final String senderId;
  final String userName;
  final String userPhotoUrl;
  final DateTime timestamp;

  Message({
    required this.id,
    required this.content,
    required this.senderId,
    required this.userName,
    required this.userPhotoUrl,
    required this.timestamp,
  });

  Message.fromMap(Map<String, dynamic> map)
      : id = map['id'] as String? ?? '',
        content = map['content'] as String? ?? '',
        senderId = map['senderId'] as String? ?? '',
        userPhotoUrl = map['userPhotoUrl'] as String? ?? '',
        userName = map['userName'] as String? ?? 'Inconnu',
        timestamp =
            (map['timestamp'] as Timestamp? ?? Timestamp.now()).toDate();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'senderId': senderId,
      'userPhotoUrl': userPhotoUrl,
      'userName': userName,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}
