class Failures {
  String errorMessage;
  Failures({required this.errorMessage});
}

class ServerError extends Failures {
  ServerError({required super.errorMessage});
}

class NetworkError extends Failures {
  NetworkError({required super.errorMessage});
}

class ValidationFailure extends Failures {
  final List<String> errors;

  ValidationFailure({required this.errors})
      : super(errorMessage: "Validation Error");
}
