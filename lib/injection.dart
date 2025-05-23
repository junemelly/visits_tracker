
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:visits_tracker/data/repositoryImpl/repository_implementor.dart';
import 'package:visits_tracker/domain/repository/visits_repository.dart';
import 'package:visits_tracker/domain/usecase/usecases.dart';
import 'core/network_client.dart';
import 'data/data_source.dart';
import 'presentation/bloc/visits_bloc.dart';
import 'presentation/bloc/data_bloc.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  // Core
  getIt.registerLazySingleton<Dio>(() => NetworkClient().dio);

  // Data
  getIt.registerLazySingleton<ApiDataSource>(
        () => ApiDataSourceImpl(getIt()),
  );

  getIt.registerLazySingleton<VisitsRepository>(
        () => VisitsRepositoryImpl(getIt()),
  );

  // Domain
  getIt.registerLazySingleton(() => GetVisitsUseCase(getIt()));
  getIt.registerLazySingleton(() => CreateVisitUseCase(getIt()));
  getIt.registerLazySingleton(() => GetCustomersUseCase(getIt()));
  getIt.registerLazySingleton(() => GetActivitiesUseCase(getIt()));

  // Presentation
  getIt.registerFactory(() => VisitsBloc(
    getVisits: getIt(),
    createVisit: getIt(),
  ));

  getIt.registerFactory(() => DataBloc(
    getCustomers: getIt(),
    getActivities: getIt(),
  ));
}