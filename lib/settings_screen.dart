import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:demo_game/audio_manager.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double _musicVolume = 0.7;
  double _soundEffectsVolume = 0.8;
  bool _fullScreenEnabled = true;
  String _selectedLanguage = 'EN';

  final List<String> _languages = ['EN', 'ES', 'FR', 'DE', 'IT', 'PT'];

  @override
  void initState() {
    super.initState();
    // Pull current volumes from AudioManager so the sliders reflect persisted values
    _musicVolume = AudioManager.instance.musicVolume;
    _soundEffectsVolume = AudioManager.instance.sfxVolume;
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
                        const SizedBox(height: 20), // Reduced space for header
                        // Settings content with scrolling
                        Expanded(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 15,
                            ),
                            child: Column(
                              children: [
                                // Music slider
                                _buildSliderSetting(
                                  icon: Icons.music_note,
                                  label: 'MUSIC',
                                  value: _musicVolume,
                                  onChanged: (value) async {
                                    setState(() => _musicVolume = value);
                                    // Apply immediately and persist
                                    await AudioManager.instance
                                        .setMusicVolume(value);
                                  },
                                ),
                                const SizedBox(height: 5),

                                // Sound Effects slider
                                _buildSliderSetting(
                                  icon: Icons.volume_up,
                                  label: 'SOUND EFFECTS',
                                  value: _soundEffectsVolume,
                                  onChanged: (value) async {
                                    setState(() =>
                                        _soundEffectsVolume = value);
                                    // Apply immediately and persist
                                    await AudioManager.instance
                                        .setSfxVolume(value);
                                  },
                                ),
                                const SizedBox(height: 5),

                                // Full-screen toggle
                                _buildToggleSetting(
                                  icon: Icons.fullscreen,
                                  label: 'FULL-SCREEN',
                                  value: _fullScreenEnabled,
                                  onChanged:
                                      (value) => setState(
                                        () => _fullScreenEnabled = value,
                                      ),
                                ),
                                const SizedBox(height: 5),

                                // Language dropdown
                                _buildDropdownSetting(),

                                const SizedBox(height: 20), // Bottom padding
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Settings header tab
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
                          'SETTINGS',
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

                  // Back button positioned at bottom left
                  Positioned(bottom: 0, right: 50, child: _buildBackButton()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSliderSetting({
    required IconData icon,
    required String label,
    required double value,
    required ValueChanged<double> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFD4A574), // Light wood
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF8B4513), width: 2),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF654321), size: 20),
          const SizedBox(width: 12),
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: GoogleFonts.vt323(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFB8860B), // Dark golden rod
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: const Color(0xFF654321), width: 1),
              ),
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 4,
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 8,
                  ),
                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 8),
                  activeTrackColor: const Color(0xFFFF4444), // Red
                  inactiveTrackColor: const Color(0xFF8B4513), // Brown
                  thumbColor: const Color(0xFFDC143C), // Crimson
                  overlayColor: const Color(0xFFFF6666),
                ),
                child: Slider(
                  value: value,
                  onChanged: onChanged,
                  min: 0.0,
                  max: 1.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleSetting({
    required IconData icon,
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFD4A574), // Light wood
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF8B4513), width: 2),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF654321), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.vt323(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => onChanged(!value),
            child: Container(
              width: 55,
              height: 26,
              decoration: BoxDecoration(
                color:
                    value ? const Color(0xFF4CAF50) : const Color(0xFF757575),
                borderRadius: BorderRadius.circular(13),
                border: Border.all(color: Colors.black, width: 2),
              ),
              child: Center(
                child: Text(
                  value ? 'ON' : 'OFF',
                  style: GoogleFonts.vt323(
                    fontSize: 12,
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

  Widget _buildDropdownSetting() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFD4A574), // Light wood
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF8B4513), width: 2),
      ),
      child: Row(
        children: [
          const Icon(Icons.language, color: Color(0xFF654321), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'LANGUAGE',
              style: GoogleFonts.vt323(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
            decoration: BoxDecoration(
              color: const Color(0xFFFFE4B5),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: const Color(0xFF8B4513), width: 1),
            ),
            height: 26, // Fixed height to match toggle switch
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedLanguage,
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: Color(0xFF654321),
                  size: 16,
                ),
                style: GoogleFonts.vt323(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                items:
                    _languages.map((String language) {
                      return DropdownMenuItem<String>(
                        value: language,
                        child: Text(language),
                      );
                    }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() => _selectedLanguage = newValue);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackButton() {
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


}
