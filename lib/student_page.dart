import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/create_student.dart';

class StudentPage extends StatefulWidget {
  const StudentPage({super.key});

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  final CollectionReference<Map<String, dynamic>> students = FirebaseFirestore
      .instance
      .collection('students');

  String getInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));

    if (name.trim().isEmpty) return '?';

    if (parts.length == 1) {
      return parts.first[0].toUpperCase();
    }

    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF2196F3);
    const backgroundColor = Color(0xFFF5F7FC);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          "Student Page",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => CreateStudent()),
                );
              },
              icon: const Icon(Icons.person_add_alt_1_rounded, size: 25),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: students.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: const CircularProgressIndicator(
                        color: primaryColor,
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error: ${snapshot.error}',
                        textAlign: TextAlign.center,
                      ),
                    );
                  }

                  final documents = snapshot.data?.docs ?? [];

                  if (documents.isEmpty) {
                    return Center(
                      child: Text(
                        'No student records yet.',
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: documents.length,
                    itemBuilder: (context, index) {
                      final document = documents[index];
                      final data = document.data();

                      final studentno = data["student_no"] ?? '';
                      final name = data["name"] ?? '';
                      final course = data['course'] ?? '';

                      return Card(
                        elevation: 0,
                        margin: EdgeInsets.only(bottom: 14),
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(18),
                          side: BorderSide(color: Color(0xFFE5EAF2), width: 1),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  CircleAvatar(
                                    radius: 26,
                                    backgroundColor: const Color(0xFFE3F0FF),
                                    child: Text(
                                      getInitials(name),
                                      style: const TextStyle(
                                        color: primaryColor,
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 14),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          name,
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF1E293B),
                                          ),
                                        ),

                                        const SizedBox(height: 7),

                                        Row(
                                          children: [
                                            Icon(
                                              Icons.badge_outlined,
                                              size: 16,
                                              color: Color(0xFF94A388),
                                            ),
                                            SizedBox(width: 6),
                                            Expanded(
                                              child: Text(
                                                studentno,
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: Color(0xFF647488),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.delete_outline_rounded,
                                      color: Color(0xFF94A3B8),
                                      size: 23,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 14),

                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Color(0xFFF1F6FD),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.school_outlined,
                                      size: 17,
                                      color: primaryColor,
                                    ),

                                    const SizedBox(width: 7),

                                    Flexible(
                                      child: Text(
                                        course,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF475569),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton(
              tooltip: 'Add student',
              style: IconButton.styleFrom(
                backgroundColor: const Color(0xFFE5F1FF),
                foregroundColor: blue,
              ),
              icon: const Icon(Icons.person_add_alt_1_rounded),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CreateStudentPage(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: students.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      size: 44,
                      color: Color(0xFFDC5353),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Unable to load students',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: darkText,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Error: ${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: secondaryText),
                    ),
                  ],
                ),
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: blue),
            );
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE5F1FF),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Icon(
                        Icons.people_outline_rounded,
                        size: 48,
                        color: blue,
                      ),
                    ),
                    const SizedBox(height: 22),
                    const Text(
                      'No students yet',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w800,
                        color: darkText,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Add your first student to get started.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: secondaryText,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 22),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CreateStudentPage(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.add_rounded),
                      label: const Text('Add Student'),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
            children: [
              const Text(
                'Student Directory',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                  color: darkText,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'View and manage your student records.',
                style: TextStyle(
                  fontSize: 14,
                  color: secondaryText,
                ),
              ),
              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: const Color(0xFFE6EDF5),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE5F1FF),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.groups_rounded,
                        color: blue,
                        size: 25,
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Records',
                            style: TextStyle(
                              fontSize: 13,
                              color: secondaryText,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Registered Students',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: darkText,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 13,
                        vertical: 9,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE5F1FF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${docs.length}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'ALL STUDENTS',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.3,
                  color: secondaryText,
                ),
              ),

              const SizedBox(height: 12),

              ...docs.map((doc) {
                final data = doc.data();
                final name = data['name']?.toString() ?? 'No name';
                final course = data['course']?.toString() ?? 'No course';
                final studentNumber =
                    data['studentNumber']?.toString() ??
                    'No student number';

                return Card(
                  color: Colors.white,
                  elevation: 0,
                  margin: const EdgeInsets.only(bottom: 14),
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                    side: const BorderSide(
                      color: Color(0xFFE6EDF5),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 27,
                              backgroundColor: const Color(0xFFE5F1FF),
                              child: Text(
                                initials(name),
                                style: const TextStyle(
                                  color: blue,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      height: 1.3,
                                      fontWeight: FontWeight.w700,
                                      color: darkText,
                                    ),
                                  ),
                                  const SizedBox(height: 7),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.badge_outlined,
                                        size: 16,
                                        color: secondaryText,
                                      ),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          studentNumber,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: secondaryText,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            IconButton(
                              tooltip: 'Delete student',
                              visualDensity: VisualDensity.compact,
                              icon: const Icon(
                                Icons.delete_outline_rounded,
                                color: Color(0xFF94A3B8),
                                size: 22,
                              ),
                              onPressed: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    icon: const Icon(
                                      Icons.delete_outline_rounded,
                                      color: Color(0xFFDC5353),
                                      size: 32,
                                    ),
                                    title: const Text('Delete Student?'),
                                    content: Text(
                                      'Are you sure you want to delete $name?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, true),
                                        style: TextButton.styleFrom(
                                          foregroundColor:
                                              const Color(0xFFDC5353),
                                        ),
                                        child: const Text('Delete'),
                                      ),
                                    ],
                                  ),
                                );

                                if (confirm == true) {
                                  try {
                                    await doc.reference.delete();
                                  } catch (e) {
                                    if (!context.mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Error: $e')),
                                    );
                                  }
                                }
                              },
                            ),
                          ],
                        ),

                        const SizedBox(height: 18),

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 13,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F8FC),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.school_outlined,
                                color: blue,
                                size: 20,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  course,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    height: 1.4,
                                    fontWeight: FontWeight.w500,
                                    color: secondaryText,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}