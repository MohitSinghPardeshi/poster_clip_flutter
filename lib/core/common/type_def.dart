import 'package:fpdart/fpdart.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureVoid = FutureEither<void>;

class Failure {
  final String message;
  Failure(
    this.message,
  );
}
