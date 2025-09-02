import 'package:flutter/material.dart';
import 'models/crop.dart';
import 'widgets/crop_stats_panel.dart';
import 'widgets/crop_display_widget.dart';

class CropSelectionScreen extends StatefulWidget {
  const CropSelectionScreen({super.key});

  @override
  State<CropSelectionScreen> createState() => _CropSelectionScreenState();
}

class _CropSelectionScreenState extends State<CropSelectionScreen> {
  int _currentCropIndex = 0;

  void _onCropChanged(int index) {
    setState(() {
      _currentCropIndex = index;
    });
  }

  void _onStartPressed() {
    final currentCrop = CropData.crops[_currentCropIndex];
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Starting with ${currentCrop.name}!'),
        backgroundColor: const Color(0xFF4CAF50),
      ),
    );
    // TODO: Navigate to game screen or implement start functionality
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg_img.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                // Left panel - Stats for Crops
                Expanded(
                  flex: 1,
                  child: CropStatsPanel(
                    currentCrop: CropData.crops[_currentCropIndex],
                    onClose: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(width: 20),
                // Right panel - Crop Selection
                Expanded(
                  flex: 1,
                  child: CropDisplayWidget(
                    crops: CropData.crops,
                    onCropChanged: _onCropChanged,
                    onStart: _onStartPressed,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
