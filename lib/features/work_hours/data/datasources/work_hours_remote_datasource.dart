import 'package:dio/dio.dart';
import 'package:maktabty/features/work_hours/data/models/monthly_work_hours_report_model.dart';
import 'package:maktabty/features/work_hours/data/models/work_day_model.dart';

class WorkHoursRemoteDataSource {
  final Dio _dio;

  WorkHoursRemoteDataSource(this._dio);

  Future<WorkDayModel> upsertWorkDay({
    required String date,
    String? shift1Start,
    String? shift1End,
    String? shift2Start,
    String? shift2End,
  }) async {
    final response = await _dio.post(
      '/work-hours',
      data: {
        'date': date,
        'shift1Start': ?shift1Start,
        'shift1End': ?shift1End,
        'shift2Start': ?shift2Start,
        'shift2End': ?shift2End,
      },
    );
    return _parseWorkDay(response.data);
  }

  Future<List<WorkDayModel>> getByDate({
    required String date,
    String? userId,
  }) async {
    final response = await _dio.get(
      '/work-hours',
      queryParameters: {
        'date': date,
        if (userId != null && userId.isNotEmpty) 'userId': userId,
      },
    );

    final data = response.data;
    if (data is Map<String, dynamic>) {
      final items = data['data'];
      return _parseList(items);
    }
    if (data is Map) {
      final items = Map<String, dynamic>.from(data)['data'];
      return _parseList(items);
    }
    return const [];
  }

  Future<MonthlyWorkHoursReportModel> getMonthly({
    required String month,
  }) async {
    final response = await _dio.get(
      '/work-hours/monthly',
      queryParameters: {'month': month},
    );
    return _parseMonthly(response.data);
  }

  List<WorkDayModel> _parseList(dynamic items) {
    if (items is List) {
      return items
          .whereType<Map>()
          .map((item) => WorkDayModel.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    }
    if (items is List<Map<String, dynamic>>) {
      return items.map(WorkDayModel.fromJson).toList();
    }
    return const [];
  }

  WorkDayModel _parseWorkDay(dynamic data) {
    if (data is Map<String, dynamic>) {
      return WorkDayModel.fromJson(data);
    }
    if (data is Map) {
      return WorkDayModel.fromJson(Map<String, dynamic>.from(data));
    }
    return const WorkDayModel(
      id: '',
      userId: '',
      date: null,
      shift1Start: null,
      shift1End: null,
      shift2Start: null,
      shift2End: null,
      totalMinutes: 0,
      createdAt: null,
      updatedAt: null,
      user: null,
    );
  }

  MonthlyWorkHoursReportModel _parseMonthly(dynamic data) {
    if (data is Map<String, dynamic>) {
      return MonthlyWorkHoursReportModel.fromJson(data);
    }
    if (data is Map) {
      return MonthlyWorkHoursReportModel.fromJson(
        Map<String, dynamic>.from(data),
      );
    }
    return const MonthlyWorkHoursReportModel(
      month: '',
      totalsByUser: [],
      totalsByDay: [],
    );
  }
}
