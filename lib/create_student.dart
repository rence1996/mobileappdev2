import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CreateStudent extends StatefulWidget {
  const CreateStudent({super.key});

  @override
  State<CreateStudent> createState() => _CreateStudentState();
}

class _CreateStudentState extends State<CreateStudent> {
  // Save function
  Future<void> saveTestData() async {
    await FirebaseFirestore.instance.collection('students').add({
      'name': 'Lawrence Magno',
      'course': 'BS Information Technology',
      'createdAt': FieldValue.serverTimestamp(),
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Test student saved successfully!')),
    );
  }

  // Delete function (queries and deletes documents matching the test name)
  Future<void> deleteTestData() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('students')
        .where('name', isEqualTo: 'Lawrence Magno')
        .get();

    for (var doc in querySnapshot.docs) {
      await doc.reference.delete();
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Test student(s) deleted successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Manage Student Data")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FilledButton(
              onPressed: saveTestData,
              child: const Text('Save Test Student'),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: deleteTestData,
              style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete Test Student'),
            ),
          ],
        ),
      ),
    );
  }
}