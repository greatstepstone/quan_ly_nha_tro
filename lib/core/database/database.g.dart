// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
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
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _avatarUrlMeta = const VerificationMeta(
    'avatarUrl',
  );
  @override
  late final GeneratedColumn<String> avatarUrl = GeneratedColumn<String>(
    'avatar_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, email, name, phone, avatarUrl];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(
    Insertable<User> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('avatar_url')) {
      context.handle(
        _avatarUrlMeta,
        avatarUrl.isAcceptableOrUnknown(data['avatar_url']!, _avatarUrlMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      email:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}email'],
          )!,
      name:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}name'],
          )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      avatarUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}avatar_url'],
      ),
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<String> id;
  final Value<String> email;
  final Value<String> name;
  final Value<String?> phone;
  final Value<String?> avatarUrl;
  final Value<int> rowid;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.email = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.avatarUrl = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsersCompanion.insert({
    required String id,
    required String email,
    required String name,
    this.phone = const Value.absent(),
    this.avatarUrl = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       email = Value(email),
       name = Value(name);
  static Insertable<User> custom({
    Expression<String>? id,
    Expression<String>? email,
    Expression<String>? name,
    Expression<String>? phone,
    Expression<String>? avatarUrl,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (email != null) 'email': email,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsersCompanion copyWith({
    Value<String>? id,
    Value<String>? email,
    Value<String>? name,
    Value<String?>? phone,
    Value<String?>? avatarUrl,
    Value<int>? rowid,
  }) {
    return UsersCompanion(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (avatarUrl.present) {
      map['avatar_url'] = Variable<String>(avatarUrl.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('avatarUrl: $avatarUrl, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PropertiesTable extends Properties
    with TableInfo<$PropertiesTable, Property> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PropertiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ownerIdMeta = const VerificationMeta(
    'ownerId',
  );
  @override
  late final GeneratedColumn<String> ownerId = GeneratedColumn<String>(
    'owner_id',
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
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalRoomsMeta = const VerificationMeta(
    'totalRooms',
  );
  @override
  late final GeneratedColumn<int> totalRooms = GeneratedColumn<int>(
    'total_rooms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _electricityPriceMeta = const VerificationMeta(
    'electricityPrice',
  );
  @override
  late final GeneratedColumn<double> electricityPrice = GeneratedColumn<double>(
    'electricity_price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _waterPriceMeta = const VerificationMeta(
    'waterPrice',
  );
  @override
  late final GeneratedColumn<double> waterPrice = GeneratedColumn<double>(
    'water_price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<BillingType, String>
  waterBillingType = GeneratedColumn<String>(
    'water_billing_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<BillingType>($PropertiesTable.$converterwaterBillingType);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('HOẠT ĐỘNG'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ownerId,
    name,
    address,
    totalRooms,
    electricityPrice,
    waterPrice,
    waterBillingType,
    status,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'properties';
  @override
  VerificationContext validateIntegrity(
    Insertable<Property> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('owner_id')) {
      context.handle(
        _ownerIdMeta,
        ownerId.isAcceptableOrUnknown(data['owner_id']!, _ownerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_ownerIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    } else if (isInserting) {
      context.missing(_addressMeta);
    }
    if (data.containsKey('total_rooms')) {
      context.handle(
        _totalRoomsMeta,
        totalRooms.isAcceptableOrUnknown(data['total_rooms']!, _totalRoomsMeta),
      );
    } else if (isInserting) {
      context.missing(_totalRoomsMeta);
    }
    if (data.containsKey('electricity_price')) {
      context.handle(
        _electricityPriceMeta,
        electricityPrice.isAcceptableOrUnknown(
          data['electricity_price']!,
          _electricityPriceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_electricityPriceMeta);
    }
    if (data.containsKey('water_price')) {
      context.handle(
        _waterPriceMeta,
        waterPrice.isAcceptableOrUnknown(data['water_price']!, _waterPriceMeta),
      );
    } else if (isInserting) {
      context.missing(_waterPriceMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Property map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Property(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      ownerId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}owner_id'],
          )!,
      name:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}name'],
          )!,
      address:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}address'],
          )!,
      totalRooms:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}total_rooms'],
          )!,
      electricityPrice:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}electricity_price'],
          )!,
      waterPrice:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}water_price'],
          )!,
      waterBillingType: $PropertiesTable.$converterwaterBillingType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}water_billing_type'],
        )!,
      ),
      status:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}status'],
          )!,
    );
  }

  @override
  $PropertiesTable createAlias(String alias) {
    return $PropertiesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<BillingType, String, String>
  $converterwaterBillingType = const EnumNameConverter<BillingType>(
    BillingType.values,
  );
}

class PropertiesCompanion extends UpdateCompanion<Property> {
  final Value<String> id;
  final Value<String> ownerId;
  final Value<String> name;
  final Value<String> address;
  final Value<int> totalRooms;
  final Value<double> electricityPrice;
  final Value<double> waterPrice;
  final Value<BillingType> waterBillingType;
  final Value<String> status;
  final Value<int> rowid;
  const PropertiesCompanion({
    this.id = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.name = const Value.absent(),
    this.address = const Value.absent(),
    this.totalRooms = const Value.absent(),
    this.electricityPrice = const Value.absent(),
    this.waterPrice = const Value.absent(),
    this.waterBillingType = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PropertiesCompanion.insert({
    required String id,
    required String ownerId,
    required String name,
    required String address,
    required int totalRooms,
    required double electricityPrice,
    required double waterPrice,
    required BillingType waterBillingType,
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       ownerId = Value(ownerId),
       name = Value(name),
       address = Value(address),
       totalRooms = Value(totalRooms),
       electricityPrice = Value(electricityPrice),
       waterPrice = Value(waterPrice),
       waterBillingType = Value(waterBillingType);
  static Insertable<Property> custom({
    Expression<String>? id,
    Expression<String>? ownerId,
    Expression<String>? name,
    Expression<String>? address,
    Expression<int>? totalRooms,
    Expression<double>? electricityPrice,
    Expression<double>? waterPrice,
    Expression<String>? waterBillingType,
    Expression<String>? status,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ownerId != null) 'owner_id': ownerId,
      if (name != null) 'name': name,
      if (address != null) 'address': address,
      if (totalRooms != null) 'total_rooms': totalRooms,
      if (electricityPrice != null) 'electricity_price': electricityPrice,
      if (waterPrice != null) 'water_price': waterPrice,
      if (waterBillingType != null) 'water_billing_type': waterBillingType,
      if (status != null) 'status': status,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PropertiesCompanion copyWith({
    Value<String>? id,
    Value<String>? ownerId,
    Value<String>? name,
    Value<String>? address,
    Value<int>? totalRooms,
    Value<double>? electricityPrice,
    Value<double>? waterPrice,
    Value<BillingType>? waterBillingType,
    Value<String>? status,
    Value<int>? rowid,
  }) {
    return PropertiesCompanion(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      name: name ?? this.name,
      address: address ?? this.address,
      totalRooms: totalRooms ?? this.totalRooms,
      electricityPrice: electricityPrice ?? this.electricityPrice,
      waterPrice: waterPrice ?? this.waterPrice,
      waterBillingType: waterBillingType ?? this.waterBillingType,
      status: status ?? this.status,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (ownerId.present) {
      map['owner_id'] = Variable<String>(ownerId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (totalRooms.present) {
      map['total_rooms'] = Variable<int>(totalRooms.value);
    }
    if (electricityPrice.present) {
      map['electricity_price'] = Variable<double>(electricityPrice.value);
    }
    if (waterPrice.present) {
      map['water_price'] = Variable<double>(waterPrice.value);
    }
    if (waterBillingType.present) {
      map['water_billing_type'] = Variable<String>(
        $PropertiesTable.$converterwaterBillingType.toSql(
          waterBillingType.value,
        ),
      );
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PropertiesCompanion(')
          ..write('id: $id, ')
          ..write('ownerId: $ownerId, ')
          ..write('name: $name, ')
          ..write('address: $address, ')
          ..write('totalRooms: $totalRooms, ')
          ..write('electricityPrice: $electricityPrice, ')
          ..write('waterPrice: $waterPrice, ')
          ..write('waterBillingType: $waterBillingType, ')
          ..write('status: $status, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ServicesTable extends Services with TableInfo<$ServicesTable, Service> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ServicesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _propertyIdMeta = const VerificationMeta(
    'propertyId',
  );
  @override
  late final GeneratedColumn<String> propertyId = GeneratedColumn<String>(
    'property_id',
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
  @override
  late final GeneratedColumnWithTypeConverter<BillingType, String> type =
      GeneratedColumn<String>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<BillingType>($ServicesTable.$convertertype);
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
    'price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, propertyId, name, type, price];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'services';
  @override
  VerificationContext validateIntegrity(
    Insertable<Service> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('property_id')) {
      context.handle(
        _propertyIdMeta,
        propertyId.isAcceptableOrUnknown(data['property_id']!, _propertyIdMeta),
      );
    } else if (isInserting) {
      context.missing(_propertyIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
        _priceMeta,
        price.isAcceptableOrUnknown(data['price']!, _priceMeta),
      );
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Service map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Service(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      propertyId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}property_id'],
          )!,
      name:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}name'],
          )!,
      type: $ServicesTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      price:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}price'],
          )!,
    );
  }

  @override
  $ServicesTable createAlias(String alias) {
    return $ServicesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<BillingType, String, String> $convertertype =
      const EnumNameConverter<BillingType>(BillingType.values);
}

class ServicesCompanion extends UpdateCompanion<Service> {
  final Value<String> id;
  final Value<String> propertyId;
  final Value<String> name;
  final Value<BillingType> type;
  final Value<double> price;
  final Value<int> rowid;
  const ServicesCompanion({
    this.id = const Value.absent(),
    this.propertyId = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.price = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ServicesCompanion.insert({
    required String id,
    required String propertyId,
    required String name,
    required BillingType type,
    required double price,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       propertyId = Value(propertyId),
       name = Value(name),
       type = Value(type),
       price = Value(price);
  static Insertable<Service> custom({
    Expression<String>? id,
    Expression<String>? propertyId,
    Expression<String>? name,
    Expression<String>? type,
    Expression<double>? price,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (propertyId != null) 'property_id': propertyId,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (price != null) 'price': price,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ServicesCompanion copyWith({
    Value<String>? id,
    Value<String>? propertyId,
    Value<String>? name,
    Value<BillingType>? type,
    Value<double>? price,
    Value<int>? rowid,
  }) {
    return ServicesCompanion(
      id: id ?? this.id,
      propertyId: propertyId ?? this.propertyId,
      name: name ?? this.name,
      type: type ?? this.type,
      price: price ?? this.price,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (propertyId.present) {
      map['property_id'] = Variable<String>(propertyId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(
        $ServicesTable.$convertertype.toSql(type.value),
      );
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ServicesCompanion(')
          ..write('id: $id, ')
          ..write('propertyId: $propertyId, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('price: $price, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RoomsTable extends Rooms with TableInfo<$RoomsTable, Room> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoomsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ownerIdMeta = const VerificationMeta(
    'ownerId',
  );
  @override
  late final GeneratedColumn<String> ownerId = GeneratedColumn<String>(
    'owner_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _propertyIdMeta = const VerificationMeta(
    'propertyId',
  );
  @override
  late final GeneratedColumn<String> propertyId = GeneratedColumn<String>(
    'property_id',
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
  @override
  late final GeneratedColumnWithTypeConverter<RoomStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<RoomStatus>($RoomsTable.$converterstatus);
  static const VerificationMeta _rentPriceMeta = const VerificationMeta(
    'rentPrice',
  );
  @override
  late final GeneratedColumn<double> rentPrice = GeneratedColumn<double>(
    'rent_price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tenantIdMeta = const VerificationMeta(
    'tenantId',
  );
  @override
  late final GeneratedColumn<String> tenantId = GeneratedColumn<String>(
    'tenant_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ownerId,
    propertyId,
    name,
    status,
    rentPrice,
    tenantId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'rooms';
  @override
  VerificationContext validateIntegrity(
    Insertable<Room> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('owner_id')) {
      context.handle(
        _ownerIdMeta,
        ownerId.isAcceptableOrUnknown(data['owner_id']!, _ownerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_ownerIdMeta);
    }
    if (data.containsKey('property_id')) {
      context.handle(
        _propertyIdMeta,
        propertyId.isAcceptableOrUnknown(data['property_id']!, _propertyIdMeta),
      );
    } else if (isInserting) {
      context.missing(_propertyIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('rent_price')) {
      context.handle(
        _rentPriceMeta,
        rentPrice.isAcceptableOrUnknown(data['rent_price']!, _rentPriceMeta),
      );
    } else if (isInserting) {
      context.missing(_rentPriceMeta);
    }
    if (data.containsKey('tenant_id')) {
      context.handle(
        _tenantIdMeta,
        tenantId.isAcceptableOrUnknown(data['tenant_id']!, _tenantIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Room map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Room(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      ownerId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}owner_id'],
          )!,
      propertyId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}property_id'],
          )!,
      name:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}name'],
          )!,
      status: $RoomsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      rentPrice:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}rent_price'],
          )!,
      tenantId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tenant_id'],
      ),
    );
  }

  @override
  $RoomsTable createAlias(String alias) {
    return $RoomsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<RoomStatus, String, String> $converterstatus =
      const EnumNameConverter<RoomStatus>(RoomStatus.values);
}

class RoomsCompanion extends UpdateCompanion<Room> {
  final Value<String> id;
  final Value<String> ownerId;
  final Value<String> propertyId;
  final Value<String> name;
  final Value<RoomStatus> status;
  final Value<double> rentPrice;
  final Value<String?> tenantId;
  final Value<int> rowid;
  const RoomsCompanion({
    this.id = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.propertyId = const Value.absent(),
    this.name = const Value.absent(),
    this.status = const Value.absent(),
    this.rentPrice = const Value.absent(),
    this.tenantId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RoomsCompanion.insert({
    required String id,
    required String ownerId,
    required String propertyId,
    required String name,
    required RoomStatus status,
    required double rentPrice,
    this.tenantId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       ownerId = Value(ownerId),
       propertyId = Value(propertyId),
       name = Value(name),
       status = Value(status),
       rentPrice = Value(rentPrice);
  static Insertable<Room> custom({
    Expression<String>? id,
    Expression<String>? ownerId,
    Expression<String>? propertyId,
    Expression<String>? name,
    Expression<String>? status,
    Expression<double>? rentPrice,
    Expression<String>? tenantId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ownerId != null) 'owner_id': ownerId,
      if (propertyId != null) 'property_id': propertyId,
      if (name != null) 'name': name,
      if (status != null) 'status': status,
      if (rentPrice != null) 'rent_price': rentPrice,
      if (tenantId != null) 'tenant_id': tenantId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RoomsCompanion copyWith({
    Value<String>? id,
    Value<String>? ownerId,
    Value<String>? propertyId,
    Value<String>? name,
    Value<RoomStatus>? status,
    Value<double>? rentPrice,
    Value<String?>? tenantId,
    Value<int>? rowid,
  }) {
    return RoomsCompanion(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      propertyId: propertyId ?? this.propertyId,
      name: name ?? this.name,
      status: status ?? this.status,
      rentPrice: rentPrice ?? this.rentPrice,
      tenantId: tenantId ?? this.tenantId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (ownerId.present) {
      map['owner_id'] = Variable<String>(ownerId.value);
    }
    if (propertyId.present) {
      map['property_id'] = Variable<String>(propertyId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $RoomsTable.$converterstatus.toSql(status.value),
      );
    }
    if (rentPrice.present) {
      map['rent_price'] = Variable<double>(rentPrice.value);
    }
    if (tenantId.present) {
      map['tenant_id'] = Variable<String>(tenantId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoomsCompanion(')
          ..write('id: $id, ')
          ..write('ownerId: $ownerId, ')
          ..write('propertyId: $propertyId, ')
          ..write('name: $name, ')
          ..write('status: $status, ')
          ..write('rentPrice: $rentPrice, ')
          ..write('tenantId: $tenantId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TenantsTable extends Tenants with TableInfo<$TenantsTable, Tenant> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TenantsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ownerIdMeta = const VerificationMeta(
    'ownerId',
  );
  @override
  late final GeneratedColumn<String> ownerId = GeneratedColumn<String>(
    'owner_id',
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
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cccdMeta = const VerificationMeta('cccd');
  @override
  late final GeneratedColumn<String> cccd = GeneratedColumn<String>(
    'cccd',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateOfBirthMeta = const VerificationMeta(
    'dateOfBirth',
  );
  @override
  late final GeneratedColumn<String> dateOfBirth = GeneratedColumn<String>(
    'date_of_birth',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hometownMeta = const VerificationMeta(
    'hometown',
  );
  @override
  late final GeneratedColumn<String> hometown = GeneratedColumn<String>(
    'hometown',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _roomIdMeta = const VerificationMeta('roomId');
  @override
  late final GeneratedColumn<String> roomId = GeneratedColumn<String>(
    'room_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _propertyIdMeta = const VerificationMeta(
    'propertyId',
  );
  @override
  late final GeneratedColumn<String> propertyId = GeneratedColumn<String>(
    'property_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<String> startDate = GeneratedColumn<String>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _depositMeta = const VerificationMeta(
    'deposit',
  );
  @override
  late final GeneratedColumn<double> deposit = GeneratedColumn<double>(
    'deposit',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isVerifiedMeta = const VerificationMeta(
    'isVerified',
  );
  @override
  late final GeneratedColumn<bool> isVerified = GeneratedColumn<bool>(
    'is_verified',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_verified" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ownerId,
    name,
    phone,
    cccd,
    dateOfBirth,
    hometown,
    roomId,
    propertyId,
    startDate,
    deposit,
    isVerified,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tenants';
  @override
  VerificationContext validateIntegrity(
    Insertable<Tenant> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('owner_id')) {
      context.handle(
        _ownerIdMeta,
        ownerId.isAcceptableOrUnknown(data['owner_id']!, _ownerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_ownerIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    } else if (isInserting) {
      context.missing(_phoneMeta);
    }
    if (data.containsKey('cccd')) {
      context.handle(
        _cccdMeta,
        cccd.isAcceptableOrUnknown(data['cccd']!, _cccdMeta),
      );
    } else if (isInserting) {
      context.missing(_cccdMeta);
    }
    if (data.containsKey('date_of_birth')) {
      context.handle(
        _dateOfBirthMeta,
        dateOfBirth.isAcceptableOrUnknown(
          data['date_of_birth']!,
          _dateOfBirthMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dateOfBirthMeta);
    }
    if (data.containsKey('hometown')) {
      context.handle(
        _hometownMeta,
        hometown.isAcceptableOrUnknown(data['hometown']!, _hometownMeta),
      );
    } else if (isInserting) {
      context.missing(_hometownMeta);
    }
    if (data.containsKey('room_id')) {
      context.handle(
        _roomIdMeta,
        roomId.isAcceptableOrUnknown(data['room_id']!, _roomIdMeta),
      );
    } else if (isInserting) {
      context.missing(_roomIdMeta);
    }
    if (data.containsKey('property_id')) {
      context.handle(
        _propertyIdMeta,
        propertyId.isAcceptableOrUnknown(data['property_id']!, _propertyIdMeta),
      );
    } else if (isInserting) {
      context.missing(_propertyIdMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('deposit')) {
      context.handle(
        _depositMeta,
        deposit.isAcceptableOrUnknown(data['deposit']!, _depositMeta),
      );
    } else if (isInserting) {
      context.missing(_depositMeta);
    }
    if (data.containsKey('is_verified')) {
      context.handle(
        _isVerifiedMeta,
        isVerified.isAcceptableOrUnknown(data['is_verified']!, _isVerifiedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Tenant map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Tenant(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      ownerId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}owner_id'],
          )!,
      name:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}name'],
          )!,
      phone:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}phone'],
          )!,
      cccd:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}cccd'],
          )!,
      dateOfBirth:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}date_of_birth'],
          )!,
      hometown:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}hometown'],
          )!,
      roomId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}room_id'],
          )!,
      propertyId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}property_id'],
          )!,
      startDate:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}start_date'],
          )!,
      deposit:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}deposit'],
          )!,
      isVerified:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_verified'],
          )!,
    );
  }

  @override
  $TenantsTable createAlias(String alias) {
    return $TenantsTable(attachedDatabase, alias);
  }
}

class TenantsCompanion extends UpdateCompanion<Tenant> {
  final Value<String> id;
  final Value<String> ownerId;
  final Value<String> name;
  final Value<String> phone;
  final Value<String> cccd;
  final Value<String> dateOfBirth;
  final Value<String> hometown;
  final Value<String> roomId;
  final Value<String> propertyId;
  final Value<String> startDate;
  final Value<double> deposit;
  final Value<bool> isVerified;
  final Value<int> rowid;
  const TenantsCompanion({
    this.id = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.cccd = const Value.absent(),
    this.dateOfBirth = const Value.absent(),
    this.hometown = const Value.absent(),
    this.roomId = const Value.absent(),
    this.propertyId = const Value.absent(),
    this.startDate = const Value.absent(),
    this.deposit = const Value.absent(),
    this.isVerified = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TenantsCompanion.insert({
    required String id,
    required String ownerId,
    required String name,
    required String phone,
    required String cccd,
    required String dateOfBirth,
    required String hometown,
    required String roomId,
    required String propertyId,
    required String startDate,
    required double deposit,
    this.isVerified = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       ownerId = Value(ownerId),
       name = Value(name),
       phone = Value(phone),
       cccd = Value(cccd),
       dateOfBirth = Value(dateOfBirth),
       hometown = Value(hometown),
       roomId = Value(roomId),
       propertyId = Value(propertyId),
       startDate = Value(startDate),
       deposit = Value(deposit);
  static Insertable<Tenant> custom({
    Expression<String>? id,
    Expression<String>? ownerId,
    Expression<String>? name,
    Expression<String>? phone,
    Expression<String>? cccd,
    Expression<String>? dateOfBirth,
    Expression<String>? hometown,
    Expression<String>? roomId,
    Expression<String>? propertyId,
    Expression<String>? startDate,
    Expression<double>? deposit,
    Expression<bool>? isVerified,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ownerId != null) 'owner_id': ownerId,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (cccd != null) 'cccd': cccd,
      if (dateOfBirth != null) 'date_of_birth': dateOfBirth,
      if (hometown != null) 'hometown': hometown,
      if (roomId != null) 'room_id': roomId,
      if (propertyId != null) 'property_id': propertyId,
      if (startDate != null) 'start_date': startDate,
      if (deposit != null) 'deposit': deposit,
      if (isVerified != null) 'is_verified': isVerified,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TenantsCompanion copyWith({
    Value<String>? id,
    Value<String>? ownerId,
    Value<String>? name,
    Value<String>? phone,
    Value<String>? cccd,
    Value<String>? dateOfBirth,
    Value<String>? hometown,
    Value<String>? roomId,
    Value<String>? propertyId,
    Value<String>? startDate,
    Value<double>? deposit,
    Value<bool>? isVerified,
    Value<int>? rowid,
  }) {
    return TenantsCompanion(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      cccd: cccd ?? this.cccd,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      hometown: hometown ?? this.hometown,
      roomId: roomId ?? this.roomId,
      propertyId: propertyId ?? this.propertyId,
      startDate: startDate ?? this.startDate,
      deposit: deposit ?? this.deposit,
      isVerified: isVerified ?? this.isVerified,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (ownerId.present) {
      map['owner_id'] = Variable<String>(ownerId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (cccd.present) {
      map['cccd'] = Variable<String>(cccd.value);
    }
    if (dateOfBirth.present) {
      map['date_of_birth'] = Variable<String>(dateOfBirth.value);
    }
    if (hometown.present) {
      map['hometown'] = Variable<String>(hometown.value);
    }
    if (roomId.present) {
      map['room_id'] = Variable<String>(roomId.value);
    }
    if (propertyId.present) {
      map['property_id'] = Variable<String>(propertyId.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<String>(startDate.value);
    }
    if (deposit.present) {
      map['deposit'] = Variable<double>(deposit.value);
    }
    if (isVerified.present) {
      map['is_verified'] = Variable<bool>(isVerified.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TenantsCompanion(')
          ..write('id: $id, ')
          ..write('ownerId: $ownerId, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('cccd: $cccd, ')
          ..write('dateOfBirth: $dateOfBirth, ')
          ..write('hometown: $hometown, ')
          ..write('roomId: $roomId, ')
          ..write('propertyId: $propertyId, ')
          ..write('startDate: $startDate, ')
          ..write('deposit: $deposit, ')
          ..write('isVerified: $isVerified, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MeterReadingsTable extends MeterReadings
    with TableInfo<$MeterReadingsTable, MeterReading> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MeterReadingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ownerIdMeta = const VerificationMeta(
    'ownerId',
  );
  @override
  late final GeneratedColumn<String> ownerId = GeneratedColumn<String>(
    'owner_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _roomIdMeta = const VerificationMeta('roomId');
  @override
  late final GeneratedColumn<String> roomId = GeneratedColumn<String>(
    'room_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _monthMeta = const VerificationMeta('month');
  @override
  late final GeneratedColumn<String> month = GeneratedColumn<String>(
    'month',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _electricOldMeta = const VerificationMeta(
    'electricOld',
  );
  @override
  late final GeneratedColumn<int> electricOld = GeneratedColumn<int>(
    'electric_old',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _electricNewMeta = const VerificationMeta(
    'electricNew',
  );
  @override
  late final GeneratedColumn<int> electricNew = GeneratedColumn<int>(
    'electric_new',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _waterOldMeta = const VerificationMeta(
    'waterOld',
  );
  @override
  late final GeneratedColumn<int> waterOld = GeneratedColumn<int>(
    'water_old',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _waterNewMeta = const VerificationMeta(
    'waterNew',
  );
  @override
  late final GeneratedColumn<int> waterNew = GeneratedColumn<int>(
    'water_new',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isRecordedMeta = const VerificationMeta(
    'isRecorded',
  );
  @override
  late final GeneratedColumn<bool> isRecorded = GeneratedColumn<bool>(
    'is_recorded',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_recorded" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ownerId,
    roomId,
    month,
    electricOld,
    electricNew,
    waterOld,
    waterNew,
    isRecorded,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'meter_readings';
  @override
  VerificationContext validateIntegrity(
    Insertable<MeterReading> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('owner_id')) {
      context.handle(
        _ownerIdMeta,
        ownerId.isAcceptableOrUnknown(data['owner_id']!, _ownerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_ownerIdMeta);
    }
    if (data.containsKey('room_id')) {
      context.handle(
        _roomIdMeta,
        roomId.isAcceptableOrUnknown(data['room_id']!, _roomIdMeta),
      );
    } else if (isInserting) {
      context.missing(_roomIdMeta);
    }
    if (data.containsKey('month')) {
      context.handle(
        _monthMeta,
        month.isAcceptableOrUnknown(data['month']!, _monthMeta),
      );
    } else if (isInserting) {
      context.missing(_monthMeta);
    }
    if (data.containsKey('electric_old')) {
      context.handle(
        _electricOldMeta,
        electricOld.isAcceptableOrUnknown(
          data['electric_old']!,
          _electricOldMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_electricOldMeta);
    }
    if (data.containsKey('electric_new')) {
      context.handle(
        _electricNewMeta,
        electricNew.isAcceptableOrUnknown(
          data['electric_new']!,
          _electricNewMeta,
        ),
      );
    }
    if (data.containsKey('water_old')) {
      context.handle(
        _waterOldMeta,
        waterOld.isAcceptableOrUnknown(data['water_old']!, _waterOldMeta),
      );
    } else if (isInserting) {
      context.missing(_waterOldMeta);
    }
    if (data.containsKey('water_new')) {
      context.handle(
        _waterNewMeta,
        waterNew.isAcceptableOrUnknown(data['water_new']!, _waterNewMeta),
      );
    }
    if (data.containsKey('is_recorded')) {
      context.handle(
        _isRecordedMeta,
        isRecorded.isAcceptableOrUnknown(data['is_recorded']!, _isRecordedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MeterReading map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MeterReading(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      ownerId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}owner_id'],
          )!,
      roomId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}room_id'],
          )!,
      month:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}month'],
          )!,
      electricOld:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}electric_old'],
          )!,
      electricNew: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}electric_new'],
      ),
      waterOld:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}water_old'],
          )!,
      waterNew: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}water_new'],
      ),
      isRecorded:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_recorded'],
          )!,
    );
  }

  @override
  $MeterReadingsTable createAlias(String alias) {
    return $MeterReadingsTable(attachedDatabase, alias);
  }
}

class MeterReadingsCompanion extends UpdateCompanion<MeterReading> {
  final Value<String> id;
  final Value<String> ownerId;
  final Value<String> roomId;
  final Value<String> month;
  final Value<int> electricOld;
  final Value<int?> electricNew;
  final Value<int> waterOld;
  final Value<int?> waterNew;
  final Value<bool> isRecorded;
  final Value<int> rowid;
  const MeterReadingsCompanion({
    this.id = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.roomId = const Value.absent(),
    this.month = const Value.absent(),
    this.electricOld = const Value.absent(),
    this.electricNew = const Value.absent(),
    this.waterOld = const Value.absent(),
    this.waterNew = const Value.absent(),
    this.isRecorded = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MeterReadingsCompanion.insert({
    required String id,
    required String ownerId,
    required String roomId,
    required String month,
    required int electricOld,
    this.electricNew = const Value.absent(),
    required int waterOld,
    this.waterNew = const Value.absent(),
    this.isRecorded = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       ownerId = Value(ownerId),
       roomId = Value(roomId),
       month = Value(month),
       electricOld = Value(electricOld),
       waterOld = Value(waterOld);
  static Insertable<MeterReading> custom({
    Expression<String>? id,
    Expression<String>? ownerId,
    Expression<String>? roomId,
    Expression<String>? month,
    Expression<int>? electricOld,
    Expression<int>? electricNew,
    Expression<int>? waterOld,
    Expression<int>? waterNew,
    Expression<bool>? isRecorded,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ownerId != null) 'owner_id': ownerId,
      if (roomId != null) 'room_id': roomId,
      if (month != null) 'month': month,
      if (electricOld != null) 'electric_old': electricOld,
      if (electricNew != null) 'electric_new': electricNew,
      if (waterOld != null) 'water_old': waterOld,
      if (waterNew != null) 'water_new': waterNew,
      if (isRecorded != null) 'is_recorded': isRecorded,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MeterReadingsCompanion copyWith({
    Value<String>? id,
    Value<String>? ownerId,
    Value<String>? roomId,
    Value<String>? month,
    Value<int>? electricOld,
    Value<int?>? electricNew,
    Value<int>? waterOld,
    Value<int?>? waterNew,
    Value<bool>? isRecorded,
    Value<int>? rowid,
  }) {
    return MeterReadingsCompanion(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      roomId: roomId ?? this.roomId,
      month: month ?? this.month,
      electricOld: electricOld ?? this.electricOld,
      electricNew: electricNew ?? this.electricNew,
      waterOld: waterOld ?? this.waterOld,
      waterNew: waterNew ?? this.waterNew,
      isRecorded: isRecorded ?? this.isRecorded,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (ownerId.present) {
      map['owner_id'] = Variable<String>(ownerId.value);
    }
    if (roomId.present) {
      map['room_id'] = Variable<String>(roomId.value);
    }
    if (month.present) {
      map['month'] = Variable<String>(month.value);
    }
    if (electricOld.present) {
      map['electric_old'] = Variable<int>(electricOld.value);
    }
    if (electricNew.present) {
      map['electric_new'] = Variable<int>(electricNew.value);
    }
    if (waterOld.present) {
      map['water_old'] = Variable<int>(waterOld.value);
    }
    if (waterNew.present) {
      map['water_new'] = Variable<int>(waterNew.value);
    }
    if (isRecorded.present) {
      map['is_recorded'] = Variable<bool>(isRecorded.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MeterReadingsCompanion(')
          ..write('id: $id, ')
          ..write('ownerId: $ownerId, ')
          ..write('roomId: $roomId, ')
          ..write('month: $month, ')
          ..write('electricOld: $electricOld, ')
          ..write('electricNew: $electricNew, ')
          ..write('waterOld: $waterOld, ')
          ..write('waterNew: $waterNew, ')
          ..write('isRecorded: $isRecorded, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $InvoicesTable extends Invoices with TableInfo<$InvoicesTable, Invoice> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InvoicesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ownerIdMeta = const VerificationMeta(
    'ownerId',
  );
  @override
  late final GeneratedColumn<String> ownerId = GeneratedColumn<String>(
    'owner_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _roomIdMeta = const VerificationMeta('roomId');
  @override
  late final GeneratedColumn<String> roomId = GeneratedColumn<String>(
    'room_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _monthMeta = const VerificationMeta('month');
  @override
  late final GeneratedColumn<String> month = GeneratedColumn<String>(
    'month',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalAmountMeta = const VerificationMeta(
    'totalAmount',
  );
  @override
  late final GeneratedColumn<double> totalAmount = GeneratedColumn<double>(
    'total_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<InvoiceStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<InvoiceStatus>($InvoicesTable.$converterstatus);
  static const VerificationMeta _dueDateMeta = const VerificationMeta(
    'dueDate',
  );
  @override
  late final GeneratedColumn<String> dueDate = GeneratedColumn<String>(
    'due_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _paidDateMeta = const VerificationMeta(
    'paidDate',
  );
  @override
  late final GeneratedColumn<String> paidDate = GeneratedColumn<String>(
    'paid_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ownerId,
    roomId,
    month,
    totalAmount,
    status,
    dueDate,
    paidDate,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'invoices';
  @override
  VerificationContext validateIntegrity(
    Insertable<Invoice> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('owner_id')) {
      context.handle(
        _ownerIdMeta,
        ownerId.isAcceptableOrUnknown(data['owner_id']!, _ownerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_ownerIdMeta);
    }
    if (data.containsKey('room_id')) {
      context.handle(
        _roomIdMeta,
        roomId.isAcceptableOrUnknown(data['room_id']!, _roomIdMeta),
      );
    } else if (isInserting) {
      context.missing(_roomIdMeta);
    }
    if (data.containsKey('month')) {
      context.handle(
        _monthMeta,
        month.isAcceptableOrUnknown(data['month']!, _monthMeta),
      );
    } else if (isInserting) {
      context.missing(_monthMeta);
    }
    if (data.containsKey('total_amount')) {
      context.handle(
        _totalAmountMeta,
        totalAmount.isAcceptableOrUnknown(
          data['total_amount']!,
          _totalAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalAmountMeta);
    }
    if (data.containsKey('due_date')) {
      context.handle(
        _dueDateMeta,
        dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta),
      );
    }
    if (data.containsKey('paid_date')) {
      context.handle(
        _paidDateMeta,
        paidDate.isAcceptableOrUnknown(data['paid_date']!, _paidDateMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Invoice map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Invoice(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      ownerId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}owner_id'],
          )!,
      roomId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}room_id'],
          )!,
      month:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}month'],
          )!,
      totalAmount:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}total_amount'],
          )!,
      status: $InvoicesTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      dueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}due_date'],
      ),
      paidDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}paid_date'],
      ),
    );
  }

  @override
  $InvoicesTable createAlias(String alias) {
    return $InvoicesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<InvoiceStatus, String, String> $converterstatus =
      const EnumNameConverter<InvoiceStatus>(InvoiceStatus.values);
}

class InvoicesCompanion extends UpdateCompanion<Invoice> {
  final Value<String> id;
  final Value<String> ownerId;
  final Value<String> roomId;
  final Value<String> month;
  final Value<double> totalAmount;
  final Value<InvoiceStatus> status;
  final Value<String?> dueDate;
  final Value<String?> paidDate;
  final Value<int> rowid;
  const InvoicesCompanion({
    this.id = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.roomId = const Value.absent(),
    this.month = const Value.absent(),
    this.totalAmount = const Value.absent(),
    this.status = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.paidDate = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InvoicesCompanion.insert({
    required String id,
    required String ownerId,
    required String roomId,
    required String month,
    required double totalAmount,
    required InvoiceStatus status,
    this.dueDate = const Value.absent(),
    this.paidDate = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       ownerId = Value(ownerId),
       roomId = Value(roomId),
       month = Value(month),
       totalAmount = Value(totalAmount),
       status = Value(status);
  static Insertable<Invoice> custom({
    Expression<String>? id,
    Expression<String>? ownerId,
    Expression<String>? roomId,
    Expression<String>? month,
    Expression<double>? totalAmount,
    Expression<String>? status,
    Expression<String>? dueDate,
    Expression<String>? paidDate,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ownerId != null) 'owner_id': ownerId,
      if (roomId != null) 'room_id': roomId,
      if (month != null) 'month': month,
      if (totalAmount != null) 'total_amount': totalAmount,
      if (status != null) 'status': status,
      if (dueDate != null) 'due_date': dueDate,
      if (paidDate != null) 'paid_date': paidDate,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InvoicesCompanion copyWith({
    Value<String>? id,
    Value<String>? ownerId,
    Value<String>? roomId,
    Value<String>? month,
    Value<double>? totalAmount,
    Value<InvoiceStatus>? status,
    Value<String?>? dueDate,
    Value<String?>? paidDate,
    Value<int>? rowid,
  }) {
    return InvoicesCompanion(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      roomId: roomId ?? this.roomId,
      month: month ?? this.month,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
      dueDate: dueDate ?? this.dueDate,
      paidDate: paidDate ?? this.paidDate,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (ownerId.present) {
      map['owner_id'] = Variable<String>(ownerId.value);
    }
    if (roomId.present) {
      map['room_id'] = Variable<String>(roomId.value);
    }
    if (month.present) {
      map['month'] = Variable<String>(month.value);
    }
    if (totalAmount.present) {
      map['total_amount'] = Variable<double>(totalAmount.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $InvoicesTable.$converterstatus.toSql(status.value),
      );
    }
    if (dueDate.present) {
      map['due_date'] = Variable<String>(dueDate.value);
    }
    if (paidDate.present) {
      map['paid_date'] = Variable<String>(paidDate.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InvoicesCompanion(')
          ..write('id: $id, ')
          ..write('ownerId: $ownerId, ')
          ..write('roomId: $roomId, ')
          ..write('month: $month, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('status: $status, ')
          ..write('dueDate: $dueDate, ')
          ..write('paidDate: $paidDate, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UsersTable users = $UsersTable(this);
  late final $PropertiesTable properties = $PropertiesTable(this);
  late final $ServicesTable services = $ServicesTable(this);
  late final $RoomsTable rooms = $RoomsTable(this);
  late final $TenantsTable tenants = $TenantsTable(this);
  late final $MeterReadingsTable meterReadings = $MeterReadingsTable(this);
  late final $InvoicesTable invoices = $InvoicesTable(this);
  late final AppDao appDao = AppDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    users,
    properties,
    services,
    rooms,
    tenants,
    meterReadings,
    invoices,
  ];
}

typedef $$UsersTableCreateCompanionBuilder =
    UsersCompanion Function({
      required String id,
      required String email,
      required String name,
      Value<String?> phone,
      Value<String?> avatarUrl,
      Value<int> rowid,
    });
typedef $$UsersTableUpdateCompanionBuilder =
    UsersCompanion Function({
      Value<String> id,
      Value<String> email,
      Value<String> name,
      Value<String?> phone,
      Value<String?> avatarUrl,
      Value<int> rowid,
    });

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get avatarUrl => $composableBuilder(
    column: $table.avatarUrl,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get avatarUrl => $composableBuilder(
    column: $table.avatarUrl,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get avatarUrl =>
      $composableBuilder(column: $table.avatarUrl, builder: (column) => column);
}

class $$UsersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UsersTable,
          User,
          $$UsersTableFilterComposer,
          $$UsersTableOrderingComposer,
          $$UsersTableAnnotationComposer,
          $$UsersTableCreateCompanionBuilder,
          $$UsersTableUpdateCompanionBuilder,
          (User, BaseReferences<_$AppDatabase, $UsersTable, User>),
          User,
          PrefetchHooks Function()
        > {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> avatarUrl = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersCompanion(
                id: id,
                email: email,
                name: name,
                phone: phone,
                avatarUrl: avatarUrl,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String email,
                required String name,
                Value<String?> phone = const Value.absent(),
                Value<String?> avatarUrl = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersCompanion.insert(
                id: id,
                email: email,
                name: name,
                phone: phone,
                avatarUrl: avatarUrl,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UsersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UsersTable,
      User,
      $$UsersTableFilterComposer,
      $$UsersTableOrderingComposer,
      $$UsersTableAnnotationComposer,
      $$UsersTableCreateCompanionBuilder,
      $$UsersTableUpdateCompanionBuilder,
      (User, BaseReferences<_$AppDatabase, $UsersTable, User>),
      User,
      PrefetchHooks Function()
    >;
typedef $$PropertiesTableCreateCompanionBuilder =
    PropertiesCompanion Function({
      required String id,
      required String ownerId,
      required String name,
      required String address,
      required int totalRooms,
      required double electricityPrice,
      required double waterPrice,
      required BillingType waterBillingType,
      Value<String> status,
      Value<int> rowid,
    });
typedef $$PropertiesTableUpdateCompanionBuilder =
    PropertiesCompanion Function({
      Value<String> id,
      Value<String> ownerId,
      Value<String> name,
      Value<String> address,
      Value<int> totalRooms,
      Value<double> electricityPrice,
      Value<double> waterPrice,
      Value<BillingType> waterBillingType,
      Value<String> status,
      Value<int> rowid,
    });

class $$PropertiesTableFilterComposer
    extends Composer<_$AppDatabase, $PropertiesTable> {
  $$PropertiesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ownerId => $composableBuilder(
    column: $table.ownerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalRooms => $composableBuilder(
    column: $table.totalRooms,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get electricityPrice => $composableBuilder(
    column: $table.electricityPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get waterPrice => $composableBuilder(
    column: $table.waterPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<BillingType, BillingType, String>
  get waterBillingType => $composableBuilder(
    column: $table.waterBillingType,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PropertiesTableOrderingComposer
    extends Composer<_$AppDatabase, $PropertiesTable> {
  $$PropertiesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ownerId => $composableBuilder(
    column: $table.ownerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalRooms => $composableBuilder(
    column: $table.totalRooms,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get electricityPrice => $composableBuilder(
    column: $table.electricityPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get waterPrice => $composableBuilder(
    column: $table.waterPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get waterBillingType => $composableBuilder(
    column: $table.waterBillingType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PropertiesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PropertiesTable> {
  $$PropertiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get ownerId =>
      $composableBuilder(column: $table.ownerId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<int> get totalRooms => $composableBuilder(
    column: $table.totalRooms,
    builder: (column) => column,
  );

  GeneratedColumn<double> get electricityPrice => $composableBuilder(
    column: $table.electricityPrice,
    builder: (column) => column,
  );

  GeneratedColumn<double> get waterPrice => $composableBuilder(
    column: $table.waterPrice,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<BillingType, String> get waterBillingType =>
      $composableBuilder(
        column: $table.waterBillingType,
        builder: (column) => column,
      );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);
}

class $$PropertiesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PropertiesTable,
          Property,
          $$PropertiesTableFilterComposer,
          $$PropertiesTableOrderingComposer,
          $$PropertiesTableAnnotationComposer,
          $$PropertiesTableCreateCompanionBuilder,
          $$PropertiesTableUpdateCompanionBuilder,
          (Property, BaseReferences<_$AppDatabase, $PropertiesTable, Property>),
          Property,
          PrefetchHooks Function()
        > {
  $$PropertiesTableTableManager(_$AppDatabase db, $PropertiesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$PropertiesTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$PropertiesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$PropertiesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> ownerId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> address = const Value.absent(),
                Value<int> totalRooms = const Value.absent(),
                Value<double> electricityPrice = const Value.absent(),
                Value<double> waterPrice = const Value.absent(),
                Value<BillingType> waterBillingType = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PropertiesCompanion(
                id: id,
                ownerId: ownerId,
                name: name,
                address: address,
                totalRooms: totalRooms,
                electricityPrice: electricityPrice,
                waterPrice: waterPrice,
                waterBillingType: waterBillingType,
                status: status,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String ownerId,
                required String name,
                required String address,
                required int totalRooms,
                required double electricityPrice,
                required double waterPrice,
                required BillingType waterBillingType,
                Value<String> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PropertiesCompanion.insert(
                id: id,
                ownerId: ownerId,
                name: name,
                address: address,
                totalRooms: totalRooms,
                electricityPrice: electricityPrice,
                waterPrice: waterPrice,
                waterBillingType: waterBillingType,
                status: status,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PropertiesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PropertiesTable,
      Property,
      $$PropertiesTableFilterComposer,
      $$PropertiesTableOrderingComposer,
      $$PropertiesTableAnnotationComposer,
      $$PropertiesTableCreateCompanionBuilder,
      $$PropertiesTableUpdateCompanionBuilder,
      (Property, BaseReferences<_$AppDatabase, $PropertiesTable, Property>),
      Property,
      PrefetchHooks Function()
    >;
typedef $$ServicesTableCreateCompanionBuilder =
    ServicesCompanion Function({
      required String id,
      required String propertyId,
      required String name,
      required BillingType type,
      required double price,
      Value<int> rowid,
    });
typedef $$ServicesTableUpdateCompanionBuilder =
    ServicesCompanion Function({
      Value<String> id,
      Value<String> propertyId,
      Value<String> name,
      Value<BillingType> type,
      Value<double> price,
      Value<int> rowid,
    });

class $$ServicesTableFilterComposer
    extends Composer<_$AppDatabase, $ServicesTable> {
  $$ServicesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get propertyId => $composableBuilder(
    column: $table.propertyId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<BillingType, BillingType, String> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ServicesTableOrderingComposer
    extends Composer<_$AppDatabase, $ServicesTable> {
  $$ServicesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get propertyId => $composableBuilder(
    column: $table.propertyId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ServicesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ServicesTable> {
  $$ServicesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get propertyId => $composableBuilder(
    column: $table.propertyId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<BillingType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);
}

class $$ServicesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ServicesTable,
          Service,
          $$ServicesTableFilterComposer,
          $$ServicesTableOrderingComposer,
          $$ServicesTableAnnotationComposer,
          $$ServicesTableCreateCompanionBuilder,
          $$ServicesTableUpdateCompanionBuilder,
          (Service, BaseReferences<_$AppDatabase, $ServicesTable, Service>),
          Service,
          PrefetchHooks Function()
        > {
  $$ServicesTableTableManager(_$AppDatabase db, $ServicesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$ServicesTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$ServicesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$ServicesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> propertyId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<BillingType> type = const Value.absent(),
                Value<double> price = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ServicesCompanion(
                id: id,
                propertyId: propertyId,
                name: name,
                type: type,
                price: price,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String propertyId,
                required String name,
                required BillingType type,
                required double price,
                Value<int> rowid = const Value.absent(),
              }) => ServicesCompanion.insert(
                id: id,
                propertyId: propertyId,
                name: name,
                type: type,
                price: price,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ServicesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ServicesTable,
      Service,
      $$ServicesTableFilterComposer,
      $$ServicesTableOrderingComposer,
      $$ServicesTableAnnotationComposer,
      $$ServicesTableCreateCompanionBuilder,
      $$ServicesTableUpdateCompanionBuilder,
      (Service, BaseReferences<_$AppDatabase, $ServicesTable, Service>),
      Service,
      PrefetchHooks Function()
    >;
typedef $$RoomsTableCreateCompanionBuilder =
    RoomsCompanion Function({
      required String id,
      required String ownerId,
      required String propertyId,
      required String name,
      required RoomStatus status,
      required double rentPrice,
      Value<String?> tenantId,
      Value<int> rowid,
    });
typedef $$RoomsTableUpdateCompanionBuilder =
    RoomsCompanion Function({
      Value<String> id,
      Value<String> ownerId,
      Value<String> propertyId,
      Value<String> name,
      Value<RoomStatus> status,
      Value<double> rentPrice,
      Value<String?> tenantId,
      Value<int> rowid,
    });

class $$RoomsTableFilterComposer extends Composer<_$AppDatabase, $RoomsTable> {
  $$RoomsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ownerId => $composableBuilder(
    column: $table.ownerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get propertyId => $composableBuilder(
    column: $table.propertyId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<RoomStatus, RoomStatus, String> get status =>
      $composableBuilder(
        column: $table.status,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<double> get rentPrice => $composableBuilder(
    column: $table.rentPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tenantId => $composableBuilder(
    column: $table.tenantId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RoomsTableOrderingComposer
    extends Composer<_$AppDatabase, $RoomsTable> {
  $$RoomsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ownerId => $composableBuilder(
    column: $table.ownerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get propertyId => $composableBuilder(
    column: $table.propertyId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rentPrice => $composableBuilder(
    column: $table.rentPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tenantId => $composableBuilder(
    column: $table.tenantId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RoomsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RoomsTable> {
  $$RoomsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get ownerId =>
      $composableBuilder(column: $table.ownerId, builder: (column) => column);

  GeneratedColumn<String> get propertyId => $composableBuilder(
    column: $table.propertyId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<RoomStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<double> get rentPrice =>
      $composableBuilder(column: $table.rentPrice, builder: (column) => column);

  GeneratedColumn<String> get tenantId =>
      $composableBuilder(column: $table.tenantId, builder: (column) => column);
}

class $$RoomsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RoomsTable,
          Room,
          $$RoomsTableFilterComposer,
          $$RoomsTableOrderingComposer,
          $$RoomsTableAnnotationComposer,
          $$RoomsTableCreateCompanionBuilder,
          $$RoomsTableUpdateCompanionBuilder,
          (Room, BaseReferences<_$AppDatabase, $RoomsTable, Room>),
          Room,
          PrefetchHooks Function()
        > {
  $$RoomsTableTableManager(_$AppDatabase db, $RoomsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$RoomsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$RoomsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$RoomsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> ownerId = const Value.absent(),
                Value<String> propertyId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<RoomStatus> status = const Value.absent(),
                Value<double> rentPrice = const Value.absent(),
                Value<String?> tenantId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RoomsCompanion(
                id: id,
                ownerId: ownerId,
                propertyId: propertyId,
                name: name,
                status: status,
                rentPrice: rentPrice,
                tenantId: tenantId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String ownerId,
                required String propertyId,
                required String name,
                required RoomStatus status,
                required double rentPrice,
                Value<String?> tenantId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RoomsCompanion.insert(
                id: id,
                ownerId: ownerId,
                propertyId: propertyId,
                name: name,
                status: status,
                rentPrice: rentPrice,
                tenantId: tenantId,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RoomsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RoomsTable,
      Room,
      $$RoomsTableFilterComposer,
      $$RoomsTableOrderingComposer,
      $$RoomsTableAnnotationComposer,
      $$RoomsTableCreateCompanionBuilder,
      $$RoomsTableUpdateCompanionBuilder,
      (Room, BaseReferences<_$AppDatabase, $RoomsTable, Room>),
      Room,
      PrefetchHooks Function()
    >;
typedef $$TenantsTableCreateCompanionBuilder =
    TenantsCompanion Function({
      required String id,
      required String ownerId,
      required String name,
      required String phone,
      required String cccd,
      required String dateOfBirth,
      required String hometown,
      required String roomId,
      required String propertyId,
      required String startDate,
      required double deposit,
      Value<bool> isVerified,
      Value<int> rowid,
    });
typedef $$TenantsTableUpdateCompanionBuilder =
    TenantsCompanion Function({
      Value<String> id,
      Value<String> ownerId,
      Value<String> name,
      Value<String> phone,
      Value<String> cccd,
      Value<String> dateOfBirth,
      Value<String> hometown,
      Value<String> roomId,
      Value<String> propertyId,
      Value<String> startDate,
      Value<double> deposit,
      Value<bool> isVerified,
      Value<int> rowid,
    });

class $$TenantsTableFilterComposer
    extends Composer<_$AppDatabase, $TenantsTable> {
  $$TenantsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ownerId => $composableBuilder(
    column: $table.ownerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cccd => $composableBuilder(
    column: $table.cccd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dateOfBirth => $composableBuilder(
    column: $table.dateOfBirth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hometown => $composableBuilder(
    column: $table.hometown,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get roomId => $composableBuilder(
    column: $table.roomId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get propertyId => $composableBuilder(
    column: $table.propertyId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get deposit => $composableBuilder(
    column: $table.deposit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isVerified => $composableBuilder(
    column: $table.isVerified,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TenantsTableOrderingComposer
    extends Composer<_$AppDatabase, $TenantsTable> {
  $$TenantsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ownerId => $composableBuilder(
    column: $table.ownerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cccd => $composableBuilder(
    column: $table.cccd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dateOfBirth => $composableBuilder(
    column: $table.dateOfBirth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hometown => $composableBuilder(
    column: $table.hometown,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get roomId => $composableBuilder(
    column: $table.roomId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get propertyId => $composableBuilder(
    column: $table.propertyId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get deposit => $composableBuilder(
    column: $table.deposit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isVerified => $composableBuilder(
    column: $table.isVerified,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TenantsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TenantsTable> {
  $$TenantsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get ownerId =>
      $composableBuilder(column: $table.ownerId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get cccd =>
      $composableBuilder(column: $table.cccd, builder: (column) => column);

  GeneratedColumn<String> get dateOfBirth => $composableBuilder(
    column: $table.dateOfBirth,
    builder: (column) => column,
  );

  GeneratedColumn<String> get hometown =>
      $composableBuilder(column: $table.hometown, builder: (column) => column);

  GeneratedColumn<String> get roomId =>
      $composableBuilder(column: $table.roomId, builder: (column) => column);

  GeneratedColumn<String> get propertyId => $composableBuilder(
    column: $table.propertyId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<double> get deposit =>
      $composableBuilder(column: $table.deposit, builder: (column) => column);

  GeneratedColumn<bool> get isVerified => $composableBuilder(
    column: $table.isVerified,
    builder: (column) => column,
  );
}

class $$TenantsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TenantsTable,
          Tenant,
          $$TenantsTableFilterComposer,
          $$TenantsTableOrderingComposer,
          $$TenantsTableAnnotationComposer,
          $$TenantsTableCreateCompanionBuilder,
          $$TenantsTableUpdateCompanionBuilder,
          (Tenant, BaseReferences<_$AppDatabase, $TenantsTable, Tenant>),
          Tenant,
          PrefetchHooks Function()
        > {
  $$TenantsTableTableManager(_$AppDatabase db, $TenantsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$TenantsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$TenantsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$TenantsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> ownerId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> phone = const Value.absent(),
                Value<String> cccd = const Value.absent(),
                Value<String> dateOfBirth = const Value.absent(),
                Value<String> hometown = const Value.absent(),
                Value<String> roomId = const Value.absent(),
                Value<String> propertyId = const Value.absent(),
                Value<String> startDate = const Value.absent(),
                Value<double> deposit = const Value.absent(),
                Value<bool> isVerified = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TenantsCompanion(
                id: id,
                ownerId: ownerId,
                name: name,
                phone: phone,
                cccd: cccd,
                dateOfBirth: dateOfBirth,
                hometown: hometown,
                roomId: roomId,
                propertyId: propertyId,
                startDate: startDate,
                deposit: deposit,
                isVerified: isVerified,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String ownerId,
                required String name,
                required String phone,
                required String cccd,
                required String dateOfBirth,
                required String hometown,
                required String roomId,
                required String propertyId,
                required String startDate,
                required double deposit,
                Value<bool> isVerified = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TenantsCompanion.insert(
                id: id,
                ownerId: ownerId,
                name: name,
                phone: phone,
                cccd: cccd,
                dateOfBirth: dateOfBirth,
                hometown: hometown,
                roomId: roomId,
                propertyId: propertyId,
                startDate: startDate,
                deposit: deposit,
                isVerified: isVerified,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TenantsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TenantsTable,
      Tenant,
      $$TenantsTableFilterComposer,
      $$TenantsTableOrderingComposer,
      $$TenantsTableAnnotationComposer,
      $$TenantsTableCreateCompanionBuilder,
      $$TenantsTableUpdateCompanionBuilder,
      (Tenant, BaseReferences<_$AppDatabase, $TenantsTable, Tenant>),
      Tenant,
      PrefetchHooks Function()
    >;
typedef $$MeterReadingsTableCreateCompanionBuilder =
    MeterReadingsCompanion Function({
      required String id,
      required String ownerId,
      required String roomId,
      required String month,
      required int electricOld,
      Value<int?> electricNew,
      required int waterOld,
      Value<int?> waterNew,
      Value<bool> isRecorded,
      Value<int> rowid,
    });
typedef $$MeterReadingsTableUpdateCompanionBuilder =
    MeterReadingsCompanion Function({
      Value<String> id,
      Value<String> ownerId,
      Value<String> roomId,
      Value<String> month,
      Value<int> electricOld,
      Value<int?> electricNew,
      Value<int> waterOld,
      Value<int?> waterNew,
      Value<bool> isRecorded,
      Value<int> rowid,
    });

class $$MeterReadingsTableFilterComposer
    extends Composer<_$AppDatabase, $MeterReadingsTable> {
  $$MeterReadingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ownerId => $composableBuilder(
    column: $table.ownerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get roomId => $composableBuilder(
    column: $table.roomId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get month => $composableBuilder(
    column: $table.month,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get electricOld => $composableBuilder(
    column: $table.electricOld,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get electricNew => $composableBuilder(
    column: $table.electricNew,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get waterOld => $composableBuilder(
    column: $table.waterOld,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get waterNew => $composableBuilder(
    column: $table.waterNew,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isRecorded => $composableBuilder(
    column: $table.isRecorded,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MeterReadingsTableOrderingComposer
    extends Composer<_$AppDatabase, $MeterReadingsTable> {
  $$MeterReadingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ownerId => $composableBuilder(
    column: $table.ownerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get roomId => $composableBuilder(
    column: $table.roomId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get month => $composableBuilder(
    column: $table.month,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get electricOld => $composableBuilder(
    column: $table.electricOld,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get electricNew => $composableBuilder(
    column: $table.electricNew,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get waterOld => $composableBuilder(
    column: $table.waterOld,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get waterNew => $composableBuilder(
    column: $table.waterNew,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isRecorded => $composableBuilder(
    column: $table.isRecorded,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MeterReadingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MeterReadingsTable> {
  $$MeterReadingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get ownerId =>
      $composableBuilder(column: $table.ownerId, builder: (column) => column);

  GeneratedColumn<String> get roomId =>
      $composableBuilder(column: $table.roomId, builder: (column) => column);

  GeneratedColumn<String> get month =>
      $composableBuilder(column: $table.month, builder: (column) => column);

  GeneratedColumn<int> get electricOld => $composableBuilder(
    column: $table.electricOld,
    builder: (column) => column,
  );

  GeneratedColumn<int> get electricNew => $composableBuilder(
    column: $table.electricNew,
    builder: (column) => column,
  );

  GeneratedColumn<int> get waterOld =>
      $composableBuilder(column: $table.waterOld, builder: (column) => column);

  GeneratedColumn<int> get waterNew =>
      $composableBuilder(column: $table.waterNew, builder: (column) => column);

  GeneratedColumn<bool> get isRecorded => $composableBuilder(
    column: $table.isRecorded,
    builder: (column) => column,
  );
}

class $$MeterReadingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MeterReadingsTable,
          MeterReading,
          $$MeterReadingsTableFilterComposer,
          $$MeterReadingsTableOrderingComposer,
          $$MeterReadingsTableAnnotationComposer,
          $$MeterReadingsTableCreateCompanionBuilder,
          $$MeterReadingsTableUpdateCompanionBuilder,
          (
            MeterReading,
            BaseReferences<_$AppDatabase, $MeterReadingsTable, MeterReading>,
          ),
          MeterReading,
          PrefetchHooks Function()
        > {
  $$MeterReadingsTableTableManager(_$AppDatabase db, $MeterReadingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$MeterReadingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () =>
                  $$MeterReadingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$MeterReadingsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> ownerId = const Value.absent(),
                Value<String> roomId = const Value.absent(),
                Value<String> month = const Value.absent(),
                Value<int> electricOld = const Value.absent(),
                Value<int?> electricNew = const Value.absent(),
                Value<int> waterOld = const Value.absent(),
                Value<int?> waterNew = const Value.absent(),
                Value<bool> isRecorded = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MeterReadingsCompanion(
                id: id,
                ownerId: ownerId,
                roomId: roomId,
                month: month,
                electricOld: electricOld,
                electricNew: electricNew,
                waterOld: waterOld,
                waterNew: waterNew,
                isRecorded: isRecorded,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String ownerId,
                required String roomId,
                required String month,
                required int electricOld,
                Value<int?> electricNew = const Value.absent(),
                required int waterOld,
                Value<int?> waterNew = const Value.absent(),
                Value<bool> isRecorded = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MeterReadingsCompanion.insert(
                id: id,
                ownerId: ownerId,
                roomId: roomId,
                month: month,
                electricOld: electricOld,
                electricNew: electricNew,
                waterOld: waterOld,
                waterNew: waterNew,
                isRecorded: isRecorded,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MeterReadingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MeterReadingsTable,
      MeterReading,
      $$MeterReadingsTableFilterComposer,
      $$MeterReadingsTableOrderingComposer,
      $$MeterReadingsTableAnnotationComposer,
      $$MeterReadingsTableCreateCompanionBuilder,
      $$MeterReadingsTableUpdateCompanionBuilder,
      (
        MeterReading,
        BaseReferences<_$AppDatabase, $MeterReadingsTable, MeterReading>,
      ),
      MeterReading,
      PrefetchHooks Function()
    >;
typedef $$InvoicesTableCreateCompanionBuilder =
    InvoicesCompanion Function({
      required String id,
      required String ownerId,
      required String roomId,
      required String month,
      required double totalAmount,
      required InvoiceStatus status,
      Value<String?> dueDate,
      Value<String?> paidDate,
      Value<int> rowid,
    });
typedef $$InvoicesTableUpdateCompanionBuilder =
    InvoicesCompanion Function({
      Value<String> id,
      Value<String> ownerId,
      Value<String> roomId,
      Value<String> month,
      Value<double> totalAmount,
      Value<InvoiceStatus> status,
      Value<String?> dueDate,
      Value<String?> paidDate,
      Value<int> rowid,
    });

class $$InvoicesTableFilterComposer
    extends Composer<_$AppDatabase, $InvoicesTable> {
  $$InvoicesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ownerId => $composableBuilder(
    column: $table.ownerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get roomId => $composableBuilder(
    column: $table.roomId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get month => $composableBuilder(
    column: $table.month,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<InvoiceStatus, InvoiceStatus, String>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paidDate => $composableBuilder(
    column: $table.paidDate,
    builder: (column) => ColumnFilters(column),
  );
}

class $$InvoicesTableOrderingComposer
    extends Composer<_$AppDatabase, $InvoicesTable> {
  $$InvoicesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ownerId => $composableBuilder(
    column: $table.ownerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get roomId => $composableBuilder(
    column: $table.roomId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get month => $composableBuilder(
    column: $table.month,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paidDate => $composableBuilder(
    column: $table.paidDate,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$InvoicesTableAnnotationComposer
    extends Composer<_$AppDatabase, $InvoicesTable> {
  $$InvoicesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get ownerId =>
      $composableBuilder(column: $table.ownerId, builder: (column) => column);

  GeneratedColumn<String> get roomId =>
      $composableBuilder(column: $table.roomId, builder: (column) => column);

  GeneratedColumn<String> get month =>
      $composableBuilder(column: $table.month, builder: (column) => column);

  GeneratedColumn<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<InvoiceStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<String> get paidDate =>
      $composableBuilder(column: $table.paidDate, builder: (column) => column);
}

class $$InvoicesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InvoicesTable,
          Invoice,
          $$InvoicesTableFilterComposer,
          $$InvoicesTableOrderingComposer,
          $$InvoicesTableAnnotationComposer,
          $$InvoicesTableCreateCompanionBuilder,
          $$InvoicesTableUpdateCompanionBuilder,
          (Invoice, BaseReferences<_$AppDatabase, $InvoicesTable, Invoice>),
          Invoice,
          PrefetchHooks Function()
        > {
  $$InvoicesTableTableManager(_$AppDatabase db, $InvoicesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$InvoicesTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$InvoicesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$InvoicesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> ownerId = const Value.absent(),
                Value<String> roomId = const Value.absent(),
                Value<String> month = const Value.absent(),
                Value<double> totalAmount = const Value.absent(),
                Value<InvoiceStatus> status = const Value.absent(),
                Value<String?> dueDate = const Value.absent(),
                Value<String?> paidDate = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InvoicesCompanion(
                id: id,
                ownerId: ownerId,
                roomId: roomId,
                month: month,
                totalAmount: totalAmount,
                status: status,
                dueDate: dueDate,
                paidDate: paidDate,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String ownerId,
                required String roomId,
                required String month,
                required double totalAmount,
                required InvoiceStatus status,
                Value<String?> dueDate = const Value.absent(),
                Value<String?> paidDate = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InvoicesCompanion.insert(
                id: id,
                ownerId: ownerId,
                roomId: roomId,
                month: month,
                totalAmount: totalAmount,
                status: status,
                dueDate: dueDate,
                paidDate: paidDate,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$InvoicesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InvoicesTable,
      Invoice,
      $$InvoicesTableFilterComposer,
      $$InvoicesTableOrderingComposer,
      $$InvoicesTableAnnotationComposer,
      $$InvoicesTableCreateCompanionBuilder,
      $$InvoicesTableUpdateCompanionBuilder,
      (Invoice, BaseReferences<_$AppDatabase, $InvoicesTable, Invoice>),
      Invoice,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$PropertiesTableTableManager get properties =>
      $$PropertiesTableTableManager(_db, _db.properties);
  $$ServicesTableTableManager get services =>
      $$ServicesTableTableManager(_db, _db.services);
  $$RoomsTableTableManager get rooms =>
      $$RoomsTableTableManager(_db, _db.rooms);
  $$TenantsTableTableManager get tenants =>
      $$TenantsTableTableManager(_db, _db.tenants);
  $$MeterReadingsTableTableManager get meterReadings =>
      $$MeterReadingsTableTableManager(_db, _db.meterReadings);
  $$InvoicesTableTableManager get invoices =>
      $$InvoicesTableTableManager(_db, _db.invoices);
}
