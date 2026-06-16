abstract class AuthEvent {}

class AppStarted extends AuthEvent {}

class LoginSubmitted extends AuthEvent {
  final String email;
  final String password;

  LoginSubmitted({required this.email, required this.password});
}

class LogoutRequested extends AuthEvent {}

class ToggleLanguage extends AuthEvent {}
