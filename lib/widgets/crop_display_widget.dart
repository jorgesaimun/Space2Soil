import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/crop.dart';

class CropDisplayWidget extends StatefulWidget {
  final List<Crop> crops;
  final Function(int) onCropChanged;
  final VoidCallback? onStart;

  const CropDisplayWidget({
    super.key,
    required this.crops,
    required this.onCropChanged,
    this.onStart,
  });

  @override
  State<CropDisplayWidget> createState() => _CropDisplayWidgetState();
}

class _CropDisplayWidgetState extends State<CropDisplayWidget>
    with TickerProviderStateMixin {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPrevious() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToNext() {
    if (_currentIndex < widget.crops.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            // Crop indicator dots
            _buildCropIndicator(),
            const SizedBox(height: 0),
            // Main crop display area
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 25,
                ), // More space for overlaid name
                child: PageView.builder(
                  clipBehavior: Clip.none, // Allow overflow
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                    widget.onCropChanged(index);
                  },
                  itemCount: widget.crops.length,
                  itemBuilder: (context, index) {
                    final crop = widget.crops[index];
                    return _buildCropCard(crop, constraints);
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Navigation and start section
            _buildNavigationSection(),
          ],
        );
      },
    );
  }

  Widget _buildCropIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.crops.length, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color:
                index == _currentIndex
                    ? const Color(0xFFD84315)
                    : const Color(0xFFFFE0B2),
            border: Border.all(color: const Color(0xFFD84315), width: 2),
          ),
        );
      }),
    );
  }

  Widget _buildCropCard(Crop crop, BoxConstraints constraints) {
    return Stack(
      clipBehavior: Clip.none, // Allow overflow outside bounds
      children: [
        // Main crop card
        Container(
          margin: const EdgeInsets.fromLTRB(
            20,
            25,
            20,
            0,
          ), // Extra top margin for name
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFFF8A50),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: const Color(0xFFD84315), width: 4),
          ),
          child: Column(
            children: [
              // Crop image - now gets maximum space
              Expanded(
                flex: 3,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFDE7),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: const Color(0xFFD84315),
                      width: 3,
                    ),
                  ),
                  child: Center(
                    child: Image.asset(
                      crop.imagePath,
                      width: constraints.maxWidth * 0.45, // Increased size
                      height: constraints.maxHeight * 0.45, // Increased size
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: constraints.maxWidth * 0.45,
                          height: constraints.maxHeight * 0.45,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.image_not_supported,
                                size: 60, // Increased icon size
                                color: Colors.grey,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                crop.name,
                                style: const TextStyle(
                                  fontSize: 16, // Increased font size
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
              const SizedBox(height: 10),
              // Related crops thumbnails
              _buildRelatedCrops(),
            ],
          ),
        ),
        // Overlaid crop name - positioned at the top edge of card
        Positioned(
          top: -5, // At the top edge of the card
          left: 70, // Centered with card margins
          right: 70, // Centered with card margins
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFFFE0B2),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFD84315), width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                '${crop.name}',
                textAlign: TextAlign.center,
                style: GoogleFonts.vt323(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Previous button
        _buildNavigationButton(
          icon: Icons.chevron_left,
          isEnabled: _currentIndex > 0,
          onPressed: _goToPrevious,
        ),
        // Start button
        Container(
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
              onTap: widget.onStart,
              child: Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'START',
                    style: GoogleFonts.vt323(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        // Next button
        _buildNavigationButton(
          icon: Icons.chevron_right,
          isEnabled: _currentIndex < widget.crops.length - 1,
          onPressed: _goToNext,
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
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: isEnabled ? const Color(0xFFD84315) : Colors.grey,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black, width: 2),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(25),
          onTap: isEnabled ? onPressed : null,
          child: Icon(icon, color: Colors.white, size: 28),
        ),
      ),
    );
  }

  /// Build related crops thumbnails
  Widget _buildRelatedCrops() {
    // Show up to 6 crops (excluding current crop or showing all available)
    final displayCrops = widget.crops.take(6).toList();

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      children:
          displayCrops.asMap().entries.map((entry) {
            final index = entry.key;
            final crop = entry.value;
            final isCurrentCrop = index == _currentIndex;

            return GestureDetector(
              onTap: () {
                // Switch to selected crop
                _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              child: Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  color:
                      isCurrentCrop
                          ? const Color(0xFF4CAF50).withOpacity(0.3)
                          : const Color(0xFFFFE0B2),
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color:
                        isCurrentCrop
                            ? const Color(0xFF4CAF50)
                            : const Color(0xFFD84315),
                    width: 2,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: Image.asset(
                    crop.imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback to crop initial letter if image fails
                      return Center(
                        child: Text(
                          crop.name.isNotEmpty
                              ? crop.name[0].toUpperCase()
                              : '?',
                          style: GoogleFonts.vt323(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF8B4513),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          }).toList(),
    );
  }
}
