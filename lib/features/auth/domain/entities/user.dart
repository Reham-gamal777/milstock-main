class User {
  final String email;
  final String name;
  final String role; // 'admin' or 'user'

  const User({
    required this.email,
    required this.name,
    required this.role,
  });
}
