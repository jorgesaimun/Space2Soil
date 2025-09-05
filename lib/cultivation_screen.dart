import 'package:flutter/material.dart';
import 'models/crop.dart';
import 'widgets/cultivation_widgets/calendar_widget.dart';
import 'widgets/cultivation_widgets/farmer_section_widget.dart';
import 'widgets/cultivation_widgets/seed_panel_widget.dart';
import 'widgets/cultivation_widgets/action_buttons_widget.dart';
import 'widgets/cultivation_widgets/environmental_data_widget.dart';
import 'widgets/cultivation_widgets/done_button_widget.dart';

class CultivationScreen extends StatefulWidget {
  final Crop selectedCrop;

  const CultivationScreen({
    super.key,
    required this.selectedCrop,
  });

  @override
  State<CultivationScreen> createState() => _CultivationScreenState();
}

class _CultivationScreenState extends State<CultivationScreen> {
  // Environmental data
  double _temperature = 33.0;
  double _humidity = 75.0;
  String _ndti = '№10';

  // Action sliders
  double _irrigationLevel = 0.4;
  double _fertilizerLevel = 0.3;
  double _pesticideLevel = 0.2;

  // Calendar data
  String _currentMonth = 'FEB';
  String _monthNumber = '01';

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
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Left column: Calendar, Speech bubble, Farmer
                _buildLeftColumn(),
                const SizedBox(width: 20),
                // Center column: Seed image, Action buttons
                _buildCenterColumn(),
                const SizedBox(width: 20),
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
      flex: 1,
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
          const Spacer(),
        ],
      ),
    );
  }


  Widget _buildCenterColumn() {
    return Expanded(
      flex: 1,
      child: Column(
        children: [
          // Center Top: Large seed image
          const SeedPanelWidget(),
          const Spacer(),
          // Center Bottom: Three action buttons
          ActionButtonsWidget(
            irrigationLevel: _irrigationLevel,
            fertilizerLevel: _fertilizerLevel,
            pesticideLevel: _pesticideLevel,
            onIrrigationChanged: (value) => setState(() => _irrigationLevel = value),
            onFertilizerChanged: (value) => setState(() => _fertilizerLevel = value),
            onPesticideChanged: (value) => setState(() => _pesticideLevel = value),
          ),
        ],
      ),
    );
  }


  Widget _buildRightColumn() {
    return Expanded(
      flex: 1,
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
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

}
