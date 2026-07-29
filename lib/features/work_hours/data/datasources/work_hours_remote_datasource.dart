import 'package:dio/dio.dart';
import 'package:maktabty/features/work_hours/data/models/monthly_work_hours_report_model.dart';
import 'package:maktabty/features/work_hours/data/models/work_day_model.dart';
import 'package:maktabty/core/network/data_parsing_exception.dart';

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
    throw const DataParsingException(
      operation: 'GET /work-hours',
      expected: 'JSON object containing a data array',
    );
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
    if (items is! List) {
      throw const DataParsingException(
        operation: 'GET /work-hours',
        expected: 'JSON array',
        field: 'data',
      );
    }
    return items
        .map(
          (item) => WorkDayModel.fromJson(
            requireStringMap(
              item,
              operation: 'GET /work-hours',
              field: 'data[]',
            ),
          ),
        )
        .toList(growable: false);
  }

  WorkDayModel _parseWorkDay(dynamic data) {
    if (data is Map<String, dynamic>) {
      return WorkDayModel.fromJson(data);
    }
    if (data is Map) {
      return WorkDayModel.fromJson(Map<String, dynamic>.from(data));
    }
    throw const DataParsingException(
      operation: 'POST /work-hours',
      expected: 'work day JSON object',
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
    throw const DataParsingException(
      operation: 'GET /work-hours/monthly',
      expected: 'monthly work-hours JSON object',
    );
  }
}
