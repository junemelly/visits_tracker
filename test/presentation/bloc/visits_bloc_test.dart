import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';
import 'package:visits_tracker/core/error_management.dart';
import 'package:visits_tracker/domain/entities/visit.dart';
import 'package:visits_tracker/domain/usecase/usecases.dart';

import 'package:visits_tracker/presentation/bloc/visits_bloc.dart';

@GenerateMocks([GetVisitsUseCase, CreateVisitUseCase])
import 'visits_bloc_test.mocks.dart';

void main() {
  late VisitsBloc bloc;
  late MockGetVisitsUseCase mockGetVisits;
  late MockCreateVisitUseCase mockCreateVisit;

  setUp(() {
    mockGetVisits = MockGetVisitsUseCase();
    mockCreateVisit = MockCreateVisitUseCase();
    bloc = VisitsBloc(
      getVisits: mockGetVisits,
      createVisit: mockCreateVisit,
    );
  });

  final tVisits = [
    Visit(
      id: 1,
      customerId: 1,
      visitDate: DateTime(2024, 10, 15),
      status: 'Completed',
      location: '123 Main St',
      notes: 'Test visit',
      activitiesDone: const [1, 2],
      createdAt: DateTime(2024, 10, 15),
    ),
  ];

  test('initial state should be VisitsInitial', () {
    expect(bloc.state, equals(VisitsInitial()));
  });

  group('LoadVisits', () {
    blocTest<VisitsBloc, VisitsState>(
      'emits [VisitsLoading, VisitsLoaded] when data is gotten successfully',
      build: () {
        when(mockGetVisits()).thenAnswer((_) async => Right(tVisits));
        return bloc;
      },
      act: (bloc) => bloc.add(LoadVisits()),
      expect: () => [
        VisitsLoading(),
        VisitsLoaded(tVisits),
      ],
    );

    blocTest<VisitsBloc, VisitsState>(
      'emits [VisitsLoading, VisitsError] when getting data fails',
      build: () {
        when(mockGetVisits())
            .thenAnswer((_) async => const Left(ServerError('Server Failure')));
        return bloc;
      },
      act: (bloc) => bloc.add(LoadVisits()),
      expect: () => [
        VisitsLoading(),
        const VisitsError('Server Failure'),
      ],
    );
  });

  group('CreateVisit', () {
    final tVisit = Visit(
      customerId: 1,
      visitDate: DateTime(2024, 10, 15),
      status: 'Pending',
      location: '123 Main St',
      notes: 'New visit',
      activitiesDone: const [1],
      createdAt: DateTime(2024, 10, 15),
    );

    blocTest<VisitsBloc, VisitsState>(
      'emits [VisitsLoading, VisitCreated] when visit is created successfully',
      build: () {
        when(mockCreateVisit(any)).thenAnswer((_) async => Right(tVisit));
        when(mockGetVisits()).thenAnswer((_) async => Right([tVisit]));
        return bloc;
      },
      act: (bloc) => bloc.add(CreateVisitEvent(tVisit)),
      expect: () => [
        VisitsLoading(),
        VisitCreated(tVisit),
        VisitsLoading(),
        VisitsLoaded([tVisit]),
      ],
    );
  });
}