import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  Position? _currentPosition;
  bool _isLoading = true;
  String _locationStatus = 'Getting location...';

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    try {
      // Request location permission
      PermissionStatus permission = await Permission.location.request();

      if (permission == PermissionStatus.granted) {
        // Check if location services are enabled
        bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

        if (!serviceEnabled) {
          setState(() {
            _locationStatus =
                'Location services are disabled. Please enable location services.';
            _isLoading = false;
          });
          return;
        }

        // Get current position
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        setState(() {
          _currentPosition = position;
          _locationStatus = 'Location found!';
          _isLoading = false;
        });
      } else if (permission == PermissionStatus.denied) {
        setState(() {
          _locationStatus =
              'Location permission denied. Please grant permission to continue.';
          _isLoading = false;
        });
      } else if (permission == PermissionStatus.permanentlyDenied) {
        setState(() {
          _locationStatus =
              'Location permission permanently denied. Please enable it in settings.';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _locationStatus = 'Error getting location: $e';
        _isLoading = false;
      });
    }
  }

  Widget _buildLocationInfo() {
    if (_isLoading) {
      return const Column(
        children: [
          CircularProgressIndicator(color: Colors.white),
          SizedBox(height: 20),
          Text(
            'Getting your location...',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ],
      );
    }

    if (_currentPosition != null) {
      return Column(
        children: [
          const Icon(Icons.location_on, color: Colors.green, size: 60),
          const SizedBox(height: 20),
          Text(
            _locationStatus,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your Location:',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    const Icon(Icons.my_location, color: Colors.blue, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Latitude: ${_currentPosition!.latitude.toStringAsFixed(6)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.my_location, color: Colors.red, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Longitude: ${_currentPosition!.longitude.toStringAsFixed(6)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.speed, color: Colors.orange, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Accuracy: ${_currentPosition!.accuracy.toStringAsFixed(1)} meters',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        const Icon(Icons.location_off, color: Colors.red, size: 60),
        const SizedBox(height: 20),
        Text(
          _locationStatus,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: _getLocation,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          ),
          child: const Text('Retry Location'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1976D2), // Blue
              Color(0xFF0D47A1), // Dark blue
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // Header
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    const Expanded(
                      child: Text(
                        'Space2Soil Game',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 50), // Balance the back button
                  ],
                ),
                const SizedBox(height: 40),

                // Location content
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(child: _buildLocationInfo()),
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
