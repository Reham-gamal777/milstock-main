import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final GetSavedUser getSavedUser;
  final LogoutUseCase logoutUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.getSavedUser,
    required this.logoutUseCase,
  }) : super(const AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<LoginSubmitted>(_onLoginSubmitted);
    on<LogoutRequested>(_onLogoutRequested);
    on<ToggleLanguage>(_onToggleLanguage);
  }

  Future<void> _onAppStarted(
    AppStarted event,
    Emitter<AuthState> emit,
  ) async {
    final user = await getSavedUser(NoParams());
    if (user != null) {
      emit(Authenticated(user: user, isArabic: state.isArabic));
    } else {
      emit(Unauthenticated(isArabic: state.isArabic));
    }
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
      // ignore: avoid_print
      print('Login Error: $e');
      emit(AuthError(
        message: e.toString().replaceAll('Exception: ', ''),
        isArabic: state.isArabic,
      ));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await logoutUseCase(NoParams());
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
