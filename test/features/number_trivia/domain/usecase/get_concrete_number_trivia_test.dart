import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:resocoder_clean_architecture/core/usecases/usecase.dart';
import 'package:resocoder_clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:resocoder_clean_architecture/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resocoder_clean_architecture/features/number_trivia/domain/usecases/get_random_number_trivia.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  GetRandomNumberTrivia? usecase;
  MockNumberTriviaRepository? mockNumberTriviaRepository;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetRandomNumberTrivia(mockNumberTriviaRepository!);
  });

  // const tNumber = 1;
  const tNumberTrivia = NumberTriviaEntity(text: 'test', number: 1);

  test(
    'should get trivia from the repository',
    () async {
      // arrange
      when(mockNumberTriviaRepository!.getRandomNumberTrivial())
          .thenAnswer((_) async => const Right(tNumberTrivia));
      // act
      final result = await usecase!(NoParams());
      // assert
      expect(result, const Right(tNumberTrivia));
      verify(mockNumberTriviaRepository!.getRandomNumberTrivial());
      verifyNoMoreInteractions(mockNumberTriviaRepository);
    },
  );
}
