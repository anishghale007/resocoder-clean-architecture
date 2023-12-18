import 'package:resocoder_clean_architecture/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:resocoder_clean_architecture/core/usecases/usecase.dart';
import 'package:resocoder_clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:resocoder_clean_architecture/features/number_trivia/domain/repositories/number_trivia_repository.dart';

class GetRandomNumberTrivia implements UseCase<NumberTriviaEntity, NoParams> {
  final NumberTriviaRepository repository;

  GetRandomNumberTrivia(this.repository);

  @override
  Future<Either<Failure, NumberTriviaEntity>> call(NoParams params) async {
    return await repository.getRandomNumberTrivial();
  }
}
