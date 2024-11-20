import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reconocimiento_plantas/controller/plant_controller.dart';

import 'view.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PlantController(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const HomeView(), // Cambia esto a HomeView
      ),
    );
  }
}
