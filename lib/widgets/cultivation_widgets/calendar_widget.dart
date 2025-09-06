import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CalendarWidget extends StatelessWidget {
  final String currentMonth;
  final String monthNumber;

  const CalendarWidget({
    super.key,
    required this.currentMonth,
    required this.monthNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        // Main content box
        Container(
          width: 100, // Adjusted width to fit content
          height: 60, // Adjusted height
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: _buildPanelDecoration(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Calendar Icon
              const Icon(
                Icons.calendar_today,
                size: 24, // Smaller icon
                color: Color(0xFF5D4037), // Dark brown color
              ),
              const SizedBox(width: 10),
              // Month Text
              Text(
                currentMonth.toUpperCase(),
                style: GoogleFonts.vt323(
                  fontSize: 20, // Larger font
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        // Month banner on top right
        Positioned(top: -15, right: 10, child: _buildMonthBanner()),
      ],
    );
  }

  Widget _buildMonthBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFFFD180), // Light orange/yellow from image
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF795548), width: 2),
      ),
      child: Text(
        'MONTH: $monthNumber',
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
      color: const Color(0xFFF5EFE4), // Creamy background from image
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: const Color(0xFF795548),
        width: 4,
      ), // Brown border
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
