import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:ecom/data/services/cloudinary_service.dart';
import 'package:ecom/utils/constants/colors.dart';
import 'package:ecom/utils/constants/sizes.dart';
import 'package:ecom/utils/helpers/helper_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

/// WhatsApp-style fixed-square profile image cropper.
///
/// Lets the user pan, pinch-zoom, slider-zoom, and rotate the picked photo
/// inside a fixed 1:1 square frame, then exports a high-resolution lossless PNG
/// without aggressive compression.
class ProfileImageCropper extends StatefulWidget {
  const ProfileImageCropper({
    super.key,
    required this.imageFile,
  });

  final XFile imageFile;

  static Future<XFile?> show(
    BuildContext context, {
    required XFile imageFile,
  }) {
    return Navigator.of(context).push<XFile?>(
      MaterialPageRoute<XFile?>(
        fullscreenDialog: true,
        builder: (_) => ProfileImageCropper(imageFile: imageFile),
      ),
    );
  }

  @override
  State<ProfileImageCropper> createState() => _ProfileImageCropperState();
}

class _ProfileImageCropperState extends State<ProfileImageCropper> {
  static const double _minZoom = 1.0;
  static const double _maxZoom = 4.0;
  static const int _maxExportDimension = 1200;
  static const int _fallbackExportDimension = 900;
  static const int _maxSafePngBytes = 8 * 1024 * 1024;

  ui.Image? _uiImage;
  String? _loadError;
  bool _isExporting = false;

  double _zoom = 1.0;
  Offset _offset = Offset.zero;
  int _quarterTurns = 0;

  double _startZoom = 1.0;
  Offset _startOffset = Offset.zero;
  Offset _startFocalPoint = Offset.zero;
  double _currentCropBoxSize = 300.0;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  @override
  void dispose() {
    _uiImage?.dispose();
    super.dispose();
  }

  Future<void> _loadImage() async {
    ui.ImmutableBuffer? buffer;
    ui.ImageDescriptor? descriptor;
    ui.Codec? codec;
    try {
      final bytes = await widget.imageFile.readAsBytes();
      if (CloudinaryService.detectPngOrJpgExtension(bytes) == null) {
        if (!mounted) return;
        setState(() {
          _loadError = 'Only PNG and JPG images are supported.';
        });
        return;
      }
      buffer = await ui.ImmutableBuffer.fromUint8List(bytes);
      descriptor = await ui.ImageDescriptor.encoded(buffer);

      const maxDecodeDim = 2560;
      if (descriptor.width > maxDecodeDim || descriptor.height > maxDecodeDim) {
        final targetWidth =
            descriptor.width >= descriptor.height ? maxDecodeDim : null;
        final targetHeight =
            descriptor.height > descriptor.width ? maxDecodeDim : null;
        codec = await descriptor.instantiateCodec(
          targetWidth: targetWidth,
          targetHeight: targetHeight,
        );
      } else {
        codec = await ui.instantiateImageCodec(bytes);
      }

      final frame = await codec.getNextFrame();

      if (!mounted) {
        frame.image.dispose();
        return;
      }

      setState(() {
        _uiImage = frame.image;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loadError =
            'Unable to load the selected image. Please choose a valid PNG or JPG image.';
      });
    } finally {
      codec?.dispose();
      descriptor?.dispose();
      buffer?.dispose();
    }
  }

  Size _baseDisplaySize(double cropBoxSize) {
    final image = _uiImage!;
    final isQuarterTurnOdd = _quarterTurns % 2 == 1;
    final effectiveW =
        (isQuarterTurnOdd ? image.height : image.width).toDouble();
    final effectiveH =
        (isQuarterTurnOdd ? image.width : image.height).toDouble();

    final baseScale = effectiveW >= effectiveH
        ? cropBoxSize / effectiveH
        : cropBoxSize / effectiveW;

    return Size(effectiveW * baseScale, effectiveH * baseScale);
  }

  Offset _clampOffset(Offset offset, double zoom, double cropBoxSize) {
    if (_uiImage == null) return Offset.zero;
    final baseSize = _baseDisplaySize(cropBoxSize);
    final scaledW = baseSize.width * zoom;
    final scaledH = baseSize.height * zoom;
    final maxDx = math.max(0.0, (scaledW - cropBoxSize) / 2);
    final maxDy = math.max(0.0, (scaledH - cropBoxSize) / 2);

    return Offset(
      offset.dx.clamp(-maxDx, maxDx),
      offset.dy.clamp(-maxDy, maxDy),
    );
  }

  void _onScaleStart(ScaleStartDetails details) {
    _startZoom = _zoom;
    _startOffset = _offset;
    _startFocalPoint = details.localFocalPoint;
  }

  void _onScaleUpdate(ScaleUpdateDetails details, Size areaSize) {
    if (_uiImage == null || _isExporting) return;

    final newZoom = (_startZoom * details.scale).clamp(_minZoom, _maxZoom);
    final zoomRatio = newZoom / _startZoom;
    final boxCenter = Offset(areaSize.width / 2, areaSize.height / 2);
    final focalFromCenter = _startFocalPoint - boxCenter;
    final panDelta = details.localFocalPoint - _startFocalPoint;

    final rawOffset = panDelta +
        focalFromCenter -
        (focalFromCenter - _startOffset) * zoomRatio;

    setState(() {
      _zoom = newZoom;
      _offset = _clampOffset(rawOffset, newZoom, _currentCropBoxSize);
    });
  }

  void _onDoubleTap() {
    if (_uiImage == null || _isExporting) return;
    setState(() {
      if (_zoom > 1.05) {
        _zoom = 1.0;
        _offset = Offset.zero;
      } else {
        _zoom = 2.0;
        _offset = _clampOffset(_offset * 2.0, _zoom, _currentCropBoxSize);
      }
    });
  }

  void _onZoomSliderChanged(double newZoom) {
    if (_uiImage == null || _isExporting) return;
    final zoomRatio = newZoom / _zoom;
    setState(() {
      _zoom = newZoom;
      _offset = _clampOffset(
        _offset * zoomRatio,
        newZoom,
        _currentCropBoxSize,
      );
    });
  }

  void _rotateRight() {
    if (_uiImage == null || _isExporting) return;
    setState(() {
      _quarterTurns = (_quarterTurns + 1) % 4;
      _offset = _clampOffset(_offset, _zoom, _currentCropBoxSize);
    });
  }

  void _resetTransform() {
    if (_uiImage == null || _isExporting) return;
    setState(() {
      _zoom = 1.0;
      _offset = Offset.zero;
      _quarterTurns = 0;
    });
  }

  Future<Uint8List?> _renderCroppedPng({
    required ui.Image image,
    required double cropX,
    required double cropY,
    required double cropSize,
    required int outSize,
  }) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(
      recorder,
      Rect.fromLTWH(0, 0, outSize.toDouble(), outSize.toDouble()),
    );

    final scale = outSize / cropSize;
    canvas.scale(scale, scale);
    canvas.translate(-cropX, -cropY);

    final imgW = image.width.toDouble();
    final imgH = image.height.toDouble();

    switch (_quarterTurns) {
      case 1:
        canvas.translate(imgH, 0);
        canvas.rotate(math.pi / 2);
        break;
      case 2:
        canvas.translate(imgW, imgH);
        canvas.rotate(math.pi);
        break;
      case 3:
        canvas.translate(0, imgW);
        canvas.rotate(-math.pi / 2);
        break;
      default:
        break;
    }

    canvas.drawImage(
      image,
      Offset.zero,
      Paint()..filterQuality = FilterQuality.high,
    );

    final picture = recorder.endRecording();
    final croppedImage = await picture.toImage(outSize, outSize);
    picture.dispose();

    try {
      final byteData = await croppedImage.toByteData(
        format: ui.ImageByteFormat.png,
      );
      return byteData?.buffer.asUint8List();
    } finally {
      croppedImage.dispose();
    }
  }

  Future<void> _cropAndReturn() async {
    final image = _uiImage;
    if (image == null || _isExporting) return;

    setState(() => _isExporting = true);

    try {
      final cropBoxSize = _currentCropBoxSize;
      final baseSize = _baseDisplaySize(cropBoxSize);
      final scaledW = baseSize.width * _zoom;
      final scaledH = baseSize.height * _zoom;

      final isQuarterTurnOdd = _quarterTurns % 2 == 1;
      final effectiveW =
          (isQuarterTurnOdd ? image.height : image.width).toDouble();
      final effectiveH =
          (isQuarterTurnOdd ? image.width : image.height).toDouble();

      final imgLeft = _offset.dx - scaledW / 2;
      final imgTop = _offset.dy - scaledH / 2;

      final normLeft = ((-cropBoxSize / 2 - imgLeft) / scaledW).clamp(0.0, 1.0);
      final normTop = ((-cropBoxSize / 2 - imgTop) / scaledH).clamp(0.0, 1.0);
      final normSizeX = (cropBoxSize / scaledW).clamp(0.0, 1.0 - normLeft);
      final normSizeY = (cropBoxSize / scaledH).clamp(0.0, 1.0 - normTop);

      final cropX = normLeft * effectiveW;
      final cropY = normTop * effectiveH;
      final cropSize = math.min(normSizeX * effectiveW, normSizeY * effectiveH);

      final targetDimension = cropSize.round().clamp(1, _maxExportDimension);

      Uint8List? pngBytes = await _renderCroppedPng(
        image: image,
        cropX: cropX,
        cropY: cropY,
        cropSize: cropSize,
        outSize: targetDimension,
      );

      if (pngBytes != null &&
          pngBytes.lengthInBytes > _maxSafePngBytes &&
          targetDimension > _fallbackExportDimension) {
        pngBytes = await _renderCroppedPng(
          image: image,
          cropX: cropX,
          cropY: cropY,
          cropSize: cropSize,
          outSize: _fallbackExportDimension,
        );
      }

      if (!mounted) return;
      if (pngBytes == null) {
        setState(() => _isExporting = false);
        return;
      }

      final fileName =
          'profile_picture_${DateTime.now().millisecondsSinceEpoch}.png';

      late final XFile croppedXFile;
      if (kIsWeb) {
        croppedXFile = XFile.fromData(
          pngBytes,
          name: fileName,
          mimeType: 'image/png',
        );
      } else {
        final tempFile = File('${Directory.systemTemp.path}/$fileName');
        await tempFile.writeAsBytes(pngBytes, flush: true);
        if (!mounted) return;
        croppedXFile = XFile(
          tempFile.path,
          name: fileName,
          mimeType: 'image/png',
        );
      }
      Navigator.of(context).pop(croppedXFile);
    } catch (_) {
      if (!mounted) return;
      setState(() => _isExporting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to process image. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = AppHelperFunctions.isDarkMode(context);
    final bgColor = isDark ? AppColors.charcoalBlack : AppColors.white;
    final fgColor = isDark ? AppColors.white : AppColors.textPrimary;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: bgColor,
          foregroundColor: fgColor,
          elevation: 0,
          leading: IconButton(
            onPressed: _isExporting ? null : () => Navigator.of(context).pop(),
            icon: Icon(Icons.close, color: fgColor),
            tooltip: 'Cancel',
          ),
          title: Text(
            'Move and Scale',
            style: TextStyle(
              color: fgColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            IconButton(
              onPressed:
                  (_uiImage == null || _isExporting) ? null : _rotateRight,
              icon: Icon(Icons.rotate_right, color: fgColor),
              tooltip: 'Rotate 90°',
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: _buildCropWorkspace(
                isDark: isDark,
                fgColor: fgColor,
              ),
            ),
            _buildBottomControls(
              isDark: isDark,
              fgColor: fgColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCropWorkspace({
    required bool isDark,
    required Color fgColor,
  }) {
    if (_loadError != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.lg),
          child: Text(
            _loadError!,
            style: TextStyle(color: fgColor),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (_uiImage == null) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final areaSize = constraints.biggest;
        final cropBoxSize = math
            .min(
              areaSize.width - AppSizes.lg,
              areaSize.height - AppSizes.lg,
            )
            .clamp(180.0, 460.0);
        _currentCropBoxSize = cropBoxSize;

        final baseSize = _baseDisplaySize(cropBoxSize);
        final clampedOffset = _clampOffset(_offset, _zoom, cropBoxSize);

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onScaleStart: _onScaleStart,
          onScaleUpdate: (details) => _onScaleUpdate(details, areaSize),
          onDoubleTap: _onDoubleTap,
          child: ClipRect(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Center(
                  child: OverflowBox(
                    maxWidth: double.infinity,
                    maxHeight: double.infinity,
                    child: Transform.translate(
                      offset: clampedOffset,
                      child: SizedBox(
                        width: baseSize.width * _zoom,
                        height: baseSize.height * _zoom,
                        child: RotatedBox(
                          quarterTurns: _quarterTurns,
                          child: RawImage(
                            image: _uiImage,
                            fit: BoxFit.fill,
                            filterQuality: FilterQuality.high,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                IgnorePointer(
                  child: CustomPaint(
                    size: areaSize,
                    painter: _SquareCropOverlayPainter(
                      cropBoxSize: cropBoxSize,
                      scrimColor: isDark
                          ? AppColors.black.withValues(alpha: 0.65)
                          : AppColors.black.withValues(alpha: 0.45),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomControls({
    required bool isDark,
    required Color fgColor,
  }) {
    final canInteract = _uiImage != null && !_isExporting;
    final barBgColor = isDark ? AppColors.blackPrimary : AppColors.lightGrey;
    final secondaryIconColor = isDark ? AppColors.darkGrey : AppColors.textSecondary;
    final sliderInactiveColor = isDark ? AppColors.darkerGrey : AppColors.grey;

    return Container(
      decoration: BoxDecoration(
        color: barBgColor,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.dark : AppColors.borderSecondary,
          ),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(
        AppSizes.md,
        AppSizes.sm,
        AppSizes.md,
        AppSizes.md,
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(
                  Icons.zoom_out,
                  color: secondaryIconColor,
                  size: AppSizes.iconSm + 4,
                ),
                Expanded(
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: AppColors.primary,
                      inactiveTrackColor: sliderInactiveColor,
                      thumbColor: isDark ? AppColors.white : AppColors.primary,
                      overlayColor: AppColors.primary.withValues(alpha: 0.2),
                    ),
                    child: Slider(
                      value: _zoom,
                      min: _minZoom,
                      max: _maxZoom,
                      onChanged: canInteract ? _onZoomSliderChanged : null,
                    ),
                  ),
                ),
                Icon(
                  Icons.zoom_in,
                  color: secondaryIconColor,
                  size: AppSizes.iconSm + 4,
                ),
              ],
            ),
            const SizedBox(height: AppSizes.xs),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed:
                      _isExporting ? null : () => Navigator.of(context).pop(),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: fgColor),
                  ),
                ),
                TextButton.icon(
                  onPressed: canInteract ? _resetTransform : null,
                  icon: Icon(
                    Icons.refresh,
                    color: secondaryIconColor,
                    size: AppSizes.iconSm + 2,
                  ),
                  label: Text(
                    'Reset',
                    style: TextStyle(color: secondaryIconColor),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: canInteract ? _cropAndReturn : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.md,
                      vertical: AppSizes.sm + 2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
                    ),
                  ),
                  icon: _isExporting
                      ? const SizedBox(
                          width: AppSizes.iconSm,
                          height: AppSizes.iconSm,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.white,
                          ),
                        )
                      : const Icon(Icons.check, size: AppSizes.iconSm + 2),
                  label: Text(_isExporting ? 'Saving...' : 'Done'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SquareCropOverlayPainter extends CustomPainter {
  const _SquareCropOverlayPainter({
    required this.cropBoxSize,
    required this.scrimColor,
  });

  final double cropBoxSize;
  final Color scrimColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final cropRect = Rect.fromCenter(
      center: center,
      width: cropBoxSize,
      height: cropBoxSize,
    );

    // Dim everything outside the fixed square crop box.
    final overlayPath = Path()
      ..addRect(Offset.zero & size)
      ..addRect(cropRect)
      ..fillType = PathFillType.evenOdd;

    canvas.drawPath(
      overlayPath,
      Paint()..color = scrimColor,
    );

    // Subtle 3x3 rule-of-thirds grid inside the square.
    final gridPaint = Paint()
      ..color = AppColors.white.withValues(alpha: 0.25)
      ..strokeWidth = 0.8;

    final third = cropBoxSize / 3;
    for (int i = 1; i <= 2; i++) {
      final dx = cropRect.left + third * i;
      final dy = cropRect.top + third * i;
      canvas.drawLine(
        Offset(dx, cropRect.top),
        Offset(dx, cropRect.bottom),
        gridPaint,
      );
      canvas.drawLine(
        Offset(cropRect.left, dy),
        Offset(cropRect.right, dy),
        gridPaint,
      );
    }

    // Subtle circular guide showing how the square frames circular avatars.
    final circleGuidePaint = Paint()
      ..color = AppColors.white.withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawCircle(center, cropBoxSize / 2, circleGuidePaint);

    // Crisp white border around the fixed square crop box.
    final borderPaint = Paint()
      ..color = AppColors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8;
    canvas.drawRect(cropRect, borderPaint);

    // Corner brackets for clear fixed-square framing.
    const cornerLen = 20.0;
    final cornerPaint = Paint()
      ..color = AppColors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.square;

    // Top-left
    canvas.drawLine(
      cropRect.topLeft,
      cropRect.topLeft + const Offset(cornerLen, 0),
      cornerPaint,
    );
    canvas.drawLine(
      cropRect.topLeft,
      cropRect.topLeft + const Offset(0, cornerLen),
      cornerPaint,
    );
    // Top-right
    canvas.drawLine(
      cropRect.topRight,
      cropRect.topRight + const Offset(-cornerLen, 0),
      cornerPaint,
    );
    canvas.drawLine(
      cropRect.topRight,
      cropRect.topRight + const Offset(0, cornerLen),
      cornerPaint,
    );
    // Bottom-left
    canvas.drawLine(
      cropRect.bottomLeft,
      cropRect.bottomLeft + const Offset(cornerLen, 0),
      cornerPaint,
    );
    canvas.drawLine(
      cropRect.bottomLeft,
      cropRect.bottomLeft + const Offset(0, -cornerLen),
      cornerPaint,
    );
    // Bottom-right
    canvas.drawLine(
      cropRect.bottomRight,
      cropRect.bottomRight + const Offset(-cornerLen, 0),
      cornerPaint,
    );
    canvas.drawLine(
      cropRect.bottomRight,
      cropRect.bottomRight + const Offset(0, -cornerLen),
      cornerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _SquareCropOverlayPainter oldDelegate) =>
      oldDelegate.cropBoxSize != cropBoxSize ||
      oldDelegate.scrimColor != scrimColor;
}
