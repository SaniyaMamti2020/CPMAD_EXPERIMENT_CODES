import 'package:flutter/material.dart';

void main() {
  runApp(const StudentRegistrationApp());
}
// MAIN APPLICATION
class StudentRegistrationApp extends StatelessWidget {
  const StudentRegistrationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Student Registration App',

      theme: ThemeData(
        useMaterial3: true,

        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),

        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),

      home: const RegistrationScreen(),
    );
  }
}
// REGISTRATION SCREEN
class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() =>
      _RegistrationScreenState();
}

class _RegistrationScreenState
    extends State<RegistrationScreen> {
  // TEXT EDITING CONTROLLERS
  final TextEditingController nameController =
      TextEditingController();

  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController phoneController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();
  // FORM KEY
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>();
  // RADIO BUTTON STATE
  String? selectedGender;
  // CHECKBOX STATE
  bool flutter = false;
  bool dart = false;
  bool laravel = false;
  bool python = false;
  // SLIDER STATE
  double age = 18;
  // SWITCH STATE
  bool receiveNotifications = true;
  bool emailUpdates = false;
  // SUBMITTED DATA
  bool isSubmitted = false;
  // VALIDATE AND SUBMIT
  void submitForm() {

    // Validate TextFormFields
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Validate gender
    if (selectedGender == null) {
      showMessage('Please select your gender.');
      return;
    }

    // Validate skills
    if (!flutter &&
        !dart &&
        !laravel &&
        !python) {
      showMessage('Please select at least one skill.');
      return;
    }

    // If everything is valid
    setState(() {
      isSubmitted = true;
    });

    showMessage(
      'Registration submitted successfully!',
    );
  }
  // SNACKBAR MESSAGE
  void showMessage(String message) {

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
  // GET SELECTED SKILLS
  List<String> getSelectedSkills() {

    List<String> skills = [];

    if (flutter) {
      skills.add('Flutter');
    }

    if (dart) {
      skills.add('Dart');
    }

    if (laravel) {
      skills.add('Laravel');
    }

    if (python) {
      skills.add('Python');
    }

    return skills;
  }
  // TEXT FIELD WIDGET
  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required String? Function(String?) validator,
    TextInputType keyboardType =
        TextInputType.text,
    bool obscureText = false,
  }) {

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),

      child: TextFormField(
        controller: controller,

        keyboardType: keyboardType,

        obscureText: obscureText,

        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon),
        ),

        validator: validator,
      ),
    );
  }
  // RESULT CARD
  Widget buildSubmittedData() {

    if (!isSubmitted) {
      return const SizedBox();
    }

    List<String> skills = getSelectedSkills();

    return Card(
      margin: const EdgeInsets.only(top: 25),

      elevation: 4,

      child: Padding(
        padding: const EdgeInsets.all(18),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            const Text(
              'Registration Details',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const Divider(),

            buildInfoRow(
              'Name',
              nameController.text,
            ),

            buildInfoRow(
              'Email',
              emailController.text,
            ),

            buildInfoRow(
              'Phone',
              phoneController.text,
            ),

            buildInfoRow(
              'Gender',
              selectedGender!,
            ),

            buildInfoRow(
              'Age',
              age.round().toString(),
            ),

            buildInfoRow(
              'Skills',
              skills.join(', '),
            ),

            buildInfoRow(
              'Notifications',
              receiveNotifications
                  ? 'Enabled'
                  : 'Disabled',
            ),

            buildInfoRow(
              'Email Updates',
              emailUpdates
                  ? 'Enabled'
                  : 'Disabled',
            ),

            const SizedBox(height: 10),

            Container(
              width: double.infinity,

              padding: const EdgeInsets.all(12),

              decoration: BoxDecoration(
                color: Colors.green.shade100,

                borderRadius:
                    BorderRadius.circular(10),
              ),

              child: const Text(
                'Registration Successful!',
                textAlign: TextAlign.center,

                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  // INFORMATION ROW
  Widget buildInfoRow(
    String title,
    String value,
  ) {

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 6,
      ),

      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          SizedBox(
            width: 110,

            child: Text(
              '$title:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
  // BUILD
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      // APP BAR
      appBar: AppBar(
        title: const Text(
          'Student Registration',
        ),

        centerTitle: true,
      ),
      // BODY
      body: SafeArea(

        child: SingleChildScrollView(

          padding: const EdgeInsets.all(16),

          child: Form(
            key: _formKey,

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                // TITLE
                const Text(
                  'Create Student Account',

                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  'Please enter your information below.',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                  ),
                ),

                const SizedBox(height: 25),
                // NAME
                buildTextField(
                  controller: nameController,

                  label: 'Full Name',

                  hint: 'Enter your full name',

                  icon: Icons.person,

                  validator: (value) {

                    if (value == null ||
                        value.trim().isEmpty) {

                      return 'Please enter your name.';
                    }

                    if (value.trim().length < 3) {

                      return 'Name must contain at least 3 characters.';
                    }

                    return null;
                  },
                ),
                // EMAIL
                buildTextField(
                  controller: emailController,

                  label: 'Email',

                  hint: 'Enter your email',

                  icon: Icons.email,

                  keyboardType:
                      TextInputType.emailAddress,

                  validator: (value) {

                    if (value == null ||
                        value.trim().isEmpty) {

                      return 'Please enter your email.';
                    }

                    final emailRegex = RegExp(
                      r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                    );

                    if (!emailRegex.hasMatch(
                        value.trim())) {

                      return 'Please enter a valid email.';
                    }

                    return null;
                  },
                ),
                // PHONE
                buildTextField(
                  controller: phoneController,

                  label: 'Phone Number',

                  hint: 'Enter 10 digit phone number',

                  icon: Icons.phone,

                  keyboardType:
                      TextInputType.phone,

                  validator: (value) {

                    if (value == null ||
                        value.trim().isEmpty) {

                      return 'Please enter your phone number.';
                    }

                    if (!RegExp(
                      r'^[0-9]{10}$',
                    ).hasMatch(value.trim())) {

                      return 'Phone number must contain 10 digits.';
                    }

                    return null;
                  },
                ),
                // PASSWORD
                buildTextField(
                  controller: passwordController,

                  label: 'Password',

                  hint: 'Enter password',

                  icon: Icons.lock,

                  obscureText: true,

                  validator: (value) {

                    if (value == null ||
                        value.isEmpty) {

                      return 'Please enter a password.';
                    }

                    if (value.length < 6) {

                      return 'Password must contain at least 6 characters.';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 10),
                // GENDER
                const Text(
                  'Gender',

                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                RadioListTile<String>(
                  title: const Text('Male'),

                  value: 'Male',

                  groupValue: selectedGender,

                  onChanged: (value) {

                    setState(() {
                      selectedGender = value;
                    });
                  },
                ),

                RadioListTile<String>(
                  title: const Text('Female'),

                  value: 'Female',

                  groupValue: selectedGender,

                  onChanged: (value) {

                    setState(() {
                      selectedGender = value;
                    });
                  },
                ),

                RadioListTile<String>(
                  title: const Text('Other'),

                  value: 'Other',

                  groupValue: selectedGender,

                  onChanged: (value) {

                    setState(() {
                      selectedGender = value;
                    });
                  },
                ),

                const SizedBox(height: 10),
                // SKILLS
                const Text(
                  'Select Skills',

                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                CheckboxListTile(
                  title: const Text('Flutter'),

                  value: flutter,

                  onChanged: (value) {

                    setState(() {
                      flutter = value ?? false;
                    });
                  },
                ),

                CheckboxListTile(
                  title: const Text('Dart'),

                  value: dart,

                  onChanged: (value) {

                    setState(() {
                      dart = value ?? false;
                    });
                  },
                ),

                CheckboxListTile(
                  title: const Text('Laravel'),

                  value: laravel,

                  onChanged: (value) {

                    setState(() {
                      laravel = value ?? false;
                    });
                  },
                ),

                CheckboxListTile(
                  title: const Text('Python'),

                  value: python,

                  onChanged: (value) {

                    setState(() {
                      python = value ?? false;
                    });
                  },
                ),

                const SizedBox(height: 10),
                // AGE SLIDER
                const Text(
                  'Age',

                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Row(
                  children: [

                    const Icon(
                      Icons.cake,
                    ),

                    Expanded(
                      child: Slider(
                        value: age,

                        min: 15,

                        max: 60,

                        divisions: 45,

                        label: age.round().toString(),

                        onChanged: (value) {

                          setState(() {
                            age = value;
                          });
                        },
                      ),
                    ),

                    Text(
                      age.round().toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),
                // SWITCH 1
                SwitchListTile(
                  title: const Text(
                    'Receive Notifications',
                  ),

                  subtitle: const Text(
                    'Receive app notifications',
                  ),

                  value: receiveNotifications,

                  onChanged: (value) {

                    setState(() {
                      receiveNotifications = value;
                    });
                  },
                ),
                // SWITCH 2
                SwitchListTile(
                  title: const Text(
                    'Email Updates',
                  ),

                  subtitle: const Text(
                    'Receive updates through email',
                  ),

                  value: emailUpdates,

                  onChanged: (value) {

                    setState(() {
                      emailUpdates = value;
                    });
                  },
                ),

                const SizedBox(height: 20),
                // SUBMIT BUTTON
                SizedBox(
                  width: double.infinity,

                  height: 52,

                  child: ElevatedButton.icon(

                    onPressed: submitForm,

                    icon: const Icon(
                      Icons.app_registration,
                    ),

                    label: const Text(
                      'Register Student',

                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                  ),
                ),
                // SUBMITTED INFORMATION
                buildSubmittedData(),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
  // DISPOSE CONTROLLERS
  @override
  void dispose() {

    nameController.dispose();

    emailController.dispose();

    phoneController.dispose();

    passwordController.dispose();

    super.dispose();
  }
}