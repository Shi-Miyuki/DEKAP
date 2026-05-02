import 'package:flutter/material.dart';
import 'resultpage.dart';
import '../model/decision_tree_model.dart';
import '../utils/input_mapper.dart';

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {

  // =========================
  // CONTROLLER
  // =========================
  final TextEditingController ageController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();

  // =========================
  // MODEL INSTANCE (SIMPLE)
  // =========================
  final DecisionTreeModel model = DecisionTreeModel();

  bool isLoaded = false;

  // =========================
  // SYMPTOM STATE (0/1/2)
  // =========================
  int lump = 0; // benjolan payudara 
  int nippleBleed = 0; // pendarahan puting 
  int skinUlcer = 0; // luka pada kulit payudara
  int peau = 0; // kulit seperti jeruk (peau d’orange)
  int fatigue = 0; // merasa kelelahan
  int weightLoss = 0; //  penurunan berat badan
  int ax_lump = 0; // benjolan di ketiak
  int shape_change = 0; // perubahan bentuk payudara
  int pain = 0; // nyeri pada payudara
  int nipple_retract = 0; // puting masuk ke dalam
  int gender = 0; 

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  Future<void> loadModel() async {
    await model.loadModel('assets/models/decision_tree.json');
    setState(() {
      isLoaded = true;
    });
  }

  // =========================
  // RADIO WIDGET
  // =========================
  Widget buildQuestion(String title, int value, Function(int?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        Row(
          children: [
            Radio(value: 1, groupValue: value, onChanged: onChanged),
            const Text("Ya"),
            Radio(value: 0, groupValue: value, onChanged: onChanged),
            const Text("Tidak"),
            Radio(value: 2, groupValue: value, onChanged: onChanged),
            const Text("Tidak tahu"),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  // =========================
  // SUBMIT
  // =========================
  void handleSubmit() {
    if (!isLoaded) return;

    Map<String, double> input = {
      "age": double.tryParse(ageController.text) ?? 0,
      "height": double.tryParse(heightController.text) ?? 0,
      "weight": double.tryParse(weightController.text) ?? 0,
      "gender": gender.toDouble(),
      "lump": mapInput(lump),
      "nipple_bleed": mapInput(nippleBleed),
      "skin_ulcer": mapInput(skinUlcer),
      "peau": mapInput(peau),

      "fatigue": mapInput(fatigue),
      "weight_loss": mapInput(weightLoss),
      "ax_lump": mapInput(ax_lump),
      "shape_change": mapInput(shape_change),
      "pain": mapInput(pain),
      "nipple_retract": mapInput(nipple_retract),
    };

    int label = model.predict(input);
    List<double> prob = model.predictProba(input);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResultPage(label: label, prob: prob),
      ),
    );
  }

  // =========================
  // UI
  // =========================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Form Screening")),
      body: isLoaded
          ? SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [

                  // INPUT DASAR
                  TextField(
                    controller: ageController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: "Umur"),
                  ),

                  TextField(
                    controller: heightController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: "Tinggi (cm)"),
                  ),

                  TextField(
                    controller: weightController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: "Berat (kg)"),
                  ),

                  const SizedBox(height: 20),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Jenis Kelamin"),
                      Row(
                        children: [
                          Radio(
                            value: 0,
                            groupValue: gender,
                            onChanged: (v) => setState(() => gender = v!),
                          ),
                          const Text("Perempuan"),

                          Radio(
                            value: 1,
                            groupValue: gender,
                            onChanged: (v) => setState(() => gender = v!),
                          ),
                          const Text("Laki-laki"),
                        ],
                      ),
                    ],
                  ),

                  // SYMPTOMS

                  buildQuestion("Apakah ada benjolan di payudara?", lump,
                      (v) => setState(() => lump = v!)),

                  buildQuestion("Apakah ada perdarahan puting?", nippleBleed,
                      (v) => setState(() => nippleBleed = v!)),

                  buildQuestion("Apakah ada luka pada kulit payudara?", skinUlcer,
                      (v) => setState(() => skinUlcer = v!)),

                  buildQuestion("Apakah kulit seperti jeruk (peau d’orange)?", peau,
                      (v) => setState(() => peau = v!)),

                  buildQuestion("Apakah merasa kelelahan?", fatigue,
                      (v) => setState(() => fatigue = v!)),

                  buildQuestion("Apakah terjadi penurunan berat badan?", weightLoss,
                      (v) => setState(() => weightLoss = v!)),

                  buildQuestion("Apakah ada benjolan di ketiak?", ax_lump,
                      (v) => setState(() => ax_lump = v!)),

                  buildQuestion("Apakah terjadi perubahan bentuk payudara?", shape_change,
                      (v) => setState(() => shape_change = v!)),

                  buildQuestion("Apakah ada nyeri pada payudara?", pain,
                      (v) => setState(() => pain = v!)),
                  
                  buildQuestion("Apakah puting masuk ke dalam?", nipple_retract,
                      (v) => setState(() => nipple_retract = v!)),
                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: handleSubmit,
                      child: const Text("Submit"),
                    ),
                  ),
                ],
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}