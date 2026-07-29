import 'package:maktabty/core/network/api_exceptions.dart';

String mapSalesError(ApiException error) {
  final status = error.statusCode;
  if (status == 401) {
    return 'Session expired. Please sign in again.';
  }
  if (status == 403) {
    return "You don't have permission.";
  }
  if (status == 404) {
    return 'Sale not found.';
  }
  if (status == 409) {
    return error.message;
  }
  return error.message;
}
