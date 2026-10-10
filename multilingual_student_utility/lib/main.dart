import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Get saved language
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String savedLanguage = prefs.getString('language') ?? 'en';

  runApp(
    StudentApp(
      savedLanguage: savedLanguage,
    ),
  );
}

class StudentApp extends StatefulWidget {
  final String savedLanguage;

  const StudentApp({
    super.key,
    required this.savedLanguage,
  });

  @override
  State<StudentApp> createState() => _StudentAppState();
}

class _StudentAppState extends State<StudentApp> {
  late Locale selectedLocale;

  @override
  void initState() {
    super.initState();

    selectedLocale = Locale(widget.savedLanguage);
  }

  // Change language
  void changeLanguage(String language) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Save language
    await prefs.setString('language', language);

    setState(() {
      selectedLocale = Locale(language);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Student Information',

      // Current language
      locale: selectedLocale,

      // Supported languages
      supportedLocales: const [
        Locale('en'),
        Locale('gu'),
        Locale('hi'),
      ],

      // Flutter localization
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      home: StudentHomePage(
        selectedLanguage: selectedLocale.languageCode,
        onLanguageChanged: changeLanguage,
      ),
    );
  }
}

// --------------------------------------------------
// STUDENT HOME PAGE
// --------------------------------------------------

class StudentHomePage extends StatelessWidget {
  final String selectedLanguage;
  final Function(String) onLanguageChanged;

  const StudentHomePage({
    super.key,
    required this.selectedLanguage,
    required this.onLanguageChanged,
  });

  // TRANSLATIONS

  String text(String key) {
    Map<String, Map<String, String>> translations = {
      'title': {
        'en': 'Student Information',
        'gu': 'વિદ્યાર્થી માહિતી',
        'hi': 'छात्र जानकारी',
      },
      'student_name': {
        'en': 'Student Name',
        'gu': 'વિદ્યાર્થીનું નામ',
        'hi': 'छात्र का नाम',
      },
      'roll_number': {
        'en': 'Roll Number',
        'gu': 'રોલ નંબર',
        'hi': 'रोल नंबर',
      },
      'course': {
        'en': 'Course',
        'gu': 'અભ્યાસક્રમ',
        'hi': 'पाठ्यक्रम',
      },
      'semester': {
        'en': 'Semester',
        'gu': 'સેમેસ્ટર',
        'hi': 'सेमेस्टर',
      },
      'date': {
        'en': 'Date',
        'gu': 'તારીખ',
        'hi': 'दिनांक',
      },
      'marks': {
        'en': 'Marks',
        'gu': 'ગુણ',
        'hi': 'अंक',
      },
      'language': {
        'en': 'Select Language',
        'gu': 'ભાષા પસંદ કરો',
        'hi': 'भाषा चुनें',
      },
      'welcome': {
        'en': 'Welcome Student!',
        'gu': 'વિદ્યાર્થીનું સ્વાગત છે!',
        'hi': 'स्वागत है छात्र!',
      },
      'english': {
        'en': 'English',
        'gu': 'અંગ્રેજી',
        'hi': 'अंग्रेज़ी',
      },
      'gujarati': {
        'en': 'Gujarati',
        'gu': 'ગુજરાતી',
        'hi': 'गुजराती',
      },
      'hindi': {
        'en': 'Hindi',
        'gu': 'હિન્દી',
        'hi': 'हिंदी',
      },
    };

    return translations[key]?[selectedLanguage] ?? key;
  }

  // DATE FORMATTING

  String getFormattedDate() {
    DateTime currentDate = DateTime.now();

    Locale locale;

    if (selectedLanguage == 'gu') {
      locale = const Locale('gu');
    } else if (selectedLanguage == 'hi') {
      locale = const Locale('hi');
    } else {
      locale = const Locale('en');
    }

    return DateFormat.yMMMMd(
      locale.toLanguageTag(),
    ).format(currentDate);
  }

  // NUMBER FORMATTING

  String getFormattedNumber() {
    double marks = 85.50;

    Locale locale;

    if (selectedLanguage == 'gu') {
      locale = const Locale('gu');
    } else if (selectedLanguage == 'hi') {
      locale = const Locale('hi');
    } else {
      locale = const Locale('en');
    }

    return NumberFormat.decimalPattern(
      locale.toLanguageTag(),
    ).format(marks);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(text('title')),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            // Welcome message
            Center(
              child: Text(
                text('welcome'),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 30),

        
            // LANGUAGE DROPDOWN
        

            Text(
              text('language'),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            DropdownButtonFormField<String>(
              value: selectedLanguage,

              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),

              items: const [
                DropdownMenuItem(
                  value: 'en',
                  child: Text('English'),
                ),
                DropdownMenuItem(
                  value: 'gu',
                  child: Text('ગુજરાતી'),
                ),
                DropdownMenuItem(
                  value: 'hi',
                  child: Text('हिंदी'),
                ),
              ],

              onChanged: (value) {
                if (value != null) {
                  onLanguageChanged(value);
                }
              },
            ),

            const SizedBox(height: 30),

        
            // STUDENT INFORMATION
        

            buildInfo(
              Icons.person,
              text('student_name'),
              'Saniya Mamti',
            ),

            buildInfo(
              Icons.confirmation_number,
              text('roll_number'),
              '16',
            ),

            buildInfo(
              Icons.school,
              text('course'),
              'B.Tech ICT',
            ),

            buildInfo(
              Icons.book,
              text('semester'),
              '5',
            ),

            buildInfo(
              Icons.calendar_month,
              text('date'),
              getFormattedDate(),
            ),

            buildInfo(
              Icons.star,
              text('marks'),
              getFormattedNumber(),
            ),
          ],
        ),
      ),
    );
  }

  // STUDENT INFO WIDGET

  Widget buildInfo(
    IconData icon,
    String label,
    String value,
  ) {
    return Card(
      child: ListTile(
        leading: Icon(icon),

        title: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        subtitle: Text(
          value,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}