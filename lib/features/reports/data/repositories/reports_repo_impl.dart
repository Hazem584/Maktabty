import 'package:dio/dio.dart';
import 'package:maktabty/core/network/api_exceptions.dart';
import 'package:maktabty/features/reports/data/datasources/reports_remote_datasource.dart';
import 'package:maktabty/features/reports/domain/entities/daily_report.dart';
import 'package:maktabty/features/reports/domain/entities/monthly_report.dart';
import 'package:maktabty/features/reports/domain/repositories/reports_repo.dart';

class ReportsRepositoryImpl implements ReportsRepository {
  final ReportsRemoteDataSource _remoteDataSource;

  ReportsRepositoryImpl({required ReportsRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<DailyReportEntity> getDailyReport({String? date}) async {
    try {
      final report = await _remoteDataSource.getDailyReport(date: date);
      return report.toEntity();
    } on DioException catch (error) {
      throw ApiExceptions.fromDio(error);
    }
  }

  @override
  Future<MonthlyReportEntity> getMonthlyReport({String? month}) async {
    try {
      final report = await _remoteDataSource.getMonthlyReport(month: month);
      return report.toEntity();
    } on DioException catch (error) {
      throw ApiExceptions.fromDio(error);
    }
  }
}
