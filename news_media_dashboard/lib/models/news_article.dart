class NewsArticle {
  final int id;
  final String title;
  final String category;
  final String author;
  final String time;
  final String description;
  final String image;

  const NewsArticle({
    required this.id,
    required this.title,
    required this.category,
    required this.author,
    required this.time,
    required this.description,
    required this.image,
  });
}
// NEWS DATA
final List<NewsArticle> newsArticles = [
  const NewsArticle(
    id: 1,
    title: 'Technology is Changing the Future',
    category: 'Technology',
    author: 'John Smith',
    time: '10 min ago',
    description:
        'New technologies are changing how people work, learn and communicate.',
    image:
        'https://images.unsplash.com/photo-1518770660439-4636190af475',
  ),

  const NewsArticle(
    id: 2,
    title: 'Global Business Market Shows Growth',
    category: 'Business',
    author: 'David Wilson',
    time: '25 min ago',
    description:
        'The global business market continues to show positive growth.',
    image:
        'https://images.unsplash.com/photo-1520607162513-77705c0f0d4a',
  ),

  const NewsArticle(
    id: 3,
    title: 'New Smartphone Technology Released',
    category: 'Technology',
    author: 'Sarah Lee',
    time: '40 min ago',
    description:
        'A new generation of smartphones has been introduced.',
    image:
        'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9',
  ),

  const NewsArticle(
    id: 4,
    title: 'Sports Championship Begins Today',
    category: 'Sports',
    author: 'Michael Brown',
    time: '1 hour ago',
    description:
        'The much-awaited sports championship begins today.',
    image:
        'https://images.unsplash.com/photo-1461896836934-ffe607ba8211',
  ),

  const NewsArticle(
    id: 5,
    title: 'Healthy Lifestyle Tips',
    category: 'Health',
    author: 'Emily Johnson',
    time: '2 hours ago',
    description:
        'Simple lifestyle changes can help maintain a healthy body and mind.',
    image:
        'https://images.unsplash.com/photo-1490645935967-10de6ba17061',
  ),

  const NewsArticle(
    id: 6,
    title: 'New Travel Destinations to Explore',
    category: 'Travel',
    author: 'Robert Davis',
    time: '3 hours ago',
    description:
        'Discover beautiful destinations for your next vacation.',
    image:
        'https://images.unsplash.com/photo-1507525428034-b723cf961d3e',
  ),
];
// CATEGORY DATA
final List<String> categories = [
  'Technology',
  'Business',
  'Sports',
  'Health',
  'Travel',
];