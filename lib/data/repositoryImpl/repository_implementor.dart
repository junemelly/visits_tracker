import 'package:dartz/dartz.dart';
import 'package:visits_tracker/core/error_management.dart';
import 'package:visits_tracker/data/data_source.dart';
import 'package:visits_tracker/data/models/visit_model.dart';
import 'package:visits_tracker/domain/entities/customer.dart';
import 'package:visits_tracker/domain/entities/activity.dart';
import 'package:visits_tracker/domain/entities/visit.dart';
import 'package:visits_tracker/domain/repository/visits_repository.dart';


class VisitsRepositoryImpl implements VisitsRepository {
  final ApiDataSource dataSource;

  VisitsRepositoryImpl(this.dataSource);

  @override
  Future<Either<ErrorManagement, List<Visit>>> getVisits() async {
    try {
      final visits = await dataSource.getVisits();
      return Right(visits);
    } catch (e) {
      return Left(ServerError(e.toString()));
    }
  }

  @override
  Future<Either<ErrorManagement, Visit>> createVisit(Visit visit) async {
    try {
      final visitModel = VisitModel.fromEntity(visit);
      final createdVisit = await dataSource.createVisit(visitModel);
      return Right(createdVisit);
    } catch (e) {
      return Left(ServerError(e.toString()));
    }
  }

  @override
  Future<Either<ErrorManagement, List<Customer>>> getCustomers() async {
    try {
      final customers = await dataSource.getCustomers();
      return Right(customers);
    } catch (e) {
      return Left(ServerError(e.toString()));
    }
  }

  @override
  Future<Either<ErrorManagement, List<Activity>>> getActivities() async {
    try {
      final activities = await dataSource.getActivities();
      return Right(activities);
    } catch (e) {
      return Left(ServerError(e.toString()));
    }
  }
}