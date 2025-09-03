import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  final String locationStatus;
  final AnimationController loadingAnimationController;

  const LoadingScreen({
    super.key,
    required this.locationStatus,
    required this.loadingAnimationController,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final imageSize = screenSize.width * 0.3;

    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated map image
            AnimatedBuilder(
              animation: loadingAnimationController,
              builder: (context, child) {
                return Transform.scale(
                  scale: 1 + (loadingAnimationController.value * 0.1),
                  child: Opacity(
                    opacity: 0.8 + (loadingAnimationController.value * 0.2),
                    child: Container(
                      width: imageSize,
                      height: imageSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: const DecorationImage(
                          image: AssetImage('assets/images/map.png'),
                          fit: BoxFit.cover,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 40),

            // Loading status text
            Text(
              locationStatus,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 15),
            const CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 3,
            ),
          ],
        ),
      ),
    );
  }
}
