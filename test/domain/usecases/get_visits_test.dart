import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';
import 'package:visits_tracker/core/error_management.dart';
import 'package:visits_tracker/domain/entities/visit.dart';
import 'package:visits_tracker/domain/repository/visits_repository.dart';
import 'package:visits_tracker/domain/usecase/usecases.dart';

@GenerateMocks([VisitsRepository])
import 'get_visits_test.mocks.dart';

void main() {
  late GetVisitsUseCase usecase;
  late MockVisitsRepository mockRepository;

  setUp(() {
    mockRepository = MockVisitsRepository();
    usecase = GetVisitsUseCase(mockRepository);
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

  group('GetVisitsUseCase', () {
    test('should get visits from repository', () async {
      // arrange
      when(mockRepository.getVisits())
          .thenAnswer((_) async => Right(tVisits));

      // act
      final result = await usecase();

      // assert
      expect(result, Right(tVisits));
      verify(mockRepository.getVisits());
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return failure when repository fails', () async {
      // arrange
      const tFailure = ServerError('Server Error');
      when(mockRepository.getVisits())
          .thenAnswer((_) async => const Left(tFailure));

      // act
      final result = await usecase();

      // assert
      expect(result, const Left(tFailure));
      verify(mockRepository.getVisits());
      verifyNoMoreInteractions(mockRepository);
    });
  });
}