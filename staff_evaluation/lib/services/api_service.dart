import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/staff.dart';

class ApiService {
  Future<List<Staff>> fetchStaff() async {
    try {
      final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        List<Staff> staff = body.map((dynamic item) => Staff.fromJson(item)).toList();
        return staff;
      } else {
        throw Exception('Failed to load staff');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
