import 'package:flutter/material.dart';
import 'models/crop.dart';
import 'models/land.dart';
import 'widgets/cultivation_widgets/calendar_widget.dart';
import 'widgets/cultivation_widgets/farmer_section_widget.dart';
import 'widgets/cultivation_widgets/seed_panel_widget.dart';
import 'widgets/cultivation_widgets/action_buttons_widget.dart';
import 'widgets/cultivation_widgets/environmental_data_widget.dart';
import 'widgets/cultivation_widgets/done_button_widget.dart';

class CultivationScreen extends StatefulWidget {
  final Crop selectedCrop;
  final Land selectedLand;

  const CultivationScreen({
    super.key,
    required this.selectedCrop,
    required this.selectedLand,
  });

  @override
  State<CultivationScreen> createState() => _CultivationScreenState();
}

class _CultivationScreenState extends State<CultivationScreen> {
  // Stage tracking - dynamic based on crop images
  int _currentStage = 1;
  late int _totalStages;

  // Environmental data
  double _temperature = 33.0;
  double _humidity = 75.0;
  String _ndti = '№10';

  // Action sliders
  double _irrigationLevel = 0.4;
  double _fertilizerLevel = 0.3;
  double _pesticideLevel = 0.2;

  // Calendar data - will be calculated based on stage
  String _currentMonth = 'FEB';
  String _monthNumber = '01';

  @override
  void initState() {
    super.initState();
    _totalStages = _getTotalStagesForCrop();
    _updateCalendarForStage();
  }

  /// Get total number of stages based on crop image count
  int _getTotalStagesForCrop() {
    // Map crop names to their folder names
    final cropFolderMap = {
      'tomato': 7,
      'potato': 5,
      'rice': 6,
      'banana': 12,
      'betel leaf': 12,
      'brinjal': 8,
      'eggplant': 8,
      'cabbage': 6,
      'cauliflower': 6,
      'chili': 7,
      'jute': 5,
      'lemon': 11,
      'lentil': 6,
      'maize': 6,
      'mango': 11,
      'mustard': 5,
      'tea': 9,
      'watermelon': 6,
      'wheat': 6,
    };

    final cropName = widget.selectedCrop.name.toLowerCase();
    return cropFolderMap[cropName] ?? 6; // Default to 6 if not found
  }

  /// Update calendar based on current stage
  void _updateCalendarForStage() {
    // Distribute stages across 3 months: FEB, MAR, APR
    final stagesPerMonth = (_totalStages / 3).ceil();

    if (_currentStage <= stagesPerMonth) {
      _currentMonth = 'FEB';
      _monthNumber = _currentStage.toString().padLeft(2, '0');
    } else if (_currentStage <= stagesPerMonth * 2) {
      _currentMonth = 'MAR';
      _monthNumber = (_currentStage - stagesPerMonth).toString().padLeft(2, '0');
    } else {
      _currentMonth = 'APR';
      _monthNumber =
          (_currentStage - (stagesPerMonth * 2)).toString().padLeft(2, '0');
    }
  }

  /// Advance to next stage
  void _advanceStage() {
    if (_currentStage < _totalStages) {
      setState(() {
        _currentStage++;
        _updateCalendarForStage();
      });
    }
  }

  /// Get current stage label based on progress
  String _getCurrentStageLabel() {
    final progress = _currentStage / _totalStages;

    if (progress <= 0.16) return 'SEED';
    if (progress <= 0.33) return 'SPROUT';
    if (progress <= 0.50) return 'YOUNG';
    if (progress <= 0.66) return 'GROWING';
    if (progress <= 0.83) return 'MATURE';
    return 'HARVEST';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/cultivated_bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                // Left column: Calendar, Speech bubble, Farmer
                _buildLeftColumn(),
                const SizedBox(width: 8),
                // Center column: Seed image, Action buttons
                _buildCenterColumn(),
                const SizedBox(width: 8),
                // Right column: Environmental data, Done button
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
      flex: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Top: Calendar widget
          CalendarWidget(
            currentMonth: _currentMonth,
            monthNumber: _monthNumber,
          ),
          const SizedBox(height: 20),
          // Left Middle: Speech bubble
          FarmerSectionWidget(cropName: widget.selectedCrop.name),
        ],
      ),
    );
  }

  Widget _buildCenterColumn() {
    return Expanded(
      flex: 3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Center Top: Dynamic stage image
          Flexible(
            child: SeedPanelWidget(
              stageLabel: _getCurrentStageLabel(),
              currentStage: _currentStage,
              totalStages: _totalStages,
              cropFolderName: widget.selectedCrop.name.toLowerCase(),
            ),
          ),
          const SizedBox(height: 20),
          // Center Bottom: Three action buttons
          ActionButtonsWidget(
            irrigationLevel: _irrigationLevel,
            fertilizerLevel: _fertilizerLevel,
            pesticideLevel: _pesticideLevel,
            onIrrigationChanged:
                (value) => setState(() => _irrigationLevel = value),
            onFertilizerChanged:
                (value) => setState(() => _fertilizerLevel = value),
            onPesticideChanged:
                (value) => setState(() => _pesticideLevel = value),
          ),
        ],
      ),
    );
  }

  Widget _buildRightColumn() {
    return Expanded(
      flex: 2,
      child: Column(
        children: [
          // Right Top to Middle: Environmental data widgets
          EnvironmentalDataWidget(
            temperature: _temperature,
            humidity: _humidity,
            ndti: _ndti,
          ),
          const Spacer(),
          // Right Bottom: Large Done button
          DoneButtonWidget(
            cropName: widget.selectedCrop.name,
            selectedCrop: widget.selectedCrop,
            irrigationLevel: _irrigationLevel,
            fertilizerLevel: _fertilizerLevel,
            pesticideLevel: _pesticideLevel,
            currentStage: _currentStage,
            totalStages: _totalStages,
            onStageAdvance: _advanceStage,
          ),
        ],
      ),
    );
  }
}
