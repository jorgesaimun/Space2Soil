import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../result_screen.dart';
import '../../models/crop.dart';

class DoneButtonWidget extends StatelessWidget {
  final String cropName;
  final Crop selectedCrop;
  final double irrigationLevel;
  final double fertilizerLevel;
  final double pesticideLevel;

  const DoneButtonWidget({
    super.key,
    required this.cropName,
    required this.selectedCrop,
    required this.irrigationLevel,
    required this.fertilizerLevel,
    required this.pesticideLevel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 60,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF9C7FB8), Color(0xFF7B68B1)],
        ),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFF4A148C), width: 3),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: () {
            // Navigate to result screen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ResultScreen(
                  selectedCrop: selectedCrop,
                  irrigationLevel: irrigationLevel,
                  fertilizerLevel: fertilizerLevel,
                  pesticideLevel: pesticideLevel,
                ),
              ),
            );
          },
          child: Center(
            child: Text(
              'DONE',
              style: GoogleFonts.vt323(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
