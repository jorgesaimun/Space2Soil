import 'package:flutter/material.dart';
import 'models/crop.dart';
import 'models/land.dart';
import 'services/crop_service.dart';
import 'widgets/cultivation_widgets/calendar_widget.dart';
import 'widgets/cultivation_widgets/farmer_section_widget.dart';
import 'widgets/cultivation_widgets/seed_panel_widget.dart';
import 'widgets/cultivation_widgets/action_buttons_widget.dart';
import 'widgets/cultivation_widgets/environmental_data_widget.dart';
import 'widgets/cultivation_widgets/done_button_widget.dart';

class CultivationScreen extends StatefulWidget {
  final Crop selectedCrop;
  final Land selectedLand;
  final String? division;

  const CultivationScreen({
    super.key,
    required this.selectedCrop,
    required this.selectedLand,
    this.division,
  });

  @override
  State<CultivationScreen> createState() => _CultivationScreenState();
}

class _CultivationScreenState extends State<CultivationScreen> {
  // Stage tracking - dynamic based on crop images
  int _currentStage = 1;
  late int _totalStages;

  // Environmental data - dynamic from database
  double _temperature = 33.0;
  double _smap = 75.0;
  String _ndvi = '№10';

  // Action sliders
  double _irrigationLevel = 0.4;
  double _fertilizerLevel = 0.3;
  double _pesticideLevel = 0.2;

  // Calendar data - dynamic based on crop cultivation period
  String _currentMonth = 'JAN';
  String _monthNumber = '01';

  // Cultivation data from database
  List<String> _cultivationMonths = [];
  int _currentMonthIndex = 0;
  Map<String, dynamic>? _smapData;
  Map<String, dynamic>? _ndviData;
  bool _isLoadingData = true;

  // Updated crop with correct cultivation period
  Crop? _updatedCrop;

  // Get the crop to use (updated version if available, otherwise original)
  Crop get currentCrop => _updatedCrop ?? widget.selectedCrop;

  @override
  void initState() {
    super.initState();
    _totalStages = _getTotalStagesForCrop();
    _loadCultivationData();
  }

  /// Normalize crop name to asset folder name
  /// - Any name containing both "brri" and "dhan" maps to 'rice'
  /// - Also normalize common aliases like 'brinjal' -> 'eggplant'
  String _normalizeCropFolderName(String cropName) {
    final normalized = cropName.toLowerCase().trim();
    if (normalized.contains('brri') && normalized.contains('dhan')) {
      return 'rice';
    }
    if (normalized == 'brinjal') return 'eggplant';
    return normalized;
  }

  /// Get total number of stages based on crop image count
  int _getTotalStagesForCrop() {
    // Map normalized crop folder name to number of stage images
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

    final folderId = _normalizeCropFolderName(widget.selectedCrop.name);
    return cropFolderMap[folderId] ?? 6; // Default to 6 if not found
  }

  /// Load cultivation data from database
  Future<void> _loadCultivationData() async {
    try {
      setState(() {
        _isLoadingData = true;
      });

      // Get division from selected land (assuming land has location info)
      // If land doesn't have division info, you might need to get it from user selection
      final division = _getDivisionFromLand();
      print(
        '🌾 Querying database - Division: $division, Crop: ${widget.selectedCrop.name}',
      );

      // Get crop details from database
      final cropDetails = await CropService.getCropDetails(
        division: division,
        crop: widget.selectedCrop.name,
      );

      print('🌾 Database returned ${cropDetails.length} crop details');

      if (cropDetails.isNotEmpty) {
        final data = cropDetails.first;

        // Extract SMAP and NDVI data
        _smapData = data['smap'] as Map<String, dynamic>?;
        _ndviData = data['ndvi'] as Map<String, dynamic>?;

        // Extract cultivation months from database cultivation_period
        // Use the actual cultivation_period field to get the correct month sequence
        final cultivationPeriod = data['cultivation_period'] as String?;
        print('🌾 Database cultivation period: $cultivationPeriod');
        print('🌾 Available SMAP months: ${_smapData?.keys.toList()}');

        if (cultivationPeriod != null && _smapData != null) {
          // ALWAYS use database cultivation period for month sequence
          _cultivationMonths = _extractMonthsFromCultivationPeriod(
            cultivationPeriod,
            _smapData!.keys.toSet(),
          );
          print('🌾 Using database cultivation period: $_cultivationMonths');
        } else if (_smapData != null) {
          // Fallback: use SMAP keys but maintain cultivation order
          _cultivationMonths = _sortMonthsInCultivationOrder(
            _smapData!.keys.toList(),
          );
          print(
            '🌾 No cultivation_period found, using fallback: $_cultivationMonths',
          );
        } else {
          // Last resort: use default months
          print('🌾 No SMAP data available, using default months');
          _cultivationMonths = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
        }

        // Keep the original database cultivation period instead of regenerating
        // This ensures all screens show the same cultivation period from database
        _updatedCrop = Crop(
          name: widget.selectedCrop.name,
          imagePath: widget.selectedCrop.imagePath,
          cropCycle:
              cultivationPeriod ??
              widget.selectedCrop.cropCycle, // Use original DB period
          places: widget.selectedCrop.places,
          notes: widget.selectedCrop.notes,
          relatedItems: widget.selectedCrop.relatedItems,
          smap: widget.selectedCrop.smap,
          ndvi: widget.selectedCrop.ndvi,
        );

        // Set initial month and environmental data
        _currentMonthIndex = 0;
        _updateCalendarAndEnvironmentalData();
      }
    } catch (e) {
      print('Error loading cultivation data: $e');
      // Fallback to default values
      _cultivationMonths = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
      _currentMonthIndex = 0;
      _updateCalendarAndEnvironmentalData();
    } finally {
      setState(() {
        _isLoadingData = false;
      });
    }
  }

  /// Get division from passed parameter or fallback to default
  String _getDivisionFromLand() {
    // Use division passed from previous screen, fallback to Dhaka
    return widget.division ?? 'Dhaka';
  }

  /// Update calendar and environmental data based on current month
  void _updateCalendarAndEnvironmentalData() {
    if (_cultivationMonths.isEmpty) return;

    final totalMonths = _cultivationMonths.length;

    // STAGE-BASED MONTH PROGRESSION: Each stage completion = next month
    // This creates realistic agricultural progression through the growing season

    if (_totalStages <= totalMonths) {
      // Each stage gets its own month (ideal case)
      // Stage 1 → Month 1, Stage 2 → Month 2, etc.
      _currentMonthIndex = (_currentStage - 1).clamp(0, totalMonths - 1);
      _monthNumber = '01'; // Always show as first week of the month
    } else {
      // More stages than months - distribute evenly but still progress through months
      // Calculate how many stages per month, then advance month accordingly
      final stagesPerMonth = (_totalStages / totalMonths).ceil();
      _currentMonthIndex = ((_currentStage - 1) ~/ stagesPerMonth).clamp(
        0,
        totalMonths - 1,
      );

      // Within each month, show stage progression
      final stageInMonth = ((_currentStage - 1) % stagesPerMonth) + 1;
      _monthNumber = stageInMonth.toString().padLeft(2, '0');
    }

    // Update current month display
    _currentMonth = _cultivationMonths[_currentMonthIndex].toUpperCase();

    // Update environmental data for the current month
    _updateEnvironmentalDataForMonth(_cultivationMonths[_currentMonthIndex]);
  }

  /// Update environmental data for specific month
  void _updateEnvironmentalDataForMonth(String month) {
    // Update SMAP data from database for current month
    if (_smapData != null && _smapData!.containsKey(month)) {
      final smapValues = _smapData![month] as List<dynamic>;
      if (smapValues.isNotEmpty) {
        // Use actual SMAP value from database (first value in array)
        final actualSmap = (smapValues[0] as num).toDouble();
        _smap = actualSmap * 100; // Convert to percentage (0.41 → 41%)
      }
    }

    // Update NDVI data from database for current month
    if (_ndviData != null && _ndviData!.containsKey(month)) {
      final ndviValues = _ndviData![month] as List<dynamic>;
      if (ndviValues.isNotEmpty) {
        // Use actual NDVI value from database (first value in array)
        final actualNdvi = (ndviValues[0] as num).toDouble();
        _ndvi = '№${(actualNdvi * 100).toInt()}'; // Format as №XX (0.25 → №25)
      }
    }

    // Temperature can vary slightly with month (optional enhancement)
    // For now, keep it relatively stable but could add seasonal variation
    _temperature = 33.0; // Could be made month-dependent in future
  }

  /// Extract months from cultivation period in correct chronological order
  List<String> _extractMonthsFromCultivationPeriod(
    String cultivationPeriod,
    Set<String> availableMonths,
  ) {
    // Parse cultivation period like "October-April" or "Nov-Mar"
    final parts = cultivationPeriod.split('-');
    if (parts.length != 2) {
      return availableMonths.toList(); // Fallback to available months
    }

    final startMonthName = parts[0].trim();
    final endMonthName = parts[1].trim();

    // Convert to standard month names
    final startMonth = _parseMonthName(startMonthName);
    final endMonth = _parseMonthName(endMonthName);

    if (startMonth == null || endMonth == null) {
      return availableMonths.toList(); // Fallback if parsing fails
    }

    // Generate chronological sequence from start to end month
    final List<String> chronologicalMonths = [];

    const monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    int currentMonth = startMonth;
    while (true) {
      final monthName = monthNames[currentMonth - 1];
      // Only include months that have data in the database
      if (availableMonths.any(
        (m) => m.toLowerCase() == monthName.toLowerCase(),
      )) {
        chronologicalMonths.add(monthName);
      }

      if (currentMonth == endMonth) break;

      currentMonth++;
      if (currentMonth > 12) currentMonth = 1; // Wrap around year
    }

    return chronologicalMonths;
  }

  /// Parse month name to month number (1-12)
  int? _parseMonthName(String monthName) {
    final normalized = monthName.toLowerCase().trim();

    const monthMap = {
      'january': 1,
      'jan': 1,
      'february': 2,
      'feb': 2,
      'march': 3,
      'mar': 3,
      'april': 4,
      'apr': 4,
      'may': 5,
      'june': 6,
      'jun': 6,
      'july': 7,
      'jul': 7,
      'august': 8,
      'aug': 8,
      'september': 9,
      'sep': 9,
      'october': 10,
      'oct': 10,
      'november': 11,
      'nov': 11,
      'december': 12,
      'dec': 12,
    };

    return monthMap[normalized];
  }

  /// Sort months in cultivation order (respecting crop cycle sequence)
  List<String> _sortMonthsInCultivationOrder(List<String> months) {
    if (months.isEmpty) return months;

    const monthNumbers = {
      'Jan': 1,
      'Feb': 2,
      'Mar': 3,
      'Apr': 4,
      'May': 5,
      'Jun': 6,
      'Jul': 7,
      'Aug': 8,
      'Sep': 9,
      'Oct': 10,
      'Nov': 11,
      'Dec': 12,
      'JAN': 1,
      'FEB': 2,
      'MAR': 3,
      'APR': 4,
      'MAY': 5,
      'JUN': 6,
      'JUL': 7,
      'AUG': 8,
      'SEP': 9,
      'OCT': 10,
      'NOV': 11,
      'DEC': 12,
    };

    // Convert month names to numbers and sort
    List<MapEntry<String, int>> monthsWithNumbers =
        months.map((month) {
          return MapEntry(month, monthNumbers[month] ?? 1);
        }).toList();

    // Sort by month number to find the cultivation sequence
    monthsWithNumbers.sort((a, b) => a.value.compareTo(b.value));

    // Find the starting month (minimum month number in the cultivation cycle)
    int startMonth = monthsWithNumbers.first.value;

    // Create cultivation sequence starting from the first month
    List<String> sortedMonths = [];

    // Add months from start month onwards (same year)
    for (var entry in monthsWithNumbers) {
      if (entry.value >= startMonth) {
        sortedMonths.add(entry.key);
      }
    }

    // Add months from January to start month (next year for cycles crossing year boundary)
    for (var entry in monthsWithNumbers) {
      if (entry.value < startMonth) {
        sortedMonths.add(entry.key);
      }
    }

    return sortedMonths;
  }

  /// Advance to next stage and month progression
  void _advanceStage() {
    if (_currentStage < _totalStages) {
      setState(() {
        _currentStage++;

        // CROP-SPECIFIC MONTH PROGRESSION
        // Each "Done" button click should ideally advance to the next cultivation month
        _advanceToNextMonth();

        _updateCalendarAndEnvironmentalData();
      });
    }
  }

  /// Advance to the next month in cultivation sequence
  void _advanceToNextMonth() {
    if (_cultivationMonths.isEmpty) return;

    final totalMonths = _cultivationMonths.length;

    // Calculate target month index based on stage progression
    if (_totalStages <= totalMonths) {
      // Each stage gets its own month - direct 1:1 mapping
      _currentMonthIndex = (_currentStage - 1).clamp(0, totalMonths - 1);
    } else {
      // More stages than months - advance month at calculated intervals
      final stagesPerMonth = (_totalStages / totalMonths).ceil();
      final targetMonthIndex = ((_currentStage - 1) ~/ stagesPerMonth).clamp(
        0,
        totalMonths - 1,
      );
      _currentMonthIndex = targetMonthIndex;
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
          child:
              _isLoadingData
                  ? const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.brown),
                    ),
                  )
                  : LayoutBuilder(
                    builder: (context, constraints) {
                      return Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Left column: Calendar, Speech bubble, Farmer
                            _buildLeftColumn(constraints),
                            const SizedBox(width: 8),
                            // Center column: Seed image, Action buttons
                            _buildCenterColumn(constraints),
                            const SizedBox(width: 8),
                            // Right column: Environmental data, Done button
                            _buildRightColumn(constraints),
                          ],
                        ),
                      );
                    },
                  ),
        ),
      ),
    );
  }

  Widget _buildLeftColumn(BoxConstraints constraints) {
    return Expanded(
      flex: 3,
      child: SizedBox(
        height: constraints.maxHeight - 24, // Account for padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Calendar widget - fixed height
            SizedBox(
              height: constraints.maxHeight * 0.25, // 25% of screen height
              child: CalendarWidget(
                currentMonth: _currentMonth,
                monthNumber: _monthNumber,
              ),
            ),
            const SizedBox(height: 10),
            // Farmer section - remaining space
            Expanded(child: FarmerSectionWidget(cropName: currentCrop.name)),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterColumn(BoxConstraints constraints) {
    print('🏗️ Building center column with constraints: $constraints');
    return Expanded(
      flex: 4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Seed panel - flexible to use available space
          Expanded(
            flex: 6, // Give more space to seed panel
            child: LayoutBuilder(
              builder: (context, localConstraints) {
                return SizedBox(
                  height: localConstraints.maxHeight,
                  child: SeedPanelWidget(
                    stageLabel: _getCurrentStageLabel(),
                    currentStage: _currentStage,
                    totalStages: _totalStages,
                    cropFolderName: _normalizeCropFolderName(currentCrop.name),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          // Action buttons - flexible but constrained
          Expanded(
            flex: 4, // Give less space to action buttons
            child: LayoutBuilder(
              builder: (context, localConstraints) {
                return SizedBox(
                  height: localConstraints.maxHeight,
                  child: ActionButtonsWidget(
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRightColumn(BoxConstraints constraints) {
    return Expanded(
      flex: 2,
      child: SizedBox(
        height: constraints.maxHeight - 24, // Account for padding
        child: Column(
          children: [
            // Environmental data - takes most space
            Expanded(
              flex: 3,
              child: EnvironmentalDataWidget(
                temperature: _temperature,
                smap: _smap,
                ndvi: _ndvi,
              ),
            ),
            const SizedBox(height: 10),
            // Done button - fixed height
            SizedBox(
              height: constraints.maxHeight * 0.15, // 15% of screen height
              child: DoneButtonWidget(
                cropName: currentCrop.name,
                selectedCrop: currentCrop,
                irrigationLevel: _irrigationLevel,
                fertilizerLevel: _fertilizerLevel,
                pesticideLevel: _pesticideLevel,
                currentStage: _currentStage,
                totalStages: _totalStages,
                onStageAdvance: _advanceStage,
                currentMonth: _currentMonth,
                monthNumber: _monthNumber,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
