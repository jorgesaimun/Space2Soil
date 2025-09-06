import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ResultsPanelWidget extends StatelessWidget {
  final String whatHappened;
  final String why;
  final int starRating;

  const ResultsPanelWidget({
    super.key,
    required this.whatHappened,
    required this.why,
    required this.starRating,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        // Main panel
        Container(
          width: 350,
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          decoration: _buildPanelDecoration(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Star rating
              _buildStarRating(),
              const SizedBox(height: 10),
              // What happened section
              _buildResultSection('What Happened:', whatHappened),
              const SizedBox(height: 15),
              // Why section
              _buildResultSection('Why:', why),
            ],
          ),
        ),
        // Results banner at the top
        Positioned(top: -20, child: _buildResultsBanner()),
      ],
    );
  }

  Widget _buildStarRating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          child: Icon(
            index < starRating ? Icons.star : Icons.star_border,
            color: const Color(0xFFFFD700), // Gold color
            size: 40,
          ),
        );
      }),
    );
  }

  Widget _buildResultSection(String label, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE0B2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE65100), width: 2),
      ),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$label ',
              style: GoogleFonts.vt323(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            TextSpan(
              text: value,
              style: GoogleFonts.vt323(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFD32F2F), // Red color for values
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNextButton() {
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF9C7FB8), Color(0xFF7B68B1)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.black, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          'NEXT',
          style: GoogleFonts.vt323(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildResultsBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFFFD180),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF795548), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Text(
        'RESULTS',
        style: GoogleFonts.vt323(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  BoxDecoration _buildPanelDecoration() {
    return BoxDecoration(
      color: const Color(0xFFF5EFE4),
      borderRadius: BorderRadius.circular(15),
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
