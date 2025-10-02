import 'package:demo_game/unlocked_all_mode.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models/crop.dart';

/// Final result screen shown after completing all cultivation stages
class FinalResultScreen extends StatelessWidget {
  final Crop selectedCrop;
  final double irrigationLevel;
  final double fertilizerLevel;
  final double pesticideLevel;
  final String? division;

  const FinalResultScreen({
    super.key,
    required this.selectedCrop,
    required this.irrigationLevel,
    required this.fertilizerLevel,
    required this.pesticideLevel,
    this.division,
  });

  /// Format crop cycle to display in the header (e.g., "October-April (Available in Chattogram)" -> "OCT-APR")
  String _formatCropCycleForDisplay() {
    final cropCycle = selectedCrop.cropCycle;

    // Extract just the month range part, ignore location part in parentheses
    String monthPart = cropCycle;
    if (cropCycle.contains('(')) {
      monthPart = cropCycle.split('(')[0].trim();
    }

    // If monthPart contains months, format them to abbreviated form
    if (monthPart.contains('-')) {
      final months = monthPart.split('-');
      if (months.length == 2) {
        final startMonth = _abbreviateMonth(months[0].trim());
        final endMonth = _abbreviateMonth(months[1].trim());
        return '$startMonth-$endMonth';
      }
    }

    return monthPart.toUpperCase();
  }

  /// Convert month name to 3-letter abbreviation
  String _abbreviateMonth(String month) {
    final monthMap = {
      'january': 'JAN',
      'february': 'FEB',
      'march': 'MAR',
      'april': 'APR',
      'may': 'MAY',
      'june': 'JUN',
      'july': 'JUL',
      'august': 'AUG',
      'september': 'SEP',
      'october': 'OCT',
      'november': 'NOV',
      'december': 'DEC',
    };

    return monthMap[month.toLowerCase()] ?? month.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/cultivated_bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              children: [
                // Crop cycle header - Top Center
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFB74D),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFFFF8F00),
                        width: 3,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          color: Colors.brown,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _formatCropCycleForDisplay(),
                          style: GoogleFonts.vt323(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Main dialog card - Center
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    constraints: const BoxConstraints(maxWidth: 400),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF8E1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFFFF8F00),
                        width: 4,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Crop image (pixelated style)
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.brown, width: 2),
                          ),
                          child: Image.asset(
                            selectedCrop.imagePath,
                            fit: BoxFit.cover,
                            filterQuality:
                                FilterQuality.none, // Pixelated effect
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[300],
                                child: const Icon(
                                  Icons.eco,
                                  size: 60,
                                  color: Colors.green,
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Success message
                        Text(
                          'YOU HAVE SUCCESSFULLY CULTIVATED',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.vt323(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 8),
                // Next button - Bottom Center
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => UnlockedAllMode(
                                location: division ?? 'Unknown Location',
                              ),
                        ),
                      );
                    },
                    child: Container(
                      width: 120,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFE6A8E6), // Light purple
                            Color(0xFFC585C5), // Darker purple
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: Colors.black, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            offset: const Offset(0, 3),
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          'NEXT',
                          style: GoogleFonts.vt323(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
