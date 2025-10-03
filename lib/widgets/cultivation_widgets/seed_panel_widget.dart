import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'stage_image_widget.dart';

class SeedPanelWidget extends StatelessWidget {
  final String stageLabel;
  final int currentStage;
  final int totalStages;
  final String cropFolderName;

  const SeedPanelWidget({
    super.key,
    required this.stageLabel,
    required this.currentStage,
    required this.totalStages,
    required this.cropFolderName,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate responsive dimensions
        final maxWidth =
            constraints.maxWidth > 0 ? constraints.maxWidth * 0.9 : 200.0;
        final maxHeight =
            constraints.maxHeight > 0 ? constraints.maxHeight * 0.8 : 120.0;

        return Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            // Main content box
            Container(
              width: maxWidth.clamp(180.0, 240.0).toDouble(),
              height: maxHeight.clamp(100.0, 160.0).toDouble(),
              decoration: _buildPanelDecoration(),
              child: Column(
                children: [
                  // Stage progress indicator (dynamic count)
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(totalStages, (index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 1.5),
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color:
                                index < currentStage
                                    ? const Color(0xFF4CAF50)
                                    : Colors.grey.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        );
                      }),
                    ),
                  ),
                  // Stage image - taking most of the space
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        12.0,
                        20.0,
                        12.0,
                        12.0,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: StageImageWidget(
                          currentStage: currentStage,
                          cropType: cropFolderName,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Title banner
            Positioned(top: -10, child: _buildSeedBanner()),
          ],
        );
      },
    );
  }

  Widget _buildSeedBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFFFD180),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF795548), width: 2),
      ),
      child: Text(
        stageLabel,
        style: GoogleFonts.vt323(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  BoxDecoration _buildPanelDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
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
