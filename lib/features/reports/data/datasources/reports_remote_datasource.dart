import 'package:dio/dio.dart';
import 'package:maktabty/features/reports/data/models/daily_report_model.dart';
import 'package:maktabty/features/reports/data/models/monthly_report_model.dart';

class ReportsRemoteDataSource {
  final Dio _dio;

  ReportsRemoteDataSource(this._dio);

  Future<DailyReportModel> getDailyReport({String? date}) async {
    final response = await _dio.get(
      '/reports/daily',
      queryParameters: {
        if (date != null && date.isNotEmpty) 'date': date,
      },
    );
    return _parseDaily(response.data);
  }

  Future<MonthlyReportModel> getMonthlyReport({String? month}) async {
    final response = await _dio.get(
      '/reports/monthly-with-time',
      queryParameters: {
        if (month != null && month.isNotEmpty) 'month': month,
      },
    );
    return _parseMonthly(response.data);
  }

  DailyReportModel _parseDaily(dynamic data) {
    if (data is Map<String, dynamic>) {
      return DailyReportModel.fromJson(data);
    }
    if (data is Map) {
      return DailyReportModel.fromJson(Map<String, dynamic>.from(data));
    }
    return const DailyReportModel(
      date: '',
      totalSalesAmount: 0,
      totalOrders: 0,
      totalItemsSold: 0,
      topProducts: [],
    );
  }

  MonthlyReportModel _parseMonthly(dynamic data) {
    if (data is Map<String, dynamic>) {
      return MonthlyReportModel.fromJson(data);
    }
    if (data is Map) {
      return MonthlyReportModel.fromJson(Map<String, dynamic>.from(data));
    }
    return const MonthlyReportModel(
      month: '',
      totalSalesAmount: 0,
      totalOrders: 0,
      totalItemsSold: 0,
      dailyBreakdown: [],
    );
  }
}
