import 'package:flutter/material.dart';
import 'login.dart';
import 'category_detail_page.dart';
import 'profile.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2D5F5D),
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(elevation: 0, centerTitle: false),
      ),
    ),
  );
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const Body(),
    const Center(child: Text('Explore Page')),
    const Center(child: Text('Saved Page')),
    const Profilepg(
      value1: 'John Doe',
      value2: '+1 234 567 8900',
      value3: 'johndoe@example.com',
      value4: 'Travel enthusiast and adventure seeker',
      value5: '',
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    BottomNavigationBarItem _navItem(
      IconData icon,
      IconData activeIcon,
      String label,
      int index,
    ) {
      return BottomNavigationBarItem(
        label: label,
        icon: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          transitionBuilder: (child, animation) {
            return ScaleTransition(
              scale: animation,
              child: FadeTransition(opacity: animation, child: child),
            );
          },
          child: Icon(
            _selectedIndex == index ? activeIcon : icon,
            key: ValueKey(_selectedIndex == index),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: _selectedIndex != 3
          ? AppBar(
              backgroundColor: const Color(0xFF2D5F5D),
              title: const Text(
                "Venture",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  letterSpacing: 1.2,
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Loginpg()),
                    );
                  },
                  icon: const Icon(Icons.person_outline),
                  style: IconButton.styleFrom(
                    foregroundColor: Colors.white,
                    iconSize: 28,
                  ),
                ),
                const SizedBox(width: 8),
              ],
            )
          : null,
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF2D5F5D),
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.white,
        showUnselectedLabels: true,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          _navItem(Icons.home_outlined, Icons.home, 'Home', 0),
          _navItem(Icons.explore_outlined, Icons.explore, 'Explore', 1),
          _navItem(Icons.favorite_outline, Icons.favorite, 'Saved', 2),
          _navItem(Icons.person_outline, Icons.person, 'Profile', 3),
        ],
      ),
    );
  }
}

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final List<Map<String, String>> categories = [
    {
      'image':
          'https://images.unsplash.com/photo-1653151106766-52f14da3bb68?q=80&w=1173&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D?w=400',
      'name': 'Alpine Escapes',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1724031948257-8b3c68232ccc?q=80&w=670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D?w=400',
      'name': 'Coastal Havens',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1509982724584-2ce0d4366d8b?q=80&w=1230&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D?w=400',
      'name': 'Urban Pulse',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1612862862126-865765df2ded?q=80&w=1074&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D?w=400',
      'name': 'Ancient Wonders',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1566650576880-6740b03eaad1?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D?w=400',
      'name': 'Wild Safaris',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1683647986987-bcd7c320f3a1?q=80&w=1087&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D?w=400',
      'name': 'Hidden Retreats',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(
            "Explore the Unexplored",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2D5F5D),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Begin your adventure today",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.85,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return _buildCategoryCard(
                  context,
                  categories[index]['image']!,
                  categories[index]['name']!,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context,
    String imageUrl,
    String name,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CategoryDetailPage(
                categoryName: name,
                categoryImage: imageUrl,
              ),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Icon(
                      Icons.image_not_supported,
                      size: 50,
                      color: Colors.grey,
                    ),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: Colors.grey[200],
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              color: Colors.white,
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
