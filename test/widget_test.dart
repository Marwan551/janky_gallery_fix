import 'package:flutter_test/flutter_test.dart';

import 'package:janky_gallery/data/photo_repository.dart';
import 'package:janky_gallery/main.dart';

void main() {
  testWidgets('shows the gallery title', (tester) async {
    await tester.pumpWidget(GalleryApp(repository: PhotoRepository()));
    expect(find.text('Gallery'), findsOneWidget);
  });
}
