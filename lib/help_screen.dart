import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg1.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.75,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(
                children: [
                  // Main wooden dialog background
                  Container(
                    margin: const EdgeInsets.only(top: 25),
                    decoration: BoxDecoration(
                      color: const Color(0xFF8B4513), // Wood brown
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFFD4A574),
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 60), // Space for header
                        // Help content
                        Expanded(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 25,
                              vertical: 15,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Game Instructions
                                _buildHelpSection(
                                  'How to Play',
                                  'Welcome to Space2Soil! This game uses real NASA data to help you learn about soil and agriculture.',
                                ),
                                const SizedBox(height: 20),

                                _buildHelpSection(
                                  'Location Access',
                                  'We need your location to provide accurate NASA soil and weather data for your specific area.',
                                ),
                                const SizedBox(height: 20),

                                _buildHelpSection(
                                  'Game Features',
                                  '• Plant and grow different crops\n• Learn about soil composition\n• Use real NASA satellite data\n• Explore agricultural science',
                                ),
                                const SizedBox(height: 20),

                                _buildHelpSection(
                                  'Controls',
                                  '• Tap to interact with objects\n• Use settings to adjust sound and graphics\n• Navigate with on-screen buttons',
                                ),

                                const SizedBox(height: 30),

                                // Back button
                                Center(child: _buildBackButton(context)),

                                const SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Help header tab
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFD700), // Golden yellow
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: const Color(0xFFFF8C00),
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Text(
                          'HELP',
                          style: GoogleFonts.vt323(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHelpSection(String title, String content) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFD4A574), // Light wood
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF8B4513), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.vt323(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: GoogleFonts.vt323(
              fontSize: 14,
              color: Colors.black,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        width: 100,
        height: 40,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF9C7FB8), Color(0xFF7B68B1)],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black, width: 3),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Text(
            'BACK',
            style: GoogleFonts.vt323(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    );
  }
}
