import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import '../models/staff.dart';
import '../services/storage_service.dart';
import '../services/location_service.dart';

class EvaluationFormScreen extends StatefulWidget {
  final Staff staff;
  const EvaluationFormScreen({super.key, required this.staff});

  @override
  State<EvaluationFormScreen> createState() => _EvaluationFormScreenState();
}

class _EvaluationFormScreenState extends State<EvaluationFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _commentsController = TextEditingController();
  double _score = 3.0;
  File? _image;
  final StorageService _storageService = StorageService();
  final LocationService _locationService = LocationService();
  bool _isSubmitting = false;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      String locationStr = "Location not captured";
      try {
        Position position = await _locationService.getCurrentLocation();
        locationStr = "Lat: \${position.latitude.toStringAsFixed(4)}, Long: \${position.longitude.toStringAsFixed(4)}";
      } catch (e) {
        locationStr = "Error: \$e";
      }

      final evaluation = {
        'staffId': widget.staff.id,
        'staffName': widget.staff.name,
        'score': _score,
        'comments': _commentsController.text,
        'imagePath': _image?.path ?? '',
        'location': locationStr,
        'date': DateTime.now().toIso8601String(),
      };

      await _storageService.saveEvaluation(evaluation);

      if (!mounted) return;

      setState(() {
        _isSubmitting = false;
      });

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Success'),
          content: Text('Evaluation for ${widget.staff.name} saved successfully!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Go back to list
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Evaluate: ${widget.staff.name}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text('Staff Name: ${widget.staff.name}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text('Email: ${widget.staff.email}'),
              const Divider(height: 30),

              const Text('Attach Photo (Device Feature: Camera)', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 10),
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.blueAccent),
                    ),
                    child: _image == null
                        ? const Icon(Icons.camera_alt, size: 50, color: Colors.blueAccent)
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(_image!, fit: BoxFit.cover),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              const Text('Performance Score (1-5):', style: TextStyle(fontSize: 16)),
              Slider(
                value: _score,
                min: 1,
                max: 5,
                divisions: 4,
                label: _score.round().toString(),
                onChanged: (value) {
                  setState(() {
                    _score = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _commentsController,
                decoration: const InputDecoration(
                  labelText: 'Comments',
                  border: OutlineInputBorder(),
                  hintText: 'Enter evaluation feedback...',
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some comments';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: Colors.blueAccent,
                ),
                onPressed: _isSubmitting ? null : _submitForm,
                child: _isSubmitting 
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text('Save Evaluation & Location', style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
