import 'package:dartz/dartz.dart';
import 'package:visits_tracker/core/error_management.dart';
import 'package:visits_tracker/domain/entities/customer.dart';
import 'package:visits_tracker/domain/entities/activity.dart';
import 'package:visits_tracker/domain/entities/visit.dart';


abstract class VisitsRepository {
  Future<Either<ErrorManagement, List<Visit>>> getVisits();
  Future<Either<ErrorManagement, Visit>> createVisit(Visit visit);
  Future<Either<ErrorManagement, List<Customer>>> getCustomers();
  Future<Either<ErrorManagement, List<Activity>>> getActivities();
}