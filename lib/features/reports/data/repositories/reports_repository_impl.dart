import 'package:maktabty/core/network/app_failure_mapper.dart';
import 'package:maktabty/features/reports/data/datasources/reports_remote_datasource.dart';
import 'package:maktabty/features/reports/domain/entities/daily_report.dart';
import 'package:maktabty/features/reports/domain/entities/monthly_report.dart';
import 'package:maktabty/features/reports/domain/repositories/reports_repository.dart';

class ReportsRepositoryImpl implements ReportsRepository {
  final ReportsRemoteDataSource _remoteDataSource;

  ReportsRepositoryImpl({required this._remoteDataSource});

  @override
  Future<DailyReportEntity> getDailyReport({String? date}) async {
    try {
      final report = await _remoteDataSource.getDailyReport(date: date);
      return report.toEntity();
    } catch (error) {
      throw AppFailureMapper.fromException(error);
    }
  }

  @override
  Future<MonthlyReportEntity> getMonthlyReport({String? month}) async {
    try {
      final report = await _remoteDataSource.getMonthlyReport(month: month);
      return report.toEntity();
    } catch (error) {
      throw AppFailureMapper.fromException(error);
    }
  }
}
