import 'package:flutter/material.dart';
import 'dart:math' as math;

class EarthGlobeSection extends StatelessWidget {
  final AnimationController globeController;
  final VoidCallback? onNextPressed;

  const EarthGlobeSection({
    super.key,
    required this.globeController,
    this.onNextPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: _buildCardDecoration(),
      child: Column(
        children: [
          _buildHeaderRow(),
          const SizedBox(height: 20),
          Expanded(child: _buildRotatingEarthGlobe()),
          const SizedBox(height: 20),
          _buildNextButton(),
        ],
      ),
    );
  }

  BoxDecoration _buildCardDecoration() {
    return BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xFFFF8A50), Color(0xFFFFB74D)],
      ),
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: const Color(0xFFD84315), width: 4),
    );
  }

  Widget _buildHeaderRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Icon(Icons.location_on, color: Color(0xFFD84315), size: 30),
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: const Color(0xFFD84315),
            borderRadius: BorderRadius.circular(5),
          ),
          child: const Icon(Icons.close, color: Colors.white, size: 20),
        ),
      ],
    );
  }

  Widget _buildRotatingEarthGlobe() {
    return Center(
      child: Container(
        width: 280,
        height: 280,
        decoration: BoxDecoration(
          color: const Color(0xFFFFF8DC), // Cream background
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: const Color(0xFFD84315), width: 3),
        ),
        child: Stack(
          children: [
            // Grid background
            _buildGridBackground(),
            // Rotating map globe
            Center(
              child: Container(
                width: 200,
                height: 200,
                child: AnimatedBuilder(
                  animation: globeController,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: globeController.value * 2 * math.pi,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 8,
                              spreadRadius: 2,
                              offset: const Offset(2, 2),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Container(
                            width: 200,
                            height: 200,
                            child: AspectRatio(
                              aspectRatio: 1.0,
                              child: Image.asset(
                                'assets/images/map.png',
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  // Fallback if map.png is not available
                                  return Container(
                                    width: 200,
                                    height: 200,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: RadialGradient(
                                        colors: [
                                          Color(0xFF4FC3F7),
                                          Color(0xFF29B6F6),
                                          Color(0xFF0288D1),
                                        ],
                                      ),
                                    ),
                                    child: Stack(
                                      children: [
                                        _buildContinent(40, 60, 80, 60),
                                        _buildContinent(
                                          null,
                                          40,
                                          60,
                                          40,
                                          bottom: 50,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContinent(
    double? top,
    double? left,
    double width,
    double height, {
    double? bottom,
  }) {
    return Positioned(
      top: top,
      left: left,
      bottom: bottom,
      right: left == null ? 40 : null,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color:
              top == null ? const Color(0xFF66BB6A) : const Color(0xFF4CAF50),
          borderRadius: BorderRadius.circular(height / 2),
        ),
      ),
    );
  }

  Widget _buildGridBackground() {
    return Positioned.fill(child: CustomPaint(painter: GridPainter()));
  }

  Widget _buildNextButton() {
    return Container(
      width: 150,
      height: 50,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF9C7FB8), Color(0xFF7B68B1)],
        ),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: const Color(0xFF4A148C), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(25),
          onTap: onNextPressed,
          child: const Center(
            child: Text(
              'NEXT',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Custom painter for grid background
class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = const Color(0xFF8D6E63).withOpacity(0.3)
          ..strokeWidth = 1
          ..style = PaintingStyle.stroke;

    const gridSpacing = 20.0;

    // Draw vertical lines
    for (double x = gridSpacing; x < size.width; x += gridSpacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Draw horizontal lines
    for (double y = gridSpacing; y < size.height; y += gridSpacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
