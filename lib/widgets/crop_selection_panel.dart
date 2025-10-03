import 'package:flutter/material.dart';
import '../models/crop.dart';

class CropSelectionPanel extends StatelessWidget {
  final Crop currentCrop;
  final int currentIndex;
  final int totalCrops;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final VoidCallback? onStart;
  final Function(int)? onCropChanged;

  const CropSelectionPanel({
    super.key,
    required this.currentCrop,
    required this.currentIndex,
    required this.totalCrops,
    this.onPrevious,
    this.onNext,
    this.onStart,
    this.onCropChanged,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFFF8A50),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: const Color(0xFFD84315), width: 4),
          ),
          child: Column(
            children: [
              _buildNameHeader(constraints),
              const SizedBox(height: 20),
              Expanded(flex: 2, child: _buildCropImageSection(constraints)),
              const SizedBox(height: 20),
              // _buildRelatedItems(),
              // const SizedBox(height: 20),
              _buildStartButton(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNameHeader(BoxConstraints constraints) {
    double fontSize = constraints.maxWidth < 250 ? 18 : 24;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE0B2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFD84315), width: 2),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          'Name: ${currentCrop.name}',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontFamily: 'monospace',
          ),
        ),
      ),
    );
  }

  Widget _buildCropImageSection(BoxConstraints constraints) {
    return Row(
      children: [
        _buildNavigationButton(
          icon: Icons.chevron_left,
          isEnabled: currentIndex > 0,
          onPressed: onPrevious,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: GestureDetector(
            onTap: () {
              // Allow tapping on the image to cycle through crops
              if (currentIndex < totalCrops - 1) {
                onNext?.call();
              } else {
                // If at last crop, go back to first
                onCropChanged?.call(0);
              }
            },
            child: Container(
              height: constraints.maxHeight * 0.4,
              decoration: BoxDecoration(
                color: const Color(0xFFFFE0B2),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: const Color(0xFFD84315), width: 3),
              ),
              child: Center(
                child: Image.asset(
                  currentCrop.imagePath,
                  width: constraints.maxWidth * 0.3,
                  height: constraints.maxHeight * 0.3,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: constraints.maxWidth * 0.3,
                      height: constraints.maxHeight * 0.3,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.image_not_supported,
                            size: 30,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            currentCrop.name,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        _buildNavigationButton(
          icon: Icons.chevron_right,
          isEnabled: currentIndex < totalCrops - 1,
          onPressed: onNext,
        ),
      ],
    );
  }

  Widget _buildNavigationButton({
    required IconData icon,
    required bool isEnabled,
    VoidCallback? onPressed,
  }) {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        color: isEnabled ? const Color(0xFFD84315) : Colors.grey,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black, width: 2),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(22.5),
          onTap: isEnabled ? onPressed : null,
          child: Icon(icon, color: Colors.white, size: 24),
        ),
      ),
    );
  }

  Widget _buildRelatedItems() {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      children: List.generate(4, (index) {
        return Container(
          width: 35,
          height: 35,
          decoration: BoxDecoration(
            color: const Color(0xFFFFE0B2),
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: const Color(0xFFD84315), width: 2),
          ),
          child: const Icon(Icons.grass, color: Color(0xFF4CAF50), size: 18),
        );
      }),
    );
  }

  Widget _buildStartButton() {
    return Container(
      width: 140,
      height: 50,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF9C7FB8), Color(0xFF7B68B1)],
        ),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.black, width: 3),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(25),
          onTap: onStart,
          child: const Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                'START',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'monospace',
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
