import 'package:flutter/material.dart';

class BiensRendusModel extends ChangeNotifier {
  List<int> _biensRendus = [];

  List<int> get biensRendus => _biensRendus;

  void addBienRendu(int id) {
    _biensRendus.add(id);
    notifyListeners();
  }

  void removeBienRendu(int id) {
    _biensRendus.remove(id);
    notifyListeners();
  }

  bool estRendu(int id) {
    return _biensRendus.contains(id);
  }
}