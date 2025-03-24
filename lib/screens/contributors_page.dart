import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContributorsPage extends StatefulWidget {
  const ContributorsPage({super.key});

  @override
  State<ContributorsPage> createState() => _ContributorsPageState();
}

class _ContributorsPageState extends State<ContributorsPage> {
  Set<String> expandedCards = {};

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final secondaryColor = Theme.of(context).colorScheme.secondary;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Meet Our Team',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        centerTitle: true,
        leading: null,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [primaryColor, secondaryColor],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildContributorCard(
                  context,
                  'Shorya Kumar',
                  'IIIT Naya Raipur',
                  'Designed the user interface and experience of the application.',
                  'assets/profile/shorya.JPEG',
                  ['Flutter', 'UI/UX', 'TensorFlow'],
                  'https://github.com/shoryakumar',
                  'https://linkedin.com/in/shorya-kumar',
                ),
                const SizedBox(height: 20),
                _buildContributorCard(
                  context,
                  'Amritanshu Yadav',
                  'IIIT Naya Raipur',
                  'Worked on optimizing machine learning models and enhancing the accuracy of cataract detection.',
                  'assets/profile/amritanshu.jpeg',
                  ['Machine Learning', 'Computer Vision', 'TensorFlow'],
                  'https://github.com/TechNxt05',
                  'https://www.linkedin.com/in/amritanshu-yadav-6480662a8/',
                ),
                const SizedBox(height: 20),
                _buildContributorCard(
                  context,
                  'Shashwati Bhattacharya',
                  'IIIT Naya Raipur',
                  'Focused on machine learning model optimization and training.',
                  'assets/profile/shashwati.JPG',
                  ['Machine Learning', 'Model Training', 'TensorFlow'],
                  'https://github.com/shashbha14',
                  'https://www.linkedin.com/in/shashwati-bhattacharya-197589269?utm_source=share&utm_campaign=share_via&utm_content=profile&utm_medium=android_app',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContributorCard(
    BuildContext context,
    String name,
    String role,
    String description,
    String imagePath,
    List<String> skills,
    String githubUrl,
    String linkedinUrl,
  ) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final isExpanded = expandedCards.contains(name);

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isExpanded) {
            expandedCards.remove(name);
          } else {
            expandedCards.add(name);
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(0.1),
              blurRadius: 20,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Hero(
                  tag: name,
                  child: GestureDetector(
                    onTap: () => _showExpandedImage(context, imagePath, name),
                    child: Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withOpacity(0.2),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 40,
                        backgroundImage: AssetImage(imagePath),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        role,
                        style: TextStyle(
                          fontSize: 16,
                          color: primaryColor.withOpacity(0.8),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          IconButton(
                            icon: Image.asset(
                              'assets/images/github.png',
                              width: 24,
                              height: 24,
                            ),
                            onPressed: () => _launchUrl(githubUrl),
                            color: primaryColor,
                          ),
                          IconButton(
                            icon: Image.asset(
                              'assets/images/linkedin.png',
                              width: 24,
                              height: 24,
                            ),
                            onPressed: () => _launchUrl(linkedinUrl),
                            color: primaryColor,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (isExpanded) ...[
              const SizedBox(height: 20),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 15),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: skills
                    .map((skill) => _buildSkillChip(context, skill))
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSkillChip(BuildContext context, String skill) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: primaryColor.withOpacity(0.3)),
      ),
      child: Text(
        skill,
        style: TextStyle(
          color: primaryColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void _showExpandedImage(BuildContext context, String imagePath, String name) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Hero(
          tag: name,
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }
}
