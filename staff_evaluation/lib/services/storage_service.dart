import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class StorageService {
  static const String _keyEvaluations = 'evaluations';

  Future<void> saveEvaluation(Map<String, dynamic> evaluation) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> evaluations = prefs.getStringList(_keyEvaluations) ?? [];
    evaluations.add(jsonEncode(evaluation));
    await prefs.setStringList(_keyEvaluations, evaluations);
  }

  Future<List<Map<String, dynamic>>> getEvaluations() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> evaluationsStr = prefs.getStringList(_keyEvaluations) ?? [];
    return evaluationsStr.map((e) => jsonDecode(e) as Map<String, dynamic>).toList();
  }

  Future<void> clearEvaluations() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyEvaluations);
  }
}
