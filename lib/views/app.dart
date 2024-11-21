import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reconocimiento_plantas/controller/image_state.dart';
import 'package:reconocimiento_plantas/controller/plant_controller.dart';
import 'package:reconocimiento_plantas/views/home_veiew.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PlantController()),
        ChangeNotifierProvider(create: (context) => ImageState()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const HomeView(),
      ),
    );
  }
}
