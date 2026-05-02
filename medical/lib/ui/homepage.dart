import 'package:flutter/material.dart';
import 'formpage.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Early Risk Screening"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.health_and_safety,
              size: 100,
              color: Colors.pink,
            ),

            const SizedBox(height: 30),

            const Text(
              "Early Risk Detection\nBreast Cancer",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Aplikasi ini membantu melakukan skrining awal risiko kanker payudara "
              "berdasarkan gejala yang Anda alami.\n\n"
              "Hasil bukan diagnosis medis.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const FormPage(),
                    ),
                  );
                },
                child: const Text("Mulai Screening"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}