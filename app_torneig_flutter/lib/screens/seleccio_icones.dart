import 'dart:convert';

import 'package:app_torneig/utils/tamanys_pantalles.dart';
import 'package:app_torneig/widgets/custom_text/text_personalitzat.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ImageSelectionScreen extends StatelessWidget {
  final Function(String) onImageSelected;
  const ImageSelectionScreen({super.key, required this.onImageSelected});

  Future<List<String>> _loadImagePaths() async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final manifest = json.decode(manifestContent) as Map<String, dynamic>;

    final imagePaths = manifest.keys
        .where((String key) => key.startsWith('assets/icons/'))
        .toList();

    return imagePaths;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomTexts(
          text: 'Selecciona una imatge',
          colorText: Colors.black,
          fontFamily: 'Montserrat-bold',
          fontSize: 30,
        ),
      ),
      body: FutureBuilder<List<String>>(
        future: _loadImagePaths(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error al cargar las imágenes'));
          } else {
            final imagePaths = snapshot.data!;
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isMobile(context) ? 4 : 6,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
              ),
              itemCount: imagePaths.length,
              itemBuilder: (context, index) {
                final imagePath = imagePaths[index];

                return IconButton(
                  onPressed: () {
                    onImageSelected(imagePath);
                    Navigator.pop(context);
                  },
                  icon: Image.asset(
                    imagePath,
                    height: 100,
                    width: 100,
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
