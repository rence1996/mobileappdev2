import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManagementPage extends StatefulWidget {
  const ManagementPage({super.key});

  @override
  State<ManagementPage> createState() => _ManagementPageState();
}

class _ManagementPageState extends State<ManagementPage> {
  final CollectionReference _students = FirebaseFirestore.instance.collection('students');

  void _showForm([DocumentSnapshot? document]) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController studentIdController = TextEditingController();
    final TextEditingController courseController = TextEditingController();
    final TextEditingController yearLevelController = TextEditingController();
    final TextEditingController emailController = TextEditingController();

    if (document != null) {
      final data = document.data() as Map<String, dynamic>? ?? {};
      nameController.text = data['studentName'] ?? data['productName'] ?? '';
      studentIdController.text = data['studentId'] ?? '';
      courseController.text = data['course'] ?? data['category'] ?? '';
      yearLevelController.text = data['yearLevel'] ?? data['stock']?.toString() ?? '';
      emailController.text = data['email'] ?? data['supplier'] ?? '';
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
          top: 20,
          left: 20,
          right: 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                document == null ? 'Add Student' : 'Edit Student',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Student Name',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.green, width: 2)),
                  labelStyle: TextStyle(color: Colors.green),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: studentIdController,
                decoration: const InputDecoration(
                  labelText: 'Student ID',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.green, width: 2)),
                  labelStyle: TextStyle(color: Colors.green),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: courseController,
                decoration: const InputDecoration(
                  labelText: 'Course / Program',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.green, width: 2)),
                  labelStyle: TextStyle(color: Colors.green),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: yearLevelController,
                decoration: const InputDecoration(
                  labelText: 'Year Level',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.green, width: 2)),
                  labelStyle: TextStyle(color: Colors.green),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.green, width: 2)),
                  labelStyle: TextStyle(color: Colors.green),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    final String name = nameController.text.trim();
                    final String studentId = studentIdController.text.trim();
                    final String course = courseController.text.trim();
                    final String yearLevel = yearLevelController.text.trim();
                    final String email = emailController.text.trim();

                    if (name.isEmpty || studentId.isEmpty || course.isEmpty || yearLevel.isEmpty || email.isEmpty) {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please fill out all fields properly.')),
                      );
                      return;
                    }

                    if (document == null) {
                      await _students.add({
                        'studentName': name,
                        'studentId': studentId,
                        'course': course,
                        'yearLevel': yearLevel,
                        'email': email,
                        'createdAt': FieldValue.serverTimestamp(),
                      });
                    } else {
                      await _students.doc(document.id).update({
                        'studentName': name,
                        'studentId': studentId,
                        'course': course,
                        'yearLevel': yearLevel,
                        'email': email,
                      });
                    }

                    if (!mounted) return;
                    Navigator.pop(sheetContext);
                  },
                  child: Text(document == null ? 'Save Student' : 'Update Student'),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _deleteStudent(String docId) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text('Are you sure you want to delete this record?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () async {
              await _students.doc(docId).delete();
              if (!mounted) return;
              Navigator.pop(dialogContext);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Information'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _students.orderBy('createdAt', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.green));
          }

          final docs = snapshot.data?.docs ?? [];
          if (docs.isEmpty) {
            return const Center(child: Text('No students found. Add one now.'));
          }

          return ListView.builder(
            itemCount: docs.length,
            padding: const EdgeInsets.all(8),
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>? ?? {};
              
              final studentName = data['studentName'] ?? data['productName'] ?? 'No Name';
              final studentId = data['studentId'] ?? 'N/A';
              final course = data['course'] ?? data['category'] ?? 'N/A';
              final yearLevel = data['yearLevel'] ?? data['stock']?.toString() ?? 'N/A';
              final email = data['email'] ?? data['supplier'] ?? 'N/A';

              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  title: Text(studentName, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                    'Student ID: $studentId\nCourse: $course | Year: $yearLevel\nEmail: $email',
                  ),
                  isThreeLine: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.green),
                        onPressed: () => _showForm(doc),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteStudent(doc.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        onPressed: () => _showForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}