import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SeedPanelWidget extends StatelessWidget {
  const SeedPanelWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        // Main content box
        Container(
          width: 250, // Wider panel
          height: 170, // Taller panel
          decoration: _buildPanelDecoration(),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Image.asset(
              'assets/images/seed_img.png',
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.grass, size: 80, color: Colors.brown);
              },
            ),
          ),
        ),
        // Title banner
        Positioned(top: -10, child: _buildSeedBanner()),
      ],
    );
  }

  Widget _buildSeedBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFFFD180),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF795548), width: 2),
      ),
      child: Text(
        'SEED',
        style: GoogleFonts.vt323(
          fontSize: 16,
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
