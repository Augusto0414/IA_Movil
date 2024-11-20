import 'dart:io';
import 'package:dio/dio.dart';
import 'package:reconocimiento_plantas/model/prediction_model.dart';

class ApiService {
  final Dio _dio = Dio();
  final String apiUrl = 'https://fastia.onrender.com/predict/'; // URL de la API

  Future<PredictionModel?> uploadImage(File imageFile) async {
    try {
      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(imageFile.path),
      });

      Response response = await _dio.post(apiUrl, data: formData);

      if (response.statusCode == 200) {
        return PredictionModel.fromJson(response.data);
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
    return null;
  }
}
