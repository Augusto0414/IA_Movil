import 'dart:io';
import 'package:flutter/material.dart';

class ImageState with ChangeNotifier {
  File? _image;
  bool _isUploading = false;
  bool _isLoading = false;

  File? get image => _image;
  bool get isUploading => _isUploading;
  bool get isLoading => _isLoading;

  void setImage(File image) {
    _image = image;
    notifyListeners();
  }

  void clearImage() {
    _image = null;
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setUploading(bool uploading) {
    _isUploading = uploading;
    notifyListeners();
  }

  Future<void> loadImage(File image) async {
    setLoading(true);
    await Future.delayed(const Duration(seconds: 2));
    setImage(image);
    setLoading(false);
  }

  Future<void> processImage() async {
    setUploading(true);
    await Future.delayed(const Duration(seconds: 3));
    setUploading(false);
  }
}
