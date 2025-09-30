import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/land.dart';

class CustomLandDialog extends StatefulWidget {
  final Function(Land) onLandCreated;

  const CustomLandDialog({super.key, required this.onLandCreated});

  @override
  State<CustomLandDialog> createState() => _CustomLandDialogState();
}

class _CustomLandDialogState extends State<CustomLandDialog> {
  final TextEditingController _lengthController = TextEditingController();
  final TextEditingController _widthController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _bothInputsFilled = false;

  @override
  void initState() {
    super.initState();
    _lengthController.addListener(_updateButtonState);
    _widthController.addListener(_updateButtonState);
  }

  void _updateButtonState() {
    setState(() {
      _bothInputsFilled =
          _lengthController.text.isNotEmpty && _widthController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _lengthController.removeListener(_updateButtonState);
    _widthController.removeListener(_updateButtonState);
    _lengthController.dispose();
    _widthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final bool isKeyboardOpen = keyboardHeight > 0;
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.only(
        left: 12,
        right: 12,
        top: isKeyboardOpen ? 2 : 32,
        bottom: isKeyboardOpen ? 2 : 24,
      ),
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.only(bottom: keyboardHeight > 0 ? 0 : 0),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 380),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF5EFE4),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF8D6E63), width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(isKeyboardOpen ? 4 : 10),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Input fields
                        _buildInputFields(isKeyboardOpen),
                        SizedBox(height: isKeyboardOpen ? 4 : 10),
                        // Reserve tiny space so floating button doesn't overlap fields
                        SizedBox(height: _bothInputsFilled ? (isKeyboardOpen ? 0 : 12) : 0),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: -14,
              right: -14,
              child: _buildFloatingCloseButton(),
            ),
            if (_bothInputsFilled && !isKeyboardOpen)
              Positioned(
                bottom: -16,
                left: 0,
                right: 0,
                child: _buildFloatingDoneButton(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingCloseButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => Navigator.of(context).pop(),
        customBorder: const CircleBorder(),
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: const Color(0xFFE57373),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF8D6E63), width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: const Icon(Icons.close, color: Colors.white, size: 18),
        ),
      ),
    );
  }

  Widget _buildInputFields([bool isKeyboardOpen = false]) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: isKeyboardOpen ? 3 : 6),
          child: _buildInputField("Length:", _lengthController),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: isKeyboardOpen ? 3 : 6),
          child: _buildInputField("Width:", _widthController),
        ),
      ],
    );
  }

  Widget _buildInputField(String label, TextEditingController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFD54F), Color(0xFFFFC107)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE65100), width: 2),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: GoogleFonts.vt323(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF4A4A4A),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextFormField(
              controller: controller,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: GoogleFonts.vt323(
                fontSize: 18,
                color: const Color(0xFF4A4A4A),
              ),
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF8D6E63), width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF6D4C41), width: 2),
                ),
                fillColor: Colors.white,
                filled: true,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Required';
                }
                final intValue = int.tryParse(value);
                if (intValue == null || intValue <= 0) {
                  return 'Invalid';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  // Removed inline done button; using floating button below the dialog

  Widget _buildFloatingDoneButton() {
    return Center(
      child: GestureDetector(
        onTap: _handleCreate,
        child: Container(
          width: 140,
          height: 50,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF9C7FB8), Color(0xFF7B68B1)],
            ),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.black, width: 3),
          ),
          child: Center(
            child: Text(
              'DONE',
              style: GoogleFonts.vt323(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Old generic button removed; dialog uses shared START/DONE style

  void _handleCreate() {
    if (!_formKey.currentState!.validate()) return;

    final length = int.parse(_lengthController.text);
    final width = int.parse(_widthController.text);

    final customLand = Land(length: length, width: width, isCustom: true);
    // Return the created land to the caller so it can decide navigation
    Navigator.of(context).pop(customLand);
  }
}
