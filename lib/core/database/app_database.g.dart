// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CachedProductsTable extends CachedProducts
    with TableInfo<$CachedProductsTable, CachedProduct> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedProductsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sellingPriceMinorMeta = const VerificationMeta(
    'sellingPriceMinor',
  );
  @override
  late final GeneratedColumn<int> sellingPriceMinor = GeneratedColumn<int>(
    'selling_price_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serverStockMeta = const VerificationMeta(
    'serverStock',
  );
  @override
  late final GeneratedColumn<int> serverStock = GeneratedColumn<int>(
    'server_stock',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reservedStockMeta = const VerificationMeta(
    'reservedStock',
  );
  @override
  late final GeneratedColumn<int> reservedStock = GeneratedColumn<int>(
    'reserved_stock',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _archivedAtMeta = const VerificationMeta(
    'archivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> archivedAt = GeneratedColumn<DateTime>(
    'archived_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _archiveReasonMeta = const VerificationMeta(
    'archiveReason',
  );
  @override
  late final GeneratedColumn<String> archiveReason = GeneratedColumn<String>(
    'archive_reason',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _serverUpdatedAtMeta = const VerificationMeta(
    'serverUpdatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> serverUpdatedAt =
      GeneratedColumn<DateTime>(
        'server_updated_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _lastCachedAtMeta = const VerificationMeta(
    'lastCachedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastCachedAt = GeneratedColumn<DateTime>(
    'last_cached_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    productId,
    name,
    code,
    sellingPriceMinor,
    serverStock,
    reservedStock,
    isActive,
    archivedAt,
    archiveReason,
    category,
    serverUpdatedAt,
    lastCachedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_products';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedProduct> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    }
    if (data.containsKey('selling_price_minor')) {
      context.handle(
        _sellingPriceMinorMeta,
        sellingPriceMinor.isAcceptableOrUnknown(
          data['selling_price_minor']!,
          _sellingPriceMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sellingPriceMinorMeta);
    }
    if (data.containsKey('server_stock')) {
      context.handle(
        _serverStockMeta,
        serverStock.isAcceptableOrUnknown(
          data['server_stock']!,
          _serverStockMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_serverStockMeta);
    }
    if (data.containsKey('reserved_stock')) {
      context.handle(
        _reservedStockMeta,
        reservedStock.isAcceptableOrUnknown(
          data['reserved_stock']!,
          _reservedStockMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('archived_at')) {
      context.handle(
        _archivedAtMeta,
        archivedAt.isAcceptableOrUnknown(data['archived_at']!, _archivedAtMeta),
      );
    }
    if (data.containsKey('archive_reason')) {
      context.handle(
        _archiveReasonMeta,
        archiveReason.isAcceptableOrUnknown(
          data['archive_reason']!,
          _archiveReasonMeta,
        ),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('server_updated_at')) {
      context.handle(
        _serverUpdatedAtMeta,
        serverUpdatedAt.isAcceptableOrUnknown(
          data['server_updated_at']!,
          _serverUpdatedAtMeta,
        ),
      );
    }
    if (data.containsKey('last_cached_at')) {
      context.handle(
        _lastCachedAtMeta,
        lastCachedAt.isAcceptableOrUnknown(
          data['last_cached_at']!,
          _lastCachedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastCachedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {productId};
  @override
  CachedProduct map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedProduct(
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      ),
      sellingPriceMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}selling_price_minor'],
      )!,
      serverStock: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}server_stock'],
      )!,
      reservedStock: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reserved_stock'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      archivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}archived_at'],
      ),
      archiveReason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}archive_reason'],
      ),
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      ),
      serverUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}server_updated_at'],
      ),
      lastCachedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_cached_at'],
      )!,
    );
  }

  @override
  $CachedProductsTable createAlias(String alias) {
    return $CachedProductsTable(attachedDatabase, alias);
  }
}

class CachedProduct extends DataClass implements Insertable<CachedProduct> {
  final String productId;
  final String name;
  final String? code;
  final int sellingPriceMinor;
  final int serverStock;
  final int reservedStock;
  final bool isActive;
  final DateTime? archivedAt;
  final String? archiveReason;
  final String? category;
  final DateTime? serverUpdatedAt;
  final DateTime lastCachedAt;
  const CachedProduct({
    required this.productId,
    required this.name,
    this.code,
    required this.sellingPriceMinor,
    required this.serverStock,
    required this.reservedStock,
    required this.isActive,
    this.archivedAt,
    this.archiveReason,
    this.category,
    this.serverUpdatedAt,
    required this.lastCachedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['product_id'] = Variable<String>(productId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || code != null) {
      map['code'] = Variable<String>(code);
    }
    map['selling_price_minor'] = Variable<int>(sellingPriceMinor);
    map['server_stock'] = Variable<int>(serverStock);
    map['reserved_stock'] = Variable<int>(reservedStock);
    map['is_active'] = Variable<bool>(isActive);
    if (!nullToAbsent || archivedAt != null) {
      map['archived_at'] = Variable<DateTime>(archivedAt);
    }
    if (!nullToAbsent || archiveReason != null) {
      map['archive_reason'] = Variable<String>(archiveReason);
    }
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    if (!nullToAbsent || serverUpdatedAt != null) {
      map['server_updated_at'] = Variable<DateTime>(serverUpdatedAt);
    }
    map['last_cached_at'] = Variable<DateTime>(lastCachedAt);
    return map;
  }

  CachedProductsCompanion toCompanion(bool nullToAbsent) {
    return CachedProductsCompanion(
      productId: Value(productId),
      name: Value(name),
      code: code == null && nullToAbsent ? const Value.absent() : Value(code),
      sellingPriceMinor: Value(sellingPriceMinor),
      serverStock: Value(serverStock),
      reservedStock: Value(reservedStock),
      isActive: Value(isActive),
      archivedAt: archivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedAt),
      archiveReason: archiveReason == null && nullToAbsent
          ? const Value.absent()
          : Value(archiveReason),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      serverUpdatedAt: serverUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(serverUpdatedAt),
      lastCachedAt: Value(lastCachedAt),
    );
  }

  factory CachedProduct.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedProduct(
      productId: serializer.fromJson<String>(json['productId']),
      name: serializer.fromJson<String>(json['name']),
      code: serializer.fromJson<String?>(json['code']),
      sellingPriceMinor: serializer.fromJson<int>(json['sellingPriceMinor']),
      serverStock: serializer.fromJson<int>(json['serverStock']),
      reservedStock: serializer.fromJson<int>(json['reservedStock']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      archivedAt: serializer.fromJson<DateTime?>(json['archivedAt']),
      archiveReason: serializer.fromJson<String?>(json['archiveReason']),
      category: serializer.fromJson<String?>(json['category']),
      serverUpdatedAt: serializer.fromJson<DateTime?>(json['serverUpdatedAt']),
      lastCachedAt: serializer.fromJson<DateTime>(json['lastCachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'productId': serializer.toJson<String>(productId),
      'name': serializer.toJson<String>(name),
      'code': serializer.toJson<String?>(code),
      'sellingPriceMinor': serializer.toJson<int>(sellingPriceMinor),
      'serverStock': serializer.toJson<int>(serverStock),
      'reservedStock': serializer.toJson<int>(reservedStock),
      'isActive': serializer.toJson<bool>(isActive),
      'archivedAt': serializer.toJson<DateTime?>(archivedAt),
      'archiveReason': serializer.toJson<String?>(archiveReason),
      'category': serializer.toJson<String?>(category),
      'serverUpdatedAt': serializer.toJson<DateTime?>(serverUpdatedAt),
      'lastCachedAt': serializer.toJson<DateTime>(lastCachedAt),
    };
  }

  CachedProduct copyWith({
    String? productId,
    String? name,
    Value<String?> code = const Value.absent(),
    int? sellingPriceMinor,
    int? serverStock,
    int? reservedStock,
    bool? isActive,
    Value<DateTime?> archivedAt = const Value.absent(),
    Value<String?> archiveReason = const Value.absent(),
    Value<String?> category = const Value.absent(),
    Value<DateTime?> serverUpdatedAt = const Value.absent(),
    DateTime? lastCachedAt,
  }) => CachedProduct(
    productId: productId ?? this.productId,
    name: name ?? this.name,
    code: code.present ? code.value : this.code,
    sellingPriceMinor: sellingPriceMinor ?? this.sellingPriceMinor,
    serverStock: serverStock ?? this.serverStock,
    reservedStock: reservedStock ?? this.reservedStock,
    isActive: isActive ?? this.isActive,
    archivedAt: archivedAt.present ? archivedAt.value : this.archivedAt,
    archiveReason: archiveReason.present
        ? archiveReason.value
        : this.archiveReason,
    category: category.present ? category.value : this.category,
    serverUpdatedAt: serverUpdatedAt.present
        ? serverUpdatedAt.value
        : this.serverUpdatedAt,
    lastCachedAt: lastCachedAt ?? this.lastCachedAt,
  );
  CachedProduct copyWithCompanion(CachedProductsCompanion data) {
    return CachedProduct(
      productId: data.productId.present ? data.productId.value : this.productId,
      name: data.name.present ? data.name.value : this.name,
      code: data.code.present ? data.code.value : this.code,
      sellingPriceMinor: data.sellingPriceMinor.present
          ? data.sellingPriceMinor.value
          : this.sellingPriceMinor,
      serverStock: data.serverStock.present
          ? data.serverStock.value
          : this.serverStock,
      reservedStock: data.reservedStock.present
          ? data.reservedStock.value
          : this.reservedStock,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      archivedAt: data.archivedAt.present
          ? data.archivedAt.value
          : this.archivedAt,
      archiveReason: data.archiveReason.present
          ? data.archiveReason.value
          : this.archiveReason,
      category: data.category.present ? data.category.value : this.category,
      serverUpdatedAt: data.serverUpdatedAt.present
          ? data.serverUpdatedAt.value
          : this.serverUpdatedAt,
      lastCachedAt: data.lastCachedAt.present
          ? data.lastCachedAt.value
          : this.lastCachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedProduct(')
          ..write('productId: $productId, ')
          ..write('name: $name, ')
          ..write('code: $code, ')
          ..write('sellingPriceMinor: $sellingPriceMinor, ')
          ..write('serverStock: $serverStock, ')
          ..write('reservedStock: $reservedStock, ')
          ..write('isActive: $isActive, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('archiveReason: $archiveReason, ')
          ..write('category: $category, ')
          ..write('serverUpdatedAt: $serverUpdatedAt, ')
          ..write('lastCachedAt: $lastCachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    productId,
    name,
    code,
    sellingPriceMinor,
    serverStock,
    reservedStock,
    isActive,
    archivedAt,
    archiveReason,
    category,
    serverUpdatedAt,
    lastCachedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedProduct &&
          other.productId == this.productId &&
          other.name == this.name &&
          other.code == this.code &&
          other.sellingPriceMinor == this.sellingPriceMinor &&
          other.serverStock == this.serverStock &&
          other.reservedStock == this.reservedStock &&
          other.isActive == this.isActive &&
          other.archivedAt == this.archivedAt &&
          other.archiveReason == this.archiveReason &&
          other.category == this.category &&
          other.serverUpdatedAt == this.serverUpdatedAt &&
          other.lastCachedAt == this.lastCachedAt);
}

class CachedProductsCompanion extends UpdateCompanion<CachedProduct> {
  final Value<String> productId;
  final Value<String> name;
  final Value<String?> code;
  final Value<int> sellingPriceMinor;
  final Value<int> serverStock;
  final Value<int> reservedStock;
  final Value<bool> isActive;
  final Value<DateTime?> archivedAt;
  final Value<String?> archiveReason;
  final Value<String?> category;
  final Value<DateTime?> serverUpdatedAt;
  final Value<DateTime> lastCachedAt;
  final Value<int> rowid;
  const CachedProductsCompanion({
    this.productId = const Value.absent(),
    this.name = const Value.absent(),
    this.code = const Value.absent(),
    this.sellingPriceMinor = const Value.absent(),
    this.serverStock = const Value.absent(),
    this.reservedStock = const Value.absent(),
    this.isActive = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.archiveReason = const Value.absent(),
    this.category = const Value.absent(),
    this.serverUpdatedAt = const Value.absent(),
    this.lastCachedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedProductsCompanion.insert({
    required String productId,
    required String name,
    this.code = const Value.absent(),
    required int sellingPriceMinor,
    required int serverStock,
    this.reservedStock = const Value.absent(),
    this.isActive = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.archiveReason = const Value.absent(),
    this.category = const Value.absent(),
    this.serverUpdatedAt = const Value.absent(),
    required DateTime lastCachedAt,
    this.rowid = const Value.absent(),
  }) : productId = Value(productId),
       name = Value(name),
       sellingPriceMinor = Value(sellingPriceMinor),
       serverStock = Value(serverStock),
       lastCachedAt = Value(lastCachedAt);
  static Insertable<CachedProduct> custom({
    Expression<String>? productId,
    Expression<String>? name,
    Expression<String>? code,
    Expression<int>? sellingPriceMinor,
    Expression<int>? serverStock,
    Expression<int>? reservedStock,
    Expression<bool>? isActive,
    Expression<DateTime>? archivedAt,
    Expression<String>? archiveReason,
    Expression<String>? category,
    Expression<DateTime>? serverUpdatedAt,
    Expression<DateTime>? lastCachedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (productId != null) 'product_id': productId,
      if (name != null) 'name': name,
      if (code != null) 'code': code,
      if (sellingPriceMinor != null) 'selling_price_minor': sellingPriceMinor,
      if (serverStock != null) 'server_stock': serverStock,
      if (reservedStock != null) 'reserved_stock': reservedStock,
      if (isActive != null) 'is_active': isActive,
      if (archivedAt != null) 'archived_at': archivedAt,
      if (archiveReason != null) 'archive_reason': archiveReason,
      if (category != null) 'category': category,
      if (serverUpdatedAt != null) 'server_updated_at': serverUpdatedAt,
      if (lastCachedAt != null) 'last_cached_at': lastCachedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedProductsCompanion copyWith({
    Value<String>? productId,
    Value<String>? name,
    Value<String?>? code,
    Value<int>? sellingPriceMinor,
    Value<int>? serverStock,
    Value<int>? reservedStock,
    Value<bool>? isActive,
    Value<DateTime?>? archivedAt,
    Value<String?>? archiveReason,
    Value<String?>? category,
    Value<DateTime?>? serverUpdatedAt,
    Value<DateTime>? lastCachedAt,
    Value<int>? rowid,
  }) {
    return CachedProductsCompanion(
      productId: productId ?? this.productId,
      name: name ?? this.name,
      code: code ?? this.code,
      sellingPriceMinor: sellingPriceMinor ?? this.sellingPriceMinor,
      serverStock: serverStock ?? this.serverStock,
      reservedStock: reservedStock ?? this.reservedStock,
      isActive: isActive ?? this.isActive,
      archivedAt: archivedAt ?? this.archivedAt,
      archiveReason: archiveReason ?? this.archiveReason,
      category: category ?? this.category,
      serverUpdatedAt: serverUpdatedAt ?? this.serverUpdatedAt,
      lastCachedAt: lastCachedAt ?? this.lastCachedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (sellingPriceMinor.present) {
      map['selling_price_minor'] = Variable<int>(sellingPriceMinor.value);
    }
    if (serverStock.present) {
      map['server_stock'] = Variable<int>(serverStock.value);
    }
    if (reservedStock.present) {
      map['reserved_stock'] = Variable<int>(reservedStock.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (archivedAt.present) {
      map['archived_at'] = Variable<DateTime>(archivedAt.value);
    }
    if (archiveReason.present) {
      map['archive_reason'] = Variable<String>(archiveReason.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (serverUpdatedAt.present) {
      map['server_updated_at'] = Variable<DateTime>(serverUpdatedAt.value);
    }
    if (lastCachedAt.present) {
      map['last_cached_at'] = Variable<DateTime>(lastCachedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedProductsCompanion(')
          ..write('productId: $productId, ')
          ..write('name: $name, ')
          ..write('code: $code, ')
          ..write('sellingPriceMinor: $sellingPriceMinor, ')
          ..write('serverStock: $serverStock, ')
          ..write('reservedStock: $reservedStock, ')
          ..write('isActive: $isActive, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('archiveReason: $archiveReason, ')
          ..write('category: $category, ')
          ..write('serverUpdatedAt: $serverUpdatedAt, ')
          ..write('lastCachedAt: $lastCachedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TenantCachedProductsTable extends TenantCachedProducts
    with TableInfo<$TenantCachedProductsTable, TenantCachedProduct> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TenantCachedProductsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _storeIdMeta = const VerificationMeta(
    'storeId',
  );
  @override
  late final GeneratedColumn<String> storeId = GeneratedColumn<String>(
    'store_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sellingPriceMinorMeta = const VerificationMeta(
    'sellingPriceMinor',
  );
  @override
  late final GeneratedColumn<int> sellingPriceMinor = GeneratedColumn<int>(
    'selling_price_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serverStockMeta = const VerificationMeta(
    'serverStock',
  );
  @override
  late final GeneratedColumn<int> serverStock = GeneratedColumn<int>(
    'server_stock',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reservedStockMeta = const VerificationMeta(
    'reservedStock',
  );
  @override
  late final GeneratedColumn<int> reservedStock = GeneratedColumn<int>(
    'reserved_stock',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _archivedAtMeta = const VerificationMeta(
    'archivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> archivedAt = GeneratedColumn<DateTime>(
    'archived_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _archiveReasonMeta = const VerificationMeta(
    'archiveReason',
  );
  @override
  late final GeneratedColumn<String> archiveReason = GeneratedColumn<String>(
    'archive_reason',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _serverUpdatedAtMeta = const VerificationMeta(
    'serverUpdatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> serverUpdatedAt =
      GeneratedColumn<DateTime>(
        'server_updated_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _lastCachedAtMeta = const VerificationMeta(
    'lastCachedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastCachedAt = GeneratedColumn<DateTime>(
    'last_cached_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    storeId,
    productId,
    name,
    code,
    sellingPriceMinor,
    serverStock,
    reservedStock,
    isActive,
    archivedAt,
    archiveReason,
    category,
    serverUpdatedAt,
    lastCachedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tenant_cached_products';
  @override
  VerificationContext validateIntegrity(
    Insertable<TenantCachedProduct> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('store_id')) {
      context.handle(
        _storeIdMeta,
        storeId.isAcceptableOrUnknown(data['store_id']!, _storeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_storeIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    }
    if (data.containsKey('selling_price_minor')) {
      context.handle(
        _sellingPriceMinorMeta,
        sellingPriceMinor.isAcceptableOrUnknown(
          data['selling_price_minor']!,
          _sellingPriceMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sellingPriceMinorMeta);
    }
    if (data.containsKey('server_stock')) {
      context.handle(
        _serverStockMeta,
        serverStock.isAcceptableOrUnknown(
          data['server_stock']!,
          _serverStockMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_serverStockMeta);
    }
    if (data.containsKey('reserved_stock')) {
      context.handle(
        _reservedStockMeta,
        reservedStock.isAcceptableOrUnknown(
          data['reserved_stock']!,
          _reservedStockMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('archived_at')) {
      context.handle(
        _archivedAtMeta,
        archivedAt.isAcceptableOrUnknown(data['archived_at']!, _archivedAtMeta),
      );
    }
    if (data.containsKey('archive_reason')) {
      context.handle(
        _archiveReasonMeta,
        archiveReason.isAcceptableOrUnknown(
          data['archive_reason']!,
          _archiveReasonMeta,
        ),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('server_updated_at')) {
      context.handle(
        _serverUpdatedAtMeta,
        serverUpdatedAt.isAcceptableOrUnknown(
          data['server_updated_at']!,
          _serverUpdatedAtMeta,
        ),
      );
    }
    if (data.containsKey('last_cached_at')) {
      context.handle(
        _lastCachedAtMeta,
        lastCachedAt.isAcceptableOrUnknown(
          data['last_cached_at']!,
          _lastCachedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastCachedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {storeId, productId};
  @override
  TenantCachedProduct map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TenantCachedProduct(
      storeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}store_id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      ),
      sellingPriceMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}selling_price_minor'],
      )!,
      serverStock: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}server_stock'],
      )!,
      reservedStock: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reserved_stock'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      archivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}archived_at'],
      ),
      archiveReason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}archive_reason'],
      ),
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      ),
      serverUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}server_updated_at'],
      ),
      lastCachedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_cached_at'],
      )!,
    );
  }

  @override
  $TenantCachedProductsTable createAlias(String alias) {
    return $TenantCachedProductsTable(attachedDatabase, alias);
  }
}

class TenantCachedProduct extends DataClass
    implements Insertable<TenantCachedProduct> {
  final String storeId;
  final String productId;
  final String name;
  final String? code;
  final int sellingPriceMinor;
  final int serverStock;
  final int reservedStock;
  final bool isActive;
  final DateTime? archivedAt;
  final String? archiveReason;
  final String? category;
  final DateTime? serverUpdatedAt;
  final DateTime lastCachedAt;
  const TenantCachedProduct({
    required this.storeId,
    required this.productId,
    required this.name,
    this.code,
    required this.sellingPriceMinor,
    required this.serverStock,
    required this.reservedStock,
    required this.isActive,
    this.archivedAt,
    this.archiveReason,
    this.category,
    this.serverUpdatedAt,
    required this.lastCachedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['store_id'] = Variable<String>(storeId);
    map['product_id'] = Variable<String>(productId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || code != null) {
      map['code'] = Variable<String>(code);
    }
    map['selling_price_minor'] = Variable<int>(sellingPriceMinor);
    map['server_stock'] = Variable<int>(serverStock);
    map['reserved_stock'] = Variable<int>(reservedStock);
    map['is_active'] = Variable<bool>(isActive);
    if (!nullToAbsent || archivedAt != null) {
      map['archived_at'] = Variable<DateTime>(archivedAt);
    }
    if (!nullToAbsent || archiveReason != null) {
      map['archive_reason'] = Variable<String>(archiveReason);
    }
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    if (!nullToAbsent || serverUpdatedAt != null) {
      map['server_updated_at'] = Variable<DateTime>(serverUpdatedAt);
    }
    map['last_cached_at'] = Variable<DateTime>(lastCachedAt);
    return map;
  }

  TenantCachedProductsCompanion toCompanion(bool nullToAbsent) {
    return TenantCachedProductsCompanion(
      storeId: Value(storeId),
      productId: Value(productId),
      name: Value(name),
      code: code == null && nullToAbsent ? const Value.absent() : Value(code),
      sellingPriceMinor: Value(sellingPriceMinor),
      serverStock: Value(serverStock),
      reservedStock: Value(reservedStock),
      isActive: Value(isActive),
      archivedAt: archivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedAt),
      archiveReason: archiveReason == null && nullToAbsent
          ? const Value.absent()
          : Value(archiveReason),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      serverUpdatedAt: serverUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(serverUpdatedAt),
      lastCachedAt: Value(lastCachedAt),
    );
  }

  factory TenantCachedProduct.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TenantCachedProduct(
      storeId: serializer.fromJson<String>(json['storeId']),
      productId: serializer.fromJson<String>(json['productId']),
      name: serializer.fromJson<String>(json['name']),
      code: serializer.fromJson<String?>(json['code']),
      sellingPriceMinor: serializer.fromJson<int>(json['sellingPriceMinor']),
      serverStock: serializer.fromJson<int>(json['serverStock']),
      reservedStock: serializer.fromJson<int>(json['reservedStock']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      archivedAt: serializer.fromJson<DateTime?>(json['archivedAt']),
      archiveReason: serializer.fromJson<String?>(json['archiveReason']),
      category: serializer.fromJson<String?>(json['category']),
      serverUpdatedAt: serializer.fromJson<DateTime?>(json['serverUpdatedAt']),
      lastCachedAt: serializer.fromJson<DateTime>(json['lastCachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'storeId': serializer.toJson<String>(storeId),
      'productId': serializer.toJson<String>(productId),
      'name': serializer.toJson<String>(name),
      'code': serializer.toJson<String?>(code),
      'sellingPriceMinor': serializer.toJson<int>(sellingPriceMinor),
      'serverStock': serializer.toJson<int>(serverStock),
      'reservedStock': serializer.toJson<int>(reservedStock),
      'isActive': serializer.toJson<bool>(isActive),
      'archivedAt': serializer.toJson<DateTime?>(archivedAt),
      'archiveReason': serializer.toJson<String?>(archiveReason),
      'category': serializer.toJson<String?>(category),
      'serverUpdatedAt': serializer.toJson<DateTime?>(serverUpdatedAt),
      'lastCachedAt': serializer.toJson<DateTime>(lastCachedAt),
    };
  }

  TenantCachedProduct copyWith({
    String? storeId,
    String? productId,
    String? name,
    Value<String?> code = const Value.absent(),
    int? sellingPriceMinor,
    int? serverStock,
    int? reservedStock,
    bool? isActive,
    Value<DateTime?> archivedAt = const Value.absent(),
    Value<String?> archiveReason = const Value.absent(),
    Value<String?> category = const Value.absent(),
    Value<DateTime?> serverUpdatedAt = const Value.absent(),
    DateTime? lastCachedAt,
  }) => TenantCachedProduct(
    storeId: storeId ?? this.storeId,
    productId: productId ?? this.productId,
    name: name ?? this.name,
    code: code.present ? code.value : this.code,
    sellingPriceMinor: sellingPriceMinor ?? this.sellingPriceMinor,
    serverStock: serverStock ?? this.serverStock,
    reservedStock: reservedStock ?? this.reservedStock,
    isActive: isActive ?? this.isActive,
    archivedAt: archivedAt.present ? archivedAt.value : this.archivedAt,
    archiveReason: archiveReason.present
        ? archiveReason.value
        : this.archiveReason,
    category: category.present ? category.value : this.category,
    serverUpdatedAt: serverUpdatedAt.present
        ? serverUpdatedAt.value
        : this.serverUpdatedAt,
    lastCachedAt: lastCachedAt ?? this.lastCachedAt,
  );
  TenantCachedProduct copyWithCompanion(TenantCachedProductsCompanion data) {
    return TenantCachedProduct(
      storeId: data.storeId.present ? data.storeId.value : this.storeId,
      productId: data.productId.present ? data.productId.value : this.productId,
      name: data.name.present ? data.name.value : this.name,
      code: data.code.present ? data.code.value : this.code,
      sellingPriceMinor: data.sellingPriceMinor.present
          ? data.sellingPriceMinor.value
          : this.sellingPriceMinor,
      serverStock: data.serverStock.present
          ? data.serverStock.value
          : this.serverStock,
      reservedStock: data.reservedStock.present
          ? data.reservedStock.value
          : this.reservedStock,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      archivedAt: data.archivedAt.present
          ? data.archivedAt.value
          : this.archivedAt,
      archiveReason: data.archiveReason.present
          ? data.archiveReason.value
          : this.archiveReason,
      category: data.category.present ? data.category.value : this.category,
      serverUpdatedAt: data.serverUpdatedAt.present
          ? data.serverUpdatedAt.value
          : this.serverUpdatedAt,
      lastCachedAt: data.lastCachedAt.present
          ? data.lastCachedAt.value
          : this.lastCachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TenantCachedProduct(')
          ..write('storeId: $storeId, ')
          ..write('productId: $productId, ')
          ..write('name: $name, ')
          ..write('code: $code, ')
          ..write('sellingPriceMinor: $sellingPriceMinor, ')
          ..write('serverStock: $serverStock, ')
          ..write('reservedStock: $reservedStock, ')
          ..write('isActive: $isActive, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('archiveReason: $archiveReason, ')
          ..write('category: $category, ')
          ..write('serverUpdatedAt: $serverUpdatedAt, ')
          ..write('lastCachedAt: $lastCachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    storeId,
    productId,
    name,
    code,
    sellingPriceMinor,
    serverStock,
    reservedStock,
    isActive,
    archivedAt,
    archiveReason,
    category,
    serverUpdatedAt,
    lastCachedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TenantCachedProduct &&
          other.storeId == this.storeId &&
          other.productId == this.productId &&
          other.name == this.name &&
          other.code == this.code &&
          other.sellingPriceMinor == this.sellingPriceMinor &&
          other.serverStock == this.serverStock &&
          other.reservedStock == this.reservedStock &&
          other.isActive == this.isActive &&
          other.archivedAt == this.archivedAt &&
          other.archiveReason == this.archiveReason &&
          other.category == this.category &&
          other.serverUpdatedAt == this.serverUpdatedAt &&
          other.lastCachedAt == this.lastCachedAt);
}

class TenantCachedProductsCompanion
    extends UpdateCompanion<TenantCachedProduct> {
  final Value<String> storeId;
  final Value<String> productId;
  final Value<String> name;
  final Value<String?> code;
  final Value<int> sellingPriceMinor;
  final Value<int> serverStock;
  final Value<int> reservedStock;
  final Value<bool> isActive;
  final Value<DateTime?> archivedAt;
  final Value<String?> archiveReason;
  final Value<String?> category;
  final Value<DateTime?> serverUpdatedAt;
  final Value<DateTime> lastCachedAt;
  final Value<int> rowid;
  const TenantCachedProductsCompanion({
    this.storeId = const Value.absent(),
    this.productId = const Value.absent(),
    this.name = const Value.absent(),
    this.code = const Value.absent(),
    this.sellingPriceMinor = const Value.absent(),
    this.serverStock = const Value.absent(),
    this.reservedStock = const Value.absent(),
    this.isActive = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.archiveReason = const Value.absent(),
    this.category = const Value.absent(),
    this.serverUpdatedAt = const Value.absent(),
    this.lastCachedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TenantCachedProductsCompanion.insert({
    required String storeId,
    required String productId,
    required String name,
    this.code = const Value.absent(),
    required int sellingPriceMinor,
    required int serverStock,
    this.reservedStock = const Value.absent(),
    this.isActive = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.archiveReason = const Value.absent(),
    this.category = const Value.absent(),
    this.serverUpdatedAt = const Value.absent(),
    required DateTime lastCachedAt,
    this.rowid = const Value.absent(),
  }) : storeId = Value(storeId),
       productId = Value(productId),
       name = Value(name),
       sellingPriceMinor = Value(sellingPriceMinor),
       serverStock = Value(serverStock),
       lastCachedAt = Value(lastCachedAt);
  static Insertable<TenantCachedProduct> custom({
    Expression<String>? storeId,
    Expression<String>? productId,
    Expression<String>? name,
    Expression<String>? code,
    Expression<int>? sellingPriceMinor,
    Expression<int>? serverStock,
    Expression<int>? reservedStock,
    Expression<bool>? isActive,
    Expression<DateTime>? archivedAt,
    Expression<String>? archiveReason,
    Expression<String>? category,
    Expression<DateTime>? serverUpdatedAt,
    Expression<DateTime>? lastCachedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (storeId != null) 'store_id': storeId,
      if (productId != null) 'product_id': productId,
      if (name != null) 'name': name,
      if (code != null) 'code': code,
      if (sellingPriceMinor != null) 'selling_price_minor': sellingPriceMinor,
      if (serverStock != null) 'server_stock': serverStock,
      if (reservedStock != null) 'reserved_stock': reservedStock,
      if (isActive != null) 'is_active': isActive,
      if (archivedAt != null) 'archived_at': archivedAt,
      if (archiveReason != null) 'archive_reason': archiveReason,
      if (category != null) 'category': category,
      if (serverUpdatedAt != null) 'server_updated_at': serverUpdatedAt,
      if (lastCachedAt != null) 'last_cached_at': lastCachedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TenantCachedProductsCompanion copyWith({
    Value<String>? storeId,
    Value<String>? productId,
    Value<String>? name,
    Value<String?>? code,
    Value<int>? sellingPriceMinor,
    Value<int>? serverStock,
    Value<int>? reservedStock,
    Value<bool>? isActive,
    Value<DateTime?>? archivedAt,
    Value<String?>? archiveReason,
    Value<String?>? category,
    Value<DateTime?>? serverUpdatedAt,
    Value<DateTime>? lastCachedAt,
    Value<int>? rowid,
  }) {
    return TenantCachedProductsCompanion(
      storeId: storeId ?? this.storeId,
      productId: productId ?? this.productId,
      name: name ?? this.name,
      code: code ?? this.code,
      sellingPriceMinor: sellingPriceMinor ?? this.sellingPriceMinor,
      serverStock: serverStock ?? this.serverStock,
      reservedStock: reservedStock ?? this.reservedStock,
      isActive: isActive ?? this.isActive,
      archivedAt: archivedAt ?? this.archivedAt,
      archiveReason: archiveReason ?? this.archiveReason,
      category: category ?? this.category,
      serverUpdatedAt: serverUpdatedAt ?? this.serverUpdatedAt,
      lastCachedAt: lastCachedAt ?? this.lastCachedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (storeId.present) {
      map['store_id'] = Variable<String>(storeId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (sellingPriceMinor.present) {
      map['selling_price_minor'] = Variable<int>(sellingPriceMinor.value);
    }
    if (serverStock.present) {
      map['server_stock'] = Variable<int>(serverStock.value);
    }
    if (reservedStock.present) {
      map['reserved_stock'] = Variable<int>(reservedStock.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (archivedAt.present) {
      map['archived_at'] = Variable<DateTime>(archivedAt.value);
    }
    if (archiveReason.present) {
      map['archive_reason'] = Variable<String>(archiveReason.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (serverUpdatedAt.present) {
      map['server_updated_at'] = Variable<DateTime>(serverUpdatedAt.value);
    }
    if (lastCachedAt.present) {
      map['last_cached_at'] = Variable<DateTime>(lastCachedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TenantCachedProductsCompanion(')
          ..write('storeId: $storeId, ')
          ..write('productId: $productId, ')
          ..write('name: $name, ')
          ..write('code: $code, ')
          ..write('sellingPriceMinor: $sellingPriceMinor, ')
          ..write('serverStock: $serverStock, ')
          ..write('reservedStock: $reservedStock, ')
          ..write('isActive: $isActive, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('archiveReason: $archiveReason, ')
          ..write('category: $category, ')
          ..write('serverUpdatedAt: $serverUpdatedAt, ')
          ..write('lastCachedAt: $lastCachedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OfflineSalesTable extends OfflineSales
    with TableInfo<$OfflineSalesTable, OfflineSale> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OfflineSalesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _clientSaleIdMeta = const VerificationMeta(
    'clientSaleId',
  );
  @override
  late final GeneratedColumn<String> clientSaleId = GeneratedColumn<String>(
    'client_sale_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _storeIdMeta = const VerificationMeta(
    'storeId',
  );
  @override
  late final GeneratedColumn<String> storeId = GeneratedColumn<String>(
    'store_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ownerUserIdMeta = const VerificationMeta(
    'ownerUserId',
  );
  @override
  late final GeneratedColumn<String> ownerUserId = GeneratedColumn<String>(
    'owner_user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _occurredAtMeta = const VerificationMeta(
    'occurredAt',
  );
  @override
  late final GeneratedColumn<DateTime> occurredAt = GeneratedColumn<DateTime>(
    'occurred_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paymentMethodMeta = const VerificationMeta(
    'paymentMethod',
  );
  @override
  late final GeneratedColumn<String> paymentMethod = GeneratedColumn<String>(
    'payment_method',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paidAmountMinorMeta = const VerificationMeta(
    'paidAmountMinor',
  );
  @override
  late final GeneratedColumn<int> paidAmountMinor = GeneratedColumn<int>(
    'paid_amount_minor',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cashAmountMinorMeta = const VerificationMeta(
    'cashAmountMinor',
  );
  @override
  late final GeneratedColumn<int> cashAmountMinor = GeneratedColumn<int>(
    'cash_amount_minor',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cardAmountMinorMeta = const VerificationMeta(
    'cardAmountMinor',
  );
  @override
  late final GeneratedColumn<int> cardAmountMinor = GeneratedColumn<int>(
    'card_amount_minor',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _discountAmountMinorMeta =
      const VerificationMeta('discountAmountMinor');
  @override
  late final GeneratedColumn<int> discountAmountMinor = GeneratedColumn<int>(
    'discount_amount_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reservationActiveMeta = const VerificationMeta(
    'reservationActive',
  );
  @override
  late final GeneratedColumn<bool> reservationActive = GeneratedColumn<bool>(
    'reservation_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("reservation_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _serverSaleIdMeta = const VerificationMeta(
    'serverSaleId',
  );
  @override
  late final GeneratedColumn<String> serverSaleId = GeneratedColumn<String>(
    'server_sale_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _receiptNoIntMeta = const VerificationMeta(
    'receiptNoInt',
  );
  @override
  late final GeneratedColumn<int> receiptNoInt = GeneratedColumn<int>(
    'receipt_no_int',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncAttemptsMeta = const VerificationMeta(
    'syncAttempts',
  );
  @override
  late final GeneratedColumn<int> syncAttempts = GeneratedColumn<int>(
    'sync_attempts',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastSyncAttemptAtMeta = const VerificationMeta(
    'lastSyncAttemptAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSyncAttemptAt =
      GeneratedColumn<DateTime>(
        'last_sync_attempt_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _nextRetryAtMeta = const VerificationMeta(
    'nextRetryAt',
  );
  @override
  late final GeneratedColumn<DateTime> nextRetryAt = GeneratedColumn<DateTime>(
    'next_retry_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastErrorCodeMeta = const VerificationMeta(
    'lastErrorCode',
  );
  @override
  late final GeneratedColumn<String> lastErrorCode = GeneratedColumn<String>(
    'last_error_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastErrorMessageMeta = const VerificationMeta(
    'lastErrorMessage',
  );
  @override
  late final GeneratedColumn<String> lastErrorMessage = GeneratedColumn<String>(
    'last_error_message',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _conflictProductIdMeta = const VerificationMeta(
    'conflictProductId',
  );
  @override
  late final GeneratedColumn<String> conflictProductId =
      GeneratedColumn<String>(
        'conflict_product_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _conflictRequestedQuantityMeta =
      const VerificationMeta('conflictRequestedQuantity');
  @override
  late final GeneratedColumn<int> conflictRequestedQuantity =
      GeneratedColumn<int>(
        'conflict_requested_quantity',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _conflictAvailableQuantityMeta =
      const VerificationMeta('conflictAvailableQuantity');
  @override
  late final GeneratedColumn<int> conflictAvailableQuantity =
      GeneratedColumn<int>(
        'conflict_available_quantity',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _saleJsonMeta = const VerificationMeta(
    'saleJson',
  );
  @override
  late final GeneratedColumn<String> saleJson = GeneratedColumn<String>(
    'sale_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _receiptJsonMeta = const VerificationMeta(
    'receiptJson',
  );
  @override
  late final GeneratedColumn<String> receiptJson = GeneratedColumn<String>(
    'receipt_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdLocallyAtMeta = const VerificationMeta(
    'createdLocallyAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdLocallyAt =
      GeneratedColumn<DateTime>(
        'created_locally_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _updatedLocallyAtMeta = const VerificationMeta(
    'updatedLocallyAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedLocallyAt =
      GeneratedColumn<DateTime>(
        'updated_locally_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    clientSaleId,
    storeId,
    ownerUserId,
    occurredAt,
    paymentMethod,
    paidAmountMinor,
    cashAmountMinor,
    cardAmountMinor,
    discountAmountMinor,
    syncStatus,
    reservationActive,
    serverSaleId,
    receiptNoInt,
    syncAttempts,
    lastSyncAttemptAt,
    nextRetryAt,
    lastErrorCode,
    lastErrorMessage,
    conflictProductId,
    conflictRequestedQuantity,
    conflictAvailableQuantity,
    saleJson,
    receiptJson,
    createdLocallyAt,
    updatedLocallyAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'offline_sales';
  @override
  VerificationContext validateIntegrity(
    Insertable<OfflineSale> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('client_sale_id')) {
      context.handle(
        _clientSaleIdMeta,
        clientSaleId.isAcceptableOrUnknown(
          data['client_sale_id']!,
          _clientSaleIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_clientSaleIdMeta);
    }
    if (data.containsKey('store_id')) {
      context.handle(
        _storeIdMeta,
        storeId.isAcceptableOrUnknown(data['store_id']!, _storeIdMeta),
      );
    }
    if (data.containsKey('owner_user_id')) {
      context.handle(
        _ownerUserIdMeta,
        ownerUserId.isAcceptableOrUnknown(
          data['owner_user_id']!,
          _ownerUserIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ownerUserIdMeta);
    }
    if (data.containsKey('occurred_at')) {
      context.handle(
        _occurredAtMeta,
        occurredAt.isAcceptableOrUnknown(data['occurred_at']!, _occurredAtMeta),
      );
    } else if (isInserting) {
      context.missing(_occurredAtMeta);
    }
    if (data.containsKey('payment_method')) {
      context.handle(
        _paymentMethodMeta,
        paymentMethod.isAcceptableOrUnknown(
          data['payment_method']!,
          _paymentMethodMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_paymentMethodMeta);
    }
    if (data.containsKey('paid_amount_minor')) {
      context.handle(
        _paidAmountMinorMeta,
        paidAmountMinor.isAcceptableOrUnknown(
          data['paid_amount_minor']!,
          _paidAmountMinorMeta,
        ),
      );
    }
    if (data.containsKey('cash_amount_minor')) {
      context.handle(
        _cashAmountMinorMeta,
        cashAmountMinor.isAcceptableOrUnknown(
          data['cash_amount_minor']!,
          _cashAmountMinorMeta,
        ),
      );
    }
    if (data.containsKey('card_amount_minor')) {
      context.handle(
        _cardAmountMinorMeta,
        cardAmountMinor.isAcceptableOrUnknown(
          data['card_amount_minor']!,
          _cardAmountMinorMeta,
        ),
      );
    }
    if (data.containsKey('discount_amount_minor')) {
      context.handle(
        _discountAmountMinorMeta,
        discountAmountMinor.isAcceptableOrUnknown(
          data['discount_amount_minor']!,
          _discountAmountMinorMeta,
        ),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    } else if (isInserting) {
      context.missing(_syncStatusMeta);
    }
    if (data.containsKey('reservation_active')) {
      context.handle(
        _reservationActiveMeta,
        reservationActive.isAcceptableOrUnknown(
          data['reservation_active']!,
          _reservationActiveMeta,
        ),
      );
    }
    if (data.containsKey('server_sale_id')) {
      context.handle(
        _serverSaleIdMeta,
        serverSaleId.isAcceptableOrUnknown(
          data['server_sale_id']!,
          _serverSaleIdMeta,
        ),
      );
    }
    if (data.containsKey('receipt_no_int')) {
      context.handle(
        _receiptNoIntMeta,
        receiptNoInt.isAcceptableOrUnknown(
          data['receipt_no_int']!,
          _receiptNoIntMeta,
        ),
      );
    }
    if (data.containsKey('sync_attempts')) {
      context.handle(
        _syncAttemptsMeta,
        syncAttempts.isAcceptableOrUnknown(
          data['sync_attempts']!,
          _syncAttemptsMeta,
        ),
      );
    }
    if (data.containsKey('last_sync_attempt_at')) {
      context.handle(
        _lastSyncAttemptAtMeta,
        lastSyncAttemptAt.isAcceptableOrUnknown(
          data['last_sync_attempt_at']!,
          _lastSyncAttemptAtMeta,
        ),
      );
    }
    if (data.containsKey('next_retry_at')) {
      context.handle(
        _nextRetryAtMeta,
        nextRetryAt.isAcceptableOrUnknown(
          data['next_retry_at']!,
          _nextRetryAtMeta,
        ),
      );
    }
    if (data.containsKey('last_error_code')) {
      context.handle(
        _lastErrorCodeMeta,
        lastErrorCode.isAcceptableOrUnknown(
          data['last_error_code']!,
          _lastErrorCodeMeta,
        ),
      );
    }
    if (data.containsKey('last_error_message')) {
      context.handle(
        _lastErrorMessageMeta,
        lastErrorMessage.isAcceptableOrUnknown(
          data['last_error_message']!,
          _lastErrorMessageMeta,
        ),
      );
    }
    if (data.containsKey('conflict_product_id')) {
      context.handle(
        _conflictProductIdMeta,
        conflictProductId.isAcceptableOrUnknown(
          data['conflict_product_id']!,
          _conflictProductIdMeta,
        ),
      );
    }
    if (data.containsKey('conflict_requested_quantity')) {
      context.handle(
        _conflictRequestedQuantityMeta,
        conflictRequestedQuantity.isAcceptableOrUnknown(
          data['conflict_requested_quantity']!,
          _conflictRequestedQuantityMeta,
        ),
      );
    }
    if (data.containsKey('conflict_available_quantity')) {
      context.handle(
        _conflictAvailableQuantityMeta,
        conflictAvailableQuantity.isAcceptableOrUnknown(
          data['conflict_available_quantity']!,
          _conflictAvailableQuantityMeta,
        ),
      );
    }
    if (data.containsKey('sale_json')) {
      context.handle(
        _saleJsonMeta,
        saleJson.isAcceptableOrUnknown(data['sale_json']!, _saleJsonMeta),
      );
    }
    if (data.containsKey('receipt_json')) {
      context.handle(
        _receiptJsonMeta,
        receiptJson.isAcceptableOrUnknown(
          data['receipt_json']!,
          _receiptJsonMeta,
        ),
      );
    }
    if (data.containsKey('created_locally_at')) {
      context.handle(
        _createdLocallyAtMeta,
        createdLocallyAt.isAcceptableOrUnknown(
          data['created_locally_at']!,
          _createdLocallyAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_createdLocallyAtMeta);
    }
    if (data.containsKey('updated_locally_at')) {
      context.handle(
        _updatedLocallyAtMeta,
        updatedLocallyAt.isAcceptableOrUnknown(
          data['updated_locally_at']!,
          _updatedLocallyAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedLocallyAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OfflineSale map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OfflineSale(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      clientSaleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_sale_id'],
      )!,
      storeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}store_id'],
      ),
      ownerUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_user_id'],
      )!,
      occurredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}occurred_at'],
      )!,
      paymentMethod: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_method'],
      )!,
      paidAmountMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}paid_amount_minor'],
      ),
      cashAmountMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cash_amount_minor'],
      ),
      cardAmountMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}card_amount_minor'],
      ),
      discountAmountMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}discount_amount_minor'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      reservationActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}reservation_active'],
      )!,
      serverSaleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_sale_id'],
      ),
      receiptNoInt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}receipt_no_int'],
      ),
      syncAttempts: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_attempts'],
      )!,
      lastSyncAttemptAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_sync_attempt_at'],
      ),
      nextRetryAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_retry_at'],
      ),
      lastErrorCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error_code'],
      ),
      lastErrorMessage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error_message'],
      ),
      conflictProductId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}conflict_product_id'],
      ),
      conflictRequestedQuantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}conflict_requested_quantity'],
      ),
      conflictAvailableQuantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}conflict_available_quantity'],
      ),
      saleJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sale_json'],
      ),
      receiptJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}receipt_json'],
      ),
      createdLocallyAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_locally_at'],
      )!,
      updatedLocallyAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_locally_at'],
      )!,
    );
  }

  @override
  $OfflineSalesTable createAlias(String alias) {
    return $OfflineSalesTable(attachedDatabase, alias);
  }
}

class OfflineSale extends DataClass implements Insertable<OfflineSale> {
  final int id;
  final String clientSaleId;
  final String? storeId;
  final String ownerUserId;
  final DateTime occurredAt;
  final String paymentMethod;
  final int? paidAmountMinor;
  final int? cashAmountMinor;
  final int? cardAmountMinor;
  final int discountAmountMinor;
  final String syncStatus;
  final bool reservationActive;
  final String? serverSaleId;
  final int? receiptNoInt;
  final int syncAttempts;
  final DateTime? lastSyncAttemptAt;
  final DateTime? nextRetryAt;
  final String? lastErrorCode;
  final String? lastErrorMessage;
  final String? conflictProductId;
  final int? conflictRequestedQuantity;
  final int? conflictAvailableQuantity;
  final String? saleJson;
  final String? receiptJson;
  final DateTime createdLocallyAt;
  final DateTime updatedLocallyAt;
  const OfflineSale({
    required this.id,
    required this.clientSaleId,
    this.storeId,
    required this.ownerUserId,
    required this.occurredAt,
    required this.paymentMethod,
    this.paidAmountMinor,
    this.cashAmountMinor,
    this.cardAmountMinor,
    required this.discountAmountMinor,
    required this.syncStatus,
    required this.reservationActive,
    this.serverSaleId,
    this.receiptNoInt,
    required this.syncAttempts,
    this.lastSyncAttemptAt,
    this.nextRetryAt,
    this.lastErrorCode,
    this.lastErrorMessage,
    this.conflictProductId,
    this.conflictRequestedQuantity,
    this.conflictAvailableQuantity,
    this.saleJson,
    this.receiptJson,
    required this.createdLocallyAt,
    required this.updatedLocallyAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['client_sale_id'] = Variable<String>(clientSaleId);
    if (!nullToAbsent || storeId != null) {
      map['store_id'] = Variable<String>(storeId);
    }
    map['owner_user_id'] = Variable<String>(ownerUserId);
    map['occurred_at'] = Variable<DateTime>(occurredAt);
    map['payment_method'] = Variable<String>(paymentMethod);
    if (!nullToAbsent || paidAmountMinor != null) {
      map['paid_amount_minor'] = Variable<int>(paidAmountMinor);
    }
    if (!nullToAbsent || cashAmountMinor != null) {
      map['cash_amount_minor'] = Variable<int>(cashAmountMinor);
    }
    if (!nullToAbsent || cardAmountMinor != null) {
      map['card_amount_minor'] = Variable<int>(cardAmountMinor);
    }
    map['discount_amount_minor'] = Variable<int>(discountAmountMinor);
    map['sync_status'] = Variable<String>(syncStatus);
    map['reservation_active'] = Variable<bool>(reservationActive);
    if (!nullToAbsent || serverSaleId != null) {
      map['server_sale_id'] = Variable<String>(serverSaleId);
    }
    if (!nullToAbsent || receiptNoInt != null) {
      map['receipt_no_int'] = Variable<int>(receiptNoInt);
    }
    map['sync_attempts'] = Variable<int>(syncAttempts);
    if (!nullToAbsent || lastSyncAttemptAt != null) {
      map['last_sync_attempt_at'] = Variable<DateTime>(lastSyncAttemptAt);
    }
    if (!nullToAbsent || nextRetryAt != null) {
      map['next_retry_at'] = Variable<DateTime>(nextRetryAt);
    }
    if (!nullToAbsent || lastErrorCode != null) {
      map['last_error_code'] = Variable<String>(lastErrorCode);
    }
    if (!nullToAbsent || lastErrorMessage != null) {
      map['last_error_message'] = Variable<String>(lastErrorMessage);
    }
    if (!nullToAbsent || conflictProductId != null) {
      map['conflict_product_id'] = Variable<String>(conflictProductId);
    }
    if (!nullToAbsent || conflictRequestedQuantity != null) {
      map['conflict_requested_quantity'] = Variable<int>(
        conflictRequestedQuantity,
      );
    }
    if (!nullToAbsent || conflictAvailableQuantity != null) {
      map['conflict_available_quantity'] = Variable<int>(
        conflictAvailableQuantity,
      );
    }
    if (!nullToAbsent || saleJson != null) {
      map['sale_json'] = Variable<String>(saleJson);
    }
    if (!nullToAbsent || receiptJson != null) {
      map['receipt_json'] = Variable<String>(receiptJson);
    }
    map['created_locally_at'] = Variable<DateTime>(createdLocallyAt);
    map['updated_locally_at'] = Variable<DateTime>(updatedLocallyAt);
    return map;
  }

  OfflineSalesCompanion toCompanion(bool nullToAbsent) {
    return OfflineSalesCompanion(
      id: Value(id),
      clientSaleId: Value(clientSaleId),
      storeId: storeId == null && nullToAbsent
          ? const Value.absent()
          : Value(storeId),
      ownerUserId: Value(ownerUserId),
      occurredAt: Value(occurredAt),
      paymentMethod: Value(paymentMethod),
      paidAmountMinor: paidAmountMinor == null && nullToAbsent
          ? const Value.absent()
          : Value(paidAmountMinor),
      cashAmountMinor: cashAmountMinor == null && nullToAbsent
          ? const Value.absent()
          : Value(cashAmountMinor),
      cardAmountMinor: cardAmountMinor == null && nullToAbsent
          ? const Value.absent()
          : Value(cardAmountMinor),
      discountAmountMinor: Value(discountAmountMinor),
      syncStatus: Value(syncStatus),
      reservationActive: Value(reservationActive),
      serverSaleId: serverSaleId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverSaleId),
      receiptNoInt: receiptNoInt == null && nullToAbsent
          ? const Value.absent()
          : Value(receiptNoInt),
      syncAttempts: Value(syncAttempts),
      lastSyncAttemptAt: lastSyncAttemptAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncAttemptAt),
      nextRetryAt: nextRetryAt == null && nullToAbsent
          ? const Value.absent()
          : Value(nextRetryAt),
      lastErrorCode: lastErrorCode == null && nullToAbsent
          ? const Value.absent()
          : Value(lastErrorCode),
      lastErrorMessage: lastErrorMessage == null && nullToAbsent
          ? const Value.absent()
          : Value(lastErrorMessage),
      conflictProductId: conflictProductId == null && nullToAbsent
          ? const Value.absent()
          : Value(conflictProductId),
      conflictRequestedQuantity:
          conflictRequestedQuantity == null && nullToAbsent
          ? const Value.absent()
          : Value(conflictRequestedQuantity),
      conflictAvailableQuantity:
          conflictAvailableQuantity == null && nullToAbsent
          ? const Value.absent()
          : Value(conflictAvailableQuantity),
      saleJson: saleJson == null && nullToAbsent
          ? const Value.absent()
          : Value(saleJson),
      receiptJson: receiptJson == null && nullToAbsent
          ? const Value.absent()
          : Value(receiptJson),
      createdLocallyAt: Value(createdLocallyAt),
      updatedLocallyAt: Value(updatedLocallyAt),
    );
  }

  factory OfflineSale.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OfflineSale(
      id: serializer.fromJson<int>(json['id']),
      clientSaleId: serializer.fromJson<String>(json['clientSaleId']),
      storeId: serializer.fromJson<String?>(json['storeId']),
      ownerUserId: serializer.fromJson<String>(json['ownerUserId']),
      occurredAt: serializer.fromJson<DateTime>(json['occurredAt']),
      paymentMethod: serializer.fromJson<String>(json['paymentMethod']),
      paidAmountMinor: serializer.fromJson<int?>(json['paidAmountMinor']),
      cashAmountMinor: serializer.fromJson<int?>(json['cashAmountMinor']),
      cardAmountMinor: serializer.fromJson<int?>(json['cardAmountMinor']),
      discountAmountMinor: serializer.fromJson<int>(
        json['discountAmountMinor'],
      ),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      reservationActive: serializer.fromJson<bool>(json['reservationActive']),
      serverSaleId: serializer.fromJson<String?>(json['serverSaleId']),
      receiptNoInt: serializer.fromJson<int?>(json['receiptNoInt']),
      syncAttempts: serializer.fromJson<int>(json['syncAttempts']),
      lastSyncAttemptAt: serializer.fromJson<DateTime?>(
        json['lastSyncAttemptAt'],
      ),
      nextRetryAt: serializer.fromJson<DateTime?>(json['nextRetryAt']),
      lastErrorCode: serializer.fromJson<String?>(json['lastErrorCode']),
      lastErrorMessage: serializer.fromJson<String?>(json['lastErrorMessage']),
      conflictProductId: serializer.fromJson<String?>(
        json['conflictProductId'],
      ),
      conflictRequestedQuantity: serializer.fromJson<int?>(
        json['conflictRequestedQuantity'],
      ),
      conflictAvailableQuantity: serializer.fromJson<int?>(
        json['conflictAvailableQuantity'],
      ),
      saleJson: serializer.fromJson<String?>(json['saleJson']),
      receiptJson: serializer.fromJson<String?>(json['receiptJson']),
      createdLocallyAt: serializer.fromJson<DateTime>(json['createdLocallyAt']),
      updatedLocallyAt: serializer.fromJson<DateTime>(json['updatedLocallyAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'clientSaleId': serializer.toJson<String>(clientSaleId),
      'storeId': serializer.toJson<String?>(storeId),
      'ownerUserId': serializer.toJson<String>(ownerUserId),
      'occurredAt': serializer.toJson<DateTime>(occurredAt),
      'paymentMethod': serializer.toJson<String>(paymentMethod),
      'paidAmountMinor': serializer.toJson<int?>(paidAmountMinor),
      'cashAmountMinor': serializer.toJson<int?>(cashAmountMinor),
      'cardAmountMinor': serializer.toJson<int?>(cardAmountMinor),
      'discountAmountMinor': serializer.toJson<int>(discountAmountMinor),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'reservationActive': serializer.toJson<bool>(reservationActive),
      'serverSaleId': serializer.toJson<String?>(serverSaleId),
      'receiptNoInt': serializer.toJson<int?>(receiptNoInt),
      'syncAttempts': serializer.toJson<int>(syncAttempts),
      'lastSyncAttemptAt': serializer.toJson<DateTime?>(lastSyncAttemptAt),
      'nextRetryAt': serializer.toJson<DateTime?>(nextRetryAt),
      'lastErrorCode': serializer.toJson<String?>(lastErrorCode),
      'lastErrorMessage': serializer.toJson<String?>(lastErrorMessage),
      'conflictProductId': serializer.toJson<String?>(conflictProductId),
      'conflictRequestedQuantity': serializer.toJson<int?>(
        conflictRequestedQuantity,
      ),
      'conflictAvailableQuantity': serializer.toJson<int?>(
        conflictAvailableQuantity,
      ),
      'saleJson': serializer.toJson<String?>(saleJson),
      'receiptJson': serializer.toJson<String?>(receiptJson),
      'createdLocallyAt': serializer.toJson<DateTime>(createdLocallyAt),
      'updatedLocallyAt': serializer.toJson<DateTime>(updatedLocallyAt),
    };
  }

  OfflineSale copyWith({
    int? id,
    String? clientSaleId,
    Value<String?> storeId = const Value.absent(),
    String? ownerUserId,
    DateTime? occurredAt,
    String? paymentMethod,
    Value<int?> paidAmountMinor = const Value.absent(),
    Value<int?> cashAmountMinor = const Value.absent(),
    Value<int?> cardAmountMinor = const Value.absent(),
    int? discountAmountMinor,
    String? syncStatus,
    bool? reservationActive,
    Value<String?> serverSaleId = const Value.absent(),
    Value<int?> receiptNoInt = const Value.absent(),
    int? syncAttempts,
    Value<DateTime?> lastSyncAttemptAt = const Value.absent(),
    Value<DateTime?> nextRetryAt = const Value.absent(),
    Value<String?> lastErrorCode = const Value.absent(),
    Value<String?> lastErrorMessage = const Value.absent(),
    Value<String?> conflictProductId = const Value.absent(),
    Value<int?> conflictRequestedQuantity = const Value.absent(),
    Value<int?> conflictAvailableQuantity = const Value.absent(),
    Value<String?> saleJson = const Value.absent(),
    Value<String?> receiptJson = const Value.absent(),
    DateTime? createdLocallyAt,
    DateTime? updatedLocallyAt,
  }) => OfflineSale(
    id: id ?? this.id,
    clientSaleId: clientSaleId ?? this.clientSaleId,
    storeId: storeId.present ? storeId.value : this.storeId,
    ownerUserId: ownerUserId ?? this.ownerUserId,
    occurredAt: occurredAt ?? this.occurredAt,
    paymentMethod: paymentMethod ?? this.paymentMethod,
    paidAmountMinor: paidAmountMinor.present
        ? paidAmountMinor.value
        : this.paidAmountMinor,
    cashAmountMinor: cashAmountMinor.present
        ? cashAmountMinor.value
        : this.cashAmountMinor,
    cardAmountMinor: cardAmountMinor.present
        ? cardAmountMinor.value
        : this.cardAmountMinor,
    discountAmountMinor: discountAmountMinor ?? this.discountAmountMinor,
    syncStatus: syncStatus ?? this.syncStatus,
    reservationActive: reservationActive ?? this.reservationActive,
    serverSaleId: serverSaleId.present ? serverSaleId.value : this.serverSaleId,
    receiptNoInt: receiptNoInt.present ? receiptNoInt.value : this.receiptNoInt,
    syncAttempts: syncAttempts ?? this.syncAttempts,
    lastSyncAttemptAt: lastSyncAttemptAt.present
        ? lastSyncAttemptAt.value
        : this.lastSyncAttemptAt,
    nextRetryAt: nextRetryAt.present ? nextRetryAt.value : this.nextRetryAt,
    lastErrorCode: lastErrorCode.present
        ? lastErrorCode.value
        : this.lastErrorCode,
    lastErrorMessage: lastErrorMessage.present
        ? lastErrorMessage.value
        : this.lastErrorMessage,
    conflictProductId: conflictProductId.present
        ? conflictProductId.value
        : this.conflictProductId,
    conflictRequestedQuantity: conflictRequestedQuantity.present
        ? conflictRequestedQuantity.value
        : this.conflictRequestedQuantity,
    conflictAvailableQuantity: conflictAvailableQuantity.present
        ? conflictAvailableQuantity.value
        : this.conflictAvailableQuantity,
    saleJson: saleJson.present ? saleJson.value : this.saleJson,
    receiptJson: receiptJson.present ? receiptJson.value : this.receiptJson,
    createdLocallyAt: createdLocallyAt ?? this.createdLocallyAt,
    updatedLocallyAt: updatedLocallyAt ?? this.updatedLocallyAt,
  );
  OfflineSale copyWithCompanion(OfflineSalesCompanion data) {
    return OfflineSale(
      id: data.id.present ? data.id.value : this.id,
      clientSaleId: data.clientSaleId.present
          ? data.clientSaleId.value
          : this.clientSaleId,
      storeId: data.storeId.present ? data.storeId.value : this.storeId,
      ownerUserId: data.ownerUserId.present
          ? data.ownerUserId.value
          : this.ownerUserId,
      occurredAt: data.occurredAt.present
          ? data.occurredAt.value
          : this.occurredAt,
      paymentMethod: data.paymentMethod.present
          ? data.paymentMethod.value
          : this.paymentMethod,
      paidAmountMinor: data.paidAmountMinor.present
          ? data.paidAmountMinor.value
          : this.paidAmountMinor,
      cashAmountMinor: data.cashAmountMinor.present
          ? data.cashAmountMinor.value
          : this.cashAmountMinor,
      cardAmountMinor: data.cardAmountMinor.present
          ? data.cardAmountMinor.value
          : this.cardAmountMinor,
      discountAmountMinor: data.discountAmountMinor.present
          ? data.discountAmountMinor.value
          : this.discountAmountMinor,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      reservationActive: data.reservationActive.present
          ? data.reservationActive.value
          : this.reservationActive,
      serverSaleId: data.serverSaleId.present
          ? data.serverSaleId.value
          : this.serverSaleId,
      receiptNoInt: data.receiptNoInt.present
          ? data.receiptNoInt.value
          : this.receiptNoInt,
      syncAttempts: data.syncAttempts.present
          ? data.syncAttempts.value
          : this.syncAttempts,
      lastSyncAttemptAt: data.lastSyncAttemptAt.present
          ? data.lastSyncAttemptAt.value
          : this.lastSyncAttemptAt,
      nextRetryAt: data.nextRetryAt.present
          ? data.nextRetryAt.value
          : this.nextRetryAt,
      lastErrorCode: data.lastErrorCode.present
          ? data.lastErrorCode.value
          : this.lastErrorCode,
      lastErrorMessage: data.lastErrorMessage.present
          ? data.lastErrorMessage.value
          : this.lastErrorMessage,
      conflictProductId: data.conflictProductId.present
          ? data.conflictProductId.value
          : this.conflictProductId,
      conflictRequestedQuantity: data.conflictRequestedQuantity.present
          ? data.conflictRequestedQuantity.value
          : this.conflictRequestedQuantity,
      conflictAvailableQuantity: data.conflictAvailableQuantity.present
          ? data.conflictAvailableQuantity.value
          : this.conflictAvailableQuantity,
      saleJson: data.saleJson.present ? data.saleJson.value : this.saleJson,
      receiptJson: data.receiptJson.present
          ? data.receiptJson.value
          : this.receiptJson,
      createdLocallyAt: data.createdLocallyAt.present
          ? data.createdLocallyAt.value
          : this.createdLocallyAt,
      updatedLocallyAt: data.updatedLocallyAt.present
          ? data.updatedLocallyAt.value
          : this.updatedLocallyAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OfflineSale(')
          ..write('id: $id, ')
          ..write('clientSaleId: $clientSaleId, ')
          ..write('storeId: $storeId, ')
          ..write('ownerUserId: $ownerUserId, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('paidAmountMinor: $paidAmountMinor, ')
          ..write('cashAmountMinor: $cashAmountMinor, ')
          ..write('cardAmountMinor: $cardAmountMinor, ')
          ..write('discountAmountMinor: $discountAmountMinor, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('reservationActive: $reservationActive, ')
          ..write('serverSaleId: $serverSaleId, ')
          ..write('receiptNoInt: $receiptNoInt, ')
          ..write('syncAttempts: $syncAttempts, ')
          ..write('lastSyncAttemptAt: $lastSyncAttemptAt, ')
          ..write('nextRetryAt: $nextRetryAt, ')
          ..write('lastErrorCode: $lastErrorCode, ')
          ..write('lastErrorMessage: $lastErrorMessage, ')
          ..write('conflictProductId: $conflictProductId, ')
          ..write('conflictRequestedQuantity: $conflictRequestedQuantity, ')
          ..write('conflictAvailableQuantity: $conflictAvailableQuantity, ')
          ..write('saleJson: $saleJson, ')
          ..write('receiptJson: $receiptJson, ')
          ..write('createdLocallyAt: $createdLocallyAt, ')
          ..write('updatedLocallyAt: $updatedLocallyAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    clientSaleId,
    storeId,
    ownerUserId,
    occurredAt,
    paymentMethod,
    paidAmountMinor,
    cashAmountMinor,
    cardAmountMinor,
    discountAmountMinor,
    syncStatus,
    reservationActive,
    serverSaleId,
    receiptNoInt,
    syncAttempts,
    lastSyncAttemptAt,
    nextRetryAt,
    lastErrorCode,
    lastErrorMessage,
    conflictProductId,
    conflictRequestedQuantity,
    conflictAvailableQuantity,
    saleJson,
    receiptJson,
    createdLocallyAt,
    updatedLocallyAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OfflineSale &&
          other.id == this.id &&
          other.clientSaleId == this.clientSaleId &&
          other.storeId == this.storeId &&
          other.ownerUserId == this.ownerUserId &&
          other.occurredAt == this.occurredAt &&
          other.paymentMethod == this.paymentMethod &&
          other.paidAmountMinor == this.paidAmountMinor &&
          other.cashAmountMinor == this.cashAmountMinor &&
          other.cardAmountMinor == this.cardAmountMinor &&
          other.discountAmountMinor == this.discountAmountMinor &&
          other.syncStatus == this.syncStatus &&
          other.reservationActive == this.reservationActive &&
          other.serverSaleId == this.serverSaleId &&
          other.receiptNoInt == this.receiptNoInt &&
          other.syncAttempts == this.syncAttempts &&
          other.lastSyncAttemptAt == this.lastSyncAttemptAt &&
          other.nextRetryAt == this.nextRetryAt &&
          other.lastErrorCode == this.lastErrorCode &&
          other.lastErrorMessage == this.lastErrorMessage &&
          other.conflictProductId == this.conflictProductId &&
          other.conflictRequestedQuantity == this.conflictRequestedQuantity &&
          other.conflictAvailableQuantity == this.conflictAvailableQuantity &&
          other.saleJson == this.saleJson &&
          other.receiptJson == this.receiptJson &&
          other.createdLocallyAt == this.createdLocallyAt &&
          other.updatedLocallyAt == this.updatedLocallyAt);
}

class OfflineSalesCompanion extends UpdateCompanion<OfflineSale> {
  final Value<int> id;
  final Value<String> clientSaleId;
  final Value<String?> storeId;
  final Value<String> ownerUserId;
  final Value<DateTime> occurredAt;
  final Value<String> paymentMethod;
  final Value<int?> paidAmountMinor;
  final Value<int?> cashAmountMinor;
  final Value<int?> cardAmountMinor;
  final Value<int> discountAmountMinor;
  final Value<String> syncStatus;
  final Value<bool> reservationActive;
  final Value<String?> serverSaleId;
  final Value<int?> receiptNoInt;
  final Value<int> syncAttempts;
  final Value<DateTime?> lastSyncAttemptAt;
  final Value<DateTime?> nextRetryAt;
  final Value<String?> lastErrorCode;
  final Value<String?> lastErrorMessage;
  final Value<String?> conflictProductId;
  final Value<int?> conflictRequestedQuantity;
  final Value<int?> conflictAvailableQuantity;
  final Value<String?> saleJson;
  final Value<String?> receiptJson;
  final Value<DateTime> createdLocallyAt;
  final Value<DateTime> updatedLocallyAt;
  const OfflineSalesCompanion({
    this.id = const Value.absent(),
    this.clientSaleId = const Value.absent(),
    this.storeId = const Value.absent(),
    this.ownerUserId = const Value.absent(),
    this.occurredAt = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.paidAmountMinor = const Value.absent(),
    this.cashAmountMinor = const Value.absent(),
    this.cardAmountMinor = const Value.absent(),
    this.discountAmountMinor = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.reservationActive = const Value.absent(),
    this.serverSaleId = const Value.absent(),
    this.receiptNoInt = const Value.absent(),
    this.syncAttempts = const Value.absent(),
    this.lastSyncAttemptAt = const Value.absent(),
    this.nextRetryAt = const Value.absent(),
    this.lastErrorCode = const Value.absent(),
    this.lastErrorMessage = const Value.absent(),
    this.conflictProductId = const Value.absent(),
    this.conflictRequestedQuantity = const Value.absent(),
    this.conflictAvailableQuantity = const Value.absent(),
    this.saleJson = const Value.absent(),
    this.receiptJson = const Value.absent(),
    this.createdLocallyAt = const Value.absent(),
    this.updatedLocallyAt = const Value.absent(),
  });
  OfflineSalesCompanion.insert({
    this.id = const Value.absent(),
    required String clientSaleId,
    this.storeId = const Value.absent(),
    required String ownerUserId,
    required DateTime occurredAt,
    required String paymentMethod,
    this.paidAmountMinor = const Value.absent(),
    this.cashAmountMinor = const Value.absent(),
    this.cardAmountMinor = const Value.absent(),
    this.discountAmountMinor = const Value.absent(),
    required String syncStatus,
    this.reservationActive = const Value.absent(),
    this.serverSaleId = const Value.absent(),
    this.receiptNoInt = const Value.absent(),
    this.syncAttempts = const Value.absent(),
    this.lastSyncAttemptAt = const Value.absent(),
    this.nextRetryAt = const Value.absent(),
    this.lastErrorCode = const Value.absent(),
    this.lastErrorMessage = const Value.absent(),
    this.conflictProductId = const Value.absent(),
    this.conflictRequestedQuantity = const Value.absent(),
    this.conflictAvailableQuantity = const Value.absent(),
    this.saleJson = const Value.absent(),
    this.receiptJson = const Value.absent(),
    required DateTime createdLocallyAt,
    required DateTime updatedLocallyAt,
  }) : clientSaleId = Value(clientSaleId),
       ownerUserId = Value(ownerUserId),
       occurredAt = Value(occurredAt),
       paymentMethod = Value(paymentMethod),
       syncStatus = Value(syncStatus),
       createdLocallyAt = Value(createdLocallyAt),
       updatedLocallyAt = Value(updatedLocallyAt);
  static Insertable<OfflineSale> custom({
    Expression<int>? id,
    Expression<String>? clientSaleId,
    Expression<String>? storeId,
    Expression<String>? ownerUserId,
    Expression<DateTime>? occurredAt,
    Expression<String>? paymentMethod,
    Expression<int>? paidAmountMinor,
    Expression<int>? cashAmountMinor,
    Expression<int>? cardAmountMinor,
    Expression<int>? discountAmountMinor,
    Expression<String>? syncStatus,
    Expression<bool>? reservationActive,
    Expression<String>? serverSaleId,
    Expression<int>? receiptNoInt,
    Expression<int>? syncAttempts,
    Expression<DateTime>? lastSyncAttemptAt,
    Expression<DateTime>? nextRetryAt,
    Expression<String>? lastErrorCode,
    Expression<String>? lastErrorMessage,
    Expression<String>? conflictProductId,
    Expression<int>? conflictRequestedQuantity,
    Expression<int>? conflictAvailableQuantity,
    Expression<String>? saleJson,
    Expression<String>? receiptJson,
    Expression<DateTime>? createdLocallyAt,
    Expression<DateTime>? updatedLocallyAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (clientSaleId != null) 'client_sale_id': clientSaleId,
      if (storeId != null) 'store_id': storeId,
      if (ownerUserId != null) 'owner_user_id': ownerUserId,
      if (occurredAt != null) 'occurred_at': occurredAt,
      if (paymentMethod != null) 'payment_method': paymentMethod,
      if (paidAmountMinor != null) 'paid_amount_minor': paidAmountMinor,
      if (cashAmountMinor != null) 'cash_amount_minor': cashAmountMinor,
      if (cardAmountMinor != null) 'card_amount_minor': cardAmountMinor,
      if (discountAmountMinor != null)
        'discount_amount_minor': discountAmountMinor,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (reservationActive != null) 'reservation_active': reservationActive,
      if (serverSaleId != null) 'server_sale_id': serverSaleId,
      if (receiptNoInt != null) 'receipt_no_int': receiptNoInt,
      if (syncAttempts != null) 'sync_attempts': syncAttempts,
      if (lastSyncAttemptAt != null) 'last_sync_attempt_at': lastSyncAttemptAt,
      if (nextRetryAt != null) 'next_retry_at': nextRetryAt,
      if (lastErrorCode != null) 'last_error_code': lastErrorCode,
      if (lastErrorMessage != null) 'last_error_message': lastErrorMessage,
      if (conflictProductId != null) 'conflict_product_id': conflictProductId,
      if (conflictRequestedQuantity != null)
        'conflict_requested_quantity': conflictRequestedQuantity,
      if (conflictAvailableQuantity != null)
        'conflict_available_quantity': conflictAvailableQuantity,
      if (saleJson != null) 'sale_json': saleJson,
      if (receiptJson != null) 'receipt_json': receiptJson,
      if (createdLocallyAt != null) 'created_locally_at': createdLocallyAt,
      if (updatedLocallyAt != null) 'updated_locally_at': updatedLocallyAt,
    });
  }

  OfflineSalesCompanion copyWith({
    Value<int>? id,
    Value<String>? clientSaleId,
    Value<String?>? storeId,
    Value<String>? ownerUserId,
    Value<DateTime>? occurredAt,
    Value<String>? paymentMethod,
    Value<int?>? paidAmountMinor,
    Value<int?>? cashAmountMinor,
    Value<int?>? cardAmountMinor,
    Value<int>? discountAmountMinor,
    Value<String>? syncStatus,
    Value<bool>? reservationActive,
    Value<String?>? serverSaleId,
    Value<int?>? receiptNoInt,
    Value<int>? syncAttempts,
    Value<DateTime?>? lastSyncAttemptAt,
    Value<DateTime?>? nextRetryAt,
    Value<String?>? lastErrorCode,
    Value<String?>? lastErrorMessage,
    Value<String?>? conflictProductId,
    Value<int?>? conflictRequestedQuantity,
    Value<int?>? conflictAvailableQuantity,
    Value<String?>? saleJson,
    Value<String?>? receiptJson,
    Value<DateTime>? createdLocallyAt,
    Value<DateTime>? updatedLocallyAt,
  }) {
    return OfflineSalesCompanion(
      id: id ?? this.id,
      clientSaleId: clientSaleId ?? this.clientSaleId,
      storeId: storeId ?? this.storeId,
      ownerUserId: ownerUserId ?? this.ownerUserId,
      occurredAt: occurredAt ?? this.occurredAt,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paidAmountMinor: paidAmountMinor ?? this.paidAmountMinor,
      cashAmountMinor: cashAmountMinor ?? this.cashAmountMinor,
      cardAmountMinor: cardAmountMinor ?? this.cardAmountMinor,
      discountAmountMinor: discountAmountMinor ?? this.discountAmountMinor,
      syncStatus: syncStatus ?? this.syncStatus,
      reservationActive: reservationActive ?? this.reservationActive,
      serverSaleId: serverSaleId ?? this.serverSaleId,
      receiptNoInt: receiptNoInt ?? this.receiptNoInt,
      syncAttempts: syncAttempts ?? this.syncAttempts,
      lastSyncAttemptAt: lastSyncAttemptAt ?? this.lastSyncAttemptAt,
      nextRetryAt: nextRetryAt ?? this.nextRetryAt,
      lastErrorCode: lastErrorCode ?? this.lastErrorCode,
      lastErrorMessage: lastErrorMessage ?? this.lastErrorMessage,
      conflictProductId: conflictProductId ?? this.conflictProductId,
      conflictRequestedQuantity:
          conflictRequestedQuantity ?? this.conflictRequestedQuantity,
      conflictAvailableQuantity:
          conflictAvailableQuantity ?? this.conflictAvailableQuantity,
      saleJson: saleJson ?? this.saleJson,
      receiptJson: receiptJson ?? this.receiptJson,
      createdLocallyAt: createdLocallyAt ?? this.createdLocallyAt,
      updatedLocallyAt: updatedLocallyAt ?? this.updatedLocallyAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (clientSaleId.present) {
      map['client_sale_id'] = Variable<String>(clientSaleId.value);
    }
    if (storeId.present) {
      map['store_id'] = Variable<String>(storeId.value);
    }
    if (ownerUserId.present) {
      map['owner_user_id'] = Variable<String>(ownerUserId.value);
    }
    if (occurredAt.present) {
      map['occurred_at'] = Variable<DateTime>(occurredAt.value);
    }
    if (paymentMethod.present) {
      map['payment_method'] = Variable<String>(paymentMethod.value);
    }
    if (paidAmountMinor.present) {
      map['paid_amount_minor'] = Variable<int>(paidAmountMinor.value);
    }
    if (cashAmountMinor.present) {
      map['cash_amount_minor'] = Variable<int>(cashAmountMinor.value);
    }
    if (cardAmountMinor.present) {
      map['card_amount_minor'] = Variable<int>(cardAmountMinor.value);
    }
    if (discountAmountMinor.present) {
      map['discount_amount_minor'] = Variable<int>(discountAmountMinor.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (reservationActive.present) {
      map['reservation_active'] = Variable<bool>(reservationActive.value);
    }
    if (serverSaleId.present) {
      map['server_sale_id'] = Variable<String>(serverSaleId.value);
    }
    if (receiptNoInt.present) {
      map['receipt_no_int'] = Variable<int>(receiptNoInt.value);
    }
    if (syncAttempts.present) {
      map['sync_attempts'] = Variable<int>(syncAttempts.value);
    }
    if (lastSyncAttemptAt.present) {
      map['last_sync_attempt_at'] = Variable<DateTime>(lastSyncAttemptAt.value);
    }
    if (nextRetryAt.present) {
      map['next_retry_at'] = Variable<DateTime>(nextRetryAt.value);
    }
    if (lastErrorCode.present) {
      map['last_error_code'] = Variable<String>(lastErrorCode.value);
    }
    if (lastErrorMessage.present) {
      map['last_error_message'] = Variable<String>(lastErrorMessage.value);
    }
    if (conflictProductId.present) {
      map['conflict_product_id'] = Variable<String>(conflictProductId.value);
    }
    if (conflictRequestedQuantity.present) {
      map['conflict_requested_quantity'] = Variable<int>(
        conflictRequestedQuantity.value,
      );
    }
    if (conflictAvailableQuantity.present) {
      map['conflict_available_quantity'] = Variable<int>(
        conflictAvailableQuantity.value,
      );
    }
    if (saleJson.present) {
      map['sale_json'] = Variable<String>(saleJson.value);
    }
    if (receiptJson.present) {
      map['receipt_json'] = Variable<String>(receiptJson.value);
    }
    if (createdLocallyAt.present) {
      map['created_locally_at'] = Variable<DateTime>(createdLocallyAt.value);
    }
    if (updatedLocallyAt.present) {
      map['updated_locally_at'] = Variable<DateTime>(updatedLocallyAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OfflineSalesCompanion(')
          ..write('id: $id, ')
          ..write('clientSaleId: $clientSaleId, ')
          ..write('storeId: $storeId, ')
          ..write('ownerUserId: $ownerUserId, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('paidAmountMinor: $paidAmountMinor, ')
          ..write('cashAmountMinor: $cashAmountMinor, ')
          ..write('cardAmountMinor: $cardAmountMinor, ')
          ..write('discountAmountMinor: $discountAmountMinor, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('reservationActive: $reservationActive, ')
          ..write('serverSaleId: $serverSaleId, ')
          ..write('receiptNoInt: $receiptNoInt, ')
          ..write('syncAttempts: $syncAttempts, ')
          ..write('lastSyncAttemptAt: $lastSyncAttemptAt, ')
          ..write('nextRetryAt: $nextRetryAt, ')
          ..write('lastErrorCode: $lastErrorCode, ')
          ..write('lastErrorMessage: $lastErrorMessage, ')
          ..write('conflictProductId: $conflictProductId, ')
          ..write('conflictRequestedQuantity: $conflictRequestedQuantity, ')
          ..write('conflictAvailableQuantity: $conflictAvailableQuantity, ')
          ..write('saleJson: $saleJson, ')
          ..write('receiptJson: $receiptJson, ')
          ..write('createdLocallyAt: $createdLocallyAt, ')
          ..write('updatedLocallyAt: $updatedLocallyAt')
          ..write(')'))
        .toString();
  }
}

class $OfflineSaleItemsTable extends OfflineSaleItems
    with TableInfo<$OfflineSaleItemsTable, OfflineSaleItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OfflineSaleItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _clientSaleIdMeta = const VerificationMeta(
    'clientSaleId',
  );
  @override
  late final GeneratedColumn<String> clientSaleId = GeneratedColumn<String>(
    'client_sale_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES offline_sales (client_sale_id)',
    ),
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productNameMeta = const VerificationMeta(
    'productName',
  );
  @override
  late final GeneratedColumn<String> productName = GeneratedColumn<String>(
    'product_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productCodeMeta = const VerificationMeta(
    'productCode',
  );
  @override
  late final GeneratedColumn<String> productCode = GeneratedColumn<String>(
    'product_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitPriceOverrideMinorMeta =
      const VerificationMeta('unitPriceOverrideMinor');
  @override
  late final GeneratedColumn<int> unitPriceOverrideMinor = GeneratedColumn<int>(
    'unit_price_override_minor',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sellingPriceMinorMeta = const VerificationMeta(
    'sellingPriceMinor',
  );
  @override
  late final GeneratedColumn<int> sellingPriceMinor = GeneratedColumn<int>(
    'selling_price_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    clientSaleId,
    productId,
    productName,
    productCode,
    quantity,
    unitPriceOverrideMinor,
    sellingPriceMinor,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'offline_sale_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<OfflineSaleItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('client_sale_id')) {
      context.handle(
        _clientSaleIdMeta,
        clientSaleId.isAcceptableOrUnknown(
          data['client_sale_id']!,
          _clientSaleIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_clientSaleIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('product_name')) {
      context.handle(
        _productNameMeta,
        productName.isAcceptableOrUnknown(
          data['product_name']!,
          _productNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_productNameMeta);
    }
    if (data.containsKey('product_code')) {
      context.handle(
        _productCodeMeta,
        productCode.isAcceptableOrUnknown(
          data['product_code']!,
          _productCodeMeta,
        ),
      );
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('unit_price_override_minor')) {
      context.handle(
        _unitPriceOverrideMinorMeta,
        unitPriceOverrideMinor.isAcceptableOrUnknown(
          data['unit_price_override_minor']!,
          _unitPriceOverrideMinorMeta,
        ),
      );
    }
    if (data.containsKey('selling_price_minor')) {
      context.handle(
        _sellingPriceMinorMeta,
        sellingPriceMinor.isAcceptableOrUnknown(
          data['selling_price_minor']!,
          _sellingPriceMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sellingPriceMinorMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OfflineSaleItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OfflineSaleItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      clientSaleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_sale_id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      )!,
      productName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_name'],
      )!,
      productCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_code'],
      ),
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
      unitPriceOverrideMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unit_price_override_minor'],
      ),
      sellingPriceMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}selling_price_minor'],
      )!,
    );
  }

  @override
  $OfflineSaleItemsTable createAlias(String alias) {
    return $OfflineSaleItemsTable(attachedDatabase, alias);
  }
}

class OfflineSaleItem extends DataClass implements Insertable<OfflineSaleItem> {
  final int id;
  final String clientSaleId;
  final String productId;
  final String productName;
  final String? productCode;
  final int quantity;
  final int? unitPriceOverrideMinor;
  final int sellingPriceMinor;
  const OfflineSaleItem({
    required this.id,
    required this.clientSaleId,
    required this.productId,
    required this.productName,
    this.productCode,
    required this.quantity,
    this.unitPriceOverrideMinor,
    required this.sellingPriceMinor,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['client_sale_id'] = Variable<String>(clientSaleId);
    map['product_id'] = Variable<String>(productId);
    map['product_name'] = Variable<String>(productName);
    if (!nullToAbsent || productCode != null) {
      map['product_code'] = Variable<String>(productCode);
    }
    map['quantity'] = Variable<int>(quantity);
    if (!nullToAbsent || unitPriceOverrideMinor != null) {
      map['unit_price_override_minor'] = Variable<int>(unitPriceOverrideMinor);
    }
    map['selling_price_minor'] = Variable<int>(sellingPriceMinor);
    return map;
  }

  OfflineSaleItemsCompanion toCompanion(bool nullToAbsent) {
    return OfflineSaleItemsCompanion(
      id: Value(id),
      clientSaleId: Value(clientSaleId),
      productId: Value(productId),
      productName: Value(productName),
      productCode: productCode == null && nullToAbsent
          ? const Value.absent()
          : Value(productCode),
      quantity: Value(quantity),
      unitPriceOverrideMinor: unitPriceOverrideMinor == null && nullToAbsent
          ? const Value.absent()
          : Value(unitPriceOverrideMinor),
      sellingPriceMinor: Value(sellingPriceMinor),
    );
  }

  factory OfflineSaleItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OfflineSaleItem(
      id: serializer.fromJson<int>(json['id']),
      clientSaleId: serializer.fromJson<String>(json['clientSaleId']),
      productId: serializer.fromJson<String>(json['productId']),
      productName: serializer.fromJson<String>(json['productName']),
      productCode: serializer.fromJson<String?>(json['productCode']),
      quantity: serializer.fromJson<int>(json['quantity']),
      unitPriceOverrideMinor: serializer.fromJson<int?>(
        json['unitPriceOverrideMinor'],
      ),
      sellingPriceMinor: serializer.fromJson<int>(json['sellingPriceMinor']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'clientSaleId': serializer.toJson<String>(clientSaleId),
      'productId': serializer.toJson<String>(productId),
      'productName': serializer.toJson<String>(productName),
      'productCode': serializer.toJson<String?>(productCode),
      'quantity': serializer.toJson<int>(quantity),
      'unitPriceOverrideMinor': serializer.toJson<int?>(unitPriceOverrideMinor),
      'sellingPriceMinor': serializer.toJson<int>(sellingPriceMinor),
    };
  }

  OfflineSaleItem copyWith({
    int? id,
    String? clientSaleId,
    String? productId,
    String? productName,
    Value<String?> productCode = const Value.absent(),
    int? quantity,
    Value<int?> unitPriceOverrideMinor = const Value.absent(),
    int? sellingPriceMinor,
  }) => OfflineSaleItem(
    id: id ?? this.id,
    clientSaleId: clientSaleId ?? this.clientSaleId,
    productId: productId ?? this.productId,
    productName: productName ?? this.productName,
    productCode: productCode.present ? productCode.value : this.productCode,
    quantity: quantity ?? this.quantity,
    unitPriceOverrideMinor: unitPriceOverrideMinor.present
        ? unitPriceOverrideMinor.value
        : this.unitPriceOverrideMinor,
    sellingPriceMinor: sellingPriceMinor ?? this.sellingPriceMinor,
  );
  OfflineSaleItem copyWithCompanion(OfflineSaleItemsCompanion data) {
    return OfflineSaleItem(
      id: data.id.present ? data.id.value : this.id,
      clientSaleId: data.clientSaleId.present
          ? data.clientSaleId.value
          : this.clientSaleId,
      productId: data.productId.present ? data.productId.value : this.productId,
      productName: data.productName.present
          ? data.productName.value
          : this.productName,
      productCode: data.productCode.present
          ? data.productCode.value
          : this.productCode,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unitPriceOverrideMinor: data.unitPriceOverrideMinor.present
          ? data.unitPriceOverrideMinor.value
          : this.unitPriceOverrideMinor,
      sellingPriceMinor: data.sellingPriceMinor.present
          ? data.sellingPriceMinor.value
          : this.sellingPriceMinor,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OfflineSaleItem(')
          ..write('id: $id, ')
          ..write('clientSaleId: $clientSaleId, ')
          ..write('productId: $productId, ')
          ..write('productName: $productName, ')
          ..write('productCode: $productCode, ')
          ..write('quantity: $quantity, ')
          ..write('unitPriceOverrideMinor: $unitPriceOverrideMinor, ')
          ..write('sellingPriceMinor: $sellingPriceMinor')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    clientSaleId,
    productId,
    productName,
    productCode,
    quantity,
    unitPriceOverrideMinor,
    sellingPriceMinor,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OfflineSaleItem &&
          other.id == this.id &&
          other.clientSaleId == this.clientSaleId &&
          other.productId == this.productId &&
          other.productName == this.productName &&
          other.productCode == this.productCode &&
          other.quantity == this.quantity &&
          other.unitPriceOverrideMinor == this.unitPriceOverrideMinor &&
          other.sellingPriceMinor == this.sellingPriceMinor);
}

class OfflineSaleItemsCompanion extends UpdateCompanion<OfflineSaleItem> {
  final Value<int> id;
  final Value<String> clientSaleId;
  final Value<String> productId;
  final Value<String> productName;
  final Value<String?> productCode;
  final Value<int> quantity;
  final Value<int?> unitPriceOverrideMinor;
  final Value<int> sellingPriceMinor;
  const OfflineSaleItemsCompanion({
    this.id = const Value.absent(),
    this.clientSaleId = const Value.absent(),
    this.productId = const Value.absent(),
    this.productName = const Value.absent(),
    this.productCode = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unitPriceOverrideMinor = const Value.absent(),
    this.sellingPriceMinor = const Value.absent(),
  });
  OfflineSaleItemsCompanion.insert({
    this.id = const Value.absent(),
    required String clientSaleId,
    required String productId,
    required String productName,
    this.productCode = const Value.absent(),
    required int quantity,
    this.unitPriceOverrideMinor = const Value.absent(),
    required int sellingPriceMinor,
  }) : clientSaleId = Value(clientSaleId),
       productId = Value(productId),
       productName = Value(productName),
       quantity = Value(quantity),
       sellingPriceMinor = Value(sellingPriceMinor);
  static Insertable<OfflineSaleItem> custom({
    Expression<int>? id,
    Expression<String>? clientSaleId,
    Expression<String>? productId,
    Expression<String>? productName,
    Expression<String>? productCode,
    Expression<int>? quantity,
    Expression<int>? unitPriceOverrideMinor,
    Expression<int>? sellingPriceMinor,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (clientSaleId != null) 'client_sale_id': clientSaleId,
      if (productId != null) 'product_id': productId,
      if (productName != null) 'product_name': productName,
      if (productCode != null) 'product_code': productCode,
      if (quantity != null) 'quantity': quantity,
      if (unitPriceOverrideMinor != null)
        'unit_price_override_minor': unitPriceOverrideMinor,
      if (sellingPriceMinor != null) 'selling_price_minor': sellingPriceMinor,
    });
  }

  OfflineSaleItemsCompanion copyWith({
    Value<int>? id,
    Value<String>? clientSaleId,
    Value<String>? productId,
    Value<String>? productName,
    Value<String?>? productCode,
    Value<int>? quantity,
    Value<int?>? unitPriceOverrideMinor,
    Value<int>? sellingPriceMinor,
  }) {
    return OfflineSaleItemsCompanion(
      id: id ?? this.id,
      clientSaleId: clientSaleId ?? this.clientSaleId,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productCode: productCode ?? this.productCode,
      quantity: quantity ?? this.quantity,
      unitPriceOverrideMinor:
          unitPriceOverrideMinor ?? this.unitPriceOverrideMinor,
      sellingPriceMinor: sellingPriceMinor ?? this.sellingPriceMinor,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (clientSaleId.present) {
      map['client_sale_id'] = Variable<String>(clientSaleId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (productName.present) {
      map['product_name'] = Variable<String>(productName.value);
    }
    if (productCode.present) {
      map['product_code'] = Variable<String>(productCode.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (unitPriceOverrideMinor.present) {
      map['unit_price_override_minor'] = Variable<int>(
        unitPriceOverrideMinor.value,
      );
    }
    if (sellingPriceMinor.present) {
      map['selling_price_minor'] = Variable<int>(sellingPriceMinor.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OfflineSaleItemsCompanion(')
          ..write('id: $id, ')
          ..write('clientSaleId: $clientSaleId, ')
          ..write('productId: $productId, ')
          ..write('productName: $productName, ')
          ..write('productCode: $productCode, ')
          ..write('quantity: $quantity, ')
          ..write('unitPriceOverrideMinor: $unitPriceOverrideMinor, ')
          ..write('sellingPriceMinor: $sellingPriceMinor')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CachedProductsTable cachedProducts = $CachedProductsTable(this);
  late final $TenantCachedProductsTable tenantCachedProducts =
      $TenantCachedProductsTable(this);
  late final $OfflineSalesTable offlineSales = $OfflineSalesTable(this);
  late final $OfflineSaleItemsTable offlineSaleItems = $OfflineSaleItemsTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    cachedProducts,
    tenantCachedProducts,
    offlineSales,
    offlineSaleItems,
  ];
}

typedef $$CachedProductsTableCreateCompanionBuilder =
    CachedProductsCompanion Function({
      required String productId,
      required String name,
      Value<String?> code,
      required int sellingPriceMinor,
      required int serverStock,
      Value<int> reservedStock,
      Value<bool> isActive,
      Value<DateTime?> archivedAt,
      Value<String?> archiveReason,
      Value<String?> category,
      Value<DateTime?> serverUpdatedAt,
      required DateTime lastCachedAt,
      Value<int> rowid,
    });
typedef $$CachedProductsTableUpdateCompanionBuilder =
    CachedProductsCompanion Function({
      Value<String> productId,
      Value<String> name,
      Value<String?> code,
      Value<int> sellingPriceMinor,
      Value<int> serverStock,
      Value<int> reservedStock,
      Value<bool> isActive,
      Value<DateTime?> archivedAt,
      Value<String?> archiveReason,
      Value<String?> category,
      Value<DateTime?> serverUpdatedAt,
      Value<DateTime> lastCachedAt,
      Value<int> rowid,
    });

class $$CachedProductsTableFilterComposer
    extends Composer<_$AppDatabase, $CachedProductsTable> {
  $$CachedProductsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sellingPriceMinor => $composableBuilder(
    column: $table.sellingPriceMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get serverStock => $composableBuilder(
    column: $table.serverStock,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reservedStock => $composableBuilder(
    column: $table.reservedStock,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get archiveReason => $composableBuilder(
    column: $table.archiveReason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastCachedAt => $composableBuilder(
    column: $table.lastCachedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedProductsTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedProductsTable> {
  $$CachedProductsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sellingPriceMinor => $composableBuilder(
    column: $table.sellingPriceMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get serverStock => $composableBuilder(
    column: $table.serverStock,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reservedStock => $composableBuilder(
    column: $table.reservedStock,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get archiveReason => $composableBuilder(
    column: $table.archiveReason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastCachedAt => $composableBuilder(
    column: $table.lastCachedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedProductsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedProductsTable> {
  $$CachedProductsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<int> get sellingPriceMinor => $composableBuilder(
    column: $table.sellingPriceMinor,
    builder: (column) => column,
  );

  GeneratedColumn<int> get serverStock => $composableBuilder(
    column: $table.serverStock,
    builder: (column) => column,
  );

  GeneratedColumn<int> get reservedStock => $composableBuilder(
    column: $table.reservedStock,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get archiveReason => $composableBuilder(
    column: $table.archiveReason,
    builder: (column) => column,
  );

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastCachedAt => $composableBuilder(
    column: $table.lastCachedAt,
    builder: (column) => column,
  );
}

class $$CachedProductsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedProductsTable,
          CachedProduct,
          $$CachedProductsTableFilterComposer,
          $$CachedProductsTableOrderingComposer,
          $$CachedProductsTableAnnotationComposer,
          $$CachedProductsTableCreateCompanionBuilder,
          $$CachedProductsTableUpdateCompanionBuilder,
          (
            CachedProduct,
            BaseReferences<_$AppDatabase, $CachedProductsTable, CachedProduct>,
          ),
          CachedProduct,
          PrefetchHooks Function()
        > {
  $$CachedProductsTableTableManager(
    _$AppDatabase db,
    $CachedProductsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedProductsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedProductsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedProductsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> productId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> code = const Value.absent(),
                Value<int> sellingPriceMinor = const Value.absent(),
                Value<int> serverStock = const Value.absent(),
                Value<int> reservedStock = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<String?> archiveReason = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<DateTime?> serverUpdatedAt = const Value.absent(),
                Value<DateTime> lastCachedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedProductsCompanion(
                productId: productId,
                name: name,
                code: code,
                sellingPriceMinor: sellingPriceMinor,
                serverStock: serverStock,
                reservedStock: reservedStock,
                isActive: isActive,
                archivedAt: archivedAt,
                archiveReason: archiveReason,
                category: category,
                serverUpdatedAt: serverUpdatedAt,
                lastCachedAt: lastCachedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String productId,
                required String name,
                Value<String?> code = const Value.absent(),
                required int sellingPriceMinor,
                required int serverStock,
                Value<int> reservedStock = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<String?> archiveReason = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<DateTime?> serverUpdatedAt = const Value.absent(),
                required DateTime lastCachedAt,
                Value<int> rowid = const Value.absent(),
              }) => CachedProductsCompanion.insert(
                productId: productId,
                name: name,
                code: code,
                sellingPriceMinor: sellingPriceMinor,
                serverStock: serverStock,
                reservedStock: reservedStock,
                isActive: isActive,
                archivedAt: archivedAt,
                archiveReason: archiveReason,
                category: category,
                serverUpdatedAt: serverUpdatedAt,
                lastCachedAt: lastCachedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedProductsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedProductsTable,
      CachedProduct,
      $$CachedProductsTableFilterComposer,
      $$CachedProductsTableOrderingComposer,
      $$CachedProductsTableAnnotationComposer,
      $$CachedProductsTableCreateCompanionBuilder,
      $$CachedProductsTableUpdateCompanionBuilder,
      (
        CachedProduct,
        BaseReferences<_$AppDatabase, $CachedProductsTable, CachedProduct>,
      ),
      CachedProduct,
      PrefetchHooks Function()
    >;
typedef $$TenantCachedProductsTableCreateCompanionBuilder =
    TenantCachedProductsCompanion Function({
      required String storeId,
      required String productId,
      required String name,
      Value<String?> code,
      required int sellingPriceMinor,
      required int serverStock,
      Value<int> reservedStock,
      Value<bool> isActive,
      Value<DateTime?> archivedAt,
      Value<String?> archiveReason,
      Value<String?> category,
      Value<DateTime?> serverUpdatedAt,
      required DateTime lastCachedAt,
      Value<int> rowid,
    });
typedef $$TenantCachedProductsTableUpdateCompanionBuilder =
    TenantCachedProductsCompanion Function({
      Value<String> storeId,
      Value<String> productId,
      Value<String> name,
      Value<String?> code,
      Value<int> sellingPriceMinor,
      Value<int> serverStock,
      Value<int> reservedStock,
      Value<bool> isActive,
      Value<DateTime?> archivedAt,
      Value<String?> archiveReason,
      Value<String?> category,
      Value<DateTime?> serverUpdatedAt,
      Value<DateTime> lastCachedAt,
      Value<int> rowid,
    });

class $$TenantCachedProductsTableFilterComposer
    extends Composer<_$AppDatabase, $TenantCachedProductsTable> {
  $$TenantCachedProductsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get storeId => $composableBuilder(
    column: $table.storeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sellingPriceMinor => $composableBuilder(
    column: $table.sellingPriceMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get serverStock => $composableBuilder(
    column: $table.serverStock,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reservedStock => $composableBuilder(
    column: $table.reservedStock,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get archiveReason => $composableBuilder(
    column: $table.archiveReason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastCachedAt => $composableBuilder(
    column: $table.lastCachedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TenantCachedProductsTableOrderingComposer
    extends Composer<_$AppDatabase, $TenantCachedProductsTable> {
  $$TenantCachedProductsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get storeId => $composableBuilder(
    column: $table.storeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sellingPriceMinor => $composableBuilder(
    column: $table.sellingPriceMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get serverStock => $composableBuilder(
    column: $table.serverStock,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reservedStock => $composableBuilder(
    column: $table.reservedStock,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get archiveReason => $composableBuilder(
    column: $table.archiveReason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastCachedAt => $composableBuilder(
    column: $table.lastCachedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TenantCachedProductsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TenantCachedProductsTable> {
  $$TenantCachedProductsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get storeId =>
      $composableBuilder(column: $table.storeId, builder: (column) => column);

  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<int> get sellingPriceMinor => $composableBuilder(
    column: $table.sellingPriceMinor,
    builder: (column) => column,
  );

  GeneratedColumn<int> get serverStock => $composableBuilder(
    column: $table.serverStock,
    builder: (column) => column,
  );

  GeneratedColumn<int> get reservedStock => $composableBuilder(
    column: $table.reservedStock,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get archiveReason => $composableBuilder(
    column: $table.archiveReason,
    builder: (column) => column,
  );

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastCachedAt => $composableBuilder(
    column: $table.lastCachedAt,
    builder: (column) => column,
  );
}

class $$TenantCachedProductsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TenantCachedProductsTable,
          TenantCachedProduct,
          $$TenantCachedProductsTableFilterComposer,
          $$TenantCachedProductsTableOrderingComposer,
          $$TenantCachedProductsTableAnnotationComposer,
          $$TenantCachedProductsTableCreateCompanionBuilder,
          $$TenantCachedProductsTableUpdateCompanionBuilder,
          (
            TenantCachedProduct,
            BaseReferences<
              _$AppDatabase,
              $TenantCachedProductsTable,
              TenantCachedProduct
            >,
          ),
          TenantCachedProduct,
          PrefetchHooks Function()
        > {
  $$TenantCachedProductsTableTableManager(
    _$AppDatabase db,
    $TenantCachedProductsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TenantCachedProductsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TenantCachedProductsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$TenantCachedProductsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> storeId = const Value.absent(),
                Value<String> productId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> code = const Value.absent(),
                Value<int> sellingPriceMinor = const Value.absent(),
                Value<int> serverStock = const Value.absent(),
                Value<int> reservedStock = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<String?> archiveReason = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<DateTime?> serverUpdatedAt = const Value.absent(),
                Value<DateTime> lastCachedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TenantCachedProductsCompanion(
                storeId: storeId,
                productId: productId,
                name: name,
                code: code,
                sellingPriceMinor: sellingPriceMinor,
                serverStock: serverStock,
                reservedStock: reservedStock,
                isActive: isActive,
                archivedAt: archivedAt,
                archiveReason: archiveReason,
                category: category,
                serverUpdatedAt: serverUpdatedAt,
                lastCachedAt: lastCachedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String storeId,
                required String productId,
                required String name,
                Value<String?> code = const Value.absent(),
                required int sellingPriceMinor,
                required int serverStock,
                Value<int> reservedStock = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<String?> archiveReason = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<DateTime?> serverUpdatedAt = const Value.absent(),
                required DateTime lastCachedAt,
                Value<int> rowid = const Value.absent(),
              }) => TenantCachedProductsCompanion.insert(
                storeId: storeId,
                productId: productId,
                name: name,
                code: code,
                sellingPriceMinor: sellingPriceMinor,
                serverStock: serverStock,
                reservedStock: reservedStock,
                isActive: isActive,
                archivedAt: archivedAt,
                archiveReason: archiveReason,
                category: category,
                serverUpdatedAt: serverUpdatedAt,
                lastCachedAt: lastCachedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TenantCachedProductsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TenantCachedProductsTable,
      TenantCachedProduct,
      $$TenantCachedProductsTableFilterComposer,
      $$TenantCachedProductsTableOrderingComposer,
      $$TenantCachedProductsTableAnnotationComposer,
      $$TenantCachedProductsTableCreateCompanionBuilder,
      $$TenantCachedProductsTableUpdateCompanionBuilder,
      (
        TenantCachedProduct,
        BaseReferences<
          _$AppDatabase,
          $TenantCachedProductsTable,
          TenantCachedProduct
        >,
      ),
      TenantCachedProduct,
      PrefetchHooks Function()
    >;
typedef $$OfflineSalesTableCreateCompanionBuilder =
    OfflineSalesCompanion Function({
      Value<int> id,
      required String clientSaleId,
      Value<String?> storeId,
      required String ownerUserId,
      required DateTime occurredAt,
      required String paymentMethod,
      Value<int?> paidAmountMinor,
      Value<int?> cashAmountMinor,
      Value<int?> cardAmountMinor,
      Value<int> discountAmountMinor,
      required String syncStatus,
      Value<bool> reservationActive,
      Value<String?> serverSaleId,
      Value<int?> receiptNoInt,
      Value<int> syncAttempts,
      Value<DateTime?> lastSyncAttemptAt,
      Value<DateTime?> nextRetryAt,
      Value<String?> lastErrorCode,
      Value<String?> lastErrorMessage,
      Value<String?> conflictProductId,
      Value<int?> conflictRequestedQuantity,
      Value<int?> conflictAvailableQuantity,
      Value<String?> saleJson,
      Value<String?> receiptJson,
      required DateTime createdLocallyAt,
      required DateTime updatedLocallyAt,
    });
typedef $$OfflineSalesTableUpdateCompanionBuilder =
    OfflineSalesCompanion Function({
      Value<int> id,
      Value<String> clientSaleId,
      Value<String?> storeId,
      Value<String> ownerUserId,
      Value<DateTime> occurredAt,
      Value<String> paymentMethod,
      Value<int?> paidAmountMinor,
      Value<int?> cashAmountMinor,
      Value<int?> cardAmountMinor,
      Value<int> discountAmountMinor,
      Value<String> syncStatus,
      Value<bool> reservationActive,
      Value<String?> serverSaleId,
      Value<int?> receiptNoInt,
      Value<int> syncAttempts,
      Value<DateTime?> lastSyncAttemptAt,
      Value<DateTime?> nextRetryAt,
      Value<String?> lastErrorCode,
      Value<String?> lastErrorMessage,
      Value<String?> conflictProductId,
      Value<int?> conflictRequestedQuantity,
      Value<int?> conflictAvailableQuantity,
      Value<String?> saleJson,
      Value<String?> receiptJson,
      Value<DateTime> createdLocallyAt,
      Value<DateTime> updatedLocallyAt,
    });

final class $$OfflineSalesTableReferences
    extends BaseReferences<_$AppDatabase, $OfflineSalesTable, OfflineSale> {
  $$OfflineSalesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$OfflineSaleItemsTable, List<OfflineSaleItem>>
  _offlineSaleItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.offlineSaleItems,
    aliasName:
        'offline_sales__client_sale_id__offline_sale_items__client_sale_id',
  );

  $$OfflineSaleItemsTableProcessedTableManager get offlineSaleItemsRefs {
    final manager =
        $$OfflineSaleItemsTableTableManager($_db, $_db.offlineSaleItems).filter(
          (f) => f.clientSaleId.clientSaleId.sqlEquals(
            $_itemColumn<String>('client_sale_id')!,
          ),
        );

    final cache = $_typedResult.readTableOrNull(
      _offlineSaleItemsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$OfflineSalesTableFilterComposer
    extends Composer<_$AppDatabase, $OfflineSalesTable> {
  $$OfflineSalesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clientSaleId => $composableBuilder(
    column: $table.clientSaleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get storeId => $composableBuilder(
    column: $table.storeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ownerUserId => $composableBuilder(
    column: $table.ownerUserId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get paidAmountMinor => $composableBuilder(
    column: $table.paidAmountMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cashAmountMinor => $composableBuilder(
    column: $table.cashAmountMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cardAmountMinor => $composableBuilder(
    column: $table.cardAmountMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get discountAmountMinor => $composableBuilder(
    column: $table.discountAmountMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get reservationActive => $composableBuilder(
    column: $table.reservationActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serverSaleId => $composableBuilder(
    column: $table.serverSaleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get receiptNoInt => $composableBuilder(
    column: $table.receiptNoInt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncAttempts => $composableBuilder(
    column: $table.syncAttempts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSyncAttemptAt => $composableBuilder(
    column: $table.lastSyncAttemptAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextRetryAt => $composableBuilder(
    column: $table.nextRetryAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastErrorCode => $composableBuilder(
    column: $table.lastErrorCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastErrorMessage => $composableBuilder(
    column: $table.lastErrorMessage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get conflictProductId => $composableBuilder(
    column: $table.conflictProductId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get conflictRequestedQuantity => $composableBuilder(
    column: $table.conflictRequestedQuantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get conflictAvailableQuantity => $composableBuilder(
    column: $table.conflictAvailableQuantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get saleJson => $composableBuilder(
    column: $table.saleJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get receiptJson => $composableBuilder(
    column: $table.receiptJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdLocallyAt => $composableBuilder(
    column: $table.createdLocallyAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedLocallyAt => $composableBuilder(
    column: $table.updatedLocallyAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> offlineSaleItemsRefs(
    Expression<bool> Function($$OfflineSaleItemsTableFilterComposer f) f,
  ) {
    final $$OfflineSaleItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clientSaleId,
      referencedTable: $db.offlineSaleItems,
      getReferencedColumn: (t) => t.clientSaleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OfflineSaleItemsTableFilterComposer(
            $db: $db,
            $table: $db.offlineSaleItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$OfflineSalesTableOrderingComposer
    extends Composer<_$AppDatabase, $OfflineSalesTable> {
  $$OfflineSalesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clientSaleId => $composableBuilder(
    column: $table.clientSaleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get storeId => $composableBuilder(
    column: $table.storeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ownerUserId => $composableBuilder(
    column: $table.ownerUserId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get paidAmountMinor => $composableBuilder(
    column: $table.paidAmountMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cashAmountMinor => $composableBuilder(
    column: $table.cashAmountMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cardAmountMinor => $composableBuilder(
    column: $table.cardAmountMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get discountAmountMinor => $composableBuilder(
    column: $table.discountAmountMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get reservationActive => $composableBuilder(
    column: $table.reservationActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serverSaleId => $composableBuilder(
    column: $table.serverSaleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get receiptNoInt => $composableBuilder(
    column: $table.receiptNoInt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncAttempts => $composableBuilder(
    column: $table.syncAttempts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSyncAttemptAt => $composableBuilder(
    column: $table.lastSyncAttemptAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextRetryAt => $composableBuilder(
    column: $table.nextRetryAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastErrorCode => $composableBuilder(
    column: $table.lastErrorCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastErrorMessage => $composableBuilder(
    column: $table.lastErrorMessage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get conflictProductId => $composableBuilder(
    column: $table.conflictProductId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get conflictRequestedQuantity => $composableBuilder(
    column: $table.conflictRequestedQuantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get conflictAvailableQuantity => $composableBuilder(
    column: $table.conflictAvailableQuantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get saleJson => $composableBuilder(
    column: $table.saleJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get receiptJson => $composableBuilder(
    column: $table.receiptJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdLocallyAt => $composableBuilder(
    column: $table.createdLocallyAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedLocallyAt => $composableBuilder(
    column: $table.updatedLocallyAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OfflineSalesTableAnnotationComposer
    extends Composer<_$AppDatabase, $OfflineSalesTable> {
  $$OfflineSalesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get clientSaleId => $composableBuilder(
    column: $table.clientSaleId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get storeId =>
      $composableBuilder(column: $table.storeId, builder: (column) => column);

  GeneratedColumn<String> get ownerUserId => $composableBuilder(
    column: $table.ownerUserId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => column,
  );

  GeneratedColumn<int> get paidAmountMinor => $composableBuilder(
    column: $table.paidAmountMinor,
    builder: (column) => column,
  );

  GeneratedColumn<int> get cashAmountMinor => $composableBuilder(
    column: $table.cashAmountMinor,
    builder: (column) => column,
  );

  GeneratedColumn<int> get cardAmountMinor => $composableBuilder(
    column: $table.cardAmountMinor,
    builder: (column) => column,
  );

  GeneratedColumn<int> get discountAmountMinor => $composableBuilder(
    column: $table.discountAmountMinor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get reservationActive => $composableBuilder(
    column: $table.reservationActive,
    builder: (column) => column,
  );

  GeneratedColumn<String> get serverSaleId => $composableBuilder(
    column: $table.serverSaleId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get receiptNoInt => $composableBuilder(
    column: $table.receiptNoInt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get syncAttempts => $composableBuilder(
    column: $table.syncAttempts,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastSyncAttemptAt => $composableBuilder(
    column: $table.lastSyncAttemptAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get nextRetryAt => $composableBuilder(
    column: $table.nextRetryAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastErrorCode => $composableBuilder(
    column: $table.lastErrorCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastErrorMessage => $composableBuilder(
    column: $table.lastErrorMessage,
    builder: (column) => column,
  );

  GeneratedColumn<String> get conflictProductId => $composableBuilder(
    column: $table.conflictProductId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get conflictRequestedQuantity => $composableBuilder(
    column: $table.conflictRequestedQuantity,
    builder: (column) => column,
  );

  GeneratedColumn<int> get conflictAvailableQuantity => $composableBuilder(
    column: $table.conflictAvailableQuantity,
    builder: (column) => column,
  );

  GeneratedColumn<String> get saleJson =>
      $composableBuilder(column: $table.saleJson, builder: (column) => column);

  GeneratedColumn<String> get receiptJson => $composableBuilder(
    column: $table.receiptJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdLocallyAt => $composableBuilder(
    column: $table.createdLocallyAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedLocallyAt => $composableBuilder(
    column: $table.updatedLocallyAt,
    builder: (column) => column,
  );

  Expression<T> offlineSaleItemsRefs<T extends Object>(
    Expression<T> Function($$OfflineSaleItemsTableAnnotationComposer a) f,
  ) {
    final $$OfflineSaleItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clientSaleId,
      referencedTable: $db.offlineSaleItems,
      getReferencedColumn: (t) => t.clientSaleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OfflineSaleItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.offlineSaleItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$OfflineSalesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OfflineSalesTable,
          OfflineSale,
          $$OfflineSalesTableFilterComposer,
          $$OfflineSalesTableOrderingComposer,
          $$OfflineSalesTableAnnotationComposer,
          $$OfflineSalesTableCreateCompanionBuilder,
          $$OfflineSalesTableUpdateCompanionBuilder,
          (OfflineSale, $$OfflineSalesTableReferences),
          OfflineSale,
          PrefetchHooks Function({bool offlineSaleItemsRefs})
        > {
  $$OfflineSalesTableTableManager(_$AppDatabase db, $OfflineSalesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OfflineSalesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OfflineSalesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OfflineSalesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> clientSaleId = const Value.absent(),
                Value<String?> storeId = const Value.absent(),
                Value<String> ownerUserId = const Value.absent(),
                Value<DateTime> occurredAt = const Value.absent(),
                Value<String> paymentMethod = const Value.absent(),
                Value<int?> paidAmountMinor = const Value.absent(),
                Value<int?> cashAmountMinor = const Value.absent(),
                Value<int?> cardAmountMinor = const Value.absent(),
                Value<int> discountAmountMinor = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<bool> reservationActive = const Value.absent(),
                Value<String?> serverSaleId = const Value.absent(),
                Value<int?> receiptNoInt = const Value.absent(),
                Value<int> syncAttempts = const Value.absent(),
                Value<DateTime?> lastSyncAttemptAt = const Value.absent(),
                Value<DateTime?> nextRetryAt = const Value.absent(),
                Value<String?> lastErrorCode = const Value.absent(),
                Value<String?> lastErrorMessage = const Value.absent(),
                Value<String?> conflictProductId = const Value.absent(),
                Value<int?> conflictRequestedQuantity = const Value.absent(),
                Value<int?> conflictAvailableQuantity = const Value.absent(),
                Value<String?> saleJson = const Value.absent(),
                Value<String?> receiptJson = const Value.absent(),
                Value<DateTime> createdLocallyAt = const Value.absent(),
                Value<DateTime> updatedLocallyAt = const Value.absent(),
              }) => OfflineSalesCompanion(
                id: id,
                clientSaleId: clientSaleId,
                storeId: storeId,
                ownerUserId: ownerUserId,
                occurredAt: occurredAt,
                paymentMethod: paymentMethod,
                paidAmountMinor: paidAmountMinor,
                cashAmountMinor: cashAmountMinor,
                cardAmountMinor: cardAmountMinor,
                discountAmountMinor: discountAmountMinor,
                syncStatus: syncStatus,
                reservationActive: reservationActive,
                serverSaleId: serverSaleId,
                receiptNoInt: receiptNoInt,
                syncAttempts: syncAttempts,
                lastSyncAttemptAt: lastSyncAttemptAt,
                nextRetryAt: nextRetryAt,
                lastErrorCode: lastErrorCode,
                lastErrorMessage: lastErrorMessage,
                conflictProductId: conflictProductId,
                conflictRequestedQuantity: conflictRequestedQuantity,
                conflictAvailableQuantity: conflictAvailableQuantity,
                saleJson: saleJson,
                receiptJson: receiptJson,
                createdLocallyAt: createdLocallyAt,
                updatedLocallyAt: updatedLocallyAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String clientSaleId,
                Value<String?> storeId = const Value.absent(),
                required String ownerUserId,
                required DateTime occurredAt,
                required String paymentMethod,
                Value<int?> paidAmountMinor = const Value.absent(),
                Value<int?> cashAmountMinor = const Value.absent(),
                Value<int?> cardAmountMinor = const Value.absent(),
                Value<int> discountAmountMinor = const Value.absent(),
                required String syncStatus,
                Value<bool> reservationActive = const Value.absent(),
                Value<String?> serverSaleId = const Value.absent(),
                Value<int?> receiptNoInt = const Value.absent(),
                Value<int> syncAttempts = const Value.absent(),
                Value<DateTime?> lastSyncAttemptAt = const Value.absent(),
                Value<DateTime?> nextRetryAt = const Value.absent(),
                Value<String?> lastErrorCode = const Value.absent(),
                Value<String?> lastErrorMessage = const Value.absent(),
                Value<String?> conflictProductId = const Value.absent(),
                Value<int?> conflictRequestedQuantity = const Value.absent(),
                Value<int?> conflictAvailableQuantity = const Value.absent(),
                Value<String?> saleJson = const Value.absent(),
                Value<String?> receiptJson = const Value.absent(),
                required DateTime createdLocallyAt,
                required DateTime updatedLocallyAt,
              }) => OfflineSalesCompanion.insert(
                id: id,
                clientSaleId: clientSaleId,
                storeId: storeId,
                ownerUserId: ownerUserId,
                occurredAt: occurredAt,
                paymentMethod: paymentMethod,
                paidAmountMinor: paidAmountMinor,
                cashAmountMinor: cashAmountMinor,
                cardAmountMinor: cardAmountMinor,
                discountAmountMinor: discountAmountMinor,
                syncStatus: syncStatus,
                reservationActive: reservationActive,
                serverSaleId: serverSaleId,
                receiptNoInt: receiptNoInt,
                syncAttempts: syncAttempts,
                lastSyncAttemptAt: lastSyncAttemptAt,
                nextRetryAt: nextRetryAt,
                lastErrorCode: lastErrorCode,
                lastErrorMessage: lastErrorMessage,
                conflictProductId: conflictProductId,
                conflictRequestedQuantity: conflictRequestedQuantity,
                conflictAvailableQuantity: conflictAvailableQuantity,
                saleJson: saleJson,
                receiptJson: receiptJson,
                createdLocallyAt: createdLocallyAt,
                updatedLocallyAt: updatedLocallyAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$OfflineSalesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({offlineSaleItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (offlineSaleItemsRefs) db.offlineSaleItems,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (offlineSaleItemsRefs)
                    await $_getPrefetchedData<
                      OfflineSale,
                      $OfflineSalesTable,
                      OfflineSaleItem
                    >(
                      currentTable: table,
                      referencedTable: $$OfflineSalesTableReferences
                          ._offlineSaleItemsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$OfflineSalesTableReferences(
                            db,
                            table,
                            p0,
                          ).offlineSaleItemsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.clientSaleId == item.clientSaleId,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$OfflineSalesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OfflineSalesTable,
      OfflineSale,
      $$OfflineSalesTableFilterComposer,
      $$OfflineSalesTableOrderingComposer,
      $$OfflineSalesTableAnnotationComposer,
      $$OfflineSalesTableCreateCompanionBuilder,
      $$OfflineSalesTableUpdateCompanionBuilder,
      (OfflineSale, $$OfflineSalesTableReferences),
      OfflineSale,
      PrefetchHooks Function({bool offlineSaleItemsRefs})
    >;
typedef $$OfflineSaleItemsTableCreateCompanionBuilder =
    OfflineSaleItemsCompanion Function({
      Value<int> id,
      required String clientSaleId,
      required String productId,
      required String productName,
      Value<String?> productCode,
      required int quantity,
      Value<int?> unitPriceOverrideMinor,
      required int sellingPriceMinor,
    });
typedef $$OfflineSaleItemsTableUpdateCompanionBuilder =
    OfflineSaleItemsCompanion Function({
      Value<int> id,
      Value<String> clientSaleId,
      Value<String> productId,
      Value<String> productName,
      Value<String?> productCode,
      Value<int> quantity,
      Value<int?> unitPriceOverrideMinor,
      Value<int> sellingPriceMinor,
    });

final class $$OfflineSaleItemsTableReferences
    extends
        BaseReferences<_$AppDatabase, $OfflineSaleItemsTable, OfflineSaleItem> {
  $$OfflineSaleItemsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $OfflineSalesTable _clientSaleIdTable(_$AppDatabase db) =>
      db.offlineSales.createAlias(
        'offline_sale_items__client_sale_id__offline_sales__client_sale_id',
      );

  $$OfflineSalesTableProcessedTableManager get clientSaleId {
    final $_column = $_itemColumn<String>('client_sale_id')!;

    final manager = $$OfflineSalesTableTableManager(
      $_db,
      $_db.offlineSales,
    ).filter((f) => f.clientSaleId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_clientSaleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$OfflineSaleItemsTableFilterComposer
    extends Composer<_$AppDatabase, $OfflineSaleItemsTable> {
  $$OfflineSaleItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productCode => $composableBuilder(
    column: $table.productCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get unitPriceOverrideMinor => $composableBuilder(
    column: $table.unitPriceOverrideMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sellingPriceMinor => $composableBuilder(
    column: $table.sellingPriceMinor,
    builder: (column) => ColumnFilters(column),
  );

  $$OfflineSalesTableFilterComposer get clientSaleId {
    final $$OfflineSalesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clientSaleId,
      referencedTable: $db.offlineSales,
      getReferencedColumn: (t) => t.clientSaleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OfflineSalesTableFilterComposer(
            $db: $db,
            $table: $db.offlineSales,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OfflineSaleItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $OfflineSaleItemsTable> {
  $$OfflineSaleItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productCode => $composableBuilder(
    column: $table.productCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get unitPriceOverrideMinor => $composableBuilder(
    column: $table.unitPriceOverrideMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sellingPriceMinor => $composableBuilder(
    column: $table.sellingPriceMinor,
    builder: (column) => ColumnOrderings(column),
  );

  $$OfflineSalesTableOrderingComposer get clientSaleId {
    final $$OfflineSalesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clientSaleId,
      referencedTable: $db.offlineSales,
      getReferencedColumn: (t) => t.clientSaleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OfflineSalesTableOrderingComposer(
            $db: $db,
            $table: $db.offlineSales,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OfflineSaleItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $OfflineSaleItemsTable> {
  $$OfflineSaleItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get productCode => $composableBuilder(
    column: $table.productCode,
    builder: (column) => column,
  );

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<int> get unitPriceOverrideMinor => $composableBuilder(
    column: $table.unitPriceOverrideMinor,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sellingPriceMinor => $composableBuilder(
    column: $table.sellingPriceMinor,
    builder: (column) => column,
  );

  $$OfflineSalesTableAnnotationComposer get clientSaleId {
    final $$OfflineSalesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clientSaleId,
      referencedTable: $db.offlineSales,
      getReferencedColumn: (t) => t.clientSaleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OfflineSalesTableAnnotationComposer(
            $db: $db,
            $table: $db.offlineSales,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OfflineSaleItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OfflineSaleItemsTable,
          OfflineSaleItem,
          $$OfflineSaleItemsTableFilterComposer,
          $$OfflineSaleItemsTableOrderingComposer,
          $$OfflineSaleItemsTableAnnotationComposer,
          $$OfflineSaleItemsTableCreateCompanionBuilder,
          $$OfflineSaleItemsTableUpdateCompanionBuilder,
          (OfflineSaleItem, $$OfflineSaleItemsTableReferences),
          OfflineSaleItem,
          PrefetchHooks Function({bool clientSaleId})
        > {
  $$OfflineSaleItemsTableTableManager(
    _$AppDatabase db,
    $OfflineSaleItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OfflineSaleItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OfflineSaleItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OfflineSaleItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> clientSaleId = const Value.absent(),
                Value<String> productId = const Value.absent(),
                Value<String> productName = const Value.absent(),
                Value<String?> productCode = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<int?> unitPriceOverrideMinor = const Value.absent(),
                Value<int> sellingPriceMinor = const Value.absent(),
              }) => OfflineSaleItemsCompanion(
                id: id,
                clientSaleId: clientSaleId,
                productId: productId,
                productName: productName,
                productCode: productCode,
                quantity: quantity,
                unitPriceOverrideMinor: unitPriceOverrideMinor,
                sellingPriceMinor: sellingPriceMinor,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String clientSaleId,
                required String productId,
                required String productName,
                Value<String?> productCode = const Value.absent(),
                required int quantity,
                Value<int?> unitPriceOverrideMinor = const Value.absent(),
                required int sellingPriceMinor,
              }) => OfflineSaleItemsCompanion.insert(
                id: id,
                clientSaleId: clientSaleId,
                productId: productId,
                productName: productName,
                productCode: productCode,
                quantity: quantity,
                unitPriceOverrideMinor: unitPriceOverrideMinor,
                sellingPriceMinor: sellingPriceMinor,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$OfflineSaleItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({clientSaleId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (clientSaleId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.clientSaleId,
                                referencedTable:
                                    $$OfflineSaleItemsTableReferences
                                        ._clientSaleIdTable(db),
                                referencedColumn:
                                    $$OfflineSaleItemsTableReferences
                                        ._clientSaleIdTable(db)
                                        .clientSaleId,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$OfflineSaleItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OfflineSaleItemsTable,
      OfflineSaleItem,
      $$OfflineSaleItemsTableFilterComposer,
      $$OfflineSaleItemsTableOrderingComposer,
      $$OfflineSaleItemsTableAnnotationComposer,
      $$OfflineSaleItemsTableCreateCompanionBuilder,
      $$OfflineSaleItemsTableUpdateCompanionBuilder,
      (OfflineSaleItem, $$OfflineSaleItemsTableReferences),
      OfflineSaleItem,
      PrefetchHooks Function({bool clientSaleId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CachedProductsTableTableManager get cachedProducts =>
      $$CachedProductsTableTableManager(_db, _db.cachedProducts);
  $$TenantCachedProductsTableTableManager get tenantCachedProducts =>
      $$TenantCachedProductsTableTableManager(_db, _db.tenantCachedProducts);
  $$OfflineSalesTableTableManager get offlineSales =>
      $$OfflineSalesTableTableManager(_db, _db.offlineSales);
  $$OfflineSaleItemsTableTableManager get offlineSaleItems =>
      $$OfflineSaleItemsTableTableManager(_db, _db.offlineSaleItems);
}
