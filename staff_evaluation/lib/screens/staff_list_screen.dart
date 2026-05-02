import 'package:flutter/material.dart';
import '../models/staff.dart';
import '../services/api_service.dart';
import 'evaluation_form_screen.dart';

class StaffListScreen extends StatefulWidget {
  const StaffListScreen({super.key});

  @override
  State<StaffListScreen> createState() => _StaffListScreenState();
}

class _StaffListScreenState extends State<StaffListScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<Staff>> _staffFuture;

  @override
  void initState() {
    super.initState();
    _staffFuture = _apiService.fetchStaff();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Staff List')),
      body: FutureBuilder<List<Staff>>(
        future: _staffFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No staff found'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final staff = snapshot.data![index];
              return ListTile(
                leading: CircleAvatar(child: Text(staff.name[0])),
                title: Text(staff.name),
                subtitle: Text(staff.email),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EvaluationFormScreen(staff: staff),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
