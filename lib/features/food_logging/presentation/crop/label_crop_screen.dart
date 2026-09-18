import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

/// Lets the user draw their own crop rectangle over a photo by dragging
/// each of its four corners independently, rather than being limited to a
/// native cropper's preset aspect ratios and pinch-to-zoom. Pops the
/// chosen rectangle in the source image's own pixel coordinates, or null
/// if the user cancels. The actual pixel crop happens afterwards via
/// `ImageCropService` — this screen only collects the rectangle.
class LabelCropScreen extends StatefulWidget {
  const LabelCropScreen({super.key, required this.imagePath});

  final String imagePath;

  @override
  State<LabelCropScreen> createState() => _LabelCropScreenState();
}

class _LabelCropScreenState extends State<LabelCropScreen> {
  ui.Image? _image;
  Rect? _cropRect;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    final bytes = await File(widget.imagePath).readAsBytes();
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    if (!mounted) return;
    final image = frame.image;
    setState(() {
      _image = image;
      _cropRect = Rect.fromLTWH(
        image.width * 0.1,
        image.height * 0.1,
        image.width * 0.8,
        image.height * 0.8,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final image = _image;
    final cropRect = _cropRect;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Crop nutrition label'),
        actions: [
          TextButton(
            onPressed: image == null || cropRect == null
                ? null
                : () => Navigator.of(context).pop(cropRect),
            child: const Text('Crop', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: image == null || cropRect == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final displayRect = _containRect(
                    Size(image.width.toDouble(), image.height.toDouble()),
                    Size(constraints.maxWidth, constraints.maxHeight),
                  );
                  return _CropCanvas(
                    image: image,
                    displayRect: displayRect,
                    cropRect: cropRect,
                    onCropRectChanged: (rect) => setState(() => _cropRect = rect),
                  );
                },
              ),
            ),
    );
  }

  static Rect _containRect(Size imageSize, Size boxSize) {
    final scale = math.min(
      boxSize.width / imageSize.width,
      boxSize.height / imageSize.height,
    );
    final displaySize = imageSize * scale;
    final offset = Offset(
      (boxSize.width - displaySize.width) / 2,
      (boxSize.height - displaySize.height) / 2,
    );
    return offset & displaySize;
  }
}

/// Draws the image plus a dimmed mask outside the crop rectangle, and
/// hosts the four independently-draggable corner handles. All dragging
/// happens in screen coordinates; [cropRect] is converted to and from the
/// image's own pixel coordinates at the boundary.
class _CropCanvas extends StatelessWidget {
  const _CropCanvas({
    required this.image,
    required this.displayRect,
    required this.cropRect,
    required this.onCropRectChanged,
  });

  final ui.Image image;
  final Rect displayRect;
  final Rect cropRect;
  final ValueChanged<Rect> onCropRectChanged;

  static const double _minSize = 40;

  double get _scale => displayRect.width / image.width;

  Rect get _screenCropRect => Rect.fromLTRB(
        displayRect.left + cropRect.left * _scale,
        displayRect.top + cropRect.top * _scale,
        displayRect.left + cropRect.right * _scale,
        displayRect.top + cropRect.bottom * _scale,
      );

  void _applyScreenRect(Rect screenRect) {
    final clamped = Rect.fromLTRB(
      screenRect.left.clamp(displayRect.left, displayRect.right),
      screenRect.top.clamp(displayRect.top, displayRect.bottom),
      screenRect.right.clamp(displayRect.left, displayRect.right),
      screenRect.bottom.clamp(displayRect.top, displayRect.bottom),
    );
    onCropRectChanged(Rect.fromLTRB(
      (clamped.left - displayRect.left) / _scale,
      (clamped.top - displayRect.top) / _scale,
      (clamped.right - displayRect.left) / _scale,
      (clamped.bottom - displayRect.top) / _scale,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final screenRect = _screenCropRect;
    return Stack(
      fit: StackFit.expand,
      children: [
        CustomPaint(
          painter: _CropMaskPainter(image: image, displayRect: displayRect, cropRect: screenRect),
        ),
        _CornerHandle(
          position: screenRect.topLeft,
          onDrag: (delta) => _applyScreenRect(Rect.fromLTRB(
            (screenRect.left + delta.dx).clamp(displayRect.left, screenRect.right - _minSize),
            (screenRect.top + delta.dy).clamp(displayRect.top, screenRect.bottom - _minSize),
            screenRect.right,
            screenRect.bottom,
          )),
        ),
        _CornerHandle(
          position: screenRect.topRight,
          onDrag: (delta) => _applyScreenRect(Rect.fromLTRB(
            screenRect.left,
            (screenRect.top + delta.dy).clamp(displayRect.top, screenRect.bottom - _minSize),
            (screenRect.right + delta.dx).clamp(screenRect.left + _minSize, displayRect.right),
            screenRect.bottom,
          )),
        ),
        _CornerHandle(
          position: screenRect.bottomLeft,
          onDrag: (delta) => _applyScreenRect(Rect.fromLTRB(
            (screenRect.left + delta.dx).clamp(displayRect.left, screenRect.right - _minSize),
            screenRect.top,
            screenRect.right,
            (screenRect.bottom + delta.dy).clamp(screenRect.top + _minSize, displayRect.bottom),
          )),
        ),
        _CornerHandle(
          position: screenRect.bottomRight,
          onDrag: (delta) => _applyScreenRect(Rect.fromLTRB(
            screenRect.left,
            screenRect.top,
            (screenRect.right + delta.dx).clamp(screenRect.left + _minSize, displayRect.right),
            (screenRect.bottom + delta.dy).clamp(screenRect.top + _minSize, displayRect.bottom),
          )),
        ),
      ],
    );
  }
}

class _CropMaskPainter extends CustomPainter {
  _CropMaskPainter({required this.image, required this.displayRect, required this.cropRect});

  final ui.Image image;
  final Rect displayRect;
  final Rect cropRect;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawImageRect(
      image,
      Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
      displayRect,
      Paint(),
    );

    final maskPath = Path()
      ..addRect(Offset.zero & size)
      ..addRect(cropRect)
      ..fillType = PathFillType.evenOdd;
    canvas.drawPath(maskPath, Paint()..color = const Color(0xB0000000));

    canvas.drawRect(
      cropRect,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(covariant _CropMaskPainter oldDelegate) {
    return oldDelegate.cropRect != cropRect ||
        oldDelegate.displayRect != displayRect ||
        oldDelegate.image != image;
  }
}

class _CornerHandle extends StatelessWidget {
  const _CornerHandle({required this.position, required this.onDrag});

  final Offset position;
  final ValueChanged<Offset> onDrag;

  static const double _touchSize = 40;
  static const double _visualSize = 22;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx - _touchSize / 2,
      top: position.dy - _touchSize / 2,
      width: _touchSize,
      height: _touchSize,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanUpdate: (details) => onDrag(details.delta),
        child: Center(
          child: Container(
            width: _visualSize,
            height: _visualSize,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.fromBorderSide(BorderSide(color: Color(0xFF3C6E4F), width: 3)),
            ),
          ),
        ),
      ),
    );
  }
}
