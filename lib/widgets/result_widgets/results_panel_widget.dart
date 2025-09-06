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
    return Container(
      width: 300,
      height: 250,
      padding: const EdgeInsets.all(16),
      decoration: _buildPanelDecoration(),
      child: Column(
        children: [
          // Title bar
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFFF8A50),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'RESULTS',
              textAlign: TextAlign.center,
              style: GoogleFonts.vt323(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Star rating
          _buildStarRating(),
          const SizedBox(height: 20),
          // What happened section
          _buildResultSection('What Happened:', whatHappened),
          const SizedBox(height: 12),
          // Why section
          _buildResultSection('Why:', why),
        ],
      ),
    );
  }

  Widget _buildStarRating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          child: Icon(
            index < starRating ? Icons.star : Icons.star_border,
            color: Colors.amber,
            size: 30,
          ),
        );
      }),
    );
  }

  Widget _buildResultSection(String label, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE0B2),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFFF8A50), width: 2),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: GoogleFonts.vt323(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.vt323(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.red,
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
