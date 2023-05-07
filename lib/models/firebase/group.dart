class Group {
  String id;
  String name;

  Group({required this.id, required this.name});

  factory Group.fromMap(Map<String, dynamic> map) {
    return Group(
      id: map['id'] as String? ?? '',
      name: map['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}
