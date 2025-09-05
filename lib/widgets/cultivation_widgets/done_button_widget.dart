import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DoneButtonWidget extends StatelessWidget {
  final String cropName;
  final VoidCallback onPressed;

  const DoneButtonWidget({
    super.key,
    required this.cropName,
    required this.onPressed,
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
            // Show success message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Cultivation settings saved for $cropName!'),
                backgroundColor: const Color(0xFF4CAF50),
              ),
            );
            onPressed();
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
