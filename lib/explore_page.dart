import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'saved_places_manager.dart';
import 'category_detail_page.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedFilter = 'All';

  final List<String> _filters = [
    'All',
    'Mountains',
    'Beaches',
    'Cities',
    'Historical',
    'Wildlife',
    'Hidden Gems'
  ];

  // All places from all categories
  final List<Map<String, String>> _allPlaces = [
    // Alpine Escapes
    {
      'image':
          'https://images.unsplash.com/photo-1653151106766-52f14da3bb68?q=80&w=1173&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D?w=400',
      'title': "Adam's Peak",
      'rating': '4.8',
      'category': 'Alpine Escapes',
      'type': 'Mountains',
      'description': 'Sacred mountain pilgrimage site',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1711719725618-1d70d2d7b4b4?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D?w=400',
      'title': 'Ella Rock',
      'rating': '4.9',
      'category': 'Alpine Escapes',
      'type': 'Mountains',
      'description': 'Stunning hiking trail with panoramic views',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1695188604020-5b508484d5a0?q=80&w=1074&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D?w=400',
      'title': "Horton Plains (World's End)",
      'rating': '4.5',
      'category': 'Alpine Escapes',
      'type': 'Mountains',
      'description': 'Breathtaking cliff edge viewpoint',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1559038331-fe26f6746fed?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D?w=400',
      'title': 'Pidurangala Rock',
      'rating': '4.8',
      'category': 'Alpine Escapes',
      'type': 'Mountains',
      'description': 'Alternative view of Sigiriya Rock',
    },
    // Coastal Havens
    {
      'image':
          'https://images.unsplash.com/photo-1580910527739-556eb89f9d65?q=80&w=1074&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D?w=400',
      'title': 'Mirissa',
      'rating': '5.0',
      'category': 'Coastal Havens',
      'type': 'Beaches',
      'description': 'Famous for whale watching and surfing',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1574895527713-07d8c1b53bba?q=80&w=736&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D?w=400',
      'title': 'Hiriketiya',
      'rating': '4.9',
      'category': 'Coastal Havens',
      'type': 'Beaches',
      'description': 'Hidden bay perfect for surfing',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1665765416044-7107644ecac2?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D?w=400',
      'title': 'Unawatuna',
      'rating': '4.7',
      'category': 'Coastal Havens',
      'type': 'Beaches',
      'description': 'Vibrant beach town with coral reefs',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1724031948257-8b3c68232ccc?q=80&w=670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D?w=400',
      'title': 'Arugam Bay',
      'rating': '4.9',
      'category': 'Coastal Havens',
      'type': 'Beaches',
      'description': "Surfer's paradise on the east coast",
    },
    // Urban Pulse
    {
      'image':
          'https://images.unsplash.com/photo-1581420455468-e748ad82ff50?q=80&w=687&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D?w=400',
      'title': 'Kandy',
      'rating': '4.9',
      'category': 'Urban Pulse',
      'type': 'Cities',
      'description': 'Cultural capital with sacred temple',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1509982724584-2ce0d4366d8b?q=80&w=1230&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D?w=400',
      'title': 'Galle',
      'rating': '4.8',
      'category': 'Urban Pulse',
      'type': 'Cities',
      'description': 'Dutch colonial fort city',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1561426802-392f5b6290cf?q=80&w=735&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D?w=400',
      'title': 'Colombo',
      'rating': '5.0',
      'category': 'Urban Pulse',
      'type': 'Cities',
      'description': 'Bustling commercial capital',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1578519050142-afb511e518de?q=80&w=687&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D?w=400',
      'title': 'Ella',
      'rating': '4.8',
      'category': 'Urban Pulse',
      'type': 'Cities',
      'description': 'Charming hill country town',
    },
    // Ancient Wonders
    {
      'image':
          'https://images.unsplash.com/photo-1612862862126-865765df2ded?w=400',
      'title': 'Sigiriya Rock Fortress',
      'rating': '5.0',
      'category': 'Ancient Wonders',
      'type': 'Historical',
      'description': 'UNESCO World Heritage ancient fortress',
    },
    {
      'image':
          'https://images.pexels.com/photos/33171754/pexels-photo-33171754.jpeg?w=400',
      'title': 'Polonnaruwa Ancient City',
      'rating': '4.9',
      'category': 'Ancient Wonders',
      'type': 'Historical',
      'description': 'Medieval capital with ruins',
    },
    {
      'image':
          'https://images.pexels.com/photos/35598967/pexels-photo-35598967.jpeg?w=400',
      'title': 'Dambulla Cave Temple',
      'rating': '4.8',
      'category': 'Ancient Wonders',
      'type': 'Historical',
      'description': 'Ancient cave temple complex',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1665849050332-8d5d7e59afb6?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D?w=400',
      'title': 'Temple of the Sacred Tooth Relic',
      'rating': '4.8',
      'category': 'Ancient Wonders',
      'type': 'Historical',
      'description': 'Sacred Buddhist temple in Kandy',
    },
    // Wild Safaris
    {
      'image':
          'https://www.thetimes.com/imageserver/image/%2Fmethode%2Ftimes%2Fprod%2Fweb%2Fbin%2F50e9e8f5-f1ca-4a08-9b7f-18b15c011582.jpg?crop=3543%2C1993%2C553%2C920?w=400',
      'title': 'Yala National Park',
      'rating': '5.0',
      'category': 'Wild Safaris',
      'type': 'Wildlife',
      'description': 'Best place to spot leopards',
    },
    {
      'image':
          'https://www.serendibtrail.com/content/images/size/w1200/2024/10/udawalawe-national-park.webp?w=400',
      'title': 'Udawalawe National Park',
      'rating': '4.9',
      'category': 'Wild Safaris',
      'type': 'Wildlife',
      'description': 'Famous for elephant herds',
    },
    {
      'image':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcScALsTYj6QxaPybHmhHATOPkLHPKL5pb2mgA&s?w=400',
      'title': 'Minneriya National Park',
      'rating': '4.8',
      'category': 'Wild Safaris',
      'type': 'Wildlife',
      'description': 'Elephant gathering phenomenon',
    },
    {
      'image':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRv8PBpY-i6PCUQCeHGmTsAosoSV0XVHkYoGA&s?w=400',
      'title': 'Sinharaja Forest Reserve',
      'rating': '4.8',
      'category': 'Wild Safaris',
      'type': 'Wildlife',
      'description': 'UNESCO rainforest biodiversity hotspot',
    },
    // Hidden Retreats
    {
      'image':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ3mWrHBlSuGgnxeTrU_6SjKKlJRq3Cqbgwkg&s?w=400',
      'title': 'Riverston',
      'rating': '5.0',
      'category': 'Hidden Retreats',
      'type': 'Hidden Gems',
      'description': 'Off-the-beaten-path mountain peak',
    },
    {
      'image':
          'https://www.lanka-excursions-holidays.com/uploads/4/0/2/1/40216937/delft-island-feral-horses-title-image_orig.jpg?w=400',
      'title': 'Delft Island',
      'rating': '4.9',
      'category': 'Hidden Retreats',
      'type': 'Hidden Gems',
      'description': 'Remote island with wild horses',
    },
    {
      'image':
          'https://upload.wikimedia.org/wikipedia/commons/c/cb/Bambarakanda_Waterfall.jpg?w=400',
      'title': 'Bambarakanda Falls',
      'rating': '4.9',
      'category': 'Hidden Retreats',
      'type': 'Hidden Gems',
      'description': "Sri Lanka's tallest waterfall",
    },
    {
      'image':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTa-HhKziNHgCyMqvp5azI9D40xDLuNhHAVCQ&s?w=400',
      'title': 'Madolsima',
      'rating': '5.0',
      'category': 'Hidden Retreats',
      'type': 'Hidden Gems',
      'description': 'Secret waterfall paradise',
    },
  ];

  List<Map<String, String>> get _filteredPlaces {
    List<Map<String, String>> filtered = _allPlaces;

    // Filter by type
    if (_selectedFilter != 'All') {
      filtered = filtered
          .where((place) => place['type'] == _selectedFilter)
          .toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((place) {
        final title = place['title']!.toLowerCase();
        final category = place['category']!.toLowerCase();
        final description = place['description']!.toLowerCase();
        final query = _searchQuery.toLowerCase();
        return title.contains(query) ||
            category.contains(query) ||
            description.contains(query);
      }).toList();
    }

    return filtered;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredPlaces = _filteredPlaces;

    return Column(
      children: [
        // Search Bar
        Container(
          padding: const EdgeInsets.all(16),
          color: const Color(0xFF2D5F5D),
          child: Column(
            children: [
              TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search destinations...',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                  prefixIcon: const Icon(Icons.search, color: Colors.white),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.white),
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                              _searchQuery = '';
                            });
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
            ],
          ),
        ),

        // Filter Chips
        Container(
          height: 60,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _filters.length,
            itemBuilder: (context, index) {
              final filter = _filters[index];
              final isSelected = filter == _selectedFilter;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(filter),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedFilter = filter;
                    });
                  },
                  backgroundColor: Colors.grey[200],
                  selectedColor: const Color(0xFF2D5F5D),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  checkmarkColor: Colors.white,
                ),
              );
            },
          ),
        ),

        // Results Count
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Text(
                '${filteredPlaces.length} ${filteredPlaces.length == 1 ? 'destination' : 'destinations'} found',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ),

        // Places Grid
        Expanded(
          child: filteredPlaces.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_off,
                        size: 80,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No destinations found',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Try adjusting your search or filters',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: filteredPlaces.length,
                  itemBuilder: (context, index) {
                    final place = filteredPlaces[index];
                    return _buildPlaceCard(place, index);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildPlaceCard(Map<String, String> place, int index) {
    final placeId = '${place['category']}_explore_$index';

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          // Navigate to category detail page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CategoryDetailPage(
                categoryName: place['category']!,
                categoryImage: place['image']!,
              ),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with heart button
            Stack(
              children: [
                SizedBox(
                  height: 140,
                  width: double.infinity,
                  child: Image.network(
                    place['image']!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.image_not_supported,
                          size: 40,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Consumer<SavedPlacesManager>(
                    builder: (context, savedManager, child) {
                      final isSaved = savedManager.isSaved(placeId);
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: Icon(
                            isSaved ? Icons.favorite : Icons.favorite_border,
                            color: isSaved ? Colors.red : Colors.grey[700],
                            size: 22,
                          ),
                          onPressed: () {
                            savedManager.toggleSave(
                              SavedPlace(
                                id: placeId,
                                image: place['image']!,
                                title: place['title']!,
                                rating: place['rating']!,
                                category: place['category']!,
                              ),
                            );

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  isSaved
                                      ? 'Removed from saved places'
                                      : 'Added to saved places',
                                ),
                                duration: const Duration(seconds: 2),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                          padding: const EdgeInsets.all(8),
                          constraints: const BoxConstraints(),
                        ),
                      );
                    },
                  ),
                ),
                // Category badge
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2D5F5D).withOpacity(0.9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      place['type']!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Place info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      place['title']!,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D5F5D),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      place['description']!,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          place['rating']!,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}