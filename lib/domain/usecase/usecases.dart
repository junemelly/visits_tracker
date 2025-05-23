import 'package:dartz/dartz.dart';
import 'package:visits_tracker/core/error_management.dart';
import 'package:visits_tracker/domain/entities/customer.dart';
import 'package:visits_tracker/domain/entities/activity.dart';
import 'package:visits_tracker/domain/entities/visit.dart';
import 'package:visits_tracker/domain/repository/visits_repository.dart';


class GetVisitsUseCase {
  final VisitsRepository repository;
  GetVisitsUseCase(this.repository);

  Future<Either<ErrorManagement, List<Visit>>> call() async {
    return await repository.getVisits();
  }
}

class CreateVisitUseCase {
  final VisitsRepository repository;
  CreateVisitUseCase(this.repository);

  Future<Either<ErrorManagement, Visit>> call(Visit visit) async {
    return await repository.createVisit(visit);
  }
}

class GetCustomersUseCase {
  final VisitsRepository repository;
  GetCustomersUseCase(this.repository);

  Future<Either<ErrorManagement, List<Customer>>> call() async {
    return await repository.getCustomers();
  }
}

class GetActivitiesUseCase {
  final VisitsRepository repository;
  GetActivitiesUseCase(this.repository);

  Future<Either<ErrorManagement, List<Activity>>> call() async {
    return await repository.getActivities();
  }
}