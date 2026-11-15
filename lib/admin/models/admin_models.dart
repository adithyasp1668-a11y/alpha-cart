enum Period { today, week, month, year }

enum KycStatus { pending, verified, rejected }

enum AdminOrderStatus {
  placed,
  confirmed,
  preparing,
  readyForPickup,
  deliveryAssigned,
  pickedUp,
  onTheWay,
  delivered,
  cancelled,
  refunded;

  String get label {
    switch (this) {
      case AdminOrderStatus.placed:
        return 'Placed';
      case AdminOrderStatus.confirmed:
        return 'Confirmed';
      case AdminOrderStatus.preparing:
        return 'Preparing';
      case AdminOrderStatus.readyForPickup:
        return 'Ready for Pickup';
      case AdminOrderStatus.deliveryAssigned:
        return 'Rider Assigned';
      case AdminOrderStatus.pickedUp:
        return 'Picked Up';
      case AdminOrderStatus.onTheWay:
        return 'On The Way';
      case AdminOrderStatus.delivered:
        return 'Delivered';
      case AdminOrderStatus.cancelled:
        return 'Cancelled';
      case AdminOrderStatus.refunded:
        return 'Refunded';
    }
  }
}

class AdminMetricSummary {
  final int totalOrders;
  final int totalSalesPaise;
  final int platformRevenuePaise;
  final int netProfitPaise;
  final double ordersDelta;
  final double salesDelta;
  final double revenueDelta;
  final double profitDelta;

  const AdminMetricSummary({
    required this.totalOrders,
    required this.totalSalesPaise,
    required this.platformRevenuePaise,
    required this.netProfitPaise,
    required this.ordersDelta,
    required this.salesDelta,
    required this.revenueDelta,
    required this.profitDelta,
  });

  String get formattedSales => '₹${(totalSalesPaise / 100).toStringAsFixed(0)}';
  String get formattedRevenue => '₹${(platformRevenuePaise / 100).toStringAsFixed(0)}';
  String get formattedProfit => '₹${(netProfitPaise / 100).toStringAsFixed(0)}';
}

class AdminOrderItem {
  final String id;
  final String name;
  final int quantity;
  final int pricePaise;

  const AdminOrderItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.pricePaise,
  });

  String get formattedPrice => '₹${((pricePaise * quantity) / 100).toStringAsFixed(0)}';
}

class AdminOrder {
  final String id;
  final String customerName;
  final String customerPhone;
  final String storeName;
  final String storeAddress;
  final String? riderName;
  final String? riderPhone;
  final AdminOrderStatus status;
  final int totalPaise;
  final int deliveryFeePaise;
  final int platformFeePaise;
  final String deliveryAddress;
  final String? deliveryOtp;
  final DateTime createdAt;
  final List<AdminOrderItem> items;

  const AdminOrder({
    required this.id,
    required this.customerName,
    required this.customerPhone,
    required this.storeName,
    required this.storeAddress,
    this.riderName,
    this.riderPhone,
    required this.status,
    required this.totalPaise,
    required this.deliveryFeePaise,
    required this.platformFeePaise,
    required this.deliveryAddress,
    this.deliveryOtp,
    required this.createdAt,
    required this.items,
  });

  String get formattedTotal => '₹${(totalPaise / 100).toStringAsFixed(0)}';
  String get formattedTime {
    final diff = DateTime.now().difference(createdAt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  AdminOrder copyWith({AdminOrderStatus? status, String? riderName, String? riderPhone}) {
    return AdminOrder(
      id: id,
      customerName: customerName,
      customerPhone: customerPhone,
      storeName: storeName,
      storeAddress: storeAddress,
      riderName: riderName ?? this.riderName,
      riderPhone: riderPhone ?? this.riderPhone,
      status: status ?? this.status,
      totalPaise: totalPaise,
      deliveryFeePaise: deliveryFeePaise,
      platformFeePaise: platformFeePaise,
      deliveryAddress: deliveryAddress,
      deliveryOtp: deliveryOtp,
      createdAt: createdAt,
      items: items,
    );
  }
}

class AdminProduct {
  final String id;
  final String storeId;
  final String storeName;
  final String name;
  final String category;
  final String description;
  final int pricePaise;
  final int discountPaise;
  final bool isAvailable;
  final String? imageUrl;
  final int stockCount;
  // Zepto-style packaged grocery fields (not required for cooked restaurant food)
  final String? netQuantity;
  final String? shelfLife;
  final String? keyFeatures;
  final String? nutritionalFacts;
  final String? storageInstructions;
  final String? manufacturerDetails;
  final String? countryOfOrigin;
  final String? fssaiLicense;

  const AdminProduct({
    required this.id,
    required this.storeId,
    required this.storeName,
    required this.name,
    required this.category,
    required this.description,
    required this.pricePaise,
    this.discountPaise = 0,
    required this.isAvailable,
    this.imageUrl,
    this.stockCount = 100,
    this.netQuantity,
    this.shelfLife,
    this.keyFeatures,
    this.nutritionalFacts,
    this.storageInstructions,
    this.manufacturerDetails,
    this.countryOfOrigin = 'India',
    this.fssaiLicense,
  });

  String get formattedPrice => '₹${(pricePaise / 100).toStringAsFixed(0)}';

  AdminProduct copyWith({
    String? name,
    String? category,
    String? description,
    int? pricePaise,
    int? discountPaise,
    bool? isAvailable,
    String? imageUrl,
    int? stockCount,
    String? storeId,
    String? storeName,
    String? netQuantity,
    String? shelfLife,
    String? keyFeatures,
    String? nutritionalFacts,
    String? storageInstructions,
    String? manufacturerDetails,
    String? countryOfOrigin,
    String? fssaiLicense,
  }) {
    return AdminProduct(
      id: id,
      storeId: storeId ?? this.storeId,
      storeName: storeName ?? this.storeName,
      name: name ?? this.name,
      category: category ?? this.category,
      description: description ?? this.description,
      pricePaise: pricePaise ?? this.pricePaise,
      discountPaise: discountPaise ?? this.discountPaise,
      isAvailable: isAvailable ?? this.isAvailable,
      imageUrl: imageUrl ?? this.imageUrl,
      stockCount: stockCount ?? this.stockCount,
      netQuantity: netQuantity ?? this.netQuantity,
      shelfLife: shelfLife ?? this.shelfLife,
      keyFeatures: keyFeatures ?? this.keyFeatures,
      nutritionalFacts: nutritionalFacts ?? this.nutritionalFacts,
      storageInstructions: storageInstructions ?? this.storageInstructions,
      manufacturerDetails: manufacturerDetails ?? this.manufacturerDetails,
      countryOfOrigin: countryOfOrigin ?? this.countryOfOrigin,
      fssaiLicense: fssaiLicense ?? this.fssaiLicense,
    );
  }
}

class AdminStore {
  final String id;
  final String name;
  final String ownerName;
  final String phone;
  final String category;
  final String address;
  final KycStatus kycStatus;
  final double commissionRate;
  final bool isOpen;
  final double rating;
  final int totalProducts;
  final int totalOrders;

  const AdminStore({
    required this.id,
    required this.name,
    required this.ownerName,
    required this.phone,
    required this.category,
    required this.address,
    required this.kycStatus,
    required this.commissionRate,
    required this.isOpen,
    required this.rating,
    required this.totalProducts,
    required this.totalOrders,
  });

  AdminStore copyWith({
    KycStatus? kycStatus,
    double? commissionRate,
    bool? isOpen,
  }) {
    return AdminStore(
      id: id,
      name: name,
      ownerName: ownerName,
      phone: phone,
      category: category,
      address: address,
      kycStatus: kycStatus ?? this.kycStatus,
      commissionRate: commissionRate ?? this.commissionRate,
      isOpen: isOpen ?? this.isOpen,
      rating: rating,
      totalProducts: totalProducts,
      totalOrders: totalOrders,
    );
  }
}

class AdminRider {
  final String id;
  final String name;
  final String phone;
  final String vehicleType;
  final String vehicleNumber;
  final double rating;
  final int totalDeliveries;
  final KycStatus kycStatus;
  final bool isOnline;
  final String? activeOrderId;

  const AdminRider({
    required this.id,
    required this.name,
    required this.phone,
    required this.vehicleType,
    required this.vehicleNumber,
    required this.rating,
    required this.totalDeliveries,
    required this.kycStatus,
    required this.isOnline,
    this.activeOrderId,
  });

  AdminRider copyWith({
    KycStatus? kycStatus,
    bool? isOnline,
    String? activeOrderId,
  }) {
    return AdminRider(
      id: id,
      name: name,
      phone: phone,
      vehicleType: vehicleType,
      vehicleNumber: vehicleNumber,
      rating: rating,
      totalDeliveries: totalDeliveries,
      kycStatus: kycStatus ?? this.kycStatus,
      isOnline: isOnline ?? this.isOnline,
      activeOrderId: activeOrderId ?? this.activeOrderId,
    );
  }
}

class AdminPayout {
  final String id;
  final String beneficiaryName;
  final String beneficiaryType; // 'STORE' or 'RIDER'
  final String bankOrUpi;
  final int amountPaise;
  final String status; // 'PENDING', 'SETTLED', 'FAILED'
  final DateTime dueDate;

  const AdminPayout({
    required this.id,
    required this.beneficiaryName,
    required this.beneficiaryType,
    required this.bankOrUpi,
    required this.amountPaise,
    required this.status,
    required this.dueDate,
  });

  String get formattedAmount => '₹${(amountPaise / 100).toStringAsFixed(0)}';

  AdminPayout copyWith({String? status}) {
    return AdminPayout(
      id: id,
      beneficiaryName: beneficiaryName,
      beneficiaryType: beneficiaryType,
      bankOrUpi: bankOrUpi,
      amountPaise: amountPaise,
      status: status ?? this.status,
      dueDate: dueDate,
    );
  }
}

class AdminPnL {
  final int gmvPaise;
  final int commissionEarnedPaise;
  final int deliveryFeesCollectedPaise;
  final int deliveryPayoutsDisbursedPaise;
  final int gatewayChargesPaise;
  final int refundsDeductedPaise;
  final int netProfitPaise;
  final double netMarginPercent;

  const AdminPnL({
    required this.gmvPaise,
    required this.commissionEarnedPaise,
    required this.deliveryFeesCollectedPaise,
    required this.deliveryPayoutsDisbursedPaise,
    required this.gatewayChargesPaise,
    required this.refundsDeductedPaise,
    required this.netProfitPaise,
    required this.netMarginPercent,
  });

  String get formattedGmv => '₹${(gmvPaise / 100).toStringAsFixed(0)}';
  String get formattedCommission => '₹${(commissionEarnedPaise / 100).toStringAsFixed(0)}';
  String get formattedDeliveryDiff => '₹${((deliveryFeesCollectedPaise - deliveryPayoutsDisbursedPaise) / 100).toStringAsFixed(0)}';
  String get formattedGateway => '₹${(gatewayChargesPaise / 100).toStringAsFixed(0)}';
  String get formattedRefunds => '₹${(refundsDeductedPaise / 100).toStringAsFixed(0)}';
  String get formattedProfit => '₹${(netProfitPaise / 100).toStringAsFixed(0)}';
}

class AdminPlatformSettings {
  final double foodCommission;
  final double groceryCommission;
  final double gymCommission;
  final double disposableCommission;
  final int baseDeliveryFeePaise;
  final int perKmDeliveryFeePaise;
  final bool codEnabled;
  final bool maintenanceMode;
  final String activeGateway;

  const AdminPlatformSettings({
    this.foodCommission = 15.0,
    this.groceryCommission = 8.0,
    this.gymCommission = 12.0,
    this.disposableCommission = 10.0,
    this.baseDeliveryFeePaise = 3000, // ₹30
    this.perKmDeliveryFeePaise = 1000, // ₹10/km
    this.codEnabled = true,
    this.maintenanceMode = false,
    this.activeGateway = 'Razorpay Sandbox',
  });

  AdminPlatformSettings copyWith({
    double? foodCommission,
    double? groceryCommission,
    double? gymCommission,
    double? disposableCommission,
    int? baseDeliveryFeePaise,
    int? perKmDeliveryFeePaise,
    bool? codEnabled,
    bool? maintenanceMode,
    String? activeGateway,
  }) {
    return AdminPlatformSettings(
      foodCommission: foodCommission ?? this.foodCommission,
      groceryCommission: groceryCommission ?? this.groceryCommission,
      gymCommission: gymCommission ?? this.gymCommission,
      disposableCommission: disposableCommission ?? this.disposableCommission,
      baseDeliveryFeePaise: baseDeliveryFeePaise ?? this.baseDeliveryFeePaise,
      perKmDeliveryFeePaise: perKmDeliveryFeePaise ?? this.perKmDeliveryFeePaise,
      codEnabled: codEnabled ?? this.codEnabled,
      maintenanceMode: maintenanceMode ?? this.maintenanceMode,
      activeGateway: activeGateway ?? this.activeGateway,
    );
  }
}
