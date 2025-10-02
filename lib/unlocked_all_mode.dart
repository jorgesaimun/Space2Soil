import 'package:demo_game/profile_screen.dart';
import 'package:flutter/material.dart';
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
      // margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      height: 100,
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage('assets/images/map.png'),
          fit: BoxFit.cover,
        ),
        // borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFFF8C00), width: 3),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 220, 129),
          borderRadius: BorderRadius.circular(12),
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
                  child: Image.asset(
                    'assets/images/map.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            // Left section with "Your Location:" text
            Expanded(
              flex: 2,
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFFF8C00), width: 2),
                ),
                child: const Center(
                  child: Text(
                    'Your Location:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF8B4513), // Brown color
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
                color: Color(0xFFFF8C00), // Orange color
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 24,
              ),
            ),

            // Right section with location name
            Expanded(
              flex: 2,
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFFFD700), width: 2),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    widget.location,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF8B4513),
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
          ElevatedButton(
            onPressed: () {
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
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 210, 154, 219),
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: const Text(
              'NEXT',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontFamily: 'VT323',
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
      top: 10,
      // bottom: 00,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Speech Bubble
          Container(
            width: 200,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.black, width: 2),
            ),
            child: Text(
              'Congratulations! You have unlocked all modes!',
              style: TextStyle(
                fontSize: 12,
                color: Colors.black,
                fontFamily: 'VT323',
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 8),
          // Character
          Container(
            width: 100,
            height: 120,
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
