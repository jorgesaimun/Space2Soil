import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EnvironmentalDataWidget extends StatelessWidget {
  final double temperature;
  final double smap;
  final String ndvi;

  const EnvironmentalDataWidget({
    super.key,
    required this.temperature,
    required this.smap,
    required this.ndvi,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildDataCard(
          title: 'TEMPERATURE',
          icon: const Icon(Icons.thermostat, color: Colors.red, size: 40),
          value: '${temperature.toInt()}°C',
        ),
        const SizedBox(height: 15),
        _buildDataCard(
          title: 'SMAP',
          icon: const Icon(Icons.water_drop, color: Colors.blue, size: 40),
          value: '${smap.toInt()}%',
        ),
        const SizedBox(height: 15),
        _buildDataCard(
          title: 'NDVI',
          icon: const Icon(Icons.check, color: Colors.green, size: 40),
          value: ndvi,
        ),
      ],
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
