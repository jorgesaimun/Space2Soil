import 'package:flutter/material.dart';

class StageImageWidget extends StatelessWidget {
  final int currentStage;
  final String cropType;

  const StageImageWidget({
    super.key,
    required this.currentStage,
    this.cropType = 'tomato',
  });

  @override
  Widget build(BuildContext context) {
    return _buildImageWithFallback();
  }

  /// Maps database crop names to image folder names
  String _getNormalizedCropType() {
    final cropLower = cropType.toLowerCase().trim();

    // Rice varieties mapping
    if (cropLower.contains('brri') || cropLower.contains('dhan')) {
      return 'rice';
    }

    // Direct mappings for crops that match folder names
    final directMappings = {
      'banana': 'banana',
      'brinjal': 'brinjal',
      'eggplant': 'brinjal',
      'jute': 'jute',
      'tossa': 'jute',
      'lentil': 'lentil',
      'mango': 'mango',
      'wheat': 'wheat',
      'maize': 'maize',
      'mustard': 'mustard',
      'potato': 'potato',
      'betel leaf': 'betel_leaf',
      'lemon': 'lemon',
      'tea': 'tea',
      'chili': 'chili',
      'watermelon': 'watermelon',
      'tomato': 'tomato',
    };

    // Check for direct matches
    for (String key in directMappings.keys) {
      if (cropLower.contains(key)) {
        return directMappings[key]!;
      }
    }

    // Default fallback
    return cropType.toLowerCase();
  }

  Widget _buildImageWithFallback() {
    final normalizedCropType = _getNormalizedCropType();

    // Candidate filenames per stage (including new crop_ naming convention)
    final List<String> candidates = [
      // New naming convention
      'assets/images/$normalizedCropType/crop_$currentStage.png',
      'assets/images/$normalizedCropType/crop_$currentStage.PNG',
      'assets/images/$normalizedCropType/crop_$currentStage.jpg',
      'assets/images/$normalizedCropType/crop_$currentStage.jpeg',

      // Existing naming conventions
      'assets/images/$normalizedCropType/$currentStage.png',
      'assets/images/$normalizedCropType/stage$currentStage.png',
      if (currentStage < 10)
        'assets/images/$normalizedCropType/0$currentStage.png',
      // .PNG
      'assets/images/$normalizedCropType/$currentStage.PNG',
      'assets/images/$normalizedCropType/stage$currentStage.PNG',
      if (currentStage < 10)
        'assets/images/$normalizedCropType/0$currentStage.PNG',
      // .jpg
      'assets/images/$normalizedCropType/$currentStage.jpg',
      'assets/images/$normalizedCropType/stage$currentStage.jpg',
      if (currentStage < 10)
        'assets/images/$normalizedCropType/0$currentStage.jpg',
      // .jpeg
      'assets/images/$normalizedCropType/$currentStage.jpeg',
      'assets/images/$normalizedCropType/stage$currentStage.jpeg',
      if (currentStage < 10)
        'assets/images/$normalizedCropType/0$currentStage.jpeg',
    ];

    // Fallback images based on stage
    final fallbackImage = _getFallbackImage();

    return Container(
      width: double.infinity,
      height: double.infinity,
      child: _buildChainedImages(candidates, fallbackImage),
    );
  }

  /// Builds a nested error-handling chain over candidate asset paths,
  /// falling back to [fallbackImage] and finally to an icon.
  Widget _buildChainedImages(List<String> candidates, String fallbackImage) {
    Widget buildAt(int index) {
      if (index >= candidates.length) {
        return Image.asset(
          fallbackImage,
          fit: BoxFit.contain,
          errorBuilder: (context, error2, stackTrace2) {
            return Container(
              width: double.infinity,
              height: double.infinity,
              child: _buildFinalFallback(),
            );
          },
        );
      }
      final path = candidates[index];
      return Image.asset(
        path,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return buildAt(index + 1);
        },
      );
    }

    return buildAt(0);
  }

  String _getFallbackImage() {
    switch (currentStage) {
      case 1:
        return 'assets/images/seed_img.png';
      case 2:
      case 3:
        return 'assets/images/potato.png';
      case 4:
      case 5:
        return 'assets/images/rice_image.png';
      case 6:
        return 'assets/images/tomato_icon.png';
      default:
        return 'assets/images/seed_img.png';
    }
  }

  Widget _buildFinalFallback() {
    IconData iconData;
    Color iconColor;

    switch (currentStage) {
      case 1:
        iconData = Icons.circle;
        iconColor = Colors.brown;
        break;
      case 2:
        iconData = Icons.grass;
        iconColor = Colors.lightGreen;
        break;
      case 3:
        iconData = Icons.local_florist;
        iconColor = Colors.green;
        break;
      case 4:
        iconData = Icons.eco;
        iconColor = Colors.green[600]!;
        break;
      case 5:
        iconData = Icons.local_florist;
        iconColor = Colors.green[800]!;
        break;
      case 6:
        iconData = Icons.agriculture;
        iconColor = Colors.red[600]!;
        break;
      default:
        iconData = Icons.circle;
        iconColor = Colors.brown;
    }

    return Center(child: Icon(iconData, size: 80, color: iconColor));
  }
}
