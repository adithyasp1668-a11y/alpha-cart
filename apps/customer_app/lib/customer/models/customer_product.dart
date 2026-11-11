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
  });
  final String id, name, category, emoji, description;
  final int price;
  final int? oldPrice;
}

const customerProducts = <CustomerProduct>[
  CustomerProduct(
    id: 'tomato',
    name: 'Tomato (1 kg)',
    category: 'Grocery',
    price: 32,
    oldPrice: 40,
    emoji: '🍅',
  ),
  CustomerProduct(
    id: 'onion',
    name: 'Onion (1 kg)',
    category: 'Grocery',
    price: 28,
    oldPrice: 34,
    emoji: '🧅',
  ),
  CustomerProduct(
    id: 'potato',
    name: 'Potato (1 kg)',
    category: 'Grocery',
    price: 26,
    oldPrice: 32,
    emoji: '🥔',
  ),
  CustomerProduct(
    id: 'banana',
    name: 'Banana (1 dozen)',
    category: 'Grocery',
    price: 48,
    oldPrice: 60,
    emoji: '🍌',
  ),
  CustomerProduct(
    id: 'biryani',
    name: 'Chicken Biryani',
    category: 'Food',
    price: 249,
    emoji: '🍛',
    description: 'Aromatic dum biryani served with raita.',
  ),
  CustomerProduct(
    id: 'pizza',
    name: 'Farmhouse Pizza',
    category: 'Food',
    price: 299,
    emoji: '🍕',
  ),
  CustomerProduct(
    id: 'burger',
    name: 'Classic Burger',
    category: 'Food',
    price: 149,
    emoji: '🍔',
  ),
  CustomerProduct(
    id: 'whey',
    name: 'Whey Protein (1 kg)',
    category: 'Gym & Fitness',
    price: 1999,
    emoji: '🏋️',
  ),
  CustomerProduct(
    id: 'creatine',
    name: 'Creatine (300 g)',
    category: 'Gym & Fitness',
    price: 899,
    emoji: '💪',
  ),
  CustomerProduct(
    id: 'paper-cup',
    name: 'Paper Cup (100 pcs)',
    category: 'Use & Throw',
    price: 129,
    emoji: '🥤',
  ),
  CustomerProduct(
    id: 'plate',
    name: 'Paper Plate (50 pcs)',
    category: 'Use & Throw',
    price: 149,
    emoji: '🍽️',
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
