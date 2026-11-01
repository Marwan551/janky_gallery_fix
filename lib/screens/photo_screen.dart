import 'package:flutter/material.dart';

import '../models/photo.dart';
import '../widgets/format.dart';

class PhotoScreen extends StatelessWidget {
  const PhotoScreen({super.key, required this.photo});

  final Photo photo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(photo.title),
      ),
      body: Column(
        children: [
          Expanded(
            child: InteractiveViewer(
              maxScale: 6,
              child: Center(child: Image.asset(photo.asset)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              '${photo.author} · ${formatDate(photo.takenAt)} · '
              '${photo.tags.map((t) => '#$t').join(' ')}',
              style: const TextStyle(color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }
}
