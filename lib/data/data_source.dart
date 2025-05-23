
import 'package:dio/dio.dart';
import 'package:visits_tracker/data/models/activity_model.dart';
import 'models/visit_model.dart';
import 'models/customer_model.dart';

abstract class ApiDataSource {
  Future<List<VisitModel>> getVisits();
  Future<VisitModel> createVisit(VisitModel visit);
  Future<List<CustomerModel>> getCustomers();
  Future<List<ActivityModel>> getActivities();
}

class ApiDataSourceImpl implements ApiDataSource {
  final Dio dio;

  ApiDataSourceImpl(this.dio);

  @override
  Future<List<VisitModel>> getVisits() async {
  try {
    final response = await dio.get('/visits');
    print('API Response: ${response.data}'); // Debug line

    if (response.statusCode == 200) {
    final List<dynamic> data = response.data;
      return data.map((json) {
        print('Parsing visit: $json'); // Debug line
        return VisitModel.fromJson(json);
      }).toList();
    } else {
      throw Exception('Failed to load visits');
    }
  } catch (e) {
    print('Error loading visits: $e'); // Debug line
    throw Exception('Network error: $e');
  }
  }

  @override
  Future<VisitModel> createVisit(VisitModel visit) async {
    final response = await dio.post(
      '/visits',
      data: visit.toJson(),
      options: Options(headers: {'Prefer': 'return=representation'}),
    );
    final List<dynamic> data = response.data;
    return VisitModel.fromJson(data.first);
  }

  @override
  Future<List<CustomerModel>> getCustomers() async {
    final response = await dio.get('/customers');
    final List<dynamic> data = response.data;
    return data.map((json) => CustomerModel.fromJson(json)).toList();
  }

  @override
  Future<List<ActivityModel>> getActivities() async {
    final response = await dio.get('/activities');
    final List<dynamic> data = response.data;
    return data.map((json) => ActivityModel.fromJson(json)).toList();
  }
}