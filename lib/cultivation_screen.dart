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
  // Stage tracking (1-6 stages across 3 months)
  int _currentStage = 1;

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
    _updateCalendarForStage();
  }

  // Update calendar based on current stage
  void _updateCalendarForStage() {
    // 6 stages across 3 months: FEB, MAR, APR
    // Stage 1-2: FEB, Stage 3-4: MAR, Stage 5-6: APR
    switch (_currentStage) {
      case 1:
      case 2:
        _currentMonth = 'FEB';
        _monthNumber = _currentStage.toString().padLeft(2, '0');
        break;
      case 3:
      case 4:
        _currentMonth = 'MAR';
        _monthNumber = (_currentStage - 2).toString().padLeft(2, '0');
        break;
      case 5:
      case 6:
        _currentMonth = 'APR';
        _monthNumber = (_currentStage - 4).toString().padLeft(2, '0');
        break;
    }
  }

  // Advance to next stage
  void _advanceStage() {
    if (_currentStage < 6) {
      setState(() {
        _currentStage++;
        _updateCalendarForStage();
      });
    }
  }

  // Get current stage label
  String _getCurrentStageLabel() {
    const stageLabels = {
      1: 'SEED',
      2: 'SPROUT',
      3: 'YOUNG',
      4: 'GROWING',
      5: 'MATURE',
      6: 'HARVEST',
    };
    return stageLabels[_currentStage] ?? 'SEED';
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
            onStageAdvance: _advanceStage,
          ),
        ],
      ),
    );
  }
}
