import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'webview_screen.dart';

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
            image: AssetImage('assets/images/background_img.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(
                children: [
                  // Main wooden dialog background
                  Container(
                    margin: const EdgeInsets.only(top: 25, bottom: 25),
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
                        const SizedBox(height: 30), // Reduced space for header
                        // Help content
                        Expanded(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 25,
                              vertical: 15, // Reduced padding
                            ),
                            child: Column(
                              children: [
                                // Description text
                                Text(
                                  'To provide accurate farming insights, Space2Soil uses your device\'s location to access NASA\'s climate and soil data specific to your region. Granting permission ensures that the game can simulate real conditions for your crops. Without location access, certain features may not work properly.',
                                  style: GoogleFonts.vt323(
                                    fontSize: 18, // Slightly smaller font
                                    color: Colors.white,
                                    height: 1.3, // Reduced line height
                                  ),
                                  textAlign: TextAlign.center,
                                ),

                                const SizedBox(height: 15), // Reduced spacing
                                // Buttons row - wrap for better responsiveness
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  alignment: WrapAlignment.center,
                                  children: [
                                    _buildMenuButton('FAQ', context),
                                    _buildMenuButton('PRIVACY POLICY', context),
                                    _buildMenuButton('CONTACT', context),
                                    _buildMenuButton('CREDITS', context),
                                  ],
                                ),

                                const SizedBox(
                                  height: 10,
                                ), // Fixed spacing instead of Spacer
                                // Version text
                                Text(
                                  'version 1.0.1',
                                  style: GoogleFonts.vt323(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                ),

                                const SizedBox(
                                  height: 15,
                                ), // Reduced bottom spacing
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
                          horizontal: 20,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD4A574), // Golden yellow
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

                  // Back button positioned at bottom right
                  Positioned(
                    bottom: 0,
                    right: 50,
                    child: _buildBackButton(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(String text, BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to webview screen with appropriate URL
        String url = _getUrlForButton(text);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WebViewScreen(title: text, url: url),
          ),
        );
      },
      child: Container(
        width: 110, // Slightly smaller width
        height: 35, // Slightly smaller height
        decoration: BoxDecoration(
          color: const Color(0xFFD4A574), // Light wood color
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color(0xFF8B4513), // Darker brown border
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.vt323(
              fontSize: 12, // Slightly smaller font
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        width: 100,
        height: 60,
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
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    );
  }

  String _getUrlForButton(String buttonText) {
    // TODO: replace with actual Google Docs links
    switch (buttonText) {
      case 'FAQ':
        return 'https://docs.google.com/document/d/1xqyg1WVdXz3F8L420c153BvMSiurDOnB3uHgdPWcmTk/edit?tab=t.0#heading=h.2hdc84oywkl7';
      case 'PRIVACY POLICY':
        return 'https://docs.google.com/document/d/1xqyg1WVdXz3F8L420c153BvMSiurDOnB3uHgdPWcmTk/edit?usp=sharing';
      case 'CONTACT':
        return 'https://docs.google.com/document/d/1xqyg1WVdXz3F8L420c153BvMSiurDOnB3uHgdPWcmTk/edit?tab=t.v7jmt2ywg6a9';
      case 'CREDITS':
        return 'https://docs.google.com/document/d/1xqyg1WVdXz3F8L420c153BvMSiurDOnB3uHgdPWcmTk/edit?tab=t.wqh3bvb5wv6j';
      default:
        return 'https://docs.google.com/document/d/your-default-doc-id/edit';
    }
  }
}
