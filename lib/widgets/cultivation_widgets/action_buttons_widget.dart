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
          imagePath: 'assets/images/irrigate_icon.png',
          value: irrigationLevel,
          onChanged: onIrrigationChanged,
        ),
        _buildActionControl(
          title: 'Fertilize',
          imagePath: 'assets/images/fertilize_icon.png',
          value: fertilizerLevel,
          onChanged: onFertilizerChanged,
        ),
        _buildActionControl(
          title: 'Pesticide',
          imagePath: 'assets/images/pesticide_icon.png',
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: _buildPanelDecoration(),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                  errorBuilder:
                      (context, error, stackTrace) =>
                          const Icon(Icons.image_not_supported, size: 40),
                ),
              ),
            ),
            Positioned(top: -10, child: _buildTitleBanner(title)),
          ],
        ),
        const SizedBox(height: 15),
        SizedBox(
          width: 110,
          child: SliderTheme(
            data: SliderThemeData(
              trackHeight: 12,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
              activeTrackColor: const Color(0xFF4CAF50),
              inactiveTrackColor: const Color(0xFFC8E6C9),
              thumbColor: const Color(0xFF1B5E20),
            ),
            child: Slider(value: value, onChanged: onChanged),
          ),
        ),
      ],
    );
  }

  Widget _buildTitleBanner(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
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

  BoxDecoration _buildPanelDecoration() {
    return BoxDecoration(
      color: const Color(0xFFF5EFE4),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: const Color(0xFF795548), width: 4),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.25),
          blurRadius: 0,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}
