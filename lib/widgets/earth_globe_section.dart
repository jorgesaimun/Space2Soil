import 'package:flutter/material.dart';
import 'dart:math' as math;

class EarthGlobeSection extends StatelessWidget {
  final AnimationController globeController;

  const EarthGlobeSection({super.key, required this.globeController});

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
                gradient: const RadialGradient(
                  colors: [
                    Color(0xFF4FC3F7), // Light blue
                    Color(0xFF29B6F6), // Blue
                    Color(0xFF0288D1), // Dark blue
                  ],
                ),
                border: Border.all(color: Colors.white, width: 3),
              ),
              child: Stack(
                children: [
                  _buildContinent(40, 60, 80, 60),
                  _buildContinent(null, 40, 60, 40, bottom: 50),
                  _buildGridOverlay(),
                ],
              ),
            ),
          );
        },
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

  Widget _buildGridOverlay() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
      ),
    );
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
      ),
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
    );
  }
}
