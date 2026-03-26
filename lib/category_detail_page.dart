import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'saved_places_manager.dart';

class CategoryDetailPage extends StatelessWidget {
  final String categoryName;
  final String categoryImage;

  const CategoryDetailPage({
    super.key,
    required this.categoryName,
    required this.categoryImage,
  });

  @override
  Widget build(BuildContext context) {
    final locations = _generateLocations(categoryName);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2D5F5D),
        title: Text(
          categoryName,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: locations.length,
        itemBuilder: (context, index) {
          return _buildLocationCard(
            context,
            locations[index]['image']!,
            locations[index]['title']!,
            locations[index]['rating']!,
            '${categoryName}_$index', // Unique ID for each place
          );
        },
      ),
    );
  }

  Widget _buildLocationCard(
    BuildContext context,
    String imageUrl,
    String title,
    String rating,
    String placeId,
  ) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {},
        child: SizedBox(
          height: 120,
          child: Row(
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: Image.network(
                  imageUrl,
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
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D5F5D),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          ...List.generate(5, (starIndex) {
                            return Icon(
                              starIndex < double.parse(rating).floor()
                                  ? Icons.star
                                  : (starIndex < double.parse(rating)
                                        ? Icons.star_half
                                        : Icons.star_border),
                              color: Colors.amber,
                              size: 20,
                            );
                          }),
                          const SizedBox(width: 6),
                          Text(
                            rating,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Consumer<SavedPlacesManager>(
                builder: (context, savedManager, child) {
                  final isSaved = savedManager.isSaved(placeId);
                  return IconButton(
                    icon: Icon(
                      isSaved ? Icons.favorite : Icons.favorite_border,
                      color: isSaved ? Colors.red : Colors.grey,
                      size: 28,
                    ),
                    onPressed: () {
                      savedManager.toggleSave(
                        SavedPlace(
                          id: placeId,
                          image: imageUrl,
                          title: title,
                          rating: rating,
                          category: categoryName,
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
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Map<String, String>> _generateLocations(String category) {
    switch (category) {
      case 'Alpine Escapes':
        return [
          {
            'image':
                'https://images.unsplash.com/photo-1653151106766-52f14da3bb68?q=80&w=1173&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D?w=400',
            'title': "Adam's Peak",
            'rating': '4.8',
          },
          {
            'image':
                'https://images.unsplash.com/photo-1711719725618-1d70d2d7b4b4?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D?w=400',
            'title': 'Ella Rock',
            'rating': '4.9',
          },
          {
            'image':
                'https://images.unsplash.com/photo-1613693687360-8b0d54705746?q=80&w=1332&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D?w=400',
            'title': "Little Adam's Peak",
            'rating': '4.7',
          },
          {
            'image':
                'https://upload.wikimedia.org/wikipedia/commons/thumb/9/9d/Knuckles_Range.JPG/500px-Knuckles_Range.JPG?w=400',
            'title': 'Knuckles Mountain Range',
            'rating': '4.6',
          },
          {
            'image':
                'https://images.unsplash.com/photo-1695188604020-5b508484d5a0?q=80&w=1074&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D?w=400',
            'title': "Horton Plains (World's End)",
            'rating': '4.5',
          },
          {
            'image':
                'https://images.unsplash.com/photo-1559038331-fe26f6746fed?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D?w=400',
            'title': 'Pidurangala Rock',
            'rating': '4.8',
          },
          {
            'image':
                'https://media-cdn.tripadvisor.com/media/attractions-splice-spp-720x480/0b/1b/32/90.jpg?w=1920?w=400',
            'title': 'Kirigalpoththa',
            'rating': '5.0',
          },
          {
            'image':
                'https://images.unsplash.com/photo-1595433754878-7913c24653af?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D?w=400',
            'title': 'Hanthana Mountain Range',
            'rating': '4.9',
          },
          {
            'image':
                'https://images.unsplash.com/photo-1621820400783-62c557fdd8e1?q=80&w=1074&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D?w=400',
            'title': 'The Pekoe Trail',
            'rating': '4.7',
          },
          {
            'image':
                'https://upload.wikimedia.org/wikipedia/commons/thumb/9/9a/Bathalegala.jpg/500px-Bathalegala.jpg?w=400',
            'title': 'Bible Rock (Bathalegala)',
            'rating': '4.8',
          },
        ];
      case 'Coastal Havens':
        return [
          {
            'image':
                'https://images.unsplash.com/photo-1580910527739-556eb89f9d65?q=80&w=1074&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D?w=400',
            'title': 'Mirissa',
            'rating': '5.0',
          },
          {
            'image':
                'https://images.unsplash.com/photo-1574895527713-07d8c1b53bba?q=80&w=736&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D?w=400',
            'title': 'Hiriketiya',
            'rating': '4.9',
          },
          {
            'image':
                'https://images.unsplash.com/photo-1695090177375-0351b2314e3a?q=80&w=1151&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D?w=400',
            'title': 'Nilaveli',
            'rating': '4.8',
          },
          {
            'image':
                'https://images.unsplash.com/photo-1665765416044-7107644ecac2?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D?w=400',
            'title': 'Unawatuna',
            'rating': '4.7',
          },
          {
            'image':
                'https://images.unsplash.com/photo-1724031948257-8b3c68232ccc?q=80&w=670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D?w=400',
            'title': 'Arugam Bay',
            'rating': '4.9',
          },
          {
            'image':
                'https://images.unsplash.com/photo-1706256840752-c9444038ac3b?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D?w=400',
            'title': 'Bentota',
            'rating': '4.8',
          },
          {
            'image':
                'https://img.traveltriangle.com/blog/wp-content/uploads/2024/06/shutterstock_2405068137-Copy.jpg?w=400',
            'title': 'Silent Beach (Tangalle)',
            'rating': '4.6',
          },
          {
            'image':
                'https://images.unsplash.com/photo-1659731649610-49b7a2bb0d30?q=80&w=1175&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D?w=400',
            'title': 'Dalawella',
            'rating': '5.0',
          },
          {
            'image':
                'https://images.unsplash.com/photo-1596967829313-0fe1918d3358?q=80&w=1293&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D?w=400',
            'title': 'Pasikuda',
            'rating': '4.7',
          },
          {
            'image':
                'https://images.unsplash.com/photo-1688222060517-60ffd3eef90b?q=80&w=1074&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D?w=400',
            'title': 'Jungle Beach',
            'rating': '4.8',
          },
        ];
      case 'Urban Pulse':
        return [
          {
            'image':
                'https://images.unsplash.com/photo-1581420455468-e748ad82ff50?q=80&w=687&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D?w=400',
            'title': 'Kandy',
            'rating': '4.9',
          },
          {
            'image':
                'https://images.unsplash.com/photo-1509982724584-2ce0d4366d8b?q=80&w=1230&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D?w=400',
            'title': 'Galle',
            'rating': '4.8',
          },
          {
            'image':
                'https://images.unsplash.com/photo-1561426802-392f5b6290cf?q=80&w=735&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D?w=400',
            'title': 'Colombo',
            'rating': '5.0',
          },
          {
            'image':
                'https://images.unsplash.com/photo-1619974643633-12acfdcedd16?q=80&w=1172&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D?w=400',
            'title': 'Nuwara Eliya',
            'rating': '4.7',
          },
          {
            'image':
                'https://images.unsplash.com/photo-1578519050142-afb511e518de?q=80&w=687&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D?w=400',
            'title': 'Ella',
            'rating': '4.8',
          },
          {
            'image':
                'https://images.unsplash.com/photo-1712746547176-3a4812c63da8?q=80&w=1332&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D?w=400',
            'title': 'Anuradhapura',
            'rating': '4.9',
          },
          {
            'image':
                'https://images.unsplash.com/photo-1591410448119-1b49cbb3b83e?q=80&w=1074&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D?w=400',
            'title': 'Jaffna',
            'rating': '4.6',
          },
          {
            'image':
                'https://images.pexels.com/photos/34804250/pexels-photo-34804250.jpeg?w=400',
            'title': 'Trincomalee',
            'rating': '4.8',
          },
          {
            'image':
                'https://upload.wikimedia.org/wikipedia/commons/d/d7/Negombo%2C_street_%28004%29_%28cropped%29.JPG?w=400',
            'title': 'Negombo',
            'rating': '4.7',
          },
          {
            'image':
                'https://images.pexels.com/photos/5042886/pexels-photo-5042886.jpeg?w=400',
            'title': 'Matara',
            'rating': '4.5',
          },
        ];
      case 'Ancient Wonders':
        return [
          {
            'image':
                'https://images.unsplash.com/photo-1612862862126-865765df2ded?w=400',
            'title': 'Sigiriya Rock Fortress',
            'rating': '5.0',
          },
          {
            'image':
                'https://images.pexels.com/photos/33171754/pexels-photo-33171754.jpeg?w=400',
            'title': 'Polonnaruwa Ancient City',
            'rating': '4.9',
          },
          {
            'image':
                'https://images.pexels.com/photos/35598967/pexels-photo-35598967.jpeg?w=400',
            'title': 'Dambulla Cave Temple',
            'rating': '4.8',
          },
          {
            'image':
                'https://upload.wikimedia.org/wikipedia/commons/thumb/4/46/Jetavanaramaya_Stupa_profile.jpg/500px-Jetavanaramaya_Stupa_profile.jpg?w=400',
            'title': 'Jetavanarama Stupa',
            'rating': '4.9',
          },
          {
            'image':
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSsE3OJbOMku-GjkJoTdexPtsXV9zgFDLqtMQ&s?w=400',
            'title': 'Gal Vihara',
            'rating': '5.0',
          },
          {
            'image':
                'https://images.unsplash.com/photo-1665849050332-8d5d7e59afb6?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D?w=400',
            'title': 'Temple of the Sacred Tooth Relic',
            'rating': '4.8',
          },
          {
            'image':
                'https://images.pexels.com/photos/17092145/pexels-photo-17092145.jpeg?w=400',
            'title': 'Mihintale',
            'rating': '4.7',
          },
          {
            'image':
                'https://upload.wikimedia.org/wikipedia/commons/3/3c/Buda_de_Avukana_-_03.jpg?w=1200&h=-1&s=1?w=400',
            'title': 'Avukana Buddha',
            'rating': '5.0',
          },
          {
            'image':
                'https://images.pexels.com/photos/32548024/pexels-photo-32548024.jpeg?w=400',
            'title': 'Yapahuwa Rock Fortress',
            'rating': '4.8',
          },
          {
            'image':
                'https://www.lanka-excursions-holidays.com/uploads/4/0/2/1/40216937/8967612_orig.jpg?w=400',
            'title': 'Buduruwagala',
            'rating': '4.6',
          },
        ];
      case 'Wild Safaris':
        return [
          {
            'image':
                'https://www.thetimes.com/imageserver/image/%2Fmethode%2Ftimes%2Fprod%2Fweb%2Fbin%2F50e9e8f5-f1ca-4a08-9b7f-18b15c011582.jpg?crop=3543%2C1993%2C553%2C920?w=400',
            'title': 'Yala National Park',
            'rating': '5.0',
          },
          {
            'image':
                'https://www.serendibtrail.com/content/images/size/w1200/2024/10/udawalawe-national-park.webp?w=400',
            'title': 'Udawalawe National Park',
            'rating': '4.9',
          },
          {
            'image':
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcScALsTYj6QxaPybHmhHATOPkLHPKL5pb2mgA&s?w=400',
            'title': 'Minneriya National Park',
            'rating': '4.8',
          },
          {
            'image':
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQWU78ydU4WL7-p4BrNd77XmPkfIKMy99rgkg&s?w=400',
            'title': 'Wilpattu National Park',
            'rating': '4.9',
          },
          {
            'image':
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQQxK2IluJXKY_XVkWsi-RlxrUugZZc6ifszg&s?w=400',
            'title': 'Bundala National Park',
            'rating': '4.7',
          },
          {
            'image':
                'https://media-cdn.tripadvisor.com/media/attractions-splice-spp-720x480/10/5b/7b/1c.jpg?w=400',
            'title': 'Kumana National Park',
            'rating': '5.0',
          },
          {
            'image':
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRv8PBpY-i6PCUQCeHGmTsAosoSV0XVHkYoGA&s?w=400',
            'title': 'Sinharaja Forest Reserve',
            'rating': '4.8',
          },
          {
            'image':
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSm40B-B2cV7DihUkfO6OrCUHAS1_1oijymNQ&s?w=400',
            'title': 'Pigeon Island',
            'rating': '5.0',
          },
          {
            'image':
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT4jIFTkj6hCb6q2l03RYFmAuNb7DYOvF-wfw&s?w=400',
            'title': 'Kalpitiya',
            'rating': '4.6',
          },
          {
            'image':
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQtdqZnZFhtjjxynYETQ9UxveHxdmV5XRc_FQ&s?w=400',
            'title': 'Gal Oya National Park',
            'rating': '4.7',
          },
        ];
      case 'Hidden Retreats':
        return [
          {
            'image':
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ3mWrHBlSuGgnxeTrU_6SjKKlJRq3Cqbgwkg&s?w=400',
            'title': 'Riverston',
            'rating': '5.0',
          },
          {
            'image':
                'https://www.lanka-excursions-holidays.com/uploads/4/0/2/1/40216937/delft-island-feral-horses-title-image_orig.jpg?w=400',
            'title': 'Delft Island',
            'rating': '4.9',
          },
          {
            'image':
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT0mGQxX9xpA474zXgbTfiSK8hjdCN_URRqFg&s?w=400',
            'title': 'Ritigala',
            'rating': '4.8',
          },
          {
            'image':
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTt-cKES1E2K_2qasrLfwjf3_vc6Z6-6lFKBg&s?w=400',
            'title': 'Mannar Island',
            'rating': '4.7',
          },
          {
            'image':
                'https://upload.wikimedia.org/wikipedia/commons/c/cb/Bambarakanda_Waterfall.jpg?w=400',
            'title': 'Bambarakanda Falls',
            'rating': '4.9',
          },
          {
            'image':
                'https://media-cdn.tripadvisor.com/media/photo-s/1a/85/3f/12/mandaram-nuwara-is-a.jpg?w=400',
            'title': 'Mandaram Nuwara',
            'rating': '4.8',
          },
          {
            'image':
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTa-HhKziNHgCyMqvp5azI9D40xDLuNhHAVCQ&s?w=400',
            'title': 'Madolsima',
            'rating': '5.0',
          },
          {
            'image':
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQy3BfyHjLODWZ0ZUtjrAOK6gngc8-zaIjpGg&s?w=400',
            'title': 'Jami Ul-Alfar (Red Mosque)',
            'rating': '4.6',
          },
          {
            'image':
                'https://www.wondersofceylon.com/content/images/2024/01/2f895e83-f9bb-411d-b811-93d8ffe28097.jpg?w=400',
            'title': 'Nil Diya Pokuna',
            'rating': '4.7',
          },
          {
            'image':
                'https://d2r2v0jxjsbm0p.cloudfront.net/2019/03/MULKIRIGALA-ROCK-TEMPLE-1.jpg?w=400',
            'title': 'Mulkirigala Rock Temple',
            'rating': '4.8',
          },
        ];
      default:
        return [];
    }
  }
}