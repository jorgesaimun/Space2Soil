import 'package:flutter/material.dart';
import '../services/location_service.dart';

/// Dialog for selecting division manually
class DivisionSelectionDialog extends StatelessWidget {
  final Function(String) onDivisionSelected;

  const DivisionSelectionDialog({
    Key? key,
    required this.onDivisionSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Select Division',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: LocationService.getBangladeshDivisions().length,
          itemBuilder: (context, index) {
            final division = LocationService.getBangladeshDivisions()[index];
            return ListTile(
              leading: const Icon(Icons.location_city),
              title: Text(
                division,
                style: const TextStyle(fontSize: 16),
              ),
              onTap: () {
                Navigator.of(context).pop();
                onDivisionSelected(division);
              },
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
