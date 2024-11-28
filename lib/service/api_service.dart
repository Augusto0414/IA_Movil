import 'dart:io';
import 'package:dio/dio.dart';
import 'package:reconocimiento_plantas/model/prediction_model.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

class ApiService {
  final Dio _dio = Dio();
  final String apiUrl = 'https://api-ia-odki.onrender.com/predict/';

  Future<PredictionModel?> uploadImage(File imageFile) async {
    try {
      String? mimeType = lookupMimeType(imageFile.path); // Detectar el MIME
      mimeType ??= 'image/jpeg';

      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          imageFile.path,
          contentType: MediaType.parse(mimeType),
        ),
      });

      Response response = await _dio.post(apiUrl, data: formData);

      if (response.statusCode == 200) {
        if (response.data is Map<String, dynamic>) {
          return PredictionModel.fromJson(response.data);
        } else {
          final Map<String, dynamic> parsedData =
              Map<String, dynamic>.from(response.data);
          return PredictionModel.fromJson(parsedData);
        }
      } else {
        print('Error: ${response.statusCode} - ${response.statusMessage}');
      }
    } catch (e) {
      print('Error: $e');
    }
    return null;
  }
}
