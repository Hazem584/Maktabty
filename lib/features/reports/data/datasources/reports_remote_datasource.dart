import 'package:dio/dio.dart';
import 'package:maktabty/features/reports/data/models/daily_report_model.dart';
import 'package:maktabty/features/reports/data/models/monthly_report_model.dart';
import 'package:maktabty/core/network/data_parsing_exception.dart';

class ReportsRemoteDataSource {
  final Dio _dio;

  ReportsRemoteDataSource(this._dio);

  Future<DailyReportModel> getDailyReport({String? date}) async {
    final response = await _dio.get(
      '/reports/daily',
      queryParameters: {if (date != null && date.isNotEmpty) 'date': date},
    );
    return _parseDaily(response.data);
  }

  Future<MonthlyReportModel> getMonthlyReport({String? month}) async {
    final response = await _dio.get(
      '/reports/monthly-with-time',
      queryParameters: {if (month != null && month.isNotEmpty) 'month': month},
    );
    return _parseMonthly(response.data);
  }

  DailyReportModel _parseDaily(dynamic data) {
    return DailyReportModel.fromJson(
      requireStringMap(data, operation: 'GET /reports/daily'),
    );
  }

  MonthlyReportModel _parseMonthly(dynamic data) {
    return MonthlyReportModel.fromJson(
      requireStringMap(data, operation: 'GET /reports/monthly-with-time'),
    );
  }
}
