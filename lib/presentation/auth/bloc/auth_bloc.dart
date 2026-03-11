import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/login_usecase.dart';
import '../../../domain/usecases/logout_usecase.dart';
import '../../../domain/usecases/get_cached_user_usecase.dart';
import '../../../core/errors/failures.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;
  final GetCachedUserUseCase getCachedUserUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.getCachedUserUseCase,
  }) : super(AuthInitial()) {
    on<CheckAuthEvent>(_onCheckAuth);
    on<LoginEvent>(_onLogin);
    on<LogoutEvent>(_onLogout);
  }

  Future<void> _onCheckAuth(
    CheckAuthEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await getCachedUserUseCase();
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (_) {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await loginUseCase(event.username, event.password);
      emit(AuthAuthenticated(user));
    } on NetworkFailure catch (e) {
      emit(AuthError(e.message));
    } on AuthFailure catch (e) {
      emit(AuthError(e.message));
    } on ServerFailure catch (e) {
      emit(AuthError(e.message));
    } catch (_) {
      emit(AuthError('An unexpected error occurred'));
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    await logoutUseCase();
    emit(AuthUnauthenticated());
  }
}
