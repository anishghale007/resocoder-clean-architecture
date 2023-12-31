import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:resocoder_clean_architecture/core/network/network_info.dart';
import 'package:resocoder_clean_architecture/core/utils/input_converter.dart';
import 'package:resocoder_clean_architecture/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:resocoder_clean_architecture/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:resocoder_clean_architecture/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:resocoder_clean_architecture/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:resocoder_clean_architecture/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:resocoder_clean_architecture/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:resocoder_clean_architecture/features/number_trivia/presentation/bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Number Trivia
  // Bloc
  sl.registerFactory(
    () => NumberTriviaBloc(
      getConcreteNumberTrivia: sl(),
      getRandomNumberTrivia: sl(),
      inputConverter: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetConcreteNumberTrivia(sl()));
  sl.registerLazySingleton(() => GetRandomNumberTrivia(sl()));

  // Repository
  sl.registerLazySingleton<NumberTriviaRepository>(
      () => NumberTriviaRepositoryImpl(
            remoteDataSource: sl(),
            localDataSource: sl(),
            networkInfo: sl(),
          ));

  // Data sources
  sl.registerLazySingleton<NumberTriviaLocalDataSource>(
      () => NumberTriviaLocalDataSourceImpl(
            sharedPreferences: sl(),
          ));

  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(
      () => NumberTriviaRemoteDataSourceImpl(
            client: sl(),
          ));

  //! Core
  sl.registerLazySingleton(() => InputConverter());

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
