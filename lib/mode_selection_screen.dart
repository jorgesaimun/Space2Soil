import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ModeSelectionScreen extends StatefulWidget {
  const ModeSelectionScreen({super.key});

  @override
  State<ModeSelectionScreen> createState() => _ModeSelectionScreenState();
}

class _ModeSelectionScreenState extends State<ModeSelectionScreen> {
  final ImagePicker _picker = ImagePicker();

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
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.7,
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Title
                    Text(
                      'SELECT MODE',
                      style: GoogleFonts.vt323(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFD4A574),
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 30),
                    
                    // Mode buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Sandbox Mode Button
                        _buildModeButton(
                          title: 'SANDBOX',
                          subtitle: 'Free Play',
                          icon: Icons.play_circle_outline,
                          gradientColors: const [
                            Color(0xFF4CAF50),
                            Color(0xFF2E7D32),
                          ],
                          onTap: () {
                            _navigateToMode('sandbox');
                          },
                        ),
                        
                        // Classic Mode Button
                        _buildModeButton(
                          title: 'CLASSIC',
                          subtitle: 'Challenge',
                          icon: Icons.star,
                          gradientColors: const [
                            Color(0xFFFF9800),
                            Color(0xFFE65100),
                          ],
                          onTap: () {
                            _navigateToMode('classic');
                          },
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // Camera button with label
                    Column(
                      children: [
                        Text(
                          'TAKE PHOTO',
                          style: GoogleFonts.vt323(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFD4A574),
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _buildCameraButton(),
                      ],
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Back button
                    _buildBackButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModeButton({
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Color> gradientColors,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        height: 120,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black, width: 3),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 32,
              color: Colors.white,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: GoogleFonts.vt323(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: GoogleFonts.vt323(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraButton() {
    return GestureDetector(
      onTap: _openCamera,
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
          ),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.6),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: const Icon(
          Icons.camera_alt,
          size: 60,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        width: 100,
        height: 50,
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
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToMode(String mode) {
    // TODO: Navigate to the selected game mode
    // For now, just show a dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Mode Selected',
          style: GoogleFonts.vt323(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'You selected ${mode.toUpperCase()} mode!',
          style: GoogleFonts.vt323(fontSize: 18),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'OK',
              style: GoogleFonts.vt323(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openCamera() async {
    try {
      // Request camera permission
      final status = await Permission.camera.request();
      
      if (status.isGranted) {
        // Open camera
        final XFile? image = await _picker.pickImage(
          source: ImageSource.camera,
          imageQuality: 80,
        );
        
        if (image != null) {
          // Show success message
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Photo captured successfully!',
                  style: GoogleFonts.vt323(fontSize: 16),
                ),
                backgroundColor: const Color(0xFF4CAF50),
                duration: const Duration(seconds: 2),
              ),
            );
          }
          
          // TODO: Process the captured image later
          print('Image captured: ${image.path}');
        }
      } else {
        // Show permission denied message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Camera permission is required to take photos.',
                style: GoogleFonts.vt323(fontSize: 16),
              ),
              backgroundColor: const Color(0xFFF44336),
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error opening camera: $e',
              style: GoogleFonts.vt323(fontSize: 16),
            ),
            backgroundColor: const Color(0xFFF44336),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }
}
