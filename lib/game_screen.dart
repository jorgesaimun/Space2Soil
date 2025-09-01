import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  Position? _currentPosition;
  String? _locationName;
  bool _isLoading = true;
  String _locationStatus = 'Getting location...';

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    try {
      setState(() {
        _isLoading = true;
        _locationStatus = 'Getting location...';
      });

      // Check if location services are enabled first
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _locationStatus =
              'Location services are disabled. Please enable location services.';
          _isLoading = false;
        });
        return;
      }

      // Request location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _locationStatus =
                'Location permission denied. Please grant permission to continue.';
            _isLoading = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _locationStatus =
              'Location permissions are permanently denied, we cannot request permissions.';
          _isLoading = false;
        });
        return;
      }

      // Get current position with timeout and lower accuracy for better compatibility
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
        timeLimit: const Duration(seconds: 10),
      );

      // Get location name from coordinates with error handling
      String locationName = 'Unknown Location';
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        if (placemarks.isNotEmpty) {
          Placemark place = placemarks[0];
          String city =
              place.locality ??
              place.subAdministrativeArea ??
              place.administrativeArea ??
              'Unknown City';
          String country = place.country ?? 'Unknown Country';
          locationName = '$city, $country';
        }
      } catch (geocodingError) {
        print('Geocoding error: $geocodingError');
        // Use coordinates as fallback if geocoding fails
        locationName =
            'LAT: ${position.latitude.toStringAsFixed(2)}, LON: ${position.longitude.toStringAsFixed(2)}';
      }

      setState(() {
        _currentPosition = position;
        _locationName = locationName.toUpperCase();
        _locationStatus = 'Location found!';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _locationStatus = 'Error getting location: ${e.toString()}';
        _isLoading = false;
      });
      print('Location error details: $e');
    }
  }

  // Mock location for testing/demo purposes
  void _useMockLocation() {
    setState(() {
      _currentPosition = Position(
        latitude: 23.8103, // Dhaka coordinates
        longitude: 90.4125,
        timestamp: DateTime.now(),
        accuracy: 10.0,
        altitude: 0.0,
        altitudeAccuracy: 0.0,
        heading: 0.0,
        headingAccuracy: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0,
      );
      _locationName = 'DHAKA, BANGLADESH';
      _locationStatus = 'Demo location loaded!';
      _isLoading = false;
    });
  }

  Widget _buildEarthGlobe() {
    return Container(
      width: 200,
      height: 200,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            Color(0xFF87CEEB), // Sky blue
            Color(0xFF4169E1), // Royal blue
            Color(0xFF000080), // Navy
          ],
        ),
      ),
      child: Stack(
        children: [
          // Earth continents (simplified)
          Positioned(
            top: 40,
            left: 60,
            child: Container(
              width: 80,
              height: 60,
              decoration: BoxDecoration(
                color: const Color(0xFF228B22),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
          Positioned(
            top: 70,
            right: 40,
            child: Container(
              width: 50,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF32CD32),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            left: 40,
            child: Container(
              width: 60,
              height: 45,
              decoration: BoxDecoration(
                color: const Color(0xFF228B22),
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
          // Location pin
          const Positioned(
            top: 80,
            left: 85,
            child: Icon(Icons.location_on, color: Colors.red, size: 30),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationContent() {
    if (_isLoading) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildEarthGlobe(),
          const SizedBox(height: 30),
          const CircularProgressIndicator(
            color: Color(0xFFFF6B35),
            strokeWidth: 3,
          ),
          const SizedBox(height: 20),
          const Text(
            'Getting your location...',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      );
    }

    if (_currentPosition == null || _locationName == null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildEarthGlobe(),
          const SizedBox(height: 30),
          const Icon(Icons.location_off, color: Colors.red, size: 60),
          const SizedBox(height: 20),
          Text(
            _locationStatus,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black, fontSize: 16),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: _getLocation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6B35),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text('Retry Location'),
              ),
              ElevatedButton(
                onPressed: _useMockLocation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8E24AA),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text('Demo Location'),
              ),
            ],
          ),
        ],
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Earth globe
        _buildEarthGlobe(),
        const SizedBox(height: 30),

        // Location dialog box
        Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF8DC), // Cornsilk color
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: const Color(0xFFFF6B35), width: 3),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              const Text(
                'Your Location is:',
                style: TextStyle(
                  color: Color(0xFFB8860B),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFDEB887),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  _locationName!,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 30),

        // Data cards row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildDataCard(
              icon: Icons.thermostat,
              value: '33°C',
              label: 'TEMPERATURE',
              color: Colors.red,
            ),
            _buildDataCard(
              icon: Icons.water_drop,
              value: '75%',
              label: 'HUMIDITY',
              color: Colors.blue,
            ),
            _buildDataCard(
              icon: Icons.eco,
              value: 'A10',
              label: 'NDTI',
              color: Colors.green,
            ),
          ],
        ),

        const SizedBox(height: 30),

        // Next button
        ElevatedButton(
          onPressed: () {
            // Navigate to next screen or show game content
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Game continues from here!'),
                backgroundColor: Color(0xFF8E24AA),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF8E24AA),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            elevation: 5,
          ),
          child: const Text(
            'NEXT',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDataCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      width: 90,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8DC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFFF6B35), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/field.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.orange.withOpacity(0.3),
                Colors.blue.withOpacity(0.2),
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // Header with close button
                Row(
                  children: [
                    const SizedBox(width: 20),
                    const Icon(Icons.location_on, color: Colors.red, size: 30),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.close,
                        color: Colors.red,
                        size: 30,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: const Color(0xFFFF6B35),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                  ],
                ),

                // Main content
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: _buildLocationContent(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
