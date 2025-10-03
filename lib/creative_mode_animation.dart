import 'package:flutter/material.dart';
import 'select_location.dart';

class CreativeModeAnimationScreen extends StatefulWidget {
  final String currentLocation;

  const CreativeModeAnimationScreen({super.key, required this.currentLocation});

  @override
  State<CreativeModeAnimationScreen> createState() =>
      _CreativeModeAnimationScreenState();
}

class _CreativeModeAnimationScreenState
    extends State<CreativeModeAnimationScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Create scale animation (card grows from small to normal size)
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.8, curve: Curves.elasticOut),
      ),
    );

    // Create opacity animation (fade in)
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
      ),
    );

    // Create slide animation (card slides up from bottom)
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOutBack),
      ),
    );

    // Start the animation
    _animationController.forward();

    // Navigate to next screen after animation completes + delay
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Wait a bit after animation completes, then navigate
        Future.delayed(const Duration(milliseconds: 800), () {
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder:
                    (context) => SelectLocationScreen(
                      currentLocation: widget.currentLocation,
                    ),
              ),
            );
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/creative_mode_bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _opacityAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      width: 300,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFFFF8C00), // Orange border
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.orange.withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Creative Mode Title
                          const Text(
                            'Creative Mode',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF8B4513), // Brown color
                              fontFamily: 'VT323',
                            ),
                          ),

                          const SizedBox(height: 10),

                          // Creative Mode Icon
                          Container(
                            width: 60,
                            height: 60,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: Image.asset(
                              'assets/images/creative_icon.png',
                              fit: BoxFit.contain,
                            ),
                          ),

                          const SizedBox(height: 10),

                          // Bottom section with orange background
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: const BoxDecoration(
                              color: Color(0xFFFF8C00), // Orange background
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(17),
                                bottomRight: Radius.circular(17),
                              ),
                            ),
                            child: const Text(
                              'PLAY WITH ANY LOCATION',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'VT323',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
