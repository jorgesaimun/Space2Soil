/// Model class for crop data
class Crop {
  final String name;
  final String imagePath;
  final String cropCycle;
  final String places;
  final String notes;
  final List<String> relatedItems;
  final double? yield;
  final Map<String, dynamic>? smap;
  final Map<String, dynamic>? ndvi;

  const Crop({
    required this.name,
    required this.imagePath,
    required this.cropCycle,
    required this.places,
    required this.notes,
    required this.relatedItems,
    this.yield,
    this.smap,
    this.ndvi,
  });

  /// Factory constructor to create Crop from database data
  factory Crop.fromDatabase(String cropName, String division) {
    return Crop(
      name: cropName,
      imagePath: _getImagePathForCrop(cropName),
      cropCycle: 'Available in $division',
      places: division,
      notes: 'Crop available in $division division',
      relatedItems: [_getImagePathForCrop(cropName)],
    );
  }

  /// Factory constructor to create Crop from real database details
  factory Crop.fromDatabaseDetails({
    required String cropName,
    required String division,
    required Map<String, dynamic> details,
  }) {
    return Crop(
      name: cropName,
      imagePath: _getImagePathForCrop(cropName),
      cropCycle:
          _formatCropCycle(details['cultivation_period']) ?? 'Not specified',
      places: division,
      notes:
          'Expected yield: ${details['yield'] ?? 'N/A'} tons per hectare. Suitable for $division division.',
      relatedItems: [_getImagePathForCrop(cropName)],
      yield: details['yield']?.toDouble(),
      smap: details['smap'],
      ndvi: details['ndvi'],
    );
  }

  /// Format crop cycle to use regular hyphen instead of en dash
  static String? _formatCropCycle(String? cultivationPeriod) {
    if (cultivationPeriod == null) return null;

    // Replace en dash (–) with regular hyphen (-)
    return cultivationPeriod
        .replaceAll('–', '-') // En dash
        .replaceAll('—', '-') // Em dash
        .trim();
  }

  /// Get image path based on crop name using standardized format
  static String _getImagePathForCrop(String cropName) {
    // Convert crop name to proper case for file name
    final formattedName = _formatCropNameForFile(cropName);

    // Return standardized path: assets/images/crops/{CropName}.jpeg
    final imagePath = 'assets/images/crops/$formattedName.jpeg';
    print('Generated image path for "$cropName": $imagePath');

    return imagePath;
  }

  /// Format crop name for file path (capitalize first letter)
  static String _formatCropNameForFile(String cropName) {
    if (cropName.isEmpty) return cropName;

    // Handle special cases and normalize the name
    String normalized = cropName.toLowerCase().trim();
    print('Formatting crop name: "$cropName" -> normalized: "$normalized"');

    // Check for BRRI dhan patterns (BRRI dhan means rice)
    if (normalized.contains('brri') && normalized.contains('dhan')) {
      print('Detected BRRI dhan variety "$cropName" - mapping to Rice');
      return 'Rice';
    }

    // Check for other rice variety patterns
    if (normalized.contains('dhan') ||
        normalized.startsWith('brri') ||
        normalized.contains('rice variety')) {
      print('Detected rice variety "$cropName" - mapping to Rice');
      return 'Rice';
    }

    // Handle special crop name mappings if needed
    final specialMappings = {
      'chili': 'Chili',
      'chilli': 'Chili',
      'banana': 'Banana',
      'rice': 'Rice',
      'wheat': 'Wheat',
      'maize': 'Maize',
      'potato': 'Potato',
      'tomato': 'Tomato',
      'lentil': 'Lentil',
      'mustard': 'Mustard',
      'tea': 'Tea',
      // Jute mappings
      'jute': 'Jute',
      'tossa jute': 'Jute',
      'tossa': 'Jute',
      'jute (tossa)': 'Jute',
      // Brinjal mappings
      'eggplant': 'Brinjal',
      'brinjal': 'Brinjal',
      'brinjal (eggplant)': 'Brinjal',
      'egg plant': 'Brinjal',
      'aubergine': 'Brinjal',
      // Other mappings
      'cabbage': 'Cabbage',
      'cauliflower': 'Cauliflower',
      'betel leaf': 'Betel_leaf',
      'betel_leaf': 'Betel_leaf',
      'watermelon': 'Watermelon',
      'mango': 'Mango',
      'lemon': 'Lemon',
    };

    // Use special mapping if available, otherwise capitalize first letter
    final result =
        specialMappings[normalized] ??
        cropName[0].toUpperCase() + cropName.substring(1).toLowerCase();

    print('Crop mapping result: "$cropName" -> "$result"');
    return result;
  }
}

/// Available crops data - now supports dynamic loading
class CropData {
  static List<Crop> crops = [];

  /// Fallback crops when database is unavailable
  static const List<Crop> fallbackCrops = [
    Crop(
      name: 'Tomato',
      imagePath: 'assets/images/tomato_icon.png',
      cropCycle: 'February-July',
      places: 'Khulna, Dhaka, CTG',
      notes:
          'Tropical Vegetable, needs good care, water and strict pesticide control',
      relatedItems: ['assets/images/tomato_icon.png'],
    ),
    Crop(
      name: 'Potato',
      imagePath: 'assets/images/potato.png',
      cropCycle: 'November-March',
      places: 'Rangpur, Bogura, Munshiganj',
      notes:
          'Cool season crop, requires well-drained soil and moderate watering',
      relatedItems: ['assets/images/potato.png'],
    ),
  ];
}
