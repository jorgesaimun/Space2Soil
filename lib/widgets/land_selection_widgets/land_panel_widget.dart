import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/land.dart';

class LandPanelWidget extends StatelessWidget {
  final Land land;
  final bool isSelected;

  const LandPanelWidget({
    super.key,
    required this.land,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableHeight = constraints.maxHeight > 0
            ? constraints.maxHeight
            : 220.0;
        return Container(
          width: 240,
          height: availableHeight,
          decoration: _buildPanelDecoration(),
          child: Column(
            children: [
              // Land image section
              Expanded(child: _buildLandImage()),
              // Land info footer
              _buildInfoFooter(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLandImage() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Land field image with scaling
          SizedBox(
            // Scale based on area while keeping aspect ratio visual clarity
            width: _scaledPreviewWidth(),
            child: AspectRatio(
              aspectRatio: () {
                final ratio = land.length / land.width;
                final clamped = ratio.clamp(0.3, 3.0);
                return clamped.toDouble();
              }(),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? const Color(0xFF4CAF50) : const Color(0xFF795548),
                    width: isSelected ? 4 : 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isSelected
                          ? const Color(0xFF4CAF50).withOpacity(0.4)
                          : Colors.black.withOpacity(0.2),
                      blurRadius: isSelected ? 8 : 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(9),
                  child: Image.asset(
                    'assets/images/field.jpg',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.green[300]!, Colors.green[600]!],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: const Icon(
                          Icons.grass,
                          size: 40,
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _scaledPreviewWidth() {
    // Normalize against a base area and clamp for usability
    const double baseArea = 10000; // 100x100
    final double scale = (land.area / baseArea).clamp(0.6, 1.4).toDouble();
    return 200 * scale;
  }

  Widget _buildInfoFooter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          Text(
            '${land.length}×${land.width}m²',
            style: GoogleFonts.vt323(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.brown[900],
            ),
          ),
          const SizedBox(height: 2),
        ],
      ),
    );
  }

  // Size description removed per simplified UI

  BoxDecoration _buildPanelDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: isSelected ? const Color(0xFF4CAF50) : const Color(0xFF795548),
        width: 4,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.3),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}
