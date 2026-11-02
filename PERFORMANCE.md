# Performance Optimizations

## #1 - Lack of Lazy Loading in `GalleryScreen`

- **Issue**: Using `SingleChildScrollView` with `ListView(shrinkWrap: true, physics: NeverScrollableScrollPhysics())` forced loading all 500 images at once, causing janky frames.
- **Before**:
  ```dart
  return SingleChildScrollView(
    controller: _scrollController,
    child: Column(
      children: [
        _buildHeader(context, photos),
        ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            for (final photo in photos) PhotoCard(photo: photo),
          ],
        ),
      ],
    ),
  );
  ```
- **Solution**: Replaced with `ListView.builder` for efficient lazy loading of items:
  ```dart
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
  ```

---

## #2 - Heavy JSON Decoding and Sorting on UI Thread

- **Issue**: Decoding JSON, mapping 500 photos with comments, and sorting by trending score on the main thread caused startup jank.
- **Solution**: Offloaded JSON decoding, model mapping (`Photo.fromJson`), and trending score sorting to a background isolate using `Isolate.run`:
  ```dart
  Future<List<Photo>> loadPhotos() async {
    final raw = await rootBundle.loadString('assets/data/photos.json');
    return Isolate.run(() {
      final data = jsonDecode(raw) as List<dynamic>;
      final photos = data
          .map((item) => Photo.fromJson(item as Map<String, dynamic>))
          .toList();
      photos.sort((a, b) => _trendingScore(b).compareTo(_trendingScore(a)));
      return photos;
    });
  }
  ```
