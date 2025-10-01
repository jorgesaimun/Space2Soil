import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models/crop.dart';
import 'widgets/cultivation_widgets/calendar_widget.dart';
import 'widgets/result_widgets/farmer_result_widget.dart';
import 'widgets/result_widgets/results_panel_widget.dart';
import 'final_result_screen.dart';

class ResultScreen extends StatefulWidget {
  final Crop selectedCrop;
  final double irrigationLevel;
  final double fertilizerLevel;
  final double pesticideLevel;
  final int currentStage;
  final int totalStages;
  final VoidCallback onStageAdvance;

  const ResultScreen({
    super.key,
    required this.selectedCrop,
    required this.irrigationLevel,
    required this.fertilizerLevel,
    required this.pesticideLevel,
    required this.currentStage,
    required this.totalStages,
    required this.onStageAdvance,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  // Calendar data
  String _currentMonth = 'FEB';
  String _monthNumber = '01';

  // Result data
  String _whatHappened = 'Successfully ripe';
  String _why = 'Perfect Irrigation';
  int _starRating = 2; // 2 out of 3 stars

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/result_bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Left column: Calendar and Farmer
                _buildLeftColumn(),
                const SizedBox(width: 20),
                // Right column: Results panel and Next button
                _buildRightColumn(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLeftColumn() {
    return Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Left: Calendar widget
          CalendarWidget(
            currentMonth: _currentMonth,
            monthNumber: _monthNumber,
          ),
          const SizedBox(height: 40),
          // Left Bottom: Farmer with speech bubble
          const Expanded(
            child: Align(
              alignment: Alignment.bottomLeft,
              child: FarmerResultWidget(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRightColumn() {
    return Expanded(
      flex: 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Right Center: Results panel without integrated Next button
          ResultsPanelWidget(
            whatHappened: _whatHappened,
            why: _why,
            starRating: _starRating,
          ),
          const SizedBox(height: 20),
          // Next button positioned below results panel
          _buildNextButton(),
        ],
      ),
    );
  }

  Widget _buildNextButton() {
    final isLastStage = widget.currentStage == widget.totalStages;

    return GestureDetector(
      onTap: () {
        if (isLastStage) {
          // Final stage - navigate to final result screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => FinalResultScreen(
                selectedCrop: widget.selectedCrop,
                irrigationLevel: widget.irrigationLevel,
                fertilizerLevel: widget.fertilizerLevel,
                pesticideLevel: widget.pesticideLevel,
              ),
            ),
          );
        } else {
          // Not final stage - advance stage and return to cultivation
          widget.onStageAdvance();
          Navigator.pop(context); // Pop result screen (cloud was replaced)
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF9C7FB8), Color(0xFF7B68B1)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.black, width: 3),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Text(
          isLastStage ? 'FINISH' : 'NEXT',
          style: GoogleFonts.vt323(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
