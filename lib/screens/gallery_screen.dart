import 'dart:math';
import 'package:flutter/material.dart';
import '../data/photo_repository.dart';
import '../main.dart';
import '../models/photo.dart';
import '../widgets/format.dart';
import '../widgets/photo_card.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key, required this.repository});

  final PhotoRepository repository;

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;
  late final Future<List<Photo>> _photosFuture;
  final _scrollController = ScrollController();
  bool _scrollTestRunning = false;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _photosFuture = widget.repository.loadPhotos().then((photos) {
      debugPrint(
          '[startup] ${photos.length} photos ready after '
          '${startupStopwatch.elapsedMilliseconds} ms');
      return photos;
    });
  }

  @override
  void dispose() {
    _pulse.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  /// Scrolls down about 25,000 pixels and back at a fixed speed
  /// (2,500 px/s), so performance measurements are repeatable.
  Future<void> _runScrollTest() async {
    if (_scrollTestRunning || !_scrollController.hasClients) return;
    setState(() => _scrollTestRunning = true);
    debugPrint('[scroll test] started');
    final watch = Stopwatch()..start();
    final target = min(_scrollController.position.maxScrollExtent, 25000.0);
    final duration = Duration(milliseconds: (target / 2.5).round());
    await _scrollController.animateTo(target,
        duration: duration, curve: Curves.linear);
    await _scrollController.animateTo(0,
        duration: duration, curve: Curves.linear);
    debugPrint('[scroll test] finished in ${watch.elapsedMilliseconds} ms');
    if (mounted) setState(() => _scrollTestRunning = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gallery'),
        actions: [
          IconButton(
            tooltip: 'Run scroll test',
            onPressed: _scrollTestRunning ? null : _runScrollTest,
            icon: const Icon(Icons.speed),
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: _pulse,
        builder: (context, _) {
          return FutureBuilder<List<Photo>>(
            future: _photosFuture,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final photos = snapshot.data!;
              return ListView.builder(
                controller: _scrollController,
                itemCount: photos.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return _buildHeader(context, photos);
                  }
                  return PhotoCard(photo: photos[index - 1]);
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, List<Photo> photos) {
    final totalComments =
        photos.fold<int>(0, (sum, p) => sum + p.comments.length);
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red.withValues(alpha: 0.3 + 0.7 * _pulse.value),
            ),
          ),
          SizedBox(width: 8),
          Text('LIVE', style: TextStyle(fontWeight: FontWeight.bold)),
          Spacer(),
          Text(
            '${formatCount(photos.length)} photos · '
            '${formatCount(totalComments)} comments',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
