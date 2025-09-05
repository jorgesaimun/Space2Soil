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
    return Container(
      width: 140,
      height: 100,
      padding: const EdgeInsets.all(8),
      decoration: _buildPanelDecoration(),
      child: Column(
        children: [
          // Month banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFFF8A50),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'MONTH: $monthNumber',
              textAlign: TextAlign.center,
              style: GoogleFonts.vt323(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Calendar icon and month
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.red, width: 2),
                ),
                child: const Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: Colors.red,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  currentMonth,
                  style: GoogleFonts.vt323(
                    fontSize: 20,
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
