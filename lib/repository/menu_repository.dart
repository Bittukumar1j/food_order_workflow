class MenuRepository {
  Future<List<Map<String, dynamic>>> fetchRestaurants() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Mock restaurant data
    return [
      {
        'id': '1',
        'name': 'The Spice Hub',
        'cuisine': 'Indian',
        'imageUrl':
        'https://images.unsplash.com/photo-1600891964599-f61ba0e24092?auto=format&fit=crop&w=800&q=80',
        'menu': [
          {
            'id': 'm1',
            'name': 'Butter Chicken',
            'description': 'Creamy tomato chicken curry',
            'price': 250.0,
            'imageUrl':
            'https://images.unsplash.com/photo-1604908177522-179d02f5dbd8?auto=format&fit=crop&w=800&q=80',
          },
          {
            'id': 'm2',
            'name': 'Paneer Tikka',
            'description': 'Grilled spiced paneer cubes',
            'price': 200.0,
            'imageUrl':
            'https://images.unsplash.com/photo-1598514983528-6c0b82d96295?auto=format&fit=crop&w=800&q=80',
          },
        ],
      },
      {
        'id': '2',
        'name': 'Sushi World',
        'cuisine': 'Japanese',
        'imageUrl':
        'https://images.unsplash.com/photo-1562967916-eb82221dfb28?auto=format&fit=crop&w=800&q=80',
        'menu': [
          {
            'id': 'm3',
            'name': 'Salmon Sushi',
            'description': 'Fresh salmon over rice',
            'price': 300.0,
            'imageUrl':
            'https://images.unsplash.com/photo-1562967916-eb82221dfb28?auto=format&fit=crop&w=800&q=80',
          },
          {
            'id': 'm4',
            'name': 'Veggie Roll',
            'description': 'Avocado and cucumber roll',
            'price': 180.0,
            'imageUrl':
            'https://images.unsplash.com/photo-1589308078050-5f02b4789e12?auto=format&fit=crop&w=800&q=80',
          },
        ],
      },
    ];
  }
}
