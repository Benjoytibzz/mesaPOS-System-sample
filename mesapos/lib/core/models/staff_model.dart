class Staff {
  final String id;
  final String name;
  final String username;
  final String role;
  final bool isActive;

  Staff({
    required this.id,
    required this.name,
    required this.username,
    required this.role,
    this.isActive = true,
  });

  Staff copyWith({
    String? name,
    String? username,
    String? role,
    bool? isActive,
  }) {
    return Staff(
      id: id,
      name: name ?? this.name,
      username: username ?? this.username,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
    );
  }
}
