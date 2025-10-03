import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FarmerResultWidget extends StatelessWidget {
  const FarmerResultWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Speech bubble
        _buildSpeechBubble(),
        const SizedBox(height: 8),
        // Farmer character
        _buildFarmerCharacter(),
      ],
    );
  }

  Widget _buildSpeechBubble() {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black, width: 2),
      ),
      child: Row(
        children: [
          // Lightbulb icon
          const Icon(Icons.lightbulb, color: Colors.yellow, size: 20),
          const SizedBox(width: 8),
          // Text message
          Expanded(
            child: Text(
              'Keep monitoring the soil',
              style: GoogleFonts.vt323(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFarmerCharacter() {
    return Image.asset(
      'assets/images/farmer_left.png',
      width: 150,
      height: 120,
      fit: BoxFit.cover, // Changed to cover to fill the space completely
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: 150,
          height: 120,
          decoration: BoxDecoration(
            color: const Color(0xFF8D6E63),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.person, color: Colors.white, size: 40),
        );
      },
    );
  }
}
