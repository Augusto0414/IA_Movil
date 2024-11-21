import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:reconocimiento_plantas/controller/image_state.dart';
import 'package:reconocimiento_plantas/controller/plant_controller.dart';
import 'package:reconocimiento_plantas/widget/description_predicion.dart';
import 'package:reconocimiento_plantas/widget/upload_imagen_buttom.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final picker = ImagePicker();

    Future<void> takePicture() async {
      final XFile? image = await picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        await Provider.of<ImageState>(context, listen: false)
            .loadImage(File(image.path));
      }
    }

    Future<void> pickFromGallery() async {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        await Provider.of<ImageState>(context, listen: false)
            .loadImage(File(image.path));
      }
    }

    Future<void> performSearch() async {
      final imageState = Provider.of<ImageState>(context, listen: false);
      final plantController =
          Provider.of<PlantController>(context, listen: false);

      if (imageState.image == null) {
        // Mostrar mensaje si no hay imagen seleccionada
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Primero selecciona una imagen')),
        );
        return;
      }

      try {
        // Realizar predicción
        await plantController.predictImage(imageState.image!);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Predicción completada')),
        );
      } catch (e) {
        // Manejo de errores
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }

    return Scaffold(
      body: const SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.only(top: 20),
                child: UploadImageButton(),
              ),
            ),
            PredictionResultsWidget()
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: takePicture,
            backgroundColor: const Color(0xFF48AB94),
            child: const Icon(
              Icons.camera_alt,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: pickFromGallery,
            backgroundColor: const Color(0xFF48AB94),
            child: const Icon(
              Icons.photo,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: performSearch,
            backgroundColor: const Color(0xFF48AB94),
            child: const Icon(
              Icons.search,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
