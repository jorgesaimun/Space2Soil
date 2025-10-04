import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';
import 'result_screen.dart';
import 'models/crop.dart';

class CloudAnimationScreen extends StatefulWidget {
  final Crop selectedCrop;
  final double irrigationLevel;
  final double fertilizerLevel;
  final double pesticideLevel;
  final int currentStage;
  final int totalStages;
  final VoidCallback onStageAdvance;
  final String currentMonth;
  final String monthNumber;
  final String? division;

  const CloudAnimationScreen({
    super.key,
    required this.selectedCrop,
    required this.irrigationLevel,
    required this.fertilizerLevel,
    required this.pesticideLevel,
    required this.currentStage,
    required this.totalStages,
    required this.onStageAdvance,
    required this.currentMonth,
    required this.monthNumber,
    this.division,
  });

  @override
  State<CloudAnimationScreen> createState() => _CloudAnimationScreenState();
}

class _CloudAnimationScreenState extends State<CloudAnimationScreen>
    with TickerProviderStateMixin {
  late VideoPlayerController _videoController;
  late AnimationController _fadeController;
  late AnimationController _textController;
  late AnimationController _dotsController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _textAnimation;

  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();

    // Initialize video controller
    _videoController = VideoPlayerController.asset(
        'assets/video/cloud_animation.mp4',
      )
      ..initialize()
          .then((_) {
            if (mounted) {
              setState(() {
                _isVideoInitialized = true;
              });
              _videoController.setLooping(true);
              _videoController.play();
            }
          })
          .catchError((error) {
            print('Video initialization error: $error');
            // Continue with fallback background if video fails
            if (mounted) {
              setState(() {
                _isVideoInitialized = false;
              });
            }
          });

    // Initialize animation controllers
    _fadeController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _textController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _dotsController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Setup animations
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

    // Start loading dots animation
    _dotsController.repeat();

    // Navigate to result screen after exactly 3 seconds (regardless of 8-second video)
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder:
              (context, animation, secondaryAnimation) => ResultScreen(
                selectedCrop: widget.selectedCrop,
                irrigationLevel: widget.irrigationLevel,
                fertilizerLevel: widget.fertilizerLevel,
                pesticideLevel: widget.pesticideLevel,
                currentStage: widget.currentStage,
                totalStages: widget.totalStages,
                onStageAdvance: widget.onStageAdvance,
                currentMonth: widget.currentMonth,
                monthNumber: widget.monthNumber,
                division: widget.division,
              ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    }
  }

  @override
  void dispose() {
    _videoController.dispose();
    _fadeController.dispose();
    _textController.dispose();
    _dotsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _fadeAnimation,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: Stack(
              children: [
                // Video background or fallback gradient
                _buildVideoBackground(),

                // Semi-transparent overlay for better text readability
                Container(color: Colors.black.withOpacity(0.15)),

                // Processing text overlay
                _buildProcessingText(),

                // Loading dots overlay
                _buildLoadingDots(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildVideoBackground() {
    if (_isVideoInitialized && _videoController.value.isInitialized) {
      return Positioned.fill(
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: _videoController.value.size.width,
            height: _videoController.value.size.height,
            child: VideoPlayer(_videoController),
          ),
        ),
      );
    } else {
      // Fallback gradient background if video fails to load
      return Positioned.fill(
        child: Container(
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
        ),
      );
    }
  }

  Widget _buildProcessingText() {
    return AnimatedBuilder(
      animation: _textAnimation,
      builder: (context, child) {
        return Positioned(
          bottom: 200,
          left: 20,
          right: 20,
          child: Transform.scale(
            scale: _textAnimation.value,
            child: Column(
              children: [
                Text(
                  widget.currentStage == widget.totalStages
                      ? 'Processing Final Results...'
                      : 'Growing Your ${widget.selectedCrop.name}...',
                  style: GoogleFonts.vt323(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.7),
                        blurRadius: 8,
                        offset: const Offset(2, 2),
                      ),
                      Shadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 16,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  widget.currentStage == widget.totalStages
                      ? 'Calculating final results for ${widget.selectedCrop.name}'
                      : 'Stage ${widget.currentStage} → Stage ${widget.currentStage + 1}',
                  style: GoogleFonts.vt323(
                    fontSize: 20,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.7),
                        blurRadius: 6,
                        offset: const Offset(1, 1),
                      ),
                      Shadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 0),
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
            animation: _dotsController,
            builder: (context, child) {
              final delay = index * 0.3;
              final animationValue = ((_dotsController.value - delay) % 1.0)
                  .clamp(0.0, 1.0);
              final opacity =
                  (animationValue < 0.5)
                      ? animationValue * 2
                      : (1.0 - animationValue) * 2;

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 6),
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(opacity),
                  borderRadius: BorderRadius.circular(7),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
