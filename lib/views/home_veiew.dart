import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reconocimiento_plantas/widget/upload_imagen_buttom.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  XFile? _image;

  final ImagePicker _picker = ImagePicker();

  Future<void> _takePicture() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _image = image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: UploadImageButton(
                    image: _image), // Pasar la imagen a UploadImageButton
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomRight,
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.end, // Alinea los botones a la derecha
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(right: 10), // Espaciado entre botones
              child: FloatingActionButton(
                onPressed: _takePicture, // Abrir la cámara cuando se presione
                backgroundColor: const Color(0xFF48AB94),
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
