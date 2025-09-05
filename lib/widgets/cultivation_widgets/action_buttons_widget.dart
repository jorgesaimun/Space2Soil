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
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActionButton(
          'Irrigate',
          Icons.water_drop,
          irrigationLevel,
          onIrrigationChanged,
        ),
        _buildActionButton(
          'Fertilize',
          Icons.eco,
          fertilizerLevel,
          onFertilizerChanged,
        ),
        _buildActionButton(
          'Pesticide',
          Icons.bug_report,
          pesticideLevel,
          onPesticideChanged,
        ),
      ],
    );
  }

  Widget _buildActionButton(
    String title,
    IconData icon,
    double value,
    Function(double) onChanged,
  ) {
    return Column(
      children: [
        // Action button
        Container(
          width: 80,
          height: 60,
          padding: const EdgeInsets.all(8),
          decoration: _buildPanelDecoration(),
          child: Column(
            children: [
              Icon(
                icon,
                size: 24,
                color: Colors.black,
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: GoogleFonts.vt323(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // Slider bar
        SizedBox(
          width: 80,
          child: Slider(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFFFF8A50),
            inactiveColor: const Color(0xFFFFE0B2),
            min: 0.0,
            max: 1.0,
          ),
        ),
      ],
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
