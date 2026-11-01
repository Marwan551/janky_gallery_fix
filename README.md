# Gallery

A photo browsing app: a feed of 500 photos with likes and comments, and a full-screen photo view.

## Setup

This repository contains only the Dart code and assets. Generate the platform folders once:

```bash
flutter create . --project-name janky_gallery --platforms android,ios
flutter pub get
```

`flutter create .` does not overwrite existing files.

## Running for performance work

Always measure in **profile mode on a real device**:

```bash
flutter run --profile
```

Then open Flutter DevTools from the link printed in the terminal.

Built-in helpers:

- The console prints `[startup] ... photos ready after N ms` when the feed data is loaded.
- The speed icon in the app bar runs a **scroll test**: it scrolls down about 25,000 pixels and back at a fixed
  speed, so you can repeat the same measurement before and after a change.

## Structure

```
lib/
  main.dart                 App entry point and startup timer
  data/photo_repository.dart  Loads and sorts photos from assets/data/photos.json
  models/photo.dart         Photo and Comment
  screens/                  Gallery feed, full-screen photo
  widgets/                  Photo card, formatting helpers
assets/
  photos/                   Original photos (full resolution)
  data/photos.json          Feed data
```
