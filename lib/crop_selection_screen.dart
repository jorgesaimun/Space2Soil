import 'package:flutter/material.dart';
import 'models/crop.dart';
import 'widgets/crop_stats_panel.dart';
import 'widgets/crop_display_widget.dart';
import 'widgets/loading_widget.dart';
import 'widgets/error_widget.dart';
import 'services/crop_data_manager.dart';
import 'land_selection_screen.dart';

class CropSelectionScreen extends StatefulWidget {
  final String detectedLocation;

  const CropSelectionScreen({super.key, required this.detectedLocation});

  @override
  State<CropSelectionScreen> createState() => _CropSelectionScreenState();
}

class _CropSelectionScreenState extends State<CropSelectionScreen> {
  int _currentCropIndex = 0;
  List<Crop> _availableCrops = [];
  String? _currentDivision;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadCropsForCurrentLocation();
  }

  /// Load crops for current location
  Future<void> _loadCropsForCurrentLocation() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Use the passed location (always available now)
    print('Using passed location: ${widget.detectedLocation}');
    // Clean and normalize the location name
    final cleanedLocation = _cleanDivisionName(widget.detectedLocation);
    print('Cleaned location name: "$cleanedLocation"');

    final result = await CropDataManager.loadCropsForDivision(cleanedLocation);
    _handleCropDataResult(result);
  }

  /// Clean division name by removing common suffixes and normalizing
  String _cleanDivisionName(String divisionName) {
    String cleaned = divisionName.trim();

    // Remove common suffixes
    final suffixesToRemove = [
      ' Division',
      ' DIVISION',
      ' district',
      ' DISTRICT',
      ' Region',
      ' REGION',
    ];

    for (final suffix in suffixesToRemove) {
      if (cleaned.endsWith(suffix)) {
        cleaned = cleaned.substring(0, cleaned.length - suffix.length).trim();
        break;
      }
    }

    // Handle common name variations for Bangladesh divisions
    final normalized = cleaned.toLowerCase().trim();
    final nameMap = {
      'chittagong': 'Chattogram',
      'chattogram': 'Chattogram',
      'dhaka': 'Dhaka',
      'sylhet': 'Sylhet',
      'rajshahi': 'Rajshahi',
      'khulna': 'Khulna',
      'barisal': 'Barishal',
      'barishal': 'Barishal',
      'rangpur': 'Rangpur',
      'mymensingh': 'Mymensingh',
    };

    // Return mapped name or original with proper capitalization
    return nameMap[normalized] ?? _capitalizeFirstLetter(cleaned);
  }

  /// Helper method to capitalize first letter of each word
  String _capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text
        .split(' ')
        .map(
          (word) =>
              word.isNotEmpty
                  ? word[0].toUpperCase() + word.substring(1).toLowerCase()
                  : word,
        )
        .join(' ');
  }

  /// Handle crop data result
  void _handleCropDataResult(CropDataResult result) {
    setState(() {
      _isLoading = false;
      _availableCrops = result.crops;
      _currentDivision = result.division;
      _currentCropIndex = 0; // Reset to first crop

      if (result.isError) {
        _errorMessage = result.message;
      }
    });

    // Show message if using fallback crops
    if (result.isFallback) {
      _showMessage(result.message);
    }
  }

  /// Show message to user
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 3)),
    );
  }

  /// Handle crop selection change
  void _onCropChanged(int index) {
    setState(() {
      _currentCropIndex = index;
    });
  }

  /// Handle start button press
  void _onStartPressed() {
    if (_availableCrops.isNotEmpty) {
      final currentCrop = _availableCrops[_currentCropIndex];
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => LandSelectionScreen(
                selectedCrop: currentCrop,
                division: _currentDivision,
              ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background_img.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: _buildContent(),
          ),
        ),
      ),
    );
  }

  /// Build main content based on current state
  Widget _buildContent() {
    if (_isLoading) {
      return LoadingWidget(
        message:
            _currentDivision != null
                ? 'Loading crops for $_currentDivision...'
                : 'Loading crops for your location...',
      );
    }

    if (_errorMessage != null && _availableCrops.isEmpty) {
      return ErrorDisplayWidget(
        message: 'Error loading crops. Please go back and check your location.',
        onRetry: _loadCropsForCurrentLocation,
      );
    }

    if (_availableCrops.isEmpty) {
      return ErrorDisplayWidget(
        message:
            'No crops available for this location. Please go back to change your location.',
        onRetry: _loadCropsForCurrentLocation,
      );
    }

    return _buildCropSelectionInterface();
  }

  /// Build the main crop selection interface
  Widget _buildCropSelectionInterface() {
    return Row(
      children: [
        // Left panel - Stats for Crops
        Expanded(
          flex: 1,
          child: CropStatsPanel(
            currentCrop: _availableCrops[_currentCropIndex],
            onClose: () => Navigator.pop(context),
          ),
        ),
        const SizedBox(width: 20),
        // Right panel - Crop Selection
        Expanded(
          flex: 1,
          child: CropDisplayWidget(
            crops: _availableCrops,
            onCropChanged: _onCropChanged,
            onStart: _onStartPressed,
          ),
        ),
      ],
    );
  }
}
