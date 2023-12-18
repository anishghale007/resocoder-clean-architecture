import 'package:dartz/dartz.dart';
import 'package:resocoder_clean_architecture/core/error/failures.dart';
import 'package:resocoder_clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';

abstract class NumberTriviaRepository {
  Future<Either<Failure, NumberTriviaEntity>> getConcreteNumberTrivial(
      int number);
  Future<Either<Failure, NumberTriviaEntity>> getRandomNumberTrivial();
}
