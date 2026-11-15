import 'package:flutter/material.dart';

class CustomerProduct {
  const CustomerProduct({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.emoji,
    this.oldPrice,
    this.description = 'Freshly selected for your everyday needs.',
    this.netQuantity,
    this.shelfLife,
    this.keyFeatures,
    this.nutritionalFacts,
    this.storageInstructions,
    this.manufacturerDetails,
    this.countryOfOrigin = 'India',
    this.fssaiLicense,
  });

  final String id, name, category, emoji, description;
  final int price;
  final int? oldPrice;

  // Zepto-style packaged grocery & FMCG fields
  final String? netQuantity;
  final String? shelfLife;
  final String? keyFeatures;
  final String? nutritionalFacts;
  final String? storageInstructions;
  final String? manufacturerDetails;
  final String? countryOfOrigin;
  final String? fssaiLicense;

  bool get hasGroceryInfo =>
      category != 'Food' &&
      (netQuantity != null ||
          shelfLife != null ||
          keyFeatures != null ||
          nutritionalFacts != null ||
          storageInstructions != null ||
          manufacturerDetails != null ||
          fssaiLicense != null);
}

const customerProducts = <CustomerProduct>[
  CustomerProduct(
    id: 'tomato',
    name: 'Tomato (1 kg)',
    category: 'Grocery',
    price: 32,
    oldPrice: 40,
    emoji: '🍅',
    description: 'Fresh, firm and juicy hybrid tomatoes sourced directly from local Karnataka farms.',
    netQuantity: '1 kg',
    shelfLife: 'Best before 5 days from delivery',
    keyFeatures: 'Pesticide residue tested · Hand-picked for quality · Naturally ripened',
    nutritionalFacts: 'Per 100g: Calories 18 kcal, Carbs 3.9g, Protein 0.9g, Vitamin C 14mg',
    storageInstructions: 'Store in cool ambient temperature or crisper drawer of refrigerator',
    manufacturerDetails: 'Fresh Mart Direct Farmers Cooperative, Kolar, Karnataka',
    countryOfOrigin: 'India',
    fssaiLicense: '11221333000542',
  ),
  CustomerProduct(
    id: 'onion',
    name: 'Onion (1 kg)',
    category: 'Grocery',
    price: 28,
    oldPrice: 34,
    emoji: '🧅',
    description: 'Crisp, pungent red onions, staple base for Indian curries and gravies.',
    netQuantity: '1 kg',
    shelfLife: 'Best before 15 days from delivery',
    keyFeatures: 'Medium sized bulbs · Low moisture · Dry outer skin',
    nutritionalFacts: 'Per 100g: Calories 40 kcal, Protein 1.1g, Dietary Fiber 1.7g, Carbs 9.3g',
    storageInstructions: 'Store in a cool, dry, well-ventilated basket away from direct sunlight',
    manufacturerDetails: 'Navalgund Agro Traders, Hubli, Karnataka',
    countryOfOrigin: 'India',
    fssaiLicense: '11221334000109',
  ),
  CustomerProduct(
    id: 'potato',
    name: 'Potato (1 kg)',
    category: 'Grocery',
    price: 26,
    oldPrice: 32,
    emoji: '🥔',
    description: 'Versatile farm-fresh regular potatoes suitable for boiling, baking, and frying.',
    netQuantity: '1 kg',
    shelfLife: 'Best before 20 days from delivery',
    keyFeatures: 'Uniform medium size · Low sugar content · Firm texture',
    nutritionalFacts: 'Per 100g: Calories 77 kcal, Potassium 421mg, Carbs 17g, Protein 2g',
    storageInstructions: 'Store in a cool dark place, do not refrigerate raw potatoes',
    manufacturerDetails: 'Hassan Farm Producer Co, Hassan, Karnataka',
    countryOfOrigin: 'India',
    fssaiLicense: '11221338000871',
  ),
  CustomerProduct(
    id: 'banana',
    name: 'Banana (1 dozen)',
    category: 'Grocery',
    price: 48,
    oldPrice: 60,
    emoji: '🍌',
    description: 'Sweet, energy-rich Robusta bananas with bright yellow skin.',
    netQuantity: '12 pcs (approx. 1.2 kg)',
    shelfLife: 'Best before 4 days from delivery',
    keyFeatures: 'Naturally ripened without calcium carbide · Rich in Potassium & Vitamin B6',
    nutritionalFacts: 'Per 100g: Calories 89 kcal, Potassium 358mg, Dietary Fiber 2.6g',
    storageInstructions: 'Keep at room temperature, avoid keeping sealed inside plastic bags',
    manufacturerDetails: 'Cauvery River Basin Orchards, Mysuru, Karnataka',
    countryOfOrigin: 'India',
    fssaiLicense: '11221339000312',
  ),
  // Restaurant / Cooked food items (NO packaged grocery info required)
  CustomerProduct(
    id: 'biryani',
    name: 'Chicken Biryani',
    category: 'Food',
    price: 249,
    emoji: '🍛',
    description: 'Aromatic dum biryani served with raita from The Spice Haven restaurant.',
  ),
  CustomerProduct(
    id: 'pizza',
    name: 'Farmhouse Pizza',
    category: 'Food',
    price: 299,
    emoji: '🍕',
    description: 'Hand-tossed crust topped with bell peppers, mushrooms, and mozzarella cheese.',
  ),
  CustomerProduct(
    id: 'burger',
    name: 'Classic Burger',
    category: 'Food',
    price: 149,
    emoji: '🍔',
    description: 'Grilled patty with lettuce, cheese, and signature house sauce.',
  ),
  // Gym & Fitness Packaged FMCG Goods
  CustomerProduct(
    id: 'whey',
    name: 'Whey Protein (1 kg)',
    category: 'Gym & Fitness',
    price: 1999,
    emoji: '🏋️',
    description: 'Premium isolate and concentrate blend with double rich chocolate flavour.',
    netQuantity: '1 kg (33 servings)',
    shelfLife: '24 months from manufacture',
    keyFeatures: '24g Protein per scoop · 5.5g BCAAs · 4g Glutamine · Zero added sugar',
    nutritionalFacts: 'Per 30g scoop: Energy 120 kcal, Protein 24g, Carbs 3g, Fat 1g',
    storageInstructions: 'Store in a cool dry place, keep lid tightly sealed after every scoop',
    manufacturerDetails: 'FitZone Labs & Nutrition, Koramangala 5th Block, Bengaluru',
    countryOfOrigin: 'India',
    fssaiLicense: '10019011005820',
  ),
  CustomerProduct(
    id: 'creatine',
    name: 'Creatine Monohydrate (300 g)',
    category: 'Gym & Fitness',
    price: 899,
    emoji: '💪',
    description: 'Micronized 200-mesh pure creatine monohydrate for strength and muscle recovery.',
    netQuantity: '300 g (100 servings)',
    shelfLife: '24 months from manufacture',
    keyFeatures: '100% pure micronized creatine · Unflavoured · Instant mixability',
    nutritionalFacts: 'Per 3g scoop: Creatine Monohydrate 3000mg',
    storageInstructions: 'Store in airtight container in dry temperature away from steam',
    manufacturerDetails: 'FitZone Labs & Nutrition, Bengaluru',
    countryOfOrigin: 'India',
    fssaiLicense: '10019011005820',
  ),
  // Use & Throw Packaged Items
  CustomerProduct(
    id: 'paper-cup',
    name: 'Paper Cup (100 pcs)',
    category: 'Use & Throw',
    price: 129,
    emoji: '🥤',
    description: 'Food-grade biodegradable paper cups for hot and cold beverages.',
    netQuantity: '100 cups (250 ml)',
    shelfLife: 'Indefinite (keep in dry space)',
    keyFeatures: '100% biodegradable PLA coating · Leakproof double wall · Heat resistant',
    storageInstructions: 'Store in dry place away from open flame and moisture',
    manufacturerDetails: 'EcoPack Disposables, Peenya Industrial Area, Bengaluru',
    countryOfOrigin: 'India',
  ),
  CustomerProduct(
    id: 'plate',
    name: 'Paper Plate (50 pcs)',
    category: 'Use & Throw',
    price: 149,
    emoji: '🍽️',
    description: 'Eco-friendly sturdy paper plates suitable for parties and catering events.',
    netQuantity: '50 pcs (10 inch diameter)',
    shelfLife: 'Indefinite (keep dry)',
    keyFeatures: 'Heavy duty grease-resistant paperboard · Compostable',
    storageInstructions: 'Keep dry and sealed inside protective polybag until use',
    manufacturerDetails: 'EcoPack Disposables, Peenya, Bengaluru',
    countryOfOrigin: 'India',
  ),
];

const customerCategories =
    <({String name, String subtitle, String emoji, Color color})>[
      (
        name: 'Grocery',
        subtitle: 'Daily essentials',
        emoji: '🧺',
        color: Color(0xFF7DC94B),
      ),
      (
        name: 'Food',
        subtitle: 'Veg & non-veg',
        emoji: '🍔',
        color: Color(0xFFFF8A27),
      ),
      (
        name: 'Gym & Fitness',
        subtitle: 'Supplements & gear',
        emoji: '🏋️',
        color: Color(0xFF9970E8),
      ),
      (
        name: 'Use & Throw',
        subtitle: 'Home & event items',
        emoji: '🥣',
        color: Color(0xFF7D858E),
      ),
    ];
