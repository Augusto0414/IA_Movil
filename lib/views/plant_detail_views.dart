import 'package:flutter/material.dart';

class DetailPlants extends StatelessWidget {
  const DetailPlants({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text(
          'Detalle de la planta',
          style: TextStyle(fontSize: 15),
        ),
        SizedBox(height: 8.0),
      ],
    );
  }
}
