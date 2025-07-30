import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../../../domain/repositories/auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;

  AuthBloc(this.repository) : super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LoggedOut>(_onLoggedOut);
    on<UploadPhotoRequested>(_onUploadPhotoRequested);
  }

  /// Uygulama açıldığında token kontrolü + expire süresi (denemelik özellik: 7 gün geçtiyse yeni login iste)
  Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final token = await repository.getToken();
    final createdAt = await repository.getTokenCreatedAt();

    if (token != null && createdAt != null) {
      if (DateTime.now().difference(createdAt).inDays <= 7) {
        emit(Authenticated());
        return;
      }
    }
    emit(Unauthenticated());
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await repository.login(event.email, event.password);
      emit(Authenticated());
    } catch (e) {
      final errorMessage = e is String ? e : e.toString();
      emit(AuthError(errorMessage));
    }
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final message = await repository.register(
        event.name,
        event.email,
        event.password,
      );
      emit(RegisterSuccess(message)); // Register başarı state
    } catch (e) {
      final errorMessage = e is String ? e : e.toString();
      emit(AuthError(errorMessage, source: 'register'));
    }
  }

  Future<void> _onLoggedOut(LoggedOut event, Emitter<AuthState> emit) async {
    await repository.removeUserData();
    emit(AuthLoading());
    await Future.delayed(Duration(seconds: 1));
    emit(Unauthenticated());
  }

  Future<void> _onUploadPhotoRequested(
    UploadPhotoRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final photoUrl = await repository.uploadPhoto(event.filePath);
      emit(PhotoUploadSuccess(photoUrl));
    } catch (e) {
      emit(PhotoUploadFailure(e.toString()));
    }
  }
}
