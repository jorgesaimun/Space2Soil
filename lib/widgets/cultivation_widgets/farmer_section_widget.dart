import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FarmerSectionWidget extends StatelessWidget {
  final String cropName;

  const FarmerSectionWidget({super.key, required this.cropName});

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
      width: 190,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black, width: 2),
      ),
      child: Text(
        'Hello Welcome to Space2Soil, now here is your ${cropName.toLowerCase()} seed. Choose your action carefully',
        style: GoogleFonts.vt323(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildFarmerCharacter() {
    return Image.asset(
      'assets/images/farmer_img.png',
      width: 125,
      height: 120,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: 120,
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
