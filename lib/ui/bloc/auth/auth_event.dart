import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AppStarted extends AuthEvent {}

class LoggedIn extends AuthEvent {
  final String token;
  LoggedIn(this.token);

  @override
  List<Object?> get props => [token];
}

class LoggedOut extends AuthEvent {}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;
  LoginRequested(this.email, this.password);
}

class RegisterRequested extends AuthEvent {
  final String name;
  final String email;
  final String password;
  RegisterRequested(this.name, this.email, this.password);
   @override
  List<Object?> get props => [name, email, password];
}
class UploadPhotoRequested extends AuthEvent {
  final String filePath;
  UploadPhotoRequested(this.filePath);
}

