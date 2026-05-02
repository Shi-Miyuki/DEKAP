import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  final int label;
  final List<double> prob;

  const ResultPage({
    super.key,
    required this.label,
    required this.prob,
  });

  String getRiskText() {
    if (label == 0) return "LOW RISK";
    if (label == 1) return "MEDIUM RISK";
    return "HIGH RISK";
  }

  Color getRiskColor() {
    if (label == 0) return Colors.green;
    if (label == 1) return Colors.orange;
    return Colors.red;
  }

  String getExplanation() {
    if (label == 0) {
      return "Tidak ditemukan indikasi kuat berdasarkan input yang diberikan. "
          "Tetap disarankan melakukan pemeriksaan rutin.";
    } else if (label == 1) {
      return "Terdapat beberapa gejala yang perlu diperhatikan. "
          "Disarankan melakukan konsultasi lebih lanjut.";
    } else {
      return "Terdapat indikasi risiko tinggi berdasarkan kombinasi gejala. "
          "Segera konsultasikan ke fasilitas kesehatan.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hasil Screening"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // =========================
            // RISK CARD
            // =========================
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: getRiskColor().withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: getRiskColor()),
              ),
              child: Column(
                children: [
                  Text(
                    getRiskText(),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: getRiskColor(),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    getExplanation(),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // =========================
            // PROBABILITY (OPTIONAL)
            // =========================
            const Text(
              "Probability Distribution",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Text("Low: ${(prob[0] * 100).toStringAsFixed(1)}%"),
            Text("Medium: ${(prob[1] * 100).toStringAsFixed(1)}%"),
            Text("High: ${(prob[2] * 100).toStringAsFixed(1)}%"),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: const Text("Kembali ke Beranda"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}