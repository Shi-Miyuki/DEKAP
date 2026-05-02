import 'dart:convert';
import 'package:flutter/services.dart';

class DecisionTreeModel {
  Map<String, dynamic>? _tree;

  bool _isLoaded = false;

  // =========================
  // LOAD MODEL JSON
  // =========================
  Future<void> loadModel(String assetPath) async {
    final String data = await rootBundle.loadString(assetPath);
    _tree = json.decode(data);
    _isLoaded = true;
  }

  // =========================
  // PREDICT CLASS LABEL
  // =========================
  int predict(Map<String, double> input) {
    if (!_isLoaded || _tree == null) {
      throw Exception("Model belum di-load");
    }

    return _traverse(_tree!, input);
  }

  // =========================
  // TRAVERSAL RECURSIVE TREE
  // =========================
  int _traverse(Map<String, dynamic> node, Map<String, double> input) {
    // leaf node
    if (node.containsKey("value")) {
      return _argMax(node["value"]);
    }

    String feature = node["feature"];
    double threshold = (node["threshold"] as num).toDouble();

    double featureValue = input[feature] ?? 0.0;

    if (featureValue <= threshold) {
      return _traverse(node["left"], input);
    } else {
      return _traverse(node["right"], input);
    }
  }

  // =========================
  // ARGMAX CLASS
  // =========================
  int _argMax(List<dynamic> value) {
    List<dynamic> counts = value[0];

    int maxIndex = 0;
    double maxValue = (counts[0] as num).toDouble();

    for (int i = 1; i < counts.length; i++) {
      double v = (counts[i] as num).toDouble();
      if (v > maxValue) {
        maxValue = v;
        maxIndex = i;
      }
    }

    return maxIndex;
  }

  // =========================
  // PROBABILITY OUTPUT (OPTIONAL)
  // =========================
  List<double> predictProba(Map<String, double> input) {
    if (!_isLoaded || _tree == null) {
      throw Exception("Model belum di-load");
    }

    List<dynamic> value = _getLeafValue(_tree!, input);
    List<dynamic> counts = value[0];

    double sum = 0;
    List<double> probs = [];

    for (var c in counts) {
      double v = (c as num).toDouble();
      probs.add(v);
      sum += v;
    }

    return probs.map((e) => e / sum).toList();
  }

  List<dynamic> _getLeafValue(Map<String, dynamic> node, Map<String, double> input) {
    if (node.containsKey("value")) {
      return node["value"];
    }

    String feature = node["feature"];
    double threshold = (node["threshold"] as num).toDouble();
    double featureValue = input[feature] ?? 0.0;

    if (featureValue <= threshold) {
      return _getLeafValue(node["left"], input);
    } else {
      return _getLeafValue(node["right"], input);
    }
  }
}
