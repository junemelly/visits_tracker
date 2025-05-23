import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visits_tracker/presentation/widgets/statistics_card.dart';
import '../bloc/visits_bloc.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Statistics')),
      body: BlocBuilder<VisitsBloc, VisitsState>(
        builder: (context, state) {
          if (state is VisitsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is VisitsLoaded) {
            final visits = state.visits;
            final totalVisits = visits.length;
            final completedVisits = visits.where((v) => v.status == 'Completed').length;
            final pendingVisits = visits.where((v) => v.status == 'Pending').length;
            final cancelledVisits = visits.where((v) => v.status == 'Cancelled').length;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  StatisticsCard(
                    title: 'Total Visits',
                    value: totalVisits.toString(),
                    icon: Icons.list,
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 16),
                  StatisticsCard(
                    title: 'Completed',
                    value: completedVisits.toString(),
                    icon: Icons.check_circle,
                    color: Colors.green,
                  ),
                  const SizedBox(height: 16),
                  StatisticsCard(
                    title: 'Pending',
                    value: pendingVisits.toString(),
                    icon: Icons.pending,
                    color: Colors.orange,
                  ),
                  const SizedBox(height: 16),
                  StatisticsCard(
                    title: 'Cancelled',
                    value: cancelledVisits.toString(),
                    icon: Icons.cancel,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 24),
                  if (totalVisits > 0) ...[
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Text(
                              'Completion Rate',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              '${((completedVisits / totalVisits) * 100).toStringAsFixed(1)}%',
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                ],
              ),
            );
          } else if (state is VisitsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(state.message),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}