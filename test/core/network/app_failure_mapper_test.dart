import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maktabty/core/errors/app_failure.dart';
import 'package:maktabty/core/network/app_failure_mapper.dart';

void main() {
  AppFailure mapResponse(int statusCode, Object? data) {
    final options = RequestOptions(path: '/test');
    return AppFailureMapper.fromException(
      DioException(
        requestOptions: options,
        response: Response<dynamic>(
          requestOptions: options,
          statusCode: statusCode,
          data: data,
        ),
        type: DioExceptionType.badResponse,
      ),
    );
  }

  test('403 ACCOUNT_DISABLED maps to AccountDisabledFailure', () {
    final failure = mapResponse(403, {
      'statusCode': 403,
      'code': 'ACCOUNT_DISABLED',
      'message': 'server text is not used for control flow',
    });

    expect(failure, isA<AccountDisabledFailure>());
    expect(failure.code, FailureCode.accountDisabled);
  });

  test('generic 403 remains ForbiddenFailure', () {
    expect(
      mapResponse(403, {'message': 'Forbidden'}),
      isA<ForbiddenFailure>(),
    );
  });

  test('401 remains UnauthorizedFailure', () {
    expect(
      mapResponse(401, {'code': 'ACCOUNT_DISABLED'}),
      isA<UnauthorizedFailure>(),
    );
  });

  test('malformed disabled response is not misclassified', () {
    expect(mapResponse(403, 'ACCOUNT_DISABLED'), isA<ForbiddenFailure>());
    expect(
      mapResponse(403, {'code': ['ACCOUNT_DISABLED']}),
      isA<ForbiddenFailure>(),
    );
  });
}
