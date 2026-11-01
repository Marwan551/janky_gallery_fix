import 'package:flutter/material.dart';

import 'data/photo_repository.dart';
import 'screens/gallery_screen.dart';

final startupStopwatch = Stopwatch();

void main() {
  startupStopwatch.start();
  runApp(GalleryApp(repository: PhotoRepository()));
}

class GalleryApp extends StatelessWidget {
  const GalleryApp({super.key, required this.repository});

  final PhotoRepository repository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gallery',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.deepOrange),
      home: GalleryScreen(repository: repository),
    );
  }
}
