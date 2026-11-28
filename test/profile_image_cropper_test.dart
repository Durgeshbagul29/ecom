import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:ecom/data/services/cloudinary_service.dart';
import 'package:ecom/features/personalization/screens/profile/widgets/profile_image_cropper.dart';
import 'package:ecom/features/personalization/screens/profile/widgets/profile_image_viewer.dart';
import 'package:ecom/utils/constants/cloudinary_constants.dart';
import 'package:ecom/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
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

Future<XFile?> _runCropperWithInput(
  WidgetTester tester,
  XFile inputFile,
) async {
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
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 350));

  expect(find.text('Move and Scale'), findsOneWidget);

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

  return croppedResult;
}

void main() {
  testWidgets('ProfileImageCropper crops PNG image into square PNG',
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

    final croppedResult = await _runCropperWithInput(tester, inputFile);

    expect(croppedResult, isNotNull);
    expect(croppedResult!.name, endsWith('.png'));
    expect(croppedResult.path, isNotEmpty);

    final croppedBytes =
        await tester.runAsync(() => croppedResult.readAsBytes());
    expect(croppedBytes, isNotNull);

    await tester.runAsync(() async {
      final f = File(croppedResult.path);
      if (await f.exists()) await f.delete();
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

  testWidgets('ProfileImageCropper crops JPG image into square PNG',
      (WidgetTester tester) async {
    final jpgFile = XFile('assets/products/1.jpg', mimeType: 'image/jpeg');
    final croppedResult = await _runCropperWithInput(tester, jpgFile);

    expect(croppedResult, isNotNull);
    expect(croppedResult!.name, endsWith('.png'));
    expect(croppedResult.path, isNotEmpty);

    final croppedBytes =
        await tester.runAsync(() => croppedResult.readAsBytes());
    expect(croppedBytes, isNotNull);

    await tester.runAsync(() async {
      final f = File(croppedResult.path);
      if (await f.exists()) await f.delete();
    });

    final decoded = await tester.runAsync(() async {
      final codec = await ui.instantiateImageCodec(croppedBytes!);
      final frame = await codec.getNextFrame();
      codec.dispose();
      return frame.image;
    });

    expect(decoded, isNotNull);
    expect(decoded!.width, equals(decoded.height));
    expect(decoded.width, greaterThan(0));
    decoded.dispose();
  });

  test('CloudinaryService.resolveUploadFileName supports PNG and JPG variants',
      () {
    expect(
      CloudinaryService.resolveUploadFileName(XFile('/tmp/avatar.png')),
      equals('avatar.png'),
    );
    expect(
      CloudinaryService.resolveUploadFileName(XFile('/tmp/photo.jpg')),
      equals('photo.jpg'),
    );
    expect(
      CloudinaryService.resolveUploadFileName(XFile('/tmp/photo.JPEG')),
      equals('photo.JPEG'),
    );
    expect(
      CloudinaryService.resolveUploadFileName(
        XFile.fromData(Uint8List(0), mimeType: 'image/jpeg'),
      ),
      endsWith('.jpg'),
    );
    expect(
      CloudinaryService.resolveUploadFileName(
        XFile('/tmp/picked_image'),
        headerBytes: Uint8List.fromList([0xFF, 0xD8, 0xFF, 0xE0]),
      ),
      equals('picked_image.jpg'),
    );
    expect(
      CloudinaryService.resolveUploadFileName(
        XFile('/tmp/picked_image'),
        headerBytes: Uint8List.fromList([0x89, 0x50, 0x4E, 0x47]),
      ),
      equals('picked_image.png'),
    );
  });

  testWidgets('ProfileImageCropper rejects GIF images',
      (WidgetTester tester) async {
    // GIF89a minimal header bytes
    final gifBytes = Uint8List.fromList([
      0x47, 0x49, 0x46, 0x38, 0x39, 0x61, 0x01, 0x00, 0x01, 0x00, 0x80, 0x00,
      0x00, 0xFF, 0xFF, 0xFF, 0x00, 0x00, 0x00, 0x2C, 0x00, 0x00, 0x00, 0x00,
      0x01, 0x00, 0x01, 0x00, 0x00, 0x02, 0x02, 0x44, 0x01, 0x00, 0x3B,
    ]);
    final gifFile = XFile.fromData(
      gifBytes,
      name: 'anim.gif',
      mimeType: 'image/gif',
    );

    expect(
      CloudinaryService.isPngOrJpg(gifFile, headerBytes: gifBytes),
      isFalse,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: ProfileImageCropper(imageFile: gifFile),
      ),
    );

    for (int i = 0;
        i < 25 &&
            find.text('Only PNG and JPG images are supported.').evaluate().isEmpty;
        i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 20)),
      );
      await tester.pump();
    }

    expect(find.text('Only PNG and JPG images are supported.'), findsOneWidget);
  });

  test('CloudinaryService.deleteByToken posts token and handles responses',
      () async {
    expect(await CloudinaryService.deleteByToken('   '), isFalse);

    late Uri capturedUri;
    late Map<String, String> capturedFields;

    final okClient = MockClient((request) async {
      capturedUri = request.url;
      capturedFields = request.bodyFields;
      return http.Response('{"result":"ok"}', 200);
    });

    final deleted = await CloudinaryService.deleteByToken(
      'sample_delete_token_123',
      client: okClient,
    );

    expect(deleted, isTrue);
    expect(capturedUri.toString(), equals(CloudinaryConstants.deleteByTokenUrl));
    expect(capturedFields['token'], equals('sample_delete_token_123'));

    final expiredClient = MockClient(
      (_) async => http.Response('{"error":{"message":"Invalid token"}}', 400),
    );
    expect(
      await CloudinaryService.deleteByToken('expired', client: expiredClient),
      isFalse,
    );
  });

  testWidgets('ProfileImageViewer follows theme mode and zooms full screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData.light(),
        home: const ProfileImageViewer(
          imageUrl: 'assets/products/1.jpg',
          userName: 'Test User',
        ),
      ),
    );

    final lightScaffold = tester.widget<Scaffold>(find.byType(Scaffold));
    expect(lightScaffold.backgroundColor, equals(AppColors.white));

    final viewerBox = tester.getSize(find.byType(InteractiveViewer));
    final screenBox = tester.getSize(find.byType(Scaffold));
    expect(viewerBox, equals(screenBox));
    expect(viewerBox.width, isNot(equals(viewerBox.height)));

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData.dark(),
        themeAnimationDuration: Duration.zero,
        home: const ProfileImageViewer(
          imageUrl: 'assets/products/1.jpg',
          userName: 'Test User',
        ),
      ),
    );
    await tester.pump();

    final darkScaffold = tester.widget<Scaffold>(find.byType(Scaffold));
    expect(darkScaffold.backgroundColor, equals(AppColors.charcoalBlack));
  });

  testWidgets('ProfileImageCropper follows light and dark theme background',
      (WidgetTester tester) async {
    final jpgFile = XFile('assets/products/1.jpg', mimeType: 'image/jpeg');

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData.light(),
        themeAnimationDuration: Duration.zero,
        home: ProfileImageCropper(imageFile: jpgFile),
      ),
    );
    expect(
      tester.widget<Scaffold>(find.byType(Scaffold)).backgroundColor,
      equals(AppColors.white),
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData.dark(),
        themeAnimationDuration: Duration.zero,
        home: ProfileImageCropper(imageFile: jpgFile),
      ),
    );
    await tester.pump();
    expect(
      tester.widget<Scaffold>(find.byType(Scaffold)).backgroundColor,
      equals(AppColors.charcoalBlack),
    );
  });
}
