import 'package:dio/dio.dart';
import 'package:maktabty/core/network/api_exceptions.dart';
import 'package:maktabty/core/network/data_parsing_exception.dart';
import 'package:maktabty/features/work_hours/data/datasources/work_hours_remote_datasource.dart';
import 'package:maktabty/features/work_hours/domain/entities/monthly_work_hours_report.dart';
import 'package:maktabty/features/work_hours/domain/entities/work_day.dart';
import 'package:maktabty/features/work_hours/domain/repositories/work_hours_repository.dart';

class WorkHoursRepositoryImpl implements WorkHoursRepository {
  final WorkHoursRemoteDataSource _remoteDataSource;

  WorkHoursRepositoryImpl({required WorkHoursRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  @override
  Future<WorkDayEntity> upsertWorkDay({
    required String date,
    String? shift1Start,
    String? shift1End,
    String? shift2Start,
    String? shift2End,
  }) async {
    try {
      final workDay = await _remoteDataSource.upsertWorkDay(
        date: date,
        shift1Start: shift1Start,
        shift1End: shift1End,
        shift2Start: shift2Start,
        shift2End: shift2End,
      );
      return workDay.toEntity();
    } on DioException catch (error) {
      throw ApiExceptions.fromDio(error);
    } on DataParsingException catch (error) {
      throw ApiExceptions.fromParsing(error);
    }
  }

  @override
  Future<List<WorkDayEntity>> getByDate({
    required String date,
    String? userId,
  }) async {
    try {
      final days = await _remoteDataSource.getByDate(
        date: date,
        userId: userId,
      );
      return days.map((item) => item.toEntity()).toList();
    } on DioException catch (error) {
      throw ApiExceptions.fromDio(error);
    } on DataParsingException catch (error) {
      throw ApiExceptions.fromParsing(error);
    }
  }

  @override
  Future<MonthlyWorkHoursReportEntity> getMonthly({
    required String month,
  }) async {
    try {
      final report = await _remoteDataSource.getMonthly(month: month);
      return report.toEntity();
    } on DioException catch (error) {
      throw ApiExceptions.fromDio(error);
    } on DataParsingException catch (error) {
      throw ApiExceptions.fromParsing(error);
    }
  }
}
