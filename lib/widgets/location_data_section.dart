import 'package:flutter/material.dart';
import 'package:demo_game/help_screen.dart';

class LocationDataSection extends StatelessWidget {
  final String? locationName;
  final Map<String, String> mockData;
  final AnimationController dataController;

  const LocationDataSection({
    super.key,
    required this.locationName,
    required this.mockData,
    required this.dataController,
  });

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
          Container(
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
        ],
      ),
    );
  }

  Widget _buildDataCardsRow() {
    return Row(
      children: [
        _buildDataCard(
          'TEMPERATURE',
          mockData['temperature']!,
          Icons.thermostat,
          const Color(0xFFFF5722),
        ),
        const SizedBox(width: 10),
        _buildDataCard(
          'HUMIDITY',
          mockData['humidity']!,
          Icons.water_drop,
          const Color(0xFF2196F3),
        ),
        const SizedBox(width: 10),
        _buildDataCard(
          'NDVI',
          mockData['ndvi']!,
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
              // color: Colors.white, // White color for the icon
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
