import 'dart:io';
import 'dart:async'; // Para simular el progreso
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:reconocimiento_plantas/controller/plant_controller.dart';

class UploadImageButton extends StatefulWidget {
  final XFile? image;

  const UploadImageButton({super.key, this.image});

  @override
  _UploadImageButtonState createState() => _UploadImageButtonState();
}

class _UploadImageButtonState extends State<UploadImageButton> {
  XFile? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  double _progress = 0.0; // Progreso de carga
  bool _isUploading = false; // Indica si está cargando

  @override
  void initState() {
    super.initState();
    if (widget.image != null) {
      _selectedImage =
          widget.image; // Si la imagen viene desde HomeView, la recibimos
      _isUploading = true;
      _progress = 0.0;
      _simulateUpload();
    }
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = image;
        _isUploading = true;
        _progress = 0.0;
      });

      // Simular carga progresiva
      _simulateUpload();

      // Esperar la predicción
      final plantController =
          Provider.of<PlantController>(context, listen: false);
      await Future.delayed(
          const Duration(seconds: 3)); // Simulación de predicción
      await plantController.predictImage(File(image.path));

      setState(() {
        _isUploading = false;
      });
    }
  }

  void _simulateUpload() {
    Timer.periodic(const Duration(milliseconds: 200), (timer) {
      if (_progress >= 1.0) {
        setState(() {
          _progress = 1.0;
        });
        timer.cancel();
      } else {
        setState(() {
          _progress += 0.1;
        });
      }
    });
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double containerWidth = size.width * 0.8;
    final double containerHeight = size.height * 0.4;
    final plantController = Provider.of<PlantController>(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: _pickImage,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            width: containerWidth,
            height: containerHeight,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: _selectedImage == null
                      ? _buildPlaceholder(containerHeight)
                      : _isUploading
                          ? _buildUploadingProgress(containerWidth)
                          : _buildImagePreview(),
                ),
              ],
            ),
          ),
        ),
        if (_selectedImage != null)
          FloatingActionButton(
            onPressed: _removeImage,
            mini: true,
            backgroundColor: Colors.redAccent,
            child: const Icon(Icons.close, color: Colors.white),
          ),
        if (plantController.prediction != null) ...[
          const SizedBox(height: 20),
          _buildPredictionResults(plantController)
        ],
      ],
    );
  }

  Widget _buildPredictionResults(PlantController plantController) {
    final prediction = plantController.prediction!;
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              prediction.clase,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green),
            ),
            const SizedBox(height: 10),
            Text(
              'Descripción: ${prediction.descripcion}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            if (prediction.caracteristicas.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: prediction.caracteristicas.entries
                    .map((entry) => Text('${entry.key}: ${entry.value}',
                        style: const TextStyle(fontSize: 14)))
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder(double containerHeight) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.upload_file,
          size: containerHeight * 0.2,
          color: Colors.grey[600],
        ),
        const SizedBox(height: 10),
        Text(
          'Deja tu imagen aquí',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey[600], fontSize: 16),
        ),
        const SizedBox(height: 5),
        const Text(
          'Browse',
          style: TextStyle(
            color: Colors.blue,
            decoration: TextDecoration.underline,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildUploadingProgress(double containerWidth) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Uploading...',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: containerWidth * 0.6,
          child: LinearProgressIndicator(
            value: _progress.clamp(0.0, 1.0),
            backgroundColor: Colors.grey[300],
            color: Colors.green,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          '${(_progress * 100).toInt()}%',
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildImagePreview() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.file(
        File(_selectedImage!.path),
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      ),
    );
  }
}
