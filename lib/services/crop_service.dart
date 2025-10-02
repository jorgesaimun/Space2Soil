import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_client.dart';

/// Service for handling crop-related database operations
class CropService {
  static final SupabaseClient _supabase = SupabaseService.client;

  /// Get all crops available for a specific division
  static Future<List<String>> getCropsByDivision(String division) async {
    if (division.isEmpty) {
      throw ArgumentError('Division cannot be empty');
    }

    try {
      // Normalize the input division name
      final normalizedDivision = _normalizeDivisionName(division.trim());

      print(
        'Searching for crops in division: "$normalizedDivision" (original: "$division")',
      );

      // Use case-insensitive search to handle name variations
      final response = await _supabase
          .from('soil2space_crop_data')
          .select('crop')
          .ilike('division', normalizedDivision);

      if (response.isEmpty) {
        // Debug: Try to find similar division names
        print(
          'No crops found for "$normalizedDivision", checking available divisions...',
        );
        final allDivisions = await getAllDivisions();
        final similarDivisions =
            allDivisions
                .where(
                  (d) =>
                      d.toLowerCase().contains(
                        normalizedDivision.toLowerCase(),
                      ) ||
                      normalizedDivision.toLowerCase().contains(
                        d.toLowerCase(),
                      ),
                )
                .toList();

        if (similarDivisions.isNotEmpty) {
          print('Similar divisions found: $similarDivisions');
          // Try searching with the first similar division
          final altResponse = await _supabase
              .from('soil2space_crop_data')
              .select('crop')
              .ilike('division', similarDivisions.first);

          if (altResponse.isNotEmpty) {
            print('Found crops using division: "${similarDivisions.first}"');
            return _extractUniqueCropNames(altResponse);
          }
        }

        print('Available divisions: $allDivisions');
        return [];
      }

      final crops = _extractUniqueCropNames(response);
      print('Found ${crops.length} crops: $crops');

      return crops;
    } catch (e) {
      print('Error fetching crops for division $division: $e');
      rethrow;
    }
  }

  /// Get detailed crop data for a specific crop in a division
  static Future<List<Map<String, dynamic>>> getCropDetails({
    required String division,
    required String crop,
  }) async {
    try {
      final response = await _supabase
          .from('soil2space_crop_data')
          .select('cultivation_period, smap, ndvi')
          .eq('division', division)
          .eq('crop', crop);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error fetching crop details for $crop in $division: $e');
      rethrow;
    }
  }

  /// Get all available divisions from database
  static Future<List<String>> getAllDivisions() async {
    try {
      final response = await _supabase
          .from('soil2space_crop_data')
          .select('division');

      return _extractUniqueDivisions(response);
    } catch (e) {
      print('Error fetching divisions: $e');
      rethrow;
    }
  }

  /// Extract unique crop names from database response
  static List<String> _extractUniqueCropNames(List<dynamic> response) {
    final Set<String> uniqueCrops = {};
    for (var item in response) {
      if (item['crop'] != null) {
        uniqueCrops.add(item['crop'] as String);
      }
    }
    return uniqueCrops.toList()..sort();
  }

  /// Extract unique divisions from database response
  static List<String> _extractUniqueDivisions(List<dynamic> response) {
    final Set<String> uniqueDivisions = {};
    for (var item in response) {
      if (item['division'] != null) {
        uniqueDivisions.add(item['division'] as String);
      }
    }
    return uniqueDivisions.toList()..sort();
  }

  /// Normalize division names to handle common variations
  static String _normalizeDivisionName(String division) {
    final normalized = division.toLowerCase().trim();

    // Handle common name variations for Bangladesh divisions
    final nameMap = {
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

    // Return mapped name or original with proper capitalization
    return nameMap[normalized] ?? _capitalizeFirstLetter(division.trim());
  }

  /// Helper method to capitalize first letter of each word
  static String _capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text
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
