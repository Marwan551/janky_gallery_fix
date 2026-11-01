import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/photo.dart';

class PhotoRepository {
  Future<List<Photo>> loadPhotos() async {
    final raw = await rootBundle.loadString('assets/data/photos.json');
    final data = jsonDecode(raw) as List<dynamic>;
    final photos = data
        .map((item) => Photo.fromJson(item as Map<String, dynamic>))
        .toList();
    photos.sort((a, b) => _trendingScore(b).compareTo(_trendingScore(a)));
    return photos;
  }

  double _trendingScore(Photo photo) {
    final commentLikes =
        photo.comments.fold<int>(0, (sum, c) => sum + c.likes);
    return photo.likes * 2 + commentLikes + photo.comments.length * 5.0;
  }
}
