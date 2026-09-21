class Product {
  final int id;
  final String name;
  final String category;
  final double price;
  final String description;
  final String image;

  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.description,
    required this.image,
  });
}

final List<Product> products = [
  const Product(
    id: 1,
    name: 'Wireless Headphones',
    category: 'Electronics',
    price: 2499,
    description:
        'High quality wireless headphones with excellent sound quality.',
    image:
        'https://images.unsplash.com/photo-1505740420928-5e560c06d30e',
  ),

  const Product(
    id: 2,
    name: 'Smart Watch',
    category: 'Electronics',
    price: 3999,
    description:
        'Modern smartwatch with fitness tracking and notification features.',
    image:
        'https://images.unsplash.com/photo-1523275335684-37898b6baf30',
  ),

  const Product(
    id: 3,
    name: 'Running Shoes',
    category: 'Fashion',
    price: 2999,
    description:
        'Comfortable running shoes designed for everyday exercise.',
    image:
        'https://images.unsplash.com/photo-1542291026-7eec264c27ff',
  ),

  const Product(
    id: 4,
    name: 'Backpack',
    category: 'Fashion',
    price: 1499,
    description:
        'Durable backpack suitable for college, office and travel.',
    image:
        'https://images.unsplash.com/photo-1553062407-98eeb64c6a62',
  ),
];