class Land {
  final int length; // in feet
  final int width; // in feet
  final bool isCustom;

  const Land({
    required this.length,
    required this.width,
    required this.isCustom,
  });

  // Calculate area in square feet
  int get area => length * width;

  // Calculate area in square meters (1 sq ft = 0.092903 sq m)
  double areaInSquareMeters() {
    return area * 0.092903;
  }

  // Get display text for dimensions
  String get dimensionsText => '${length}ft × ${width}ft';

  // Get area text
  String get areaText => '${area} sq ft';

  // Calculate relative scale for visual representation (normalized to 1.0 for 100x100)
  double get visualScale {
    const baseArea = 10000; // 100x100 = 10,000 sq ft
    final currentArea = area;
    return (currentArea / baseArea).clamp(0.3, 2.0); // Min 0.3x, Max 2.0x scale
  }

  // Copy with method for creating modified instances
  Land copyWith({int? length, int? width, bool? isCustom}) {
    return Land(
      length: length ?? this.length,
      width: width ?? this.width,
      isCustom: isCustom ?? this.isCustom,
    );
  }

  @override
  String toString() {
    return 'Land(${length}ft × ${width}ft, ${area} sq ft${isCustom ? ' - Custom' : ''})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Land &&
        other.length == length &&
        other.width == width &&
        other.isCustom == isCustom;
  }

  @override
  int get hashCode {
    return Object.hash(length, width, isCustom);
  }
}
