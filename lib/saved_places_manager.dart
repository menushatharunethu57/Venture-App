import 'package:flutter/material.dart';

class SavedPlace {
  final String id;
  final String image;
  final String title;
  final String rating;
  final String category;

  SavedPlace({
    required this.id,
    required this.image,
    required this.title,
    required this.rating,
    required this.category,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
      'title': title,
      'rating': rating,
      'category': category,
    };
  }

  factory SavedPlace.fromJson(Map<String, dynamic> json) {
    return SavedPlace(
      id: json['id'],
      image: json['image'],
      title: json['title'],
      rating: json['rating'],
      category: json['category'],
    );
  }
}

class SavedPlacesManager extends ChangeNotifier {
  final List<SavedPlace> _savedPlaces = [];

  List<SavedPlace> get savedPlaces => List.unmodifiable(_savedPlaces);

  bool isSaved(String placeId) {
    return _savedPlaces.any((place) => place.id == placeId);
  }

  void toggleSave(SavedPlace place) {
    if (isSaved(place.id)) {
      _savedPlaces.removeWhere((p) => p.id == place.id);
    } else {
      _savedPlaces.add(place);
    }
    notifyListeners();
  }

  void removeSaved(String placeId) {
    _savedPlaces.removeWhere((p) => p.id == placeId);
    notifyListeners();
  }
}