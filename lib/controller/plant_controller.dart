import 'dart:io';
import 'package:flutter/material.dart';
import 'package:reconocimiento_plantas/model/prediction_model.dart';
import 'package:reconocimiento_plantas/service/api_service.dart';

class PlantController extends ChangeNotifier {
  ApiService apiService = ApiService();
  PredictionModel? prediction;

  Future<void> predictImage(File imageFile) async {
    prediction = await apiService.uploadImage(imageFile);
    notifyListeners();
  }
}
