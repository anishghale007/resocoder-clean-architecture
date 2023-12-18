import 'package:resocoder_clean_architecture/core/error/exceptions.dart';
import 'package:resocoder_clean_architecture/core/network/network_info.dart';
import 'package:resocoder_clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:resocoder_clean_architecture/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:resocoder_clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:resocoder_clean_architecture/features/number_trivia/domain/repositories/number_trivia_repository.dart';

import '../datasources/number_trivia_local_data_source.dart';
import '../datasources/number_trivia_remote_data_source.dart';

typedef _ConcreteOrRandomChooser = Future<NumberTriviaModel> Function();

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NumberTriviaLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, NumberTriviaEntity>> getConcreteNumberTrivial(
      int number) async {
    return await _getTrivia(() {
      return remoteDataSource.getConcreteNumberTrivia(number);
    });
  }

  @override
  Future<Either<Failure, NumberTriviaEntity>> getRandomNumberTrivial() async {
    return await _getTrivia(() {
      return remoteDataSource.getRandomNumberTrivia();
    });
  }

  Future<Either<Failure, NumberTriviaEntity>> _getTrivia(
    _ConcreteOrRandomChooser getConcreteOrRandom,
  ) async {
    if (await networkInfo.isConnected) {
      // if there is internet connection
      try {
        final remoteTrivia = await getConcreteOrRandom();
        localDataSource.cacheNumberTrivia(remoteTrivia);
        return Right(remoteTrivia);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      // if there is no internet connection
      try {
        final localTrivia = await localDataSource.getLastNumberTrivia();
        return Right(localTrivia);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
