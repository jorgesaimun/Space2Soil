import 'package:demo_game/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'crop_selection_screen.dart';
import 'creative_mode_animation.dart';
import 'settings_screen.dart';
import 'help_screen.dart';

class UnlockedAllMode extends StatefulWidget {
  final String location;

  const UnlockedAllMode({super.key, required this.location});

  @override
  State<UnlockedAllMode> createState() => _UnlockedAllModeState();
}

class _UnlockedAllModeState extends State<UnlockedAllMode> {
  String selectedMode = 'career'; // default selection

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background_img.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Location Header
              _buildLocationHeader(),

              // Main Content
              Expanded(
                child: Stack(
                  children: [
                    // Left Sidebar
                    _buildLeftSidebar(),

                    // Center content with mode selection and next button
                    _buildCenterContent(),

                    // Character and Speech Bubble (Right side)
                    _buildCharacterSection(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationHeader() {
    return Container(
      height: 80,
      decoration: const BoxDecoration(
        color: Color(0xFFFFD700), // Gold/Yellow background
        border: Border(
          top: BorderSide(color: Color(0xFFFF6600), width: 4),
          bottom: BorderSide(color: Color(0xFFFF6600), width: 4),
        ),
      ),
      child: Row(
        children: [
          // Globe icon with map background
          Padding(
            padding: const EdgeInsets.all(12),
            child: Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: ClipOval(
                child: Image.asset('assets/images/map.png', fit: BoxFit.cover),
              ),
            ),
          ),

          // Left section with "Your Location:" text
          Expanded(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFE6F3FF), // Light blue background
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: const Color(0xFF4A90E2), width: 2),
              ),
              child: Center(
                child: Text(
                  'Your Location:',
                  style: GoogleFonts.vt323(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),

          // Orange play button in the middle
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFFFF6600), // Orange color
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.play_arrow, color: Colors.white, size: 24),
          ),

          // Right section with location name
          Expanded(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFE6F3FF), // Light blue background
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: const Color(0xFF4A90E2), width: 2),
              ),
              child: Center(
                child: Text(
                  widget.location,
                  style: GoogleFonts.vt323(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),
        ],
      ),
    );
  }

  Widget _buildLeftSidebar() {
    return Positioned(
      left: 20,
      top: 20,
      child: Column(
        children: [
          _buildSidebarButton('assets/images/profile_icon.png', 'Profile', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            );
          }),
          const SizedBox(height: 16),
          _buildSidebarButton(
            'assets/images/settings_icon.png',
            'Settings',
            () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
          const SizedBox(height: 16),
          _buildSidebarButton('assets/images/questins_icon.png', 'Help', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HelpScreen()),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSidebarButton(
    String imagePath,
    String tooltip,
    VoidCallback onPressed,
  ) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.orange,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 3),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Image.asset(imagePath, fit: BoxFit.contain),
        ),
      ),
    );
  }

  Widget _buildCenterContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Mode Selection
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Career Mode - Unlocked
              GestureDetector(
                onTap: () => setState(() => selectedMode = 'career'),
                child: Container(
                  decoration: BoxDecoration(
                    border:
                        selectedMode == 'career'
                            ? Border.all(color: Colors.green, width: 3)
                            : null,
                    //  borderRadius: BorderRadius.circular(10),
                  ),
                  child: Image.asset(
                    'assets/images/unlocked.png',
                    width: 150,
                    height: 150,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              // Creative Mode - Unlocked
              GestureDetector(
                onTap: () => setState(() => selectedMode = 'creative'),
                child: Container(
                  decoration: BoxDecoration(
                    border:
                        selectedMode == 'creative'
                            ? Border.all(color: Colors.green, width: 3)
                            : null,
                  ),
                  child: Image.asset(
                    'assets/images/unlocked_creative.png',
                    width: 150,
                    height: 150,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Next Button
          GestureDetector(
            onTap: () {
              if (selectedMode == 'career') {
                // Navigate to Crop Selection for Career Mode
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => CropSelectionScreen(
                          detectedLocation: widget.location,
                        ),
                  ),
                );
              } else if (selectedMode == 'creative') {
                // Navigate to Creative Mode Animation Screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreativeModeAnimationScreen(),
                  ),
                );
              }
            },
            child: Container(
              width: 120,
              height: 50,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF9C7FB8), Color(0xFF7B68B1)],
                ),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: const Color(0xFF4A148C), width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  'NEXT',
                  style: GoogleFonts.vt323(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCharacterSection() {
    return Positioned(
      right: 20,
      top: 80,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Speech Bubble
          Container(
            width: 180,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.black, width: 2),
            ),
            child: Text(
              'Congratulations! You have unlocked all modes!',
              style: GoogleFonts.vt323(fontSize: 14, color: Colors.black),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 6),
          // Character
          Container(
            width: 80,
            height: 100,
            child: Image.asset(
              'assets/images/farmer_img.png',
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
