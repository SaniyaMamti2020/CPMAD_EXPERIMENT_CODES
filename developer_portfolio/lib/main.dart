import 'package:flutter/material.dart';

void main() {
  runApp(const DeveloperPortfolioApp());
}

// MAIN APPLICATION
class DeveloperPortfolioApp extends StatelessWidget {
  const DeveloperPortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Developer Portfolio',

      // Application Theme
      theme: ThemeData(
        useMaterial3: true,

        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),

        scaffoldBackgroundColor: Colors.grey.shade100,

        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),

        cardTheme: const CardThemeData(
          elevation: 3,
          margin: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
        ),

        textTheme: const TextTheme(
          headlineSmall: TextStyle(
            fontWeight: FontWeight.bold,
          ),
          titleLarge: TextStyle(
            fontWeight: FontWeight.bold,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
          ),
        ),
      ),

      home: const DeveloperProfileScreen(),
    );
  }
}

// DEVELOPER PROFILE SCREEN

class DeveloperProfileScreen extends StatelessWidget {
  const DeveloperProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // APP BAR
      appBar: AppBar(
        title: const Text(
          'Developer Portfolio',
        ),

        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),

      // SAFE AREA
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // PROFILE CARD
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),

                  child: Column(
                    children: [

                      // Profile Image
                      Container(
                        width: 120,
                        height: 120,

                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Theme.of(context)
                                .colorScheme
                                .primary,
                            width: 4,
                          ),
                        ),

                        child: ClipOval(
                          child: Image.network(
                            'https://www.bringitonline.in/uploads/2/2/4/5/22456530/female-modeling-portfolio-shoot-in-delhi-female-best-portfolio-photographers-in-delhi-4_orig.jpg',
                            fit: BoxFit.cover,

                            errorBuilder:
                                (context, error, stackTrace) {
                              return const Icon(
                                Icons.person,
                                size: 80,
                              );
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      Text(
                        'Saniya Mamti',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall,
                      ),

                      const SizedBox(height: 5),

                      Text(
                        'Flutter & Laravel Developer',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge,
                      ),

                      const SizedBox(height: 5),

                      Text(
                        'B.Tech Computer Science',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // ABOUT SECTION

              sectionTitle(
                context,
                'About Me',
              ),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),

                  child: Text(
                    'I am a passionate software developer interested '
                    'in building modern web and mobile applications. '
                    'I enjoy working with Flutter, Dart, Laravel, '
                    'PHP and databases.',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge,
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // SKILLS
              sectionTitle(
                context,
                'Skills',
              ),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),

                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,

                    children: const [
                      SkillWidget(
                        icon: Icons.phone_android,
                        skill: 'Flutter',
                      ),

                      SkillWidget(
                        icon: Icons.code,
                        skill: 'Dart',
                      ),

                      SkillWidget(
                        icon: Icons.web,
                        skill: 'Laravel',
                      ),

                      SkillWidget(
                        icon: Icons.storage,
                        skill: 'MySQL',
                      ),

                      SkillWidget(
                        icon: Icons.api,
                        skill: 'REST API',
                      ),

                      SkillWidget(
                        icon: Icons.cloud,
                        skill: 'Firebase',
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // EDUCATION
              sectionTitle(
                context,
                'Qualification',
              ),

              Card(
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(
                      Icons.school,
                    ),
                  ),

                  title: const Text(
                    'Bachelor of Technology',
                  ),

                  subtitle: const Text(
                    'Computer Science & Engineering',
                  ),

                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // CONTACT INFORMATION
              sectionTitle(
                context,
                'Contact Information',
              ),

              const ContactWidget(
                icon: Icons.email,
                title: 'Email',
                value: 'developer@example.com',
              ),

              const ContactWidget(
                icon: Icons.phone,
                title: 'Phone',
                value: '+91 98765 43210',
              ),

              const ContactWidget(
                icon: Icons.location_on,
                title: 'Location',
                value: 'Gujarat, India',
              ),

              const ContactWidget(
                icon: Icons.link,
                title: 'Portfolio',
                value: 'www.example.com',
              ),

              const SizedBox(height: 15),

              // PROJECTS
              sectionTitle(
                context,
                'Projects',
              ),

              Row(
                children: [

                  // Expanded
                  Expanded(
                    child: ProjectCard(
                      icon: Icons.shopping_cart,
                      title: 'E-Commerce',
                      description:
                          'Flutter shopping application',
                    ),
                  ),

                  const SizedBox(width: 10),

                  // Expanded
                  Expanded(
                    child: ProjectCard(
                      icon: Icons.dashboard,
                      title: 'CRM',
                      description:
                          'Laravel CRM application',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              // RESPONSIVE ROW USING FLEXIBLE

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),

                  child: Row(
                    children: [

                      const Icon(
                        Icons.developer_mode,
                        size: 40,
                      ),

                      const SizedBox(width: 15),

                      // Flexible allows text to shrink
                      // instead of causing overflow.
                      const Flexible(
                        child: Text(
                          'Available for software development '
                          'projects and collaboration.',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // CONTACT BUTTON
              SizedBox(
                width: double.infinity,
                height: 50,

                child: ElevatedButton.icon(
                  onPressed: () {},

                  icon: const Icon(
                    Icons.mail_outline,
                  ),

                  label: const Text(
                    'Contact Me',
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// SECTION TITLE — REUSABLE WIDGET
Widget sectionTitle(
  BuildContext context,
  String title,
) {
  return Padding(
    padding: const EdgeInsets.only(
      left: 4,
      bottom: 5,
    ),

    child: Text(
      title,
      style: Theme.of(context)
          .textTheme
          .titleLarge,
    ),
  );
}

// SKILL WIDGET — REUSABLE WIDGET
class SkillWidget extends StatelessWidget {
  final IconData icon;
  final String skill;

  const SkillWidget({
    super.key,
    required this.icon,
    required this.skill,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),

      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .primaryContainer,

        borderRadius: BorderRadius.circular(20),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,

        children: [
          Icon(
            icon,
            size: 18,
          ),

          const SizedBox(width: 6),

          Text(
            skill,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// CONTACT WIDGET — REUSABLE WIDGET
class ContactWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const ContactWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context)
              .colorScheme
              .primaryContainer,

          child: Icon(
            icon,
          ),
        ),

        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        subtitle: Text(
          value,
        ),
      ),
    );
  }
}

// PROJECT CARD — REUSABLE WIDGET
class ProjectCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const ProjectCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,

      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

            Icon(
              icon,
              size: 40,
              color: Theme.of(context)
                  .colorScheme
                  .primary,
            ),

            const SizedBox(height: 10),

            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              description,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}