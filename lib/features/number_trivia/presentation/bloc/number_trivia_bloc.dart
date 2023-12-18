import 'package:equatable/equatable.dart';
import 'package:resocoder_clean_architecture/core/error/failures.dart';
import 'package:resocoder_clean_architecture/core/usecases/usecase.dart';
import 'package:resocoder_clean_architecture/core/utils/input_converter.dart';
import 'package:resocoder_clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resocoder_clean_architecture/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:resocoder_clean_architecture/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

// ignore: constant_identifier_names
const String SERVER_FAILURE_MESSAGE = 'Server Failure';
// ignore: constant_identifier_names
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
// ignore: constant_identifier_names
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The number must be a positive integer or zero.';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    required this.getConcreteNumberTrivia,
    required this.getRandomNumberTrivia,
    required this.inputConverter,
  }) : super(Empty()) {
    on<GetTriviaForConcreteNumber>((event, emit) {
      final inputEither =
          inputConverter.stringToUnsignedInteger(event.numberString);
      inputEither.fold(
          (failure) =>
              emit(const Error(errorMessage: INVALID_INPUT_FAILURE_MESSAGE)),
          (integer) async {
        emit(Loading());
        final failureOrtrivia =
            await getConcreteNumberTrivia(Params(number: integer));
        failureOrtrivia.fold(
            (failure) =>
                emit(Error(errorMessage: _mapFailureToFailure(failure))),
            (trivia) => emit(Loaded(triviaEntity: trivia)));
      });
    });
    on<GetTriviaForRandomNumber>((event, emit) async {
      emit(Loading());
      final failureOrTrivia = await getRandomNumberTrivia(NoParams());
      failureOrTrivia.fold(
          (failure) => emit(Error(errorMessage: _mapFailureToFailure(failure))),
          (trivia) => emit(Loaded(triviaEntity: trivia)));
    });
  }

  NumberTriviaState get initialState => Empty();

  String _mapFailureToFailure(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected Error';
    }
  }
}
