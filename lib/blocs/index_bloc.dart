import 'package:flutter/material.dart';

class SelectedValueProvider extends ChangeNotifier {
  String? _selectedValue;

  String? get selectedValue => _selectedValue;

  void setSelectedValue(String value) {
    _selectedValue = value;
    notifyListeners(); // Notify listeners of the change
  }
}
