import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models/crop.dart';
import 'mode_selection_screen.dart';

/// Final result screen shown after completing all cultivation stages
class FinalResultScreen extends StatelessWidget {
  final Crop selectedCrop;
  final double irrigationLevel;
  final double fertilizerLevel;
  final double pesticideLevel;

  const FinalResultScreen({
    super.key,
    required this.selectedCrop,
    required this.irrigationLevel,
    required this.fertilizerLevel,
    required this.pesticideLevel,
  });

  /// Format crop cycle to display in the header (e.g., "February-July" -> "FEB-JUL")
  String _formatCropCycleForDisplay() {
    final cropCycle = selectedCrop.cropCycle;

    // If cropCycle contains months, format them to abbreviated form
    if (cropCycle.contains('-')) {
      final months = cropCycle.split('-');
      if (months.length == 2) {
        final startMonth = _abbreviateMonth(months[0].trim());
        final endMonth = _abbreviateMonth(months[1].trim());
        return '$startMonth-$endMonth';
      }
    }

    return cropCycle.toUpperCase();
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
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ModeSelectionScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF9C27B0),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 8,
                    ),
                    child: Text(
                      'NEXT',
                      style: GoogleFonts.vt323(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
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
