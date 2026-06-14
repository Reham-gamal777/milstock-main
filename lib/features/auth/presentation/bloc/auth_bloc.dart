import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/login_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;

  AuthBloc({required this.loginUseCase}) : super(const AuthInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<LogoutRequested>(_onLogoutRequested);
    on<ToggleLanguage>(_onToggleLanguage);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading(isArabic: state.isArabic));
    try {
      final user = await loginUseCase(
        LoginParams(email: event.email, password: event.password),
      );
      emit(Authenticated(user: user, isArabic: state.isArabic));
    } catch (e) {
      emit(AuthError(
        message: e.toString().replaceAll('Exception: ', ''),
        isArabic: state.isArabic,
      ));
    }
  }

  void _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) {
    emit(Unauthenticated(isArabic: state.isArabic));
  }

  void _onToggleLanguage(
    ToggleLanguage event,
    Emitter<AuthState> emit,
  ) {
    final nextLanguage = !state.isArabic;
    final currentState = state;
    
    if (currentState is Authenticated) {
      emit(Authenticated(user: currentState.user, isArabic: nextLanguage));
    } else if (currentState is AuthLoading) {
      emit(AuthLoading(isArabic: nextLanguage));
    } else if (currentState is AuthError) {
      emit(AuthError(message: currentState.message, isArabic: nextLanguage));
    } else if (currentState is AuthInitial) {
      emit(AuthInitial(isArabic: nextLanguage));
    } else {
      emit(Unauthenticated(isArabic: nextLanguage));
    }
  }
}
