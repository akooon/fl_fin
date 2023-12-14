import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AppStarted extends AuthEvent {}

class LoggedIn extends AuthEvent {
  final String userId;

  const LoggedIn(this.userId);

  @override
  List<Object> get props => [userId];

  @override
  String toString() => 'LoggedIn { userId: $userId }';
}

class LoggedOut extends AuthEvent {}
