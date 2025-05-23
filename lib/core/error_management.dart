import 'package:equatable/equatable.dart';

abstract class ErrorManagement extends Equatable {
  final String message;
  const ErrorManagement(this.message);

  @override
  List<Object> get props => [message];
}

class ServerError extends ErrorManagement {
  const ServerError(super.message);
}

class NetworkError extends ErrorManagement {
  const NetworkError(super.message);
}