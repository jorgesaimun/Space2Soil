import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EnvironmentalDataWidget extends StatelessWidget {
  final double stock;
  final double smap;
  final String ndvi;

  const EnvironmentalDataWidget({
    super.key,
    required this.stock,
    required this.smap,
    required this.ndvi,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildDataCard(
          title: 'STOCK',
          icon: _buildCustomIcon('assets/images/stock.png'),
          value: '${stock.toInt()}',
        ),
        const SizedBox(height: 15),
        _buildDataCard(
          title: 'SMAP',
          icon: _buildCustomIcon('assets/images/smap.png'),
          value: '${smap.toInt()}%',
        ),
        const SizedBox(height: 15),
        _buildDataCard(
          title: 'NDVI',
          icon: _buildCustomIcon('assets/images/ndvi.png'),
          value: ndvi,
        ),
      ],
    );
  }

  Widget _buildCustomIcon(String assetPath) {
    return Image.asset(
      assetPath,
      width: 40,
      height: 40,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        // Fallback to Flutter icons if asset not found
        if (assetPath.contains('stock')) {
          return const Icon(Icons.inventory, color: Colors.red, size: 40);
        } else if (assetPath.contains('smap')) {
          return const Icon(Icons.water_drop, color: Colors.blue, size: 40);
        } else if (assetPath.contains('ndvi')) {
          return const Icon(Icons.eco, color: Colors.green, size: 40);
        }
        return const Icon(Icons.error, color: Colors.grey, size: 40);
      },
    );
  }

  Widget _buildDataCard({
    required String title,
    required Widget icon,
    required String value,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        // Main content box
        Container(
          width: 130,
          height: 75,
          decoration: BoxDecoration(
            color: const Color(0xFFF5EFE4),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE65100), width: 3),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                icon,
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      value,
                      style: GoogleFonts.vt323(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Title banner
        Positioned(
          top: -10,
          right: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFFFFD180),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF795548), width: 2),
            ),
            child: Text(
              title,
              style: GoogleFonts.vt323(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
