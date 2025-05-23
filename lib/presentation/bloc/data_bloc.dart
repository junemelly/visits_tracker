import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:visits_tracker/domain/entities/activity.dart';
import 'package:visits_tracker/domain/usecase/usecases.dart';
import '../../domain/entities/customer.dart';


// Events
abstract class DataEvent extends Equatable {
  const DataEvent();
  @override
  List<Object> get props => [];
}

class LoadData extends DataEvent {}

// States
abstract class DataState extends Equatable {
  const DataState();
  @override
  List<Object> get props => [];
}

class DataInitial extends DataState {}
class DataLoading extends DataState {}

class DataLoaded extends DataState {
  final List<Customer> customers;
  final List<Activity> activities;

  const DataLoaded({
    required this.customers,
    required this.activities,
  });

  @override
  List<Object> get props => [customers, activities];
}

class DataError extends DataState {
  final String message;
  const DataError(this.message);
  @override
  List<Object> get props => [message];
}

// BLoC
class DataBloc extends Bloc<DataEvent, DataState> {
  final GetCustomersUseCase getCustomers;
  final GetActivitiesUseCase getActivities;

  DataBloc({
    required this.getCustomers,
    required this.getActivities,
  }) : super(DataInitial()) {
    on<LoadData>(_onLoadData);
  }

  Future<void> _onLoadData(LoadData event, Emitter<DataState> emit) async {
    emit(DataLoading());

    final customersResult = await getCustomers();
    final activitiesResult = await getActivities();

    if (customersResult.isLeft() || activitiesResult.isLeft()) {
      emit(const DataError('Failed to load data'));
      return;
    }

    final customers = customersResult.getOrElse(() => []);
    final activities = activitiesResult.getOrElse(() => []);

    emit(DataLoaded(customers: customers, activities: activities));
  }
}