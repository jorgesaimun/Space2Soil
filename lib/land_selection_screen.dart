import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models/crop.dart';
import 'models/land.dart';
import 'cultivation_screen.dart';
import 'widgets/land_selection_widgets/land_panel_widget.dart';
import 'widgets/land_selection_widgets/custom_land_dialog.dart';

class LandSelectionScreen extends StatefulWidget {
  final Crop selectedCrop;
  final String? division;

  const LandSelectionScreen({
    super.key,
    required this.selectedCrop,
    this.division,
  });

  @override
  State<LandSelectionScreen> createState() => _LandSelectionScreenState();
}

class _LandSelectionScreenState extends State<LandSelectionScreen> {
  // Page controller to swipe between pairs of lands
  final PageController _pageController = PageController(initialPage: 0);
  int _currentIndex = 0;
  int _selectedIndex = 0;
  bool _isDialogOpen = false;

  // Pre-defined land sizes (Length x Width in feet)
  final List<Land> _predefinedLands = [
    // Examples covering squares, wide and tall rectangles
    Land(length: 100, width: 50, isCustom: false), // 100×50
    Land(length: 80, width: 80, isCustom: false), // 80×80
    Land(length: 30, width: 700, isCustom: false), // 30×700
    Land(length: 50, width: 100, isCustom: false),
    Land(length: 120, width: 90, isCustom: false),
    Land(length: 150, width: 100, isCustom: false),
    Land(length: 200, width: 150, isCustom: false),
    Land(length: 200, width: 200, isCustom: false),
    Land(length: 250, width: 200, isCustom: false),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background_img.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                // Header
                _buildHeader(),
                const SizedBox(height: 15),
                // Land selection pages (2 per page) with optional Custom on the right
                if (!_isDialogOpen) Expanded(child: _buildLandArea()),
                const SizedBox(height: 8),
                // Page indicator
                if (!_isDialogOpen) _buildPageIndicator(),
                const SizedBox(height: 12),
                // Action buttons
                if (!_isDialogOpen) _buildActionButtons(),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          'choose your field',
          style: GoogleFonts.vt323(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 4,
                offset: const Offset(2, 2),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Choose the perfect land for your ${widget.selectedCrop.name}',
          style: GoogleFonts.vt323(
            fontSize: 16,
            color: Colors.white70,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 2,
                offset: const Offset(1, 1),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  int get _totalPages => (_predefinedLands.length / 2).ceil();

  Widget _buildLandArea() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 700;
        return Row(
          children: [
            // Page with 2 cards side-by-side
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (page) {
                  setState(() {
                    _currentIndex = page * 2;
                    // Keep selection within the visible pair
                    if (_selectedIndex < _currentIndex ||
                        _selectedIndex > _currentIndex + 1) {
                      _selectedIndex = _currentIndex;
                    }
                  });
                },
                itemCount: _totalPages,
                itemBuilder: (context, page) {
                  final firstIndex = page * 2;
                  final secondIndex = firstIndex + 1;
                  final first = _predefinedLands[firstIndex];
                  final second =
                      secondIndex < _predefinedLands.length
                          ? _predefinedLands[secondIndex]
                          : null;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildLandCard(first, firstIndex),
                      const SizedBox(width: 24),
                      if (second != null) _buildLandCard(second, secondIndex),
                    ],
                  );
                },
              ),
            ),
            // Custom button on the right for wide screens
            if (isWide) ...[
              const SizedBox(width: 24),
              _buildCustomButton(() => _showCustomLandDialog()),
            ],
          ],
        );
      },
    );
  }

  Widget _buildLandCard(Land land, int index) {
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 260, maxHeight: 280),
        child: LandPanelWidget(land: land, isSelected: _selectedIndex == index),
      ),
    );
  }

  // Removed custom card from carousel; custom is accessed via button only.

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _totalPages,
        (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color:
                (_currentIndex / 2).floor() == index
                    ? const Color(0xFF4CAF50)
                    : Colors.white.withOpacity(0.4),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 700;
        return Row(
          mainAxisAlignment:
              isWide ? MainAxisAlignment.center : MainAxisAlignment.spaceEvenly,
          children: [
            if (!isWide) _buildCustomButton(() => _showCustomLandDialog()),
            _buildActionButton(
              'START',
              const Color(0xFF4CAF50),
              () => _selectCurrentLand(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCustomButton(VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFFE082), Color(0xFFFFD54F)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Color(0xFFE65100), width: 3),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 20,
              height: 20,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFFFCC80),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFE65100), width: 2),
              ),
              child: const Icon(Icons.add, size: 14, color: Color(0xFF8D6E63)),
            ),
            Text(
              'custom',
              style: GoogleFonts.vt323(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF4A4A4A),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(String text, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Text(
          text,
          style: GoogleFonts.vt323(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _showCustomLandDialog() {
    setState(() => _isDialogOpen = true);
    showDialog<Land>(
      context: context,
      barrierDismissible: true,
      builder:
          (context) => CustomLandDialog(
            onLandCreated: (land) {
              // kept for backwards compatibility; will be handled on pop result too
              _navigateToFarm(land);
            },
          ),
    ).then((result) {
      if (mounted) setState(() => _isDialogOpen = false);
      if (result != null) {
        _navigateToFarm(result);
      }
    });
  }

  void _selectCurrentLand() {
    _navigateToFarm(_predefinedLands[_selectedIndex]);
  }

  void _navigateToFarm(Land selectedLand) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => CultivationScreen(
              selectedCrop: widget.selectedCrop,
              selectedLand: selectedLand,
              division: widget.division,
            ),
      ),
    );
  }
}
