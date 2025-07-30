import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {}

class Unauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;
  final String source; // 'login' / 'register'
  const AuthError(this.message, {this.source = 'login'});

  @override
  List<Object?> get props => [message];
}

class RegisterSuccess extends AuthState {
  final String message;
  const RegisterSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class PhotoUploadSuccess extends AuthState {
  final String photoUrl;
  const PhotoUploadSuccess(this.photoUrl);
}

class PhotoUploadFailure extends AuthState {
  final String message;
  const PhotoUploadFailure(this.message);
}

