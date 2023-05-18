// Utilities
import 'package:cloud_firestore/cloud_firestore.dart';

class Group {
  final String id;
  final String name;
  final String description;
  final bool isPrivate;
  final String picture;
  final List<String> members;

  Group({
    required this.id,
    required this.name,
    required this.description,
    required this.isPrivate,
    required this.picture,
    required this.members,
  });

  Group.fromMap(Map<String, dynamic> map)
      : id = map['id'] as String? ?? '',
        name = map['name'] as String? ?? '',
        description = map['description'] as String? ?? '',
        isPrivate = map['isPrivate'] as bool? ?? false,
        picture = map['picture'] as String? ?? '',
        members = List<String>.from(map['members'] as List<dynamic>);

  Group.fromDocument(DocumentSnapshot doc)
      : this.fromMap(doc.data() as Map<String, dynamic>);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'members': members,
      'description': description,
      'isPrivate': isPrivate,
      'picture': picture,
    };
  }
}
