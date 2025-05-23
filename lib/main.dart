import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visits_tracker/presentation/ui/dashboard_screen.dart';
import 'injection.dart' as di;
import 'presentation/bloc/visits_bloc.dart';
import 'presentation/bloc/data_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.getIt<VisitsBloc>()),
        BlocProvider(create: (_) => di.getIt<DataBloc>()),
      ],
      child: MaterialApp(
        title: 'Visits Tracker',
        debugShowCheckedModeBanner: false,
      theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            ),
        home: const DashboardScreen(),
        ),
    );
  }
}
