import 'dart:io';
import 'package:flutter/material.dart';
import 'package:reconocimiento_plantas/model/prediction_model.dart';
import 'package:reconocimiento_plantas/service/api_service.dart';

class PlantController extends ChangeNotifier {
  ApiService apiService = ApiService();
  PredictionModel? _prediction;
  bool _isLoading = false;

  PredictionModel? get prediction => _prediction;
  bool get isLoading => _isLoading;

  Future<void> predictImage(File imageFile) async {
    _prediction = await apiService.uploadImage(imageFile);
    _isLoading = false;
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void clearPrediction() {
    _prediction = null;
    _isLoading = false;
    notifyListeners();
  }
}
