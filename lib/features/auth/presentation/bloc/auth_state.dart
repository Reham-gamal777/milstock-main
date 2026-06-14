import '../../domain/entities/user.dart';

abstract class AuthState {
  final bool isArabic;

  const AuthState({this.isArabic = false});
}

class AuthInitial extends AuthState {
  const AuthInitial({super.isArabic});
}

class AuthLoading extends AuthState {
  const AuthLoading({super.isArabic});
}

class Authenticated extends AuthState {
  final User user;

  const Authenticated({required this.user, super.isArabic});
}

class Unauthenticated extends AuthState {
  const Unauthenticated({super.isArabic});
}

class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message, super.isArabic});
}
