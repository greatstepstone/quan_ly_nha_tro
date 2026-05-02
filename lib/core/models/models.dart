// User (Chủ trọ / Quản lý) model
class User {
  final String id;
  final String email;
  final String name;
  final String? phone;
  final String? avatarUrl;

  const User({
    required this.id,
    required this.email,
    required this.name,
    this.phone,
    this.avatarUrl,
  });
}

// Property (Nhà trọ) model
enum BillingType { byMeter, perPerson, fixed }

extension BillingTypeExt on BillingType {
  String get label {
    switch (this) {
      case BillingType.byMeter: return 'Theo đồng hồ';
      case BillingType.perPerson: return 'Theo người';
      case BillingType.fixed: return 'Cố định';
    }
  }
}

enum PropertyStatus { active, inactive }

extension PropertyStatusExt on PropertyStatus {
  String get label {
    switch (this) {
      case PropertyStatus.active: return 'Hoạt động';
      case PropertyStatus.inactive: return 'Không hoạt động';
    }
  }
}

class Property {
  final String id;
  final String ownerId; // Thêm id của Chủ trọ (User)
  final String name;
  final String address;
  final int totalRooms;
  final double electricityPrice;
  final double waterPrice;
  final BillingType waterBillingType;
  final PropertyStatus status;
  final bool isSynced;
  final bool isDeleted;

  const Property({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.address,
    required this.totalRooms,
    required this.electricityPrice,
    required this.waterPrice,
    required this.waterBillingType,
    this.status = PropertyStatus.active,
    this.isSynced = true,
    this.isDeleted = false,
  });

  Property copyWith({
    String? id,
    String? ownerId,
    String? name,
    String? address,
    int? totalRooms,
    double? electricityPrice,
    double? waterPrice,
    BillingType? waterBillingType,
    PropertyStatus? status,
    bool? isSynced,
    bool? isDeleted,
  }) {
    return Property(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      name: name ?? this.name,
      address: address ?? this.address,
      totalRooms: totalRooms ?? this.totalRooms,
      electricityPrice: electricityPrice ?? this.electricityPrice,
      waterPrice: waterPrice ?? this.waterPrice,
      waterBillingType: waterBillingType ?? this.waterBillingType,
      status: status ?? this.status,
      isSynced: isSynced ?? this.isSynced,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}

// Service (Dịch vụ) model
class Service {
  final String id;
  final String propertyId;
  final String name;
  final BillingType type;
  final double price;
  final bool isSynced;
  final bool isDeleted;

  const Service({
    required this.id,
    required this.propertyId,
    required this.name,
    required this.type,
    required this.price,
    this.isSynced = true,
    this.isDeleted = false,
  });
}

// Room (Phòng) model
class Room {
  final String id;
  final String ownerId;
  final String propertyId;
  final String name;
  final RoomStatus status;
  final double rentPrice;
  final String? tenantId;
  final bool isSynced;
  final bool isDeleted;

  const Room({
    required this.id,
    required this.ownerId,
    required this.propertyId,
    required this.name,
    required this.status,
    required this.rentPrice,
    this.tenantId,
    this.isSynced = true,
    this.isDeleted = false,
  });
}

enum RoomStatus { empty, rented, deposited, maintenance }

extension RoomStatusExt on RoomStatus {
  String get label {
    switch (this) {
      case RoomStatus.empty:       return 'Trống';
      case RoomStatus.rented:      return 'Đã thuê';
      case RoomStatus.deposited:   return 'Đã đặt cọc';
      case RoomStatus.maintenance: return 'Đang sửa';
    }
  }
}

// Tenant (Khách thuê) model
class Tenant {
  final String id;
  final String ownerId;
  final String name;
  final String phone;
  final String cccd;
  final String dateOfBirth;
  final String hometown;
  final String roomId;
  final String propertyId;
  final String startDate;
  final double deposit;
  final bool isVerified;
  final bool isSynced;
  final bool isDeleted;

  const Tenant({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.phone,
    required this.cccd,
    required this.dateOfBirth,
    required this.hometown,
    required this.roomId,
    required this.propertyId,
    required this.startDate,
    required this.deposit,
    this.isVerified = false,
    this.isSynced = true,
    this.isDeleted = false,
  });
}

// MeterReading model
class MeterReading {
  final String id;
  final String ownerId;
  final String roomId;
  final String month;
  final int electricOld;
  final int? electricNew;
  final int waterOld;
  final int? waterNew;
  final bool isRecorded;
  final bool isSynced;
  final bool isDeleted;

  const MeterReading({
    required this.id,
    required this.ownerId,
    required this.roomId,
    required this.month,
    required this.electricOld,
    this.electricNew,
    required this.waterOld,
    this.waterNew,
    this.isRecorded = false,
    this.isSynced = true,
    this.isDeleted = false,
  });
}

// Invoice model
class Invoice {
  final String id;
  final String ownerId;
  final String roomId;
  final String month;
  final double totalAmount;
  final InvoiceStatus status;
  final String? dueDate;
  final String? paidDate;
  final String? createdAt; // Thêm trường này để lọc theo ngày tạo
  final bool isSynced;
  final bool isDeleted;

  const Invoice({
    required this.id,
    required this.ownerId,
    required this.roomId,
    required this.month,
    required this.totalAmount,
    required this.status,
    this.dueDate,
    this.paidDate,
    this.createdAt,
    this.isSynced = true,
    this.isDeleted = false,
  });
}

enum InvoiceStatus { notCreated, sent, waitingPayment, paid, overdue }

extension InvoiceStatusExt on InvoiceStatus {
  String get label {
    switch (this) {
      case InvoiceStatus.notCreated:     return 'Chưa chốt số';
      case InvoiceStatus.sent:           return 'Đã gửi hóa đơn';
      case InvoiceStatus.waitingPayment: return 'Chờ thanh toán';
      case InvoiceStatus.paid:           return 'Đã thu tiền';
      case InvoiceStatus.overdue:        return 'Quá hạn';
    }
  }
}

