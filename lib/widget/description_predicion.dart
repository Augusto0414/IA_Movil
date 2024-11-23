import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reconocimiento_plantas/controller/plant_controller.dart';
import 'package:reconocimiento_plantas/widget/loading_shimmer.dart';

class PredictionResultsWidget extends StatelessWidget {
  const PredictionResultsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PlantController>(
      builder: (context, predictionProvider, child) {
        if (predictionProvider.isLoading) {
          return const LoadingShimmer();
        }

        final prediction = predictionProvider.prediction;

        if (prediction == null) {
          return const SizedBox();
        }

        return Card(
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                    color: Colors.green,
                  ),
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
                        .map((entry) => Text(
                              '${entry.key}: ${entry.value}',
                              style: const TextStyle(fontSize: 14),
                            ))
                        .toList(),
                  ),
                const SizedBox(height: 20),
                if (prediction.probabilidades.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Probabilidades:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ...prediction.probabilidades.map(
                        (prob) => Text(
                          '${prob[0]}: ${(prob[1] * 100).toStringAsFixed(2)}%',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
