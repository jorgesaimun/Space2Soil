import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EnvironmentalDataWidget extends StatelessWidget {
  final double temperature;
  final double humidity;
  final String ndti;

  const EnvironmentalDataWidget({
    super.key,
    required this.temperature,
    required this.humidity,
    required this.ndti,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Temperature panel
        _buildEnvironmentalPanel(
          'TEMPERATURE',
          Icons.thermostat,
          '${temperature.toInt()}°C',
          Colors.red,
        ),
        const SizedBox(height: 12),
        // Humidity panel
        _buildEnvironmentalPanel(
          'HUMIDITY',
          Icons.water_drop,
          '${humidity.toInt()}%',
          Colors.blue,
        ),
        const SizedBox(height: 12),
        // NDTI panel
        _buildEnvironmentalPanel(
          'NDTI',
          Icons.check_circle,
          ndti,
          Colors.green,
        ),
      ],
    );
  }

  Widget _buildEnvironmentalPanel(
    String title,
    IconData icon,
    String value,
    Color iconColor,
  ) {
    return Container(
      width: 140,
      height: 60,
      padding: const EdgeInsets.all(8),
      decoration: _buildPanelDecoration(),
      child: Column(
        children: [
          // Title banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFFF8A50),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.vt323(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 4),
          // Icon and value
          Row(
            children: [
              Icon(
                icon,
                color: iconColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  value,
                  style: GoogleFonts.vt323(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  BoxDecoration _buildPanelDecoration() {
    return BoxDecoration(
      color: const Color(0xFFFFE0B2),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: const Color(0xFFFF8A50), width: 3),
    );
  }
}
