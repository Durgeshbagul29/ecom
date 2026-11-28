import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:ecom/features/personalization/screens/profile/widgets/profile_image_cropper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';

Future<Uint8List> _createSolidPngBytes(int width, int height) async {
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(
    recorder,
    Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()),
  );
  canvas.drawRect(
    Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()),
    Paint()..color = const Color(0xFF0074D9),
  );
  final picture = recorder.endRecording();
  final image = await picture.toImage(width, height);
  picture.dispose();
  final data = await image.toByteData(format: ui.ImageByteFormat.png);
  image.dispose();
  return data!.buffer.asUint8List();
}

void main() {
  testWidgets('ProfileImageCropper crops rectangular image into square PNG',
      (WidgetTester tester) async {
    final sourceBytes = await tester.runAsync(
      () => _createSolidPngBytes(800, 400),
    );
    expect(sourceBytes, isNotNull);

    final inputFile = XFile.fromData(
      sourceBytes!,
      name: 'sample.png',
      mimeType: 'image/png',
    );

    XFile? croppedResult;

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () async {
                  croppedResult = await ProfileImageCropper.show(
                    context,
                    imageFile: inputFile,
                  );
                },
                child: const Text('Open Cropper'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open Cropper'));
    // Let MaterialPageRoute transition finish while image decodes via runAsync.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    expect(find.text('Move and Scale'), findsOneWidget);
    expect(find.text('Done'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);

    for (int i = 0; i < 50 && find.byType(RawImage).evaluate().isEmpty; i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 20)),
      );
      await tester.pump();
    }
    expect(find.byType(RawImage), findsOneWidget);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Done'));
    await tester.pump();
    for (int i = 0; i < 50 && croppedResult == null; i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 20)),
      );
      await tester.pump();
    }
    await tester.pumpAndSettle();

    expect(croppedResult, isNotNull);
    expect(croppedResult!.name, isNotEmpty);
    expect(croppedResult!.path, isNotEmpty);
    final croppedBytes = await tester.runAsync(() => croppedResult!.readAsBytes());
    expect(croppedBytes, isNotNull);

    await tester.runAsync(() async {
      final f = File(croppedResult!.path);
      if (await f.exists()) {
        await f.delete();
      }
    });

    final decoded = await tester.runAsync(() async {
      final codec = await ui.instantiateImageCodec(croppedBytes!);
      final frame = await codec.getNextFrame();
      codec.dispose();
      return frame.image;
    });

    expect(decoded, isNotNull);
    expect(decoded!.width, equals(400));
    expect(decoded.height, equals(400));
    decoded.dispose();
  });
}
