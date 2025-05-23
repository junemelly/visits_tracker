import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:visits_tracker/domain/usecase/usecases.dart';
import '../../core/connectivity_service.dart';
import '../../domain/entities/visit.dart';

late final ConnectivityService connectivityService;

// Events
abstract class VisitsEvent extends Equatable {
  const VisitsEvent();
  @override
  List<Object> get props => [];
}

class LoadVisits extends VisitsEvent {}


class CreateVisit extends VisitsEvent {
  final Visit visit;
  const CreateVisit(this.visit);
  @override
  List<Object> get props => [visit];
}

class SearchVisits extends VisitsEvent {
  final String query;
  const SearchVisits(this.query);
  @override
  List<Object> get props => [query];
}

// States
abstract class VisitsState extends Equatable {
  const VisitsState();
  @override
  List<Object> get props => [];
}

class VisitsInitial extends VisitsState {}
class VisitsLoading extends VisitsState {}

class VisitsLoaded extends VisitsState {
  final List<Visit> visits;
  const VisitsLoaded(this.visits);
  @override
  List<Object> get props => [visits];
}

class VisitsError extends VisitsState {
  final String message;
  const VisitsError(this.message);
  @override
  List<Object> get props => [message];
}

// BLoC
class VisitsBloc extends Bloc<VisitsEvent, VisitsState> {
  final GetVisitsUseCase getVisits;
  final CreateVisitUseCase createVisit;

  List<Visit> _allVisits = [];

  VisitsBloc({
    required this.getVisits,
    required this.createVisit,
  }) : super(VisitsInitial()) {
    on<LoadVisits>(_onLoadVisits);
    on<CreateVisit>(_onCreateVisit);
    on<SearchVisits>(_onSearchVisits);
  }

  Future<void> _onLoadVisits(LoadVisits event, Emitter<VisitsState> emit) async {
    emit(VisitsLoading());

  // Check connectivity first
  final isOnline = await connectivityService.checkConnectivity();
  if (!isOnline) {
    emit(const VisitsError('No internet connection. Please check your network.'));
    return;
  }

    final result = await getVisits();
    result.fold(
          (failure) => emit(VisitsError(failure.message)),
          (visits) {
        _allVisits = visits;
        emit(VisitsLoaded(visits));
      },
    );
  }

  Future<void> _onCreateVisit(CreateVisit event, Emitter<VisitsState> emit) async {
    emit(VisitsLoading());
    final result = await createVisit(event.visit);
    result.fold(
          (failure) => emit(VisitsError(failure.message)),
          (visit) {
        add(LoadVisits()); // Reload all visits
      },
    );
  }

  Future<void> _onSearchVisits(SearchVisits event, Emitter<VisitsState> emit) async {
    if (event.query.isEmpty) {
      emit(VisitsLoaded(_allVisits));
    } else {
      final filteredVisits = _allVisits.where((visit) =>
      visit.notes?.toLowerCase().contains(event.query.toLowerCase()) == true ||
          visit.location?.toLowerCase().contains(event.query.toLowerCase()) == true ||
          visit.status.toLowerCase().contains(event.query.toLowerCase())).toList();
      emit(VisitsLoaded(filteredVisits));
    }
  }
}