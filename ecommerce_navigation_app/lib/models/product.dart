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
        'High-quality wireless headphones with excellent sound.',
    image:
        'https://images.unsplash.com/photo-1505740420928-5e560c06d30e',
  ),
  const Product(
    id: 2,
    name: 'Smart Watch',
    category: 'Electronics',
    price: 3999,
    description:
        'Modern smartwatch with fitness tracking features.',
    image:
        'https://images.unsplash.com/photo-1523275335684-37898b6baf30',
  ),
  const Product(
    id: 3,
    name: 'Running Shoes',
    category: 'Fashion',
    price: 2999,
    description:
        'Comfortable running shoes for daily exercise.',
    image:
        'https://images.unsplash.com/photo-1542291026-7eec264c27ff',
  ),
  const Product(
    id: 4,
    name: 'Backpack',
    category: 'Fashion',
    price: 1499,
    description:
        'Durable backpack suitable for college and travel.',
    image:
        'https://images.unsplash.com/photo-1553062407-98eeb64c6a62',
  ),
  const Product(
    id: 5,
    name: 'Coffee Maker',
    category: 'Home',
    price: 3499,
    description:
        'Easy-to-use coffee maker for preparing fresh coffee.',
    image:
        'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085',
  ),
  const Product(
    id: 6,
    name: 'Desk Lamp',
    category: 'Home',
    price: 999,
    description:
        'Modern LED desk lamp with adjustable brightness.',
    image:
        'https://images.unsplash.com/photo-1507473885765-e6ed057f782c',
  ),
];