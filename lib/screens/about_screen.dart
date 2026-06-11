import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  Future<void> _launchURL(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open $url')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.info_outline, size: 20),
            SizedBox(width: 8),
            Text('About'),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // App Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFE65100), Color(0xFFFF8F00)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: Colors.white.withOpacity(0.5), width: 2),
                    ),
                    child: const Icon(Icons.electric_bolt,
                        color: Colors.amber, size: 44),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'E-Bill Estimator',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Monthly Electricity Bill Calculator',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Version 1.0.0',
                    style: TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Developer Info
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.person, color: Color(0xFFE65100)),
                        SizedBox(width: 8),
                        Text(
                          'Developer Information',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFE65100),
                          ),
                        ),
                      ],
                    ),
                    const Divider(color: Color(0xFFFFCC80)),
                    const SizedBox(height: 8),

                    // Profile Picture Placeholder
                    Center(
  child: Container(
    width: 90,
    height: 90,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(
        color: const Color(0xFFe65100),
        width: 3,
      ),
      image: const DecorationImage(
        image: AssetImage('assets/images/profile.jpg'),
        fit: BoxFit.cover,
      ),
    ),
  ),
),
const SizedBox(height: 16),

                    _infoRow(Icons.badge, 'Full Name', 'Kizhe Othman Hama Salih'),
                    _infoRow(Icons.numbers, 'Student ID', 'QIU23-0423'),
                    _infoRow(Icons.school, 'Course Code', 'ICT602'),
                    _infoRow(
                        Icons.menu_book, 'Course Name', 'Mobile Technology'),
                    const SizedBox(height: 10),
                    const Center(
                      child: Text(
                        '© 2026 Kizhe Othman. All Rights Reserved.',
                        style:
                            TextStyle(fontSize: 12, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // GitHub URL
                    InkWell(
                      onTap: () => _launchURL(
                          context, 'https://github.com/KizheOthman/ebill-estimator'),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF3E0),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: const Color(0xFFFFCC80), width: 1.5),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.link,
                                color: Color(0xFFE65100), size: 20),
                            SizedBox(width: 8),
                            Text(
                              'View on GitHub',
                              style: TextStyle(
                                color: Color(0xFFE65100),
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // How to Use
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.help_outline, color: Color(0xFFE65100)),
                        SizedBox(width: 8),
                        Text(
                          'How to Use',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFE65100),
                          ),
                        ),
                      ],
                    ),
                    const Divider(color: Color(0xFFFFCC80)),
                    const SizedBox(height: 8),
                    _instructionStep('1', 'Select Month',
                        'Choose the billing month from the dropdown on the home screen.'),
                    _instructionStep('2', 'Enter Units',
                        'Enter your electricity consumption in kWh (1–1000).'),
                    _instructionStep('3', 'Set Rebate',
                        'Use the slider to select a rebate percentage between 0% and 5%.'),
                    _instructionStep('4', 'Calculate',
                        'Tap "Calculate" to compute total charges and final cost after rebate.'),
                    _instructionStep('5', 'Save Record',
                        'Tap "Save Record" to store the result in the local database.'),
                    _instructionStep('6', 'View History',
                        'Tap the history icon in the top bar to view all saved records.'),
                    _instructionStep('7', 'Edit / Delete',
                        'Tap any record in the history list to view details, edit, or delete it.'),

                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF3E0),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: const Color(0xFFFFCC80), width: 1.5),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.info, color: Color(0xFFE65100), size: 18),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Rates are charged in Malaysian sen per kWh based on Tenaga Nasional Berhad (TNB) block rate structure.',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.black87),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFE65100), size: 18),
          const SizedBox(width: 10),
          SizedBox(
            width: 110,
            child: Text(label,
                style:
                    const TextStyle(fontSize: 13, color: Colors.grey)),
          ),
          Expanded(
            child: Text(value,
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _instructionStep(
      String step, String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              color: Color(0xFFE65100),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(step,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Color(0xFF5D4037))),
                const SizedBox(height: 2),
                Text(description,
                    style: const TextStyle(
                        fontSize: 13, color: Colors.black87)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}