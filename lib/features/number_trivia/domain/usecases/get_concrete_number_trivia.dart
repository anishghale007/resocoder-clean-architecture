import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:resocoder_clean_architecture/core/error/failures.dart';
import 'package:resocoder_clean_architecture/core/usecases/usecase.dart';
import 'package:resocoder_clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:resocoder_clean_architecture/features/number_trivia/domain/repositories/number_trivia_repository.dart';

class GetConcreteNumberTrivia implements UseCase<NumberTriviaEntity, Params> {
  final NumberTriviaRepository repository;

  GetConcreteNumberTrivia(this.repository);

  @override
  Future<Either<Failure, NumberTriviaEntity>> call(Params params) async {
    return await repository.getConcreteNumberTrivial(params.number);
  }
}

class Params extends Equatable {
  final int number;

  const Params({required this.number});

  @override
  List<Object?> get props => [number];
}
