import 'package:flutter/material.dart';

void main() {
  runApp(const StudentResultApp());
}

class Student {
  String name;
  int rollNo;
  // List to store marks of five subjects
  List<int> marks;

  // Map to store subject-wise marks
  Map<String, int> subjectMarks;

  Student({
    required this.name,
    required this.rollNo,
    required this.marks,
  }) : subjectMarks = {
          'Mathematics': marks[0],
          'Physics': marks[1],
          'Chemistry': marks[2],
          'Computer': marks[3],
          'English': marks[4],
        };

  // Calculate total marks
  int calculateTotal() {
    int total = 0;

    // Loop
    for (int mark in marks) {
      total += mark;
    }

    return total;
  }

  // Calculate percentage
  double calculatePercentage() {
    return calculateTotal() / marks.length;
  }

  // Calculate grade
  String calculateGrade() {
    double percentage = calculatePercentage();

    if (percentage >= 90) {
      return 'A+';
    } else if (percentage >= 80) {
      return 'A';
    } else if (percentage >= 70) {
      return 'B';
    } else if (percentage >= 60) {
      return 'C';
    } else if (percentage >= 50) {
      return 'D';
    } else {
      return 'F';
    }
  }

  // Check pass/fail
  String getResult() {
    for (int mark in marks) {
      if (mark < 35) {
        return 'FAIL';
      }
    }

    return 'PASS';
  }
}

// FLUTTER APPLICATION

class StudentResultApp extends StatelessWidget {
  const StudentResultApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Result Calculator',

      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

      home: const StudentResultPage(),
    );
  }
}

// RESULT PAGE

class StudentResultPage extends StatefulWidget {
  const StudentResultPage({super.key});

  @override
  State<StudentResultPage> createState() => _StudentResultPageState();
}

class _StudentResultPageState extends State<StudentResultPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController rollController = TextEditingController();

  final List<TextEditingController> markControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  bool isLoading = false;
  Student? student;

  final List<String> subjects = [
    'Mathematics',
    'Physics',
    'Chemistry',
    'Computer',
    'English',
  ];

  // ASYNCHRONOUS FUNCTION
  Future<Student> loadStudentResult() async {
    // Simulate loading data from server/database
    await Future.delayed(const Duration(seconds: 2));

    List<int> marks = [];

    for (TextEditingController controller in markControllers) {
      marks.add(int.parse(controller.text));
    }

    return Student(
      name: nameController.text,
      rollNo: int.parse(rollController.text),
      marks: marks,
    );
  }

  // CALCULATE RESULT
  Future<void> calculateResult() async {
    if (nameController.text.isEmpty ||
        rollController.text.isEmpty) {
      showMessage('Please enter student name and roll number.');
      return;
    }

    for (TextEditingController controller in markControllers) {
      if (controller.text.isEmpty) {
        showMessage('Please enter marks for all subjects.');
        return;
      }

      int? mark = int.tryParse(controller.text);

      if (mark == null || mark < 0 || mark > 100) {
        showMessage('Marks must be between 0 and 100.');
        return;
      }
    }

    setState(() {
      isLoading = true;
    });

    // Await asynchronous operation
    Student result = await loadStudentResult();

    setState(() {
      student = result;
      isLoading = false;
    });
  }

  // MESSAGE FUNCTION
  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  // TEXT FIELD
  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  // RESULT CARD
  Widget buildResultCard() {
    if (student == null) {
      return const SizedBox();
    }

    final Student s = student!;

    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(top: 20),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Student Result',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const Divider(),

            Text(
              'Name: ${s.name}',
              style: const TextStyle(fontSize: 17),
            ),

            Text(
              'Roll No: ${s.rollNo}',
              style: const TextStyle(fontSize: 17),
            ),

            const SizedBox(height: 15),

            const Text(
              'Subject-wise Marks',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            // Map loop
            ...s.subjectMarks.entries.map(
              (entry) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      Text(entry.key),
                      Text(
                        '${entry.value}/100',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            const Divider(),

            Text(
              'Total: ${s.calculateTotal()} / 500',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            Text(
              'Percentage: ${s.calculatePercentage().toStringAsFixed(2)}%',
              style: const TextStyle(fontSize: 18),
            ),

            Text(
              'Grade: ${s.calculateGrade()}',
              style: const TextStyle(fontSize: 18),
            ),

            Text(
              'Result: ${s.getResult()}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: s.getResult() == 'PASS'
                    ? Colors.green
                    : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // BUILD UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Result Calculator'),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter Student Details',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            buildTextField(
              controller: nameController,
              label: 'Student Name',
              hint: 'Enter name',
            ),

            buildTextField(
              controller: rollController,
              label: 'Roll Number',
              hint: 'Enter roll number',
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 10),

            const Text(
              'Enter Marks',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            // Loop for subject fields
            for (int i = 0; i < subjects.length; i++)
              buildTextField(
                controller: markControllers[i],
                label: subjects[i],
                hint: 'Enter marks out of 100',
                keyboardType: TextInputType.number,
              ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isLoading ? null : calculateResult,
                child: isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text(
                        'Calculate Result',
                        style: TextStyle(fontSize: 18),
                      ),
              ),
            ),

            buildResultCard(),
          ],
        ),
      ),
    );
  }
  @override
  void dispose() {
    nameController.dispose();
    rollController.dispose();

    for (TextEditingController controller in markControllers) {
      controller.dispose();
    }

    super.dispose();
  }
}