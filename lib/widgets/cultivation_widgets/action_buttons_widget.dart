import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ActionButtonsWidget extends StatelessWidget {
  final double irrigationLevel;
  final double fertilizerLevel;
  final double pesticideLevel;
  final Function(double) onIrrigationChanged;
  final Function(double) onFertilizerChanged;
  final Function(double) onPesticideChanged;

  const ActionButtonsWidget({
    super.key,
    required this.irrigationLevel,
    required this.fertilizerLevel,
    required this.pesticideLevel,
    required this.onIrrigationChanged,
    required this.onFertilizerChanged,
    required this.onPesticideChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildActionControl(
          title: 'Irrigate',
          imagePath: 'assets/images/irrigate2.png',
          value: irrigationLevel,
          onChanged: onIrrigationChanged,
        ),
        _buildActionControl(
          title: 'Fertilize',
          imagePath: 'assets/images/fertilize.png',
          value: fertilizerLevel,
          onChanged: onFertilizerChanged,
        ),
        _buildActionControl(
          title: 'Pesticide',
          imagePath: 'assets/images/pesticide.png',
          value: pesticideLevel,
          onChanged: onPesticideChanged,
        ),
      ],
    );
  }

  Widget _buildActionControl({
    required String title,
    required String imagePath,
    required double value,
    required Function(double) onChanged,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Main card with two sections
        Container(
          width: 85, // Reduced from 110 to fit within constraints
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE65100), width: 3),
          ),
          child: Column(
            children: [
              // Top section - Image
              Container(
                height: 70, // Reduced from 100 to save space
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFCC80),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(2)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(2.0), // Reduced padding
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) => const Icon(
                          Icons.image_not_supported,
                          size: 30, // Reduced icon size
                          color: Color(0xFF795548),
                        ),
                  ),
                ),
              ),
              // Bottom section - Slider
              Container(
                height: 25, // Reduced from 40 to save space
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFF5EFE4),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(8),
                  ),
                ),
                child: SliderTheme(
                  data: SliderThemeData(
                    trackShape: _SegmentedSliderTrackShape(),
                    thumbShape: const _RectSliderThumbShape(
                      thumbRadius: 8,
                      thumbHeight: 20,
                    ),
                    overlayShape: SliderComponentShape.noOverlay,
                  ),
                  child: Slider(value: value, onChanged: onChanged),
                ),
              ),
            ],
          ),
        ),
        // Title banner positioned at top-left
        Positioned(top: -10, left: 5, child: _buildTitleBanner(title)),
      ],
    );
  }

  Widget _buildTitleBanner(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFFFD180),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF795548), width: 2),
      ),
      child: Text(
        title,
        style: GoogleFonts.vt323(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }
}

// Custom Slider Track Shape for segmented appearance
class _SegmentedSliderTrackShape extends SliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final trackHeight = sliderTheme.trackHeight ?? 12;
    final trackLeft = offset.dx + 10;
    final trackTop = offset.dy + (parentBox.size.height - trackHeight) / 2;
    final trackWidth = parentBox.size.width - 20;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isDiscrete = false,
    bool isEnabled = false,
  }) {
    final rect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
    );
    final canvas = context.canvas;

    // Draw inactive track
    final inactivePaint = Paint()..color = const Color(0xFF757575);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(4)),
      inactivePaint,
    );

    // Draw active track segments
    final activePaint = Paint()..color = const Color(0xFFFFA726);
    final segmentWidth = rect.width / 10;
    final segmentGap = 2.0;

    for (int i = 0; i < 10; i++) {
      final segmentLeft = rect.left + i * segmentWidth;
      if (segmentLeft + segmentWidth - segmentGap <= thumbCenter.dx) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(
              segmentLeft,
              rect.top,
              segmentWidth - segmentGap,
              rect.height,
            ),
            const Radius.circular(2),
          ),
          activePaint,
        );
      }
    }
  }
}

// Custom Slider Thumb Shape for rectangular appearance
class _RectSliderThumbShape extends SliderComponentShape {
  final double thumbRadius;
  final double thumbHeight;

  const _RectSliderThumbShape({
    required this.thumbRadius,
    required this.thumbHeight,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;

    final rect = Rect.fromCenter(
      center: center,
      width: thumbRadius * 1.5,
      height: thumbHeight,
    );

    final fillPaint = Paint()..color = const Color(0xFFE65100);
    final borderPaint =
        Paint()
          ..color = const Color(0xFF424242)
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke;

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(4)),
      fillPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(4)),
      borderPaint,
    );
  }
}
