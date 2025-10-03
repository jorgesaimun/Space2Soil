import 'package:demo_game/widgets/earth_globe_section.dart';
import 'package:demo_game/help_screen.dart';
import 'package:demo_game/crop_selection_screen.dart';
import 'package:flutter/material.dart';

class SelectLocationScreen extends StatefulWidget {
  final String currentLocation;

  const SelectLocationScreen({super.key, required this.currentLocation});

  @override
  State<SelectLocationScreen> createState() => _SelectLocationScreenState();
}

class _SelectLocationScreenState extends State<SelectLocationScreen>
    with TickerProviderStateMixin {
  final List<String> _divisions = [
    'DHAKA',
    'CHITTAGONG',
    'RAJSHAHI',
    'KHULNA',
    'BARISAL',
    'SYLHET',
    'RANGPUR',
    'MYMENSINGH',
  ];

  String? _locationName;
  bool _showDropdown = false;
  late AnimationController _globeController;
  late AnimationController _dataController;

  @override
  void initState() {
    super.initState();
    _locationName = widget.currentLocation.toUpperCase();

    _globeController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();

    _dataController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _globeController.dispose();
    _dataController.dispose();
    super.dispose();
  }

  void _selectLocation(String location) {
    setState(() {
      _locationName = location;
      _showDropdown = false;
    });
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
        child: Stack(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: EarthGlobeSection(
                    globeController: _globeController,
                    onNextPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => CropSelectionScreen(
                                detectedLocation: _locationName ?? 'CHITTAGONG',
                              ),
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: CustomLocationDataSection(
                    locationName: _locationName,
                    dataController: _dataController,
                    onToggleDropdown: () {
                      setState(() {
                        _showDropdown = !_showDropdown;
                      });
                    },
                  ),
                ),
              ],
            ),
            if (_showDropdown) _buildDropdown(),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return Positioned.fill(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _showDropdown = false;
          });
        },
        child: Container(
          color: Colors.black.withOpacity(0.5),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight:
                    MediaQuery.of(context).size.height *
                    0.7, // Max 70% of screen height
                maxWidth:
                    MediaQuery.of(context).size.width *
                    0.8, // Max 80% of screen width
              ),
              child: Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Select Division',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'monospace',
                      ),
                    ),
                    const SizedBox(height: 16),
                    Flexible(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children:
                              _divisions
                                  .map(
                                    (division) => GestureDetector(
                                      onTap: () => _selectLocation(division),
                                      child: Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 12,
                                        ),
                                        margin: const EdgeInsets.only(
                                          bottom: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color:
                                              division == _locationName
                                                  ? Colors.blue
                                                  : Colors.grey[200],
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Text(
                                          division,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'monospace',
                                            fontWeight: FontWeight.bold,
                                            color:
                                                division == _locationName
                                                    ? Colors.white
                                                    : Colors.black,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Custom LocationDataSection that matches the original LocationDataSection but with dropdown
class CustomLocationDataSection extends StatelessWidget {
  final String? locationName;
  final AnimationController dataController;
  final VoidCallback onToggleDropdown;

  const CustomLocationDataSection({
    super.key,
    required this.locationName,
    required this.dataController,
    required this.onToggleDropdown,
  });

  // Mock data matching the original
  static const Map<String, String> _mockData = {
    'temperature': '33°C',
    'humidity': '75%',
    'ndvi': 'N10',
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLocationDisplay(),
          const SizedBox(height: 20),
          _buildDataCardsRow(),
          const Spacer(),
          _buildHelpButton(context),
        ],
      ),
    );
  }

  Widget _buildLocationDisplay() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF8A50), Color(0xFFFFB74D)],
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFD84315), width: 2),
      ),
      child: Column(
        children: [
          const Text(
            'Your Location is:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF8B4513),
              fontFamily: 'monospace',
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: onToggleDropdown,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFFFE0B2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.expand_more, color: Color(0xFF8B4513)),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      locationName ?? 'LOCATION FOUND',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF8B4513),
                        fontFamily: 'monospace',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataCardsRow() {
    return Row(
      children: [
        _buildDataCard(
          'TEMPERATURE',
          _mockData['temperature']!,
          Icons.thermostat,
          const Color(0xFFFF5722),
        ),
        const SizedBox(width: 10),
        _buildDataCard(
          'HUMIDITY',
          _mockData['humidity']!,
          Icons.water_drop,
          const Color(0xFF2196F3),
        ),
        const SizedBox(width: 10),
        _buildDataCard(
          'NDVI',
          _mockData['ndvi']!,
          Icons.eco,
          const Color(0xFF4CAF50),
        ),
      ],
    );
  }

  Widget _buildHelpButton(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HelpScreen()),
          );
        },
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xFFFF8A50), // Orange background
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFD84315), width: 3),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Image(
              image: AssetImage('assets/images/questions_icon.png'),
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDataCard(
    String label,
    String value,
    IconData icon,
    Color iconColor,
  ) {
    return Expanded(
      child: AnimatedBuilder(
        animation: dataController,
        builder: (context, child) {
          return Transform.scale(
            scale: 0.8 + (dataController.value * 0.2),
            child: Container(
              height: 110,
              decoration: BoxDecoration(
                color: const Color(0xFFFFE0B2),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFD84315), width: 2),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: iconColor, size: 30),
                  const SizedBox(height: 8),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF8B4513),
                      fontFamily: 'monospace',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF8B4513),
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
