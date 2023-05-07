class Group {
  final String id;
  final String name;
  final List<String> members;

  Group({
    required this.id,
    required this.name,
    required this.members,
  });

  Group.fromMap(Map<String, dynamic> map)
      : id = map['id'] as String? ?? '',
        name = map['name'] as String? ?? '',
        members = List<String>.from(map['members'] as List<dynamic>);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'members': members,
    };
  }
}
