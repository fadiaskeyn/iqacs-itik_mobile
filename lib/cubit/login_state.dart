part of 'login_cubit.dart';

abstract class LoginState extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {}

class LoginFailure extends LoginState {
  final String errorMessage;

  LoginFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
