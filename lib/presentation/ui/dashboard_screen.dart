import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visits_tracker/presentation/ui/add_visit_screen.dart';
import 'package:visits_tracker/presentation/ui/statistics_screen.dart';
import 'package:visits_tracker/presentation/widgets/visits_card.dart';
import '../bloc/visits_bloc.dart';
import '../bloc/data_bloc.dart';


class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardState();
}

class _DashboardState extends State<DashboardScreen> {
  int _currentIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<VisitsBloc>().add(LoadVisits());
    context.read<DataBloc>().add(LoadData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildVisitsPage(),
          const StatisticsScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Visits'),
          BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'Stats'),
        ],
      ),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddVisitScreen()),
          );
          if (result == true) {
            context.read<VisitsBloc>().add(LoadVisits());
          }
        },
        child: const Icon(Icons.add),
      )
          : null,
    );
  }

  Widget _buildVisitsPage() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visits'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<VisitsBloc>().add(LoadVisits()),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search visits...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onChanged: (value) {
                context.read<VisitsBloc>().add(SearchVisits(value));
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<VisitsBloc, VisitsState>(
              builder: (context, state) {
                if (state is VisitsLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is VisitsLoaded) {
                  if (state.visits.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.inbox, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text('No visits found'),
                        ],
                      ),
                    );
                  }

                // Sort visits by date descending
                final sortedVisits = [...state.visits]
                  ..sort((a, b) => b.visitDate.compareTo(a.visitDate));

                  return BlocBuilder<DataBloc, DataState>(
                    builder: (context, dataState) {
                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: sortedVisits.length,
                        itemBuilder: (context, index) {
                        final visit = sortedVisits[index];
                          String customerName = 'Customer #${visit.customerId}';

                          if (dataState is DataLoaded) {
                            try {
                              final customer = dataState.customers
                                  .firstWhere((c) => c.id == visit.customerId);
                              customerName = customer.name;
                            } catch (e) {

                            }
                          }

                          return VisitCard(
                            visit: visit,
                            customerName: customerName,
                          );
                        },
                      );
                    },
                  );
                } else if (state is VisitsError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error, size: 64, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(state.message),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => context.read<VisitsBloc>().add(LoadVisits()),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}