import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reconocimiento_plantas/controller/image_state.dart';

class UploadImageButton extends StatelessWidget {
  const UploadImageButton({super.key});

  @override
  Widget build(BuildContext context) {
    final imageState = Provider.of<ImageState>(context);
    final image = imageState.image;
    final isLoading = imageState.isLoading;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {},
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            width: 300,
            height: 300,
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
            child: isLoading
                ? _buildLoadingProgress()
                : (image == null
                    ? _buildPlaceholder()
                    : _buildImagePreview(image)),
          ),
        ),
        if (image != null && !isLoading)
          FloatingActionButton(
            onPressed: imageState.clearImage,
            mini: true,
            backgroundColor: Colors.redAccent,
            child: const Icon(Icons.close, color: Colors.white),
          ),
      ],
    );
  }

  Widget _buildLoadingProgress() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildPlaceholder() {
    return const Center(
      child: Text("No hay imagen seleccionada"),
    );
  }

  Widget _buildImagePreview(File image) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.file(
        image,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      ),
    );
  }
}
