import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'result_screen.dart';
import 'models/crop.dart';

class CloudAnimationScreen extends StatefulWidget {
  final Crop selectedCrop;
  final double irrigationLevel;
  final double fertilizerLevel;
  final double pesticideLevel;
  final int currentStage;
  final VoidCallback onStageAdvance;

  const CloudAnimationScreen({
    super.key,
    required this.selectedCrop,
    required this.irrigationLevel,
    required this.fertilizerLevel,
    required this.pesticideLevel,
    required this.currentStage,
    required this.onStageAdvance,
  });

  @override
  State<CloudAnimationScreen> createState() => _CloudAnimationScreenState();
}

class _CloudAnimationScreenState extends State<CloudAnimationScreen>
    with TickerProviderStateMixin {
  late AnimationController _cloud1Controller;
  late AnimationController _cloud2Controller;
  late AnimationController _cloud3Controller;
  late AnimationController _fadeController;
  late AnimationController _textController;

  late Animation<Offset> _cloud1Animation;
  late Animation<Offset> _cloud2Animation;
  late Animation<Offset> _cloud3Animation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _textAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _cloud1Controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _cloud2Controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );
    _cloud3Controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _textController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Setup animations
    _cloud1Animation = Tween<Offset>(
      begin: const Offset(-1.5, 0),
      end: const Offset(1.5, 0),
    ).animate(CurvedAnimation(parent: _cloud1Controller, curve: Curves.linear));

    _cloud2Animation = Tween<Offset>(
      begin: const Offset(-1.8, 0),
      end: const Offset(1.8, 0),
    ).animate(CurvedAnimation(parent: _cloud2Controller, curve: Curves.linear));

    _cloud3Animation = Tween<Offset>(
      begin: const Offset(-2.0, 0),
      end: const Offset(2.0, 0),
    ).animate(CurvedAnimation(parent: _cloud3Controller, curve: Curves.linear));

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _textAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.elasticOut),
    );

    // Start animations
    _startAnimations();
  }

  void _startAnimations() async {
    // Start fade in
    _fadeController.forward();

    // Start text animation
    await Future.delayed(const Duration(milliseconds: 500));
    _textController.forward();

    // Start cloud animations with slight delays
    _cloud1Controller.repeat();
    await Future.delayed(const Duration(milliseconds: 300));
    _cloud2Controller.repeat();
    await Future.delayed(const Duration(milliseconds: 500));
    _cloud3Controller.repeat();

    // Navigate based on current stage after animation
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      if (widget.currentStage == 6) {
        // Final stage - go to result screen
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder:
                (context, animation, secondaryAnimation) => ResultScreen(
                  selectedCrop: widget.selectedCrop,
                  irrigationLevel: widget.irrigationLevel,
                  fertilizerLevel: widget.fertilizerLevel,
                  pesticideLevel: widget.pesticideLevel,
                ),
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      } else {
        // Not final stage - advance stage and return to cultivation
        widget.onStageAdvance();
        Navigator.pop(context);
      }
    }
  }

  @override
  void dispose() {
    _cloud1Controller.dispose();
    _cloud2Controller.dispose();
    _cloud3Controller.dispose();
    _fadeController.dispose();
    _textController.dispose();
    super.dispose();
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
              Color(0xFF87CEEB), // Sky blue
              Color(0xFFE0F6FF), // Light blue
              Color(0xFF98FB98), // Pale green
            ],
          ),
        ),
        child: AnimatedBuilder(
          animation: _fadeAnimation,
          builder: (context, child) {
            return Opacity(
              opacity: _fadeAnimation.value,
              child: Stack(
                children: [
                  // Background elements
                  _buildBackground(),

                  // Cloud animations
                  _buildCloud1(),
                  _buildCloud2(),
                  _buildCloud3(),

                  // Processing text
                  _buildProcessingText(),

                  // Loading dots
                  _buildLoadingDots(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBackground() {
    return Positioned.fill(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF87CEEB), Color(0xFFE0F6FF), Color(0xFF98FB98)],
          ),
        ),
      ),
    );
  }

  Widget _buildCloud1() {
    return AnimatedBuilder(
      animation: _cloud1Animation,
      builder: (context, child) {
        return SlideTransition(
          position: _cloud1Animation,
          child: Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: _buildCloudShape(size: 80, opacity: 0.7),
          ),
        );
      },
    );
  }

  Widget _buildCloud2() {
    return AnimatedBuilder(
      animation: _cloud2Animation,
      builder: (context, child) {
        return SlideTransition(
          position: _cloud2Animation,
          child: Positioned(
            top: 180,
            left: 0,
            right: 0,
            child: _buildCloudShape(size: 100, opacity: 0.8),
          ),
        );
      },
    );
  }

  Widget _buildCloud3() {
    return AnimatedBuilder(
      animation: _cloud3Animation,
      builder: (context, child) {
        return SlideTransition(
          position: _cloud3Animation,
          child: Positioned(
            top: 260,
            left: 0,
            right: 0,
            child: _buildCloudShape(size: 120, opacity: 0.6),
          ),
        );
      },
    );
  }

  Widget _buildCloudShape({required double size, required double opacity}) {
    return Center(
      child: Container(
        width: size * 2,
        height: size,
        child: Stack(
          children: [
            // Main cloud body
            Positioned(
              left: size * 0.3,
              top: size * 0.3,
              child: Container(
                width: size * 1.4,
                height: size * 0.6,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(opacity),
                  borderRadius: BorderRadius.circular(size * 0.3),
                ),
              ),
            ),
            // Cloud puffs
            Positioned(
              left: size * 0.1,
              top: size * 0.2,
              child: Container(
                width: size * 0.6,
                height: size * 0.6,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(opacity),
                  borderRadius: BorderRadius.circular(size * 0.3),
                ),
              ),
            ),
            Positioned(
              right: size * 0.1,
              top: size * 0.1,
              child: Container(
                width: size * 0.7,
                height: size * 0.7,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(opacity),
                  borderRadius: BorderRadius.circular(size * 0.35),
                ),
              ),
            ),
            Positioned(
              left: size * 0.6,
              top: size * 0.05,
              child: Container(
                width: size * 0.5,
                height: size * 0.5,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(opacity),
                  borderRadius: BorderRadius.circular(size * 0.25),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProcessingText() {
    return AnimatedBuilder(
      animation: _textAnimation,
      builder: (context, child) {
        return Positioned(
          bottom: 200,
          left: 0,
          right: 0,
          child: Transform.scale(
            scale: _textAnimation.value,
            child: Column(
              children: [
                Text(
                  widget.currentStage == 6
                      ? 'Processing Final Results...'
                      : 'Growing Your ${widget.selectedCrop.name}...',
                  style: GoogleFonts.vt323(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(2, 2),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  widget.currentStage == 6
                      ? 'Calculating final results for ${widget.selectedCrop.name}'
                      : 'Stage ${widget.currentStage} → Stage ${widget.currentStage + 1}',
                  style: GoogleFonts.vt323(
                    fontSize: 20,
                    color: Colors.white70,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 3,
                        offset: const Offset(1, 1),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingDots() {
    return Positioned(
      bottom: 150,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(3, (index) {
          return AnimatedBuilder(
            animation: _textController,
            builder: (context, child) {
              final delay = index * 0.2;
              final animationValue = (_textController.value - delay).clamp(
                0.0,
                1.0,
              );
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(animationValue),
                  borderRadius: BorderRadius.circular(6),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
