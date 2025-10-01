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
    // Candidate filenames per stage (robust to different naming styles)
    final List<String> candidates = [
      'assets/images/$cropType/$currentStage.png',
      'assets/images/$cropType/stage$currentStage.png',
      if (currentStage < 10) 'assets/images/$cropType/0$currentStage.png',
      // .PNG
      'assets/images/$cropType/$currentStage.PNG',
      'assets/images/$cropType/stage$currentStage.PNG',
      if (currentStage < 10) 'assets/images/$cropType/0$currentStage.PNG',
      // .jpg
      'assets/images/$cropType/$currentStage.jpg',
      'assets/images/$cropType/stage$currentStage.jpg',
      if (currentStage < 10) 'assets/images/$cropType/0$currentStage.jpg',
      // .jpeg
      'assets/images/$cropType/$currentStage.jpeg',
      'assets/images/$cropType/stage$currentStage.jpeg',
      if (currentStage < 10) 'assets/images/$cropType/0$currentStage.jpeg',
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
