import 'package:equatable/equatable.dart';

import 'exceptions.dart';

abstract class Failure extends Equatable {
  String get message;
  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  @override
  final String message;

  final int statusCode;
  ServerFailure(this.message, this.statusCode);

  factory ServerFailure.fromException(ServerException e) {
    return ServerFailure(e.message, e.statusCode);
  }

  @override
  String toString() {
    return 'ServerFailure: $message ($statusCode)';
  }

  @override
  List<Object?> get props => [statusCode, message];
}

class LocalFailure extends Failure {
  @override
  final String message;

  LocalFailure(this.message);

  @override
  String toString() {
    return 'LocalFailure: $message';
  }
}

class UnknownFailure extends Failure {
  @override
  final String message;
  final StackTrace? stackTrace;

  UnknownFailure(this.message, [this.stackTrace]);
  @override
  String toString() {
    return 'UnknownFailure: $message\n${stackTrace ?? ""}';
  }

  @override
  List<Object?> get props => [message, stackTrace];
}
