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

  Widget _buildImageWithFallback() {
    // Primary image path
    final primaryImage = 'assets/images/$cropType/stage$currentStage.png';

    // Fallback images based on stage
    final fallbackImage = _getFallbackImage();

    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Image.asset(
        primaryImage,
        fit: BoxFit.cover, // Fill the entire container
        errorBuilder: (context, error, stackTrace) {
          // Try fallback image
          return Image.asset(
            fallbackImage,
            fit: BoxFit.cover, // Fill the entire container
            errorBuilder: (context, error2, stackTrace2) {
              // Final fallback - show stage appropriate icon
              return Container(
                width: double.infinity,
                height: double.infinity,
                child: _buildFinalFallback(),
              );
            },
          );
        },
      ),
    );
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
