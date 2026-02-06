import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
      'place_id': id,
      'image': image,
      'title': title,
      'rating': rating,
      'category': category,
    };
  }

  factory SavedPlace.fromJson(Map<String, dynamic> json) {
    return SavedPlace(
      id: json['place_id'],
      image: json['image'],
      title: json['title'],
      rating: json['rating'],
      category: json['category'],
    );
  }
}

class SavedPlacesManager extends ChangeNotifier {
  final List<SavedPlace> _savedPlaces = [];
  final SupabaseClient _supabase = Supabase.instance.client;
  bool _isLoading = false;

  List<SavedPlace> get savedPlaces => List.unmodifiable(_savedPlaces);
  bool get isLoading => _isLoading;

  bool isSaved(String placeId) {
    return _savedPlaces.any((place) => place.id == placeId);
  }

  Future<void> loadSavedPlaces() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      _savedPlaces.clear();
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final response = await _supabase
          .from('saved_places')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      _savedPlaces.clear();
      for (var item in response) {
        _savedPlaces.add(SavedPlace.fromJson(item));
      }
    } catch (e) {
      debugPrint('Error loading saved places: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleSave(SavedPlace place) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    try {
      if (isSaved(place.id)) {
        await _supabase
            .from('saved_places')
            .delete()
            .eq('user_id', userId)
            .eq('place_id', place.id);

        _savedPlaces.removeWhere((p) => p.id == place.id);
      } else {
        final data = {
          'user_id': userId,
          ...place.toJson(),
        };

        await _supabase.from('saved_places').insert(data);
        _savedPlaces.add(place);
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error toggling save: $e');
      rethrow;
    }
  }

  Future<void> removeSaved(String placeId) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    try {
      await _supabase
          .from('saved_places')
          .delete()
          .eq('user_id', userId)
          .eq('place_id', placeId);

      _savedPlaces.removeWhere((p) => p.id == placeId);
      notifyListeners();
    } catch (e) {
      debugPrint('Error removing saved place: $e');
      rethrow;
    }
  }

  void clearSavedPlaces() {
    _savedPlaces.clear();
    notifyListeners();
  }
}