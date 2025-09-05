import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SeedPanelWidget extends StatelessWidget {
  const SeedPanelWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 150,
      padding: const EdgeInsets.all(12),
      decoration: _buildPanelDecoration(),
      child: Column(
        children: [
          // Seed banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFFF8A50),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'SEED',
              textAlign: TextAlign.center,
              style: GoogleFonts.vt323(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Large seed image
          Expanded(
            child: Center(
              child: Image.asset(
                'assets/images/seed_img.png',
                width: 80,
                height: 80,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFF8D6E63),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.grass,
                      color: Colors.white,
                      size: 40,
                    ),
                  );
                },
              ),
            ),
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
