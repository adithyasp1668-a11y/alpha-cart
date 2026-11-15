import 'package:flutter/foundation.dart';
import '../models/admin_models.dart';

class AdminApiService extends ChangeNotifier {
  static final AdminApiService _instance = AdminApiService._internal();
  factory AdminApiService() => _instance;
  AdminApiService._internal() {
    _seedMockData();
  }

  bool useMock = true;

  // Cached state
  List<AdminOrder> _orders = [];
  List<AdminProduct> _products = [];
  List<AdminStore> _stores = [];
  List<AdminRider> _riders = [];
  List<AdminPayout> _payouts = [];
  AdminPlatformSettings _settings = const AdminPlatformSettings();

  List<AdminOrder> get orders => List.unmodifiable(_orders);
  List<AdminProduct> get products => List.unmodifiable(_products);
  List<AdminStore> get stores => List.unmodifiable(_stores);
  List<AdminRider> get riders => List.unmodifiable(_riders);
  List<AdminPayout> get payouts => List.unmodifiable(_payouts);
  AdminPlatformSettings get settings => _settings;

  void _seedMockData() {
    _stores = [
      const AdminStore(
        id: 'store_1',
        name: 'The Spice Haven',
        ownerName: 'Chef Rameshwar',
        phone: '+91 98765 43210',
        category: 'Food',
        address: 'Indiranagar 100ft Rd, Bengaluru',
        kycStatus: KycStatus.verified,
        commissionRate: 15.0,
        isOpen: true,
        rating: 4.8,
        totalProducts: 42,
        totalOrders: 1320,
      ),
      const AdminStore(
        id: 'store_2',
        name: 'Fresh Mart Supermarket',
        ownerName: 'Sunita Reddy',
        phone: '+91 98450 11223',
        category: 'Grocery',
        address: 'HSR Layout Sector 2, Bengaluru',
        kycStatus: KycStatus.verified,
        commissionRate: 8.0,
        isOpen: true,
        rating: 4.6,
        totalProducts: 250,
        totalOrders: 3100,
      ),
      const AdminStore(
        id: 'store_3',
        name: 'FitZone Nutrition & Gear',
        ownerName: 'Vikram Singh',
        phone: '+91 97400 88990',
        category: 'Gym & Fitness',
        address: 'Koramangala 5th Block, Bengaluru',
        kycStatus: KycStatus.pending,
        commissionRate: 12.0,
        isOpen: false,
        rating: 4.9,
        totalProducts: 64,
        totalOrders: 420,
      ),
      const AdminStore(
        id: 'store_4',
        name: 'EcoPack Disposables',
        ownerName: 'Anand Mehta',
        phone: '+91 99001 23456',
        category: 'Use & Throw',
        address: 'Peenya Industrial Area, Bengaluru',
        kycStatus: KycStatus.verified,
        commissionRate: 10.0,
        isOpen: true,
        rating: 4.5,
        totalProducts: 38,
        totalOrders: 890,
      ),
    ];

    _riders = [
      const AdminRider(
        id: 'rider_1',
        name: 'Ravi Kumar',
        phone: '+91 91234 56789',
        vehicleType: 'EV Scooter',
        vehicleNumber: 'KA 01 EK 4492',
        rating: 4.9,
        totalDeliveries: 420,
        kycStatus: KycStatus.verified,
        isOnline: true,
        activeOrderId: 'AC-9082',
      ),
      const AdminRider(
        id: 'rider_2',
        name: 'Manoj S',
        phone: '+91 92345 67890',
        vehicleType: 'Hero Splendor',
        vehicleNumber: 'KA 05 MN 1283',
        rating: 4.7,
        totalDeliveries: 285,
        kycStatus: KycStatus.verified,
        isOnline: true,
      ),
      const AdminRider(
        id: 'rider_3',
        name: 'Abhishek R',
        phone: '+91 93456 78901',
        vehicleType: 'TVS Jupiter',
        vehicleNumber: 'KA 03 AB 9940',
        rating: 4.6,
        totalDeliveries: 190,
        kycStatus: KycStatus.pending,
        isOnline: false,
      ),
      const AdminRider(
        id: 'rider_4',
        name: 'Kiran Deep',
        phone: '+91 94567 89012',
        vehicleType: 'Honda Activa',
        vehicleNumber: 'KA 04 KD 5521',
        rating: 4.8,
        totalDeliveries: 510,
        kycStatus: KycStatus.verified,
        isOnline: false,
      ),
    ];

    _products = [
      const AdminProduct(
        id: 'prod_1',
        storeId: 'store_1',
        storeName: 'The Spice Haven',
        name: 'Royal Hyderabadi Chicken Biryani',
        category: 'Food',
        description: 'Dum-cooked aromatic basmati rice with marinated chicken & secret spices',
        pricePaise: 34900,
        discountPaise: 5000,
        isAvailable: true,
        stockCount: 50,
      ),
      const AdminProduct(
        id: 'prod_2',
        storeId: 'store_3',
        storeName: 'FitZone Nutrition & Gear',
        name: 'Gold Standard 100% Whey Protein (1kg)',
        category: 'Gym & Fitness',
        description: 'Imported isolate whey protein double rich chocolate flavour',
        pricePaise: 389900,
        discountPaise: 30000,
        isAvailable: true,
        stockCount: 18,
      ),
      const AdminProduct(
        id: 'prod_3',
        storeId: 'store_4',
        storeName: 'EcoPack Disposables',
        name: 'Biodegradable Paper Cups (Pack of 100)',
        category: 'Use & Throw',
        description: 'Eco-friendly double wall hot coffee & tea beverage cups 250ml',
        pricePaise: 18000,
        isAvailable: true,
        stockCount: 120,
      ),
      const AdminProduct(
        id: 'prod_4',
        storeId: 'store_2',
        storeName: 'Fresh Mart Supermarket',
        name: 'Farm Fresh Hybrid Tomatoes (1kg)',
        category: 'Grocery',
        description: 'Locally sourced fresh and juicy grade-A tomatoes',
        pricePaise: 4200,
        isAvailable: true,
        stockCount: 80,
      ),
      const AdminProduct(
        id: 'prod_5',
        storeId: 'store_1',
        storeName: 'The Spice Haven',
        name: 'Paneer Butter Masala (350g)',
        category: 'Food',
        description: 'Soft cottage cheese cubes in rich creamy tomato cashew gravy',
        pricePaise: 26900,
        isAvailable: true,
        stockCount: 35,
      ),
    ];

    _orders = [
      AdminOrder(
        id: 'AC-9082',
        customerName: 'Adarsh Gowda',
        customerPhone: '+91 99887 76655',
        storeName: 'The Spice Haven',
        storeAddress: 'Indiranagar 100ft Rd',
        riderName: 'Ravi Kumar',
        riderPhone: '+91 91234 56789',
        status: AdminOrderStatus.onTheWay,
        totalPaise: 74800,
        deliveryFeePaise: 4000,
        platformFeePaise: 1500,
        deliveryAddress: 'Flat 402, Green Glen Layout, Bellandur, Bengaluru',
        deliveryOtp: '5821',
        createdAt: DateTime.now().subtract(const Duration(minutes: 24)),
        items: const [
          AdminOrderItem(id: 'item_1', name: 'Royal Hyderabadi Chicken Biryani', quantity: 2, pricePaise: 34900),
        ],
      ),
      AdminOrder(
        id: 'AC-9081',
        customerName: 'Priya Sharma',
        customerPhone: '+91 97766 55443',
        storeName: 'FitZone Nutrition & Gear',
        storeAddress: 'Koramangala 5th Block',
        status: AdminOrderStatus.preparing,
        totalPaise: 364900,
        deliveryFeePaise: 5000,
        platformFeePaise: 2000,
        deliveryAddress: 'House 12, 4th Cross, ST Bed, Koramangala',
        createdAt: DateTime.now().subtract(const Duration(minutes: 48)),
        items: const [
          AdminOrderItem(id: 'item_2', name: 'Gold Standard 100% Whey Protein (1kg)', quantity: 1, pricePaise: 359900),
        ],
      ),
      AdminOrder(
        id: 'AC-9080',
        customerName: 'Karthik Rao',
        customerPhone: '+91 96655 44332',
        storeName: 'Fresh Mart Supermarket',
        storeAddress: 'HSR Layout Sector 2',
        riderName: 'Manoj S',
        riderPhone: '+91 92345 67890',
        status: AdminOrderStatus.delivered,
        totalPaise: 126000,
        deliveryFeePaise: 3000,
        platformFeePaise: 1000,
        deliveryAddress: 'Villa 7, Palm Meadows, Whitefield',
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
        items: const [
          AdminOrderItem(id: 'item_3', name: 'Farm Fresh Tomatoes (1kg)', quantity: 3, pricePaise: 4200),
          AdminOrderItem(id: 'item_4', name: 'Aashirvaad Whole Wheat Atta 10kg', quantity: 1, pricePaise: 48000),
        ],
      ),
      AdminOrder(
        id: 'AC-9079',
        customerName: 'Sneha Patel',
        customerPhone: '+91 95544 33221',
        storeName: 'EcoPack Disposables',
        storeAddress: 'Peenya Industrial Area',
        status: AdminOrderStatus.placed,
        totalPaise: 54000,
        deliveryFeePaise: 6000,
        platformFeePaise: 1000,
        deliveryAddress: 'Catering Hub, Rajajinagar 1st Block',
        createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
        items: const [
          AdminOrderItem(id: 'item_5', name: 'Biodegradable Paper Cups (Pack of 100)', quantity: 3, pricePaise: 18000),
        ],
      ),
      AdminOrder(
        id: 'AC-9078',
        customerName: 'Rahul Verma',
        customerPhone: '+91 94433 22110',
        storeName: 'The Spice Haven',
        storeAddress: 'Indiranagar 100ft Rd',
        status: AdminOrderStatus.cancelled,
        totalPaise: 29900,
        deliveryFeePaise: 3000,
        platformFeePaise: 1000,
        deliveryAddress: 'Kalyan Nagar HRBR Layout',
        createdAt: DateTime.now().subtract(const Duration(hours: 6)),
        items: const [
          AdminOrderItem(id: 'item_6', name: 'Paneer Butter Masala (350g)', quantity: 1, pricePaise: 26900),
        ],
      ),
    ];

    _payouts = [
      AdminPayout(
        id: 'PAY-1001',
        beneficiaryName: 'The Spice Haven',
        beneficiaryType: 'STORE',
        bankOrUpi: 'HDFC Bank •••• 9102',
        amountPaise: 4860000, // ₹48,600
        status: 'PENDING',
        dueDate: DateTime.now().add(const Duration(days: 1)),
      ),
      AdminPayout(
        id: 'PAY-1002',
        beneficiaryName: 'Fresh Mart Supermarket',
        beneficiaryType: 'STORE',
        bankOrUpi: 'ICICI Bank •••• 4039',
        amountPaise: 8240000, // ₹82,400
        status: 'PENDING',
        dueDate: DateTime.now().add(const Duration(days: 1)),
      ),
      AdminPayout(
        id: 'PAY-1003',
        beneficiaryName: 'Ravi Kumar',
        beneficiaryType: 'RIDER',
        bankOrUpi: 'ravikumar@oksbi',
        amountPaise: 645000, // ₹6,450
        status: 'PENDING',
        dueDate: DateTime.now(),
      ),
      AdminPayout(
        id: 'PAY-1004',
        beneficiaryName: 'Manoj S',
        beneficiaryType: 'RIDER',
        bankOrUpi: 'manojs@paytm',
        amountPaise: 492000, // ₹4,920
        status: 'SETTLED',
        dueDate: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ];
  }

  // Dashboard Metrics
  AdminMetricSummary getDashboardMetrics(Period period) {
    int totalPaise = 0;
    int ordersCount = _orders.length;
    for (final o in _orders) {
      if (o.status != AdminOrderStatus.cancelled) {
        totalPaise += o.totalPaise;
      }
    }
    // Estimated platform revenue ~ 12% commission + platform fees
    final revenue = (totalPaise * 0.12).round() + (ordersCount * 1500);
    final profit = (revenue * 0.72).round(); // after server/gateway costs

    return AdminMetricSummary(
      totalOrders: 148 + ordersCount,
      totalSalesPaise: 24890000 + totalPaise,
      platformRevenuePaise: 3840000 + revenue,
      netProfitPaise: 2620000 + profit,
      ordersDelta: 14.8,
      salesDelta: 18.2,
      revenueDelta: 12.5,
      profitDelta: 9.4,
    );
  }

  // P&L Metrics
  AdminPnL getPnLReport(Period period) {
    final gmv = 142500000; // ₹14,25,000 GMV
    final commission = (gmv * 0.125).round(); // ~₹1,78,125
    final deliveryFees = 28500000; // ₹2,85,000 collected
    final deliveryPayouts = 25200000; // ₹2,52,000 paid to riders
    final gateway = (gmv * 0.018).round(); // 1.8% gateway cut
    final refunds = 1200000; // ₹12,000 refunds
    final netProfit = (commission + (deliveryFees - deliveryPayouts)) - gateway - refunds;
    final margin = (netProfit / gmv) * 100;

    return AdminPnL(
      gmvPaise: gmv,
      commissionEarnedPaise: commission,
      deliveryFeesCollectedPaise: deliveryFees,
      deliveryPayoutsDisbursedPaise: deliveryPayouts,
      gatewayChargesPaise: gateway,
      refundsDeductedPaise: refunds,
      netProfitPaise: netProfit,
      netMarginPercent: margin,
    );
  }

  // Mutators
  void updateOrderStatus(String orderId, AdminOrderStatus newStatus) {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      _orders[index] = _orders[index].copyWith(status: newStatus);
      notifyListeners();
    }
  }

  void toggleProductAvailability(String productId) {
    final index = _products.indexWhere((p) => p.id == productId);
    if (index != -1) {
      final current = _products[index];
      _products[index] = current.copyWith(isAvailable: !current.isAvailable);
      notifyListeners();
    }
  }

  void saveProduct(AdminProduct product) {
    final index = _products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      _products[index] = product;
    } else {
      _products.insert(0, product);
    }
    notifyListeners();
  }

  void deleteProduct(String productId) {
    _products.removeWhere((p) => p.id == productId);
    notifyListeners();
  }

  void updateStoreKyc(String storeId, KycStatus status) {
    final index = _stores.indexWhere((s) => s.id == storeId);
    if (index != -1) {
      _stores[index] = _stores[index].copyWith(kycStatus: status);
      notifyListeners();
    }
  }

  void updateStoreCommission(String storeId, double rate) {
    final index = _stores.indexWhere((s) => s.id == storeId);
    if (index != -1) {
      _stores[index] = _stores[index].copyWith(commissionRate: rate);
      notifyListeners();
    }
  }

  void toggleStoreOpen(String storeId) {
    final index = _stores.indexWhere((s) => s.id == storeId);
    if (index != -1) {
      final current = _stores[index];
      _stores[index] = current.copyWith(isOpen: !current.isOpen);
      notifyListeners();
    }
  }

  void updateRiderKyc(String riderId, KycStatus status) {
    final index = _riders.indexWhere((r) => r.id == riderId);
    if (index != -1) {
      _riders[index] = _riders[index].copyWith(kycStatus: status);
      notifyListeners();
    }
  }

  void toggleRiderOnline(String riderId) {
    final index = _riders.indexWhere((r) => r.id == riderId);
    if (index != -1) {
      final current = _riders[index];
      _riders[index] = current.copyWith(isOnline: !current.isOnline);
      notifyListeners();
    }
  }

  void settlePayouts({List<String>? payoutIds}) {
    for (int i = 0; i < _payouts.length; i++) {
      if (payoutIds == null || payoutIds.contains(_payouts[i].id)) {
        if (_payouts[i].status == 'PENDING') {
          _payouts[i] = _payouts[i].copyWith(status: 'SETTLED');
        }
      }
    }
    notifyListeners();
  }

  void updateSettings(AdminPlatformSettings newSettings) {
    _settings = newSettings;
    notifyListeners();
  }
}
