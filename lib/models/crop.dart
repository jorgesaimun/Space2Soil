/// Model class for crop data
class Crop {
  final String name;
  final String imagePath;
  final String cropCycle;
  final String places;
  final String notes;
  final List<String> relatedItems;

  const Crop({
    required this.name,
    required this.imagePath,
    required this.cropCycle,
    required this.places,
    required this.notes,
    required this.relatedItems,
  });
}

/// Available crops data
class CropData {
  static const List<Crop> crops = [
    Crop(
      name: 'Tomato',
      imagePath: 'assets/images/tomato_icon.png',
      cropCycle: 'February-July',
      places: 'Khulna, Dhaka, CTG',
      notes:
          'Tropical Vegetable, needs good care, water and strict pesticide control',
      relatedItems: [
        'assets/images/tomato_icon.png',
      ], // Add more related items as needed
    ),
    Crop(
      name: 'Potato',
      imagePath: 'assets/images/potato.png',
      cropCycle: 'November-March',
      places: 'Rangpur, Bogura, Munshiganj',
      notes:
          'Cool season crop, requires well-drained soil and moderate watering',
      relatedItems: [
        'assets/images/potato.png',
      ], // Add more related items as needed
    ),
  ];
}
