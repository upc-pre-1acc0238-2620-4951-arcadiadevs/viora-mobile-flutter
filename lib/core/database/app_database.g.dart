// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ManagerLicensesTable extends ManagerLicenses
    with TableInfo<$ManagerLicensesTable, ManagerLicenseRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ManagerLicensesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _licenseIdMeta = const VerificationMeta(
    'licenseId',
  );
  @override
  late final GeneratedColumn<String> licenseId = GeneratedColumn<String>(
    'license_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _organizationNameMeta = const VerificationMeta(
    'organizationName',
  );
  @override
  late final GeneratedColumn<String> organizationName = GeneratedColumn<String>(
    'organization_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _seatsMeta = const VerificationMeta('seats');
  @override
  late final GeneratedColumn<int> seats = GeneratedColumn<int>(
    'seats',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contractedAreaHaMeta = const VerificationMeta(
    'contractedAreaHa',
  );
  @override
  late final GeneratedColumn<double> contractedAreaHa = GeneratedColumn<double>(
    'contracted_area_ha',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startsAtMeta = const VerificationMeta(
    'startsAt',
  );
  @override
  late final GeneratedColumn<DateTime> startsAt = GeneratedColumn<DateTime>(
    'starts_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endsAtMeta = const VerificationMeta('endsAt');
  @override
  late final GeneratedColumn<DateTime> endsAt = GeneratedColumn<DateTime>(
    'ends_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    userId,
    licenseId,
    organizationName,
    seats,
    contractedAreaHa,
    startsAt,
    endsAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'manager_licenses';
  @override
  VerificationContext validateIntegrity(
    Insertable<ManagerLicenseRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('license_id')) {
      context.handle(
        _licenseIdMeta,
        licenseId.isAcceptableOrUnknown(data['license_id']!, _licenseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_licenseIdMeta);
    }
    if (data.containsKey('organization_name')) {
      context.handle(
        _organizationNameMeta,
        organizationName.isAcceptableOrUnknown(
          data['organization_name']!,
          _organizationNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_organizationNameMeta);
    }
    if (data.containsKey('seats')) {
      context.handle(
        _seatsMeta,
        seats.isAcceptableOrUnknown(data['seats']!, _seatsMeta),
      );
    } else if (isInserting) {
      context.missing(_seatsMeta);
    }
    if (data.containsKey('contracted_area_ha')) {
      context.handle(
        _contractedAreaHaMeta,
        contractedAreaHa.isAcceptableOrUnknown(
          data['contracted_area_ha']!,
          _contractedAreaHaMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_contractedAreaHaMeta);
    }
    if (data.containsKey('starts_at')) {
      context.handle(
        _startsAtMeta,
        startsAt.isAcceptableOrUnknown(data['starts_at']!, _startsAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startsAtMeta);
    }
    if (data.containsKey('ends_at')) {
      context.handle(
        _endsAtMeta,
        endsAt.isAcceptableOrUnknown(data['ends_at']!, _endsAtMeta),
      );
    } else if (isInserting) {
      context.missing(_endsAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId};
  @override
  ManagerLicenseRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ManagerLicenseRow(
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      licenseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}license_id'],
      )!,
      organizationName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}organization_name'],
      )!,
      seats: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}seats'],
      )!,
      contractedAreaHa: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}contracted_area_ha'],
      )!,
      startsAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}starts_at'],
      )!,
      endsAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ends_at'],
      )!,
    );
  }

  @override
  $ManagerLicensesTable createAlias(String alias) {
    return $ManagerLicensesTable(attachedDatabase, alias);
  }
}

class ManagerLicenseRow extends DataClass
    implements Insertable<ManagerLicenseRow> {
  final String userId;
  final String licenseId;
  final String organizationName;
  final int seats;
  final double contractedAreaHa;
  final DateTime startsAt;
  final DateTime endsAt;
  const ManagerLicenseRow({
    required this.userId,
    required this.licenseId,
    required this.organizationName,
    required this.seats,
    required this.contractedAreaHa,
    required this.startsAt,
    required this.endsAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    map['license_id'] = Variable<String>(licenseId);
    map['organization_name'] = Variable<String>(organizationName);
    map['seats'] = Variable<int>(seats);
    map['contracted_area_ha'] = Variable<double>(contractedAreaHa);
    map['starts_at'] = Variable<DateTime>(startsAt);
    map['ends_at'] = Variable<DateTime>(endsAt);
    return map;
  }

  ManagerLicensesCompanion toCompanion(bool nullToAbsent) {
    return ManagerLicensesCompanion(
      userId: Value(userId),
      licenseId: Value(licenseId),
      organizationName: Value(organizationName),
      seats: Value(seats),
      contractedAreaHa: Value(contractedAreaHa),
      startsAt: Value(startsAt),
      endsAt: Value(endsAt),
    );
  }

  factory ManagerLicenseRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ManagerLicenseRow(
      userId: serializer.fromJson<String>(json['userId']),
      licenseId: serializer.fromJson<String>(json['licenseId']),
      organizationName: serializer.fromJson<String>(json['organizationName']),
      seats: serializer.fromJson<int>(json['seats']),
      contractedAreaHa: serializer.fromJson<double>(json['contractedAreaHa']),
      startsAt: serializer.fromJson<DateTime>(json['startsAt']),
      endsAt: serializer.fromJson<DateTime>(json['endsAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<String>(userId),
      'licenseId': serializer.toJson<String>(licenseId),
      'organizationName': serializer.toJson<String>(organizationName),
      'seats': serializer.toJson<int>(seats),
      'contractedAreaHa': serializer.toJson<double>(contractedAreaHa),
      'startsAt': serializer.toJson<DateTime>(startsAt),
      'endsAt': serializer.toJson<DateTime>(endsAt),
    };
  }

  ManagerLicenseRow copyWith({
    String? userId,
    String? licenseId,
    String? organizationName,
    int? seats,
    double? contractedAreaHa,
    DateTime? startsAt,
    DateTime? endsAt,
  }) => ManagerLicenseRow(
    userId: userId ?? this.userId,
    licenseId: licenseId ?? this.licenseId,
    organizationName: organizationName ?? this.organizationName,
    seats: seats ?? this.seats,
    contractedAreaHa: contractedAreaHa ?? this.contractedAreaHa,
    startsAt: startsAt ?? this.startsAt,
    endsAt: endsAt ?? this.endsAt,
  );
  ManagerLicenseRow copyWithCompanion(ManagerLicensesCompanion data) {
    return ManagerLicenseRow(
      userId: data.userId.present ? data.userId.value : this.userId,
      licenseId: data.licenseId.present ? data.licenseId.value : this.licenseId,
      organizationName: data.organizationName.present
          ? data.organizationName.value
          : this.organizationName,
      seats: data.seats.present ? data.seats.value : this.seats,
      contractedAreaHa: data.contractedAreaHa.present
          ? data.contractedAreaHa.value
          : this.contractedAreaHa,
      startsAt: data.startsAt.present ? data.startsAt.value : this.startsAt,
      endsAt: data.endsAt.present ? data.endsAt.value : this.endsAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ManagerLicenseRow(')
          ..write('userId: $userId, ')
          ..write('licenseId: $licenseId, ')
          ..write('organizationName: $organizationName, ')
          ..write('seats: $seats, ')
          ..write('contractedAreaHa: $contractedAreaHa, ')
          ..write('startsAt: $startsAt, ')
          ..write('endsAt: $endsAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    userId,
    licenseId,
    organizationName,
    seats,
    contractedAreaHa,
    startsAt,
    endsAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ManagerLicenseRow &&
          other.userId == this.userId &&
          other.licenseId == this.licenseId &&
          other.organizationName == this.organizationName &&
          other.seats == this.seats &&
          other.contractedAreaHa == this.contractedAreaHa &&
          other.startsAt == this.startsAt &&
          other.endsAt == this.endsAt);
}

class ManagerLicensesCompanion extends UpdateCompanion<ManagerLicenseRow> {
  final Value<String> userId;
  final Value<String> licenseId;
  final Value<String> organizationName;
  final Value<int> seats;
  final Value<double> contractedAreaHa;
  final Value<DateTime> startsAt;
  final Value<DateTime> endsAt;
  final Value<int> rowid;
  const ManagerLicensesCompanion({
    this.userId = const Value.absent(),
    this.licenseId = const Value.absent(),
    this.organizationName = const Value.absent(),
    this.seats = const Value.absent(),
    this.contractedAreaHa = const Value.absent(),
    this.startsAt = const Value.absent(),
    this.endsAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ManagerLicensesCompanion.insert({
    required String userId,
    required String licenseId,
    required String organizationName,
    required int seats,
    required double contractedAreaHa,
    required DateTime startsAt,
    required DateTime endsAt,
    this.rowid = const Value.absent(),
  }) : userId = Value(userId),
       licenseId = Value(licenseId),
       organizationName = Value(organizationName),
       seats = Value(seats),
       contractedAreaHa = Value(contractedAreaHa),
       startsAt = Value(startsAt),
       endsAt = Value(endsAt);
  static Insertable<ManagerLicenseRow> custom({
    Expression<String>? userId,
    Expression<String>? licenseId,
    Expression<String>? organizationName,
    Expression<int>? seats,
    Expression<double>? contractedAreaHa,
    Expression<DateTime>? startsAt,
    Expression<DateTime>? endsAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (licenseId != null) 'license_id': licenseId,
      if (organizationName != null) 'organization_name': organizationName,
      if (seats != null) 'seats': seats,
      if (contractedAreaHa != null) 'contracted_area_ha': contractedAreaHa,
      if (startsAt != null) 'starts_at': startsAt,
      if (endsAt != null) 'ends_at': endsAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ManagerLicensesCompanion copyWith({
    Value<String>? userId,
    Value<String>? licenseId,
    Value<String>? organizationName,
    Value<int>? seats,
    Value<double>? contractedAreaHa,
    Value<DateTime>? startsAt,
    Value<DateTime>? endsAt,
    Value<int>? rowid,
  }) {
    return ManagerLicensesCompanion(
      userId: userId ?? this.userId,
      licenseId: licenseId ?? this.licenseId,
      organizationName: organizationName ?? this.organizationName,
      seats: seats ?? this.seats,
      contractedAreaHa: contractedAreaHa ?? this.contractedAreaHa,
      startsAt: startsAt ?? this.startsAt,
      endsAt: endsAt ?? this.endsAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (licenseId.present) {
      map['license_id'] = Variable<String>(licenseId.value);
    }
    if (organizationName.present) {
      map['organization_name'] = Variable<String>(organizationName.value);
    }
    if (seats.present) {
      map['seats'] = Variable<int>(seats.value);
    }
    if (contractedAreaHa.present) {
      map['contracted_area_ha'] = Variable<double>(contractedAreaHa.value);
    }
    if (startsAt.present) {
      map['starts_at'] = Variable<DateTime>(startsAt.value);
    }
    if (endsAt.present) {
      map['ends_at'] = Variable<DateTime>(endsAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ManagerLicensesCompanion(')
          ..write('userId: $userId, ')
          ..write('licenseId: $licenseId, ')
          ..write('organizationName: $organizationName, ')
          ..write('seats: $seats, ')
          ..write('contractedAreaHa: $contractedAreaHa, ')
          ..write('startsAt: $startsAt, ')
          ..write('endsAt: $endsAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ManagerLicensesTable managerLicenses = $ManagerLicensesTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [managerLicenses];
}

typedef $$ManagerLicensesTableCreateCompanionBuilder =
    ManagerLicensesCompanion Function({
      required String userId,
      required String licenseId,
      required String organizationName,
      required int seats,
      required double contractedAreaHa,
      required DateTime startsAt,
      required DateTime endsAt,
      Value<int> rowid,
    });
typedef $$ManagerLicensesTableUpdateCompanionBuilder =
    ManagerLicensesCompanion Function({
      Value<String> userId,
      Value<String> licenseId,
      Value<String> organizationName,
      Value<int> seats,
      Value<double> contractedAreaHa,
      Value<DateTime> startsAt,
      Value<DateTime> endsAt,
      Value<int> rowid,
    });

class $$ManagerLicensesTableFilterComposer
    extends Composer<_$AppDatabase, $ManagerLicensesTable> {
  $$ManagerLicensesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get licenseId => $composableBuilder(
    column: $table.licenseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get organizationName => $composableBuilder(
    column: $table.organizationName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get seats => $composableBuilder(
    column: $table.seats,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get contractedAreaHa => $composableBuilder(
    column: $table.contractedAreaHa,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startsAt => $composableBuilder(
    column: $table.startsAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endsAt => $composableBuilder(
    column: $table.endsAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ManagerLicensesTableOrderingComposer
    extends Composer<_$AppDatabase, $ManagerLicensesTable> {
  $$ManagerLicensesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get licenseId => $composableBuilder(
    column: $table.licenseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get organizationName => $composableBuilder(
    column: $table.organizationName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get seats => $composableBuilder(
    column: $table.seats,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get contractedAreaHa => $composableBuilder(
    column: $table.contractedAreaHa,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startsAt => $composableBuilder(
    column: $table.startsAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endsAt => $composableBuilder(
    column: $table.endsAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ManagerLicensesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ManagerLicensesTable> {
  $$ManagerLicensesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get licenseId =>
      $composableBuilder(column: $table.licenseId, builder: (column) => column);

  GeneratedColumn<String> get organizationName => $composableBuilder(
    column: $table.organizationName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get seats =>
      $composableBuilder(column: $table.seats, builder: (column) => column);

  GeneratedColumn<double> get contractedAreaHa => $composableBuilder(
    column: $table.contractedAreaHa,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startsAt =>
      $composableBuilder(column: $table.startsAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endsAt =>
      $composableBuilder(column: $table.endsAt, builder: (column) => column);
}

class $$ManagerLicensesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ManagerLicensesTable,
          ManagerLicenseRow,
          $$ManagerLicensesTableFilterComposer,
          $$ManagerLicensesTableOrderingComposer,
          $$ManagerLicensesTableAnnotationComposer,
          $$ManagerLicensesTableCreateCompanionBuilder,
          $$ManagerLicensesTableUpdateCompanionBuilder,
          (
            ManagerLicenseRow,
            BaseReferences<
              _$AppDatabase,
              $ManagerLicensesTable,
              ManagerLicenseRow
            >,
          ),
          ManagerLicenseRow,
          PrefetchHooks Function()
        > {
  $$ManagerLicensesTableTableManager(
    _$AppDatabase db,
    $ManagerLicensesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ManagerLicensesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ManagerLicensesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ManagerLicensesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> userId = const Value.absent(),
                Value<String> licenseId = const Value.absent(),
                Value<String> organizationName = const Value.absent(),
                Value<int> seats = const Value.absent(),
                Value<double> contractedAreaHa = const Value.absent(),
                Value<DateTime> startsAt = const Value.absent(),
                Value<DateTime> endsAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ManagerLicensesCompanion(
                userId: userId,
                licenseId: licenseId,
                organizationName: organizationName,
                seats: seats,
                contractedAreaHa: contractedAreaHa,
                startsAt: startsAt,
                endsAt: endsAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String userId,
                required String licenseId,
                required String organizationName,
                required int seats,
                required double contractedAreaHa,
                required DateTime startsAt,
                required DateTime endsAt,
                Value<int> rowid = const Value.absent(),
              }) => ManagerLicensesCompanion.insert(
                userId: userId,
                licenseId: licenseId,
                organizationName: organizationName,
                seats: seats,
                contractedAreaHa: contractedAreaHa,
                startsAt: startsAt,
                endsAt: endsAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ManagerLicensesTable, ManagerLicenseRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $ManagerLicensesTable,
                    ManagerLicenseRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ManagerLicensesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ManagerLicensesTable,
      ManagerLicenseRow,
      $$ManagerLicensesTableFilterComposer,
      $$ManagerLicensesTableOrderingComposer,
      $$ManagerLicensesTableAnnotationComposer,
      $$ManagerLicensesTableCreateCompanionBuilder,
      $$ManagerLicensesTableUpdateCompanionBuilder,
      (
        ManagerLicenseRow,
        BaseReferences<_$AppDatabase, $ManagerLicensesTable, ManagerLicenseRow>,
      ),
      ManagerLicenseRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ManagerLicensesTableTableManager get managerLicenses =>
      $$ManagerLicensesTableTableManager(_db, _db.managerLicenses);
}
