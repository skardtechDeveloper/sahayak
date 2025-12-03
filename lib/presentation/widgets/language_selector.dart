import 'package:flutter/material.dart';

class LanguageSelector extends StatelessWidget {
  final String currentLanguage;
  final Function(String) onLanguageChanged;

  const LanguageSelector({
    super.key,
    required this.currentLanguage,
    required this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blue),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildLanguageButton('en', 'EN', context),
          Container(
            width: 1,
            height: 20,
            color: Colors.blue,
          ),
          _buildLanguageButton('ne', 'ने', context),
        ],
      ),
    );
  }

  Widget _buildLanguageButton(String code, String label, BuildContext context) {
    final isSelected = currentLanguage == code;
    return InkWell(
      onTap: () => onLanguageChanged(code),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: isSelected
            ? BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(16),
              )
            : null,
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.blue,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
