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

  /// Get image path based on crop name
  static String _getImagePathForCrop(String cropName) {
    final cropImages = {
      'tomato': 'assets/images/tomato_icon.png',
      'potato': 'assets/images/potato.png',
      'rice': 'assets/images/rice_image.png',
      'wheat': 'assets/images/wheat/1.png',
      'maize': 'assets/images/maize/1.png',
      'jute': 'assets/images/jute/1.png',
      'tea': 'assets/images/tea/1.png',
      'banana': 'assets/images/banana/1.png',
      'mango': 'assets/images/mango/1.png',
      'lemon': 'assets/images/lemon/1.png',
      'chili': 'assets/images/chili/1.png',
      'lentil': 'assets/images/lentil/1.png',
      'mustard': 'assets/images/mustard/1.png',
      'cauliflower': 'assets/images/cauliflower/1.png',
      'cabbage': 'assets/images/cabbage/1.png',
      'brinjal': 'assets/images/brinjal_(_eggplant)/1.png',
      'eggplant': 'assets/images/brinjal_(_eggplant)/1.png',
      'watermelon': 'assets/images/watermelon/1.png',
      'betel_leaf': 'assets/images/betel_leaf/1.png',
    };

    return cropImages[cropName.toLowerCase()] ?? 'assets/images/seed_img.png';
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
