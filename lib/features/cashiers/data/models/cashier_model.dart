import 'package:maktabty/core/network/data_parsing_exception.dart';
import 'package:maktabty/core/network/json_helpers.dart';
import 'package:maktabty/core/utils/text_sanitizer.dart';
import 'package:maktabty/features/cashiers/domain/entities/cashier_entity.dart';

class CashierModel {
  final CashierEntity entity;

  const CashierModel(this.entity);

  factory CashierModel.fromJson(Map<String, dynamic> json) {
    const operation = 'parse cashier';
    return CashierModel(
      CashierEntity(
        id: requireString(json, const ['id'], operation: operation),
        fullName: TextSanitizer.fixMojibake(
          requireString(json, const ['fullName', 'name'], operation: operation),
        ),
        email: requireString(json, const ['email'], operation: operation),
        role: requireString(json, const ['role'], operation: operation),
        storeId: requireString(json, const ['storeId'], operation: operation),
        isActive: optionalBoolValue(json, 'isActive', true),
        createdAt: tolerantDateTime(json, 'createdAt'),
        updatedAt: tolerantDateTime(json, 'updatedAt'),
      ),
    );
  }
}
