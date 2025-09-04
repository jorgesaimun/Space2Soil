import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/crop.dart';

class CropStatsPanel extends StatelessWidget {
  final Crop currentCrop;
  final VoidCallback? onClose;

  const CropStatsPanel({super.key, required this.currentCrop, this.onClose});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsive font sizes based on available width
        double titleFontSize = constraints.maxWidth < 250 ? 14 : 28;
        double labelFontSize = constraints.maxWidth < 250 ? 10 : 12;
        double textFontSize = constraints.maxWidth < 250 ? 10 : 12;

        return Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFFF8A50),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: const Color(0xFFD84315), width: 4),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(titleFontSize),
              const SizedBox(height: 10),
              _buildCropCycleCard(labelFontSize, textFontSize),
              const SizedBox(height: 10),
              _buildPlacesCard(labelFontSize, textFontSize),
              const SizedBox(height: 10),
              Expanded(child: _buildNotesCard(labelFontSize, textFontSize)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(double fontSize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              'Stats for Crops',
              style: GoogleFonts.vt323(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: const Color(0xFFD84315),
            borderRadius: BorderRadius.circular(5),
          ),
          child: IconButton(
            padding: EdgeInsets.zero,
            onPressed: onClose,
            icon: const Icon(Icons.close, color: Colors.white, size: 18),
          ),
        ),
      ],
    );
  }

  Widget _buildCropCycleCard(double labelFontSize, double textFontSize) {
    return _buildInfoCard(
      'Crop Cycle:',
      currentCrop.cropCycle,
      labelFontSize,
      textFontSize,
    );
  }

  Widget _buildPlacesCard(double labelFontSize, double textFontSize) {
    return _buildInfoCard(
      'Places:',
      currentCrop.places,
      labelFontSize,
      textFontSize,
    );
  }

  Widget _buildNotesCard(double labelFontSize, double textFontSize) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE0B2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFD84315), width: 2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Notes:',
            style: GoogleFonts.vt323(
              fontSize: labelFontSize,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                currentCrop.notes,
                style: GoogleFonts.vt323(
                  fontSize: textFontSize,
                  color: const Color(0xFFD84315),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
    String label,
    String value,
    double labelFontSize,
    double textFontSize,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE0B2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFD84315), width: 2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.vt323(
              fontSize: labelFontSize,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            value,
            style: GoogleFonts.vt323(
              fontSize: textFontSize,
              color: const Color(0xFFD84315),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
