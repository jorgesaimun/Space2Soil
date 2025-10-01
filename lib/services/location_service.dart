import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

/// Service for handling location-related operations
class LocationService {
  /// Get current device location
  static Future<Position?> getCurrentLocation() async {
    try {
      await _checkLocationPermissions();
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      print('Error getting location: $e');
      return null;
    }
  }

  /// Get division name from coordinates
  static Future<String?> getDivisionFromCoordinates({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final placemarks = await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isEmpty) return null;

      final place = placemarks.first;
      return _extractDivisionFromPlacemark(place);
    } catch (e) {
      print('Error getting division from coordinates: $e');
      return null;
    }
  }

  /// Get current division based on device location
  static Future<String?> getCurrentDivision() async {
    final position = await getCurrentLocation();
    if (position == null) return null;

    return await getDivisionFromCoordinates(
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }

  /// Get list of Bangladesh divisions
  static List<String> getBangladeshDivisions() {
    return [
      'Dhaka',
      'Chattogram',
      'Sylhet',
      'Rajshahi',
      'Khulna',
      'Barishal',
      'Rangpur',
      'Mymensingh',
    ];
  }

  /// Check and request location permissions
  static Future<void> _checkLocationPermissions() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled');
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied');
    }
  }

  /// Extract division name from placemark
  static String? _extractDivisionFromPlacemark(Placemark place) {
    // Try different fields to find division name
    String? rawDivision =
        place.administrativeArea ??
        place.locality ??
        place.subAdministrativeArea;

    if (rawDivision == null) return null;

    // Map common variations to official division names
    return _mapToBangladeshDivision(rawDivision);
  }

  /// Map location names to official Bangladesh divisions
  static String _mapToBangladeshDivision(String locationName) {
    final normalized = locationName.toLowerCase().trim();

    // Division mapping for Bangladesh
    final divisionMap = {
      'chittagong': 'Chattogram',
      'chattogram': 'Chattogram',
      'dhaka': 'Dhaka',
      'sylhet': 'Sylhet',
      'rajshahi': 'Rajshahi',
      'khulna': 'Khulna',
      'barisal': 'Barishal',
      'barishal': 'Barishal',
      'rangpur': 'Rangpur',
      'mymensingh': 'Mymensingh',
    };

    // Check for exact matches first
    if (divisionMap.containsKey(normalized)) {
      return divisionMap[normalized]!;
    }

    // Check for partial matches
    for (final entry in divisionMap.entries) {
      if (normalized.contains(entry.key) || entry.key.contains(normalized)) {
        return entry.value;
      }
    }

    // Return original with proper capitalization if no mapping found
    return locationName
        .split(' ')
        .map(
          (word) =>
              word.isNotEmpty
                  ? word[0].toUpperCase() + word.substring(1).toLowerCase()
                  : word,
        )
        .join(' ');
  }
}
