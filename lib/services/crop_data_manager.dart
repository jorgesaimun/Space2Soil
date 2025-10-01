import '../models/crop.dart';
import 'location_service.dart';
import 'crop_service.dart';

/// Manager class for handling crop data operations
class CropDataManager {
  /// Load crops for current location
  static Future<CropDataResult> loadCropsForCurrentLocation() async {
    try {
      final division = await LocationService.getCurrentDivision();

      if (division != null) {
        return await _loadCropsForDivision(division);
      } else {
        return CropDataResult.fallback(
          message: 'Could not detect your location. Using default crops.',
        );
      }
    } catch (e) {
      return CropDataResult.error(message: 'Error detecting location: $e');
    }
  }

  /// Load crops for specific division
  static Future<CropDataResult> loadCropsForDivision(String division) async {
    return await _loadCropsForDivision(division);
  }

  /// Load crops for division with error handling
  static Future<CropDataResult> _loadCropsForDivision(String division) async {
    try {
      final cropNames = await CropService.getCropsByDivision(division);

      if (cropNames.isEmpty) {
        return CropDataResult.fallback(
          message: 'No crops found for $division. Using default crops.',
        );
      }

      // Fetch detailed data for each crop
      final crops = <Crop>[];
      for (final cropName in cropNames) {
        try {
          final cropDetails = await CropService.getCropDetails(
            division: division,
            crop: cropName,
          );

          if (cropDetails.isNotEmpty) {
            // Use the first result if multiple entries exist
            final details = cropDetails.first;
            print('Fetched details for $cropName: $details');
            crops.add(
              Crop.fromDatabaseDetails(
                cropName: cropName,
                division: division,
                details: details,
              ),
            );
          } else {
            // Fallback to basic crop if no details found
            crops.add(Crop.fromDatabase(cropName, division));
          }
        } catch (e) {
          print('Error fetching details for $cropName: $e');
          // Fallback to basic crop if detail fetch fails
          crops.add(Crop.fromDatabase(cropName, division));
        }
      }

      return CropDataResult.success(crops: crops, division: division);
    } catch (e) {
      return CropDataResult.error(
        message: 'Error loading crops for $division: $e',
      );
    }
  }

  /// Get fallback crops when database fails
  static List<Crop> getFallbackCrops() {
    return CropData.fallbackCrops;
  }
}

/// Result class for crop data operations
class CropDataResult {
  final bool isSuccess;
  final bool isError;
  final bool isFallback;
  final List<Crop> crops;
  final String? division;
  final String message;

  const CropDataResult._({
    required this.isSuccess,
    required this.isError,
    required this.isFallback,
    required this.crops,
    this.division,
    required this.message,
  });

  factory CropDataResult.success({
    required List<Crop> crops,
    required String division,
  }) {
    return CropDataResult._(
      isSuccess: true,
      isError: false,
      isFallback: false,
      crops: crops,
      division: division,
      message: 'Crops loaded successfully for $division',
    );
  }

  factory CropDataResult.error({required String message}) {
    return CropDataResult._(
      isSuccess: false,
      isError: true,
      isFallback: false,
      crops: [],
      message: message,
    );
  }

  factory CropDataResult.fallback({required String message}) {
    return CropDataResult._(
      isSuccess: false,
      isError: false,
      isFallback: true,
      crops: CropData.fallbackCrops,
      message: message,
    );
  }
}
