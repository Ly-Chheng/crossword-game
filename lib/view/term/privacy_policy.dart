import 'package:flutter/material.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({super.key});

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFFDEA9F),
                  Color(0XFFF3D988),
                ],
              ),
            ),
            child: SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    children: [
                       IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.purple,
                        size: 24,
                      ),
                    ),
                      Expanded(
                        child: Center(
                          child: Text(
                            "Privacy Policy",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.purple,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Last updated: ${DateTime.now().toString().split(' ')[0]}",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  SizedBox(height: 20),
                  
                  _buildSection(
                    "Introduction",
                    "This Privacy Policy describes how BETEI KIDS GAME collects, uses, and protects your child's information when using our educational mobile application. We are committed to protecting children's privacy and complying with applicable privacy laws including COPPA (Children's Online Privacy Protection Act).",
                  ),
                  
                  _buildSection(
                    "Information We Collect",
                    "BETEI KIDS GAME is designed to be safe for children. We collect minimal information:\n\n"
                    "• Game Progress: Educational progress, levels completed, and learning achievements (stored locally on device)\n"
                    "• Usage Data: Which games are played and time spent (for educational improvement purposes)\n"
                    "• Device Information: Device type and operating system (for technical support)\n"
                    "• Parental Contact: Email address (only if parent provides it for updates)\n\n"
                    "We do NOT collect:\n"
                    "• Personal names or photos\n"
                    "• Location data\n"
                    "• Contact lists\n"
                    "• Any personally identifiable information from children",
                  ),
                  
                  _buildSection(
                    "How We Use Your Information",
                    "We use the collected information solely for:\n\n"
                    "• Providing educational games and activities\n"
                    "• Tracking learning progress to adapt difficulty levels\n"
                    "• Improving our educational content and games\n"
                    "• Technical support and app functionality\n"
                    "• Sending educational tips to parents (only if email provided)\n\n"
                    "We never use children's information for advertising or marketing purposes.",
                  ),
                  
                  _buildSection(
                    "Data Sharing and Disclosure",
                    "We do not sell, trade, or rent your personal information to third parties. We may share your information only in the following circumstances:\n\n"
                    "• With your explicit consent\n"
                    "• To comply with legal obligations\n"
                    "• To protect our rights and safety\n"
                    "• With trusted service providers who assist in app operations (bound by confidentiality agreements)",
                  ),
                  
                  _buildSection(
                    "Data Security",
                    "We implement strict security measures to protect any information collected:\n\n"
                    "• All game progress is stored locally on your device\n"
                    "• No sensitive data is transmitted to external servers\n"
                    "• The app works offline without internet connection\n"
                    "• Regular security updates and testing\n"
                    "• No data sharing with third parties",
                  ),
                  
                  _buildSection(
                    "Data Retention",
                    "We retain your personal information only as long as necessary to fulfill the purposes outlined in this Privacy Policy, unless a longer retention period is required by law.",
                  ),
                  
                  _buildSection(
                    "Parental Rights",
                    "As a parent or guardian, you have the right to:\n\n"
                    "• Review any information collected about your child\n"
                    "• Request deletion of your child's information\n"
                    "• Refuse further collection of your child's information\n"
                    "• Delete all app data by uninstalling BETEI KIDS GAME\n"
                    "• Contact us with any privacy concerns\n\n"
                    "Since most data is stored locally, you have full control over your child's information.",
                  ),
                  
                  _buildSection(
                    "Third-Party Services",
                    "Our app may contain links to third-party websites or services. We are not responsible for the privacy practices of these third parties. We encourage you to review their privacy policies.",
                  ),
                  
                  _buildSection(
                    "Children's Privacy (COPPA Compliance)",
                    "BETEI KIDS GAME is designed for children and complies with COPPA requirements:\n\n"
                    "• We do not knowingly collect personal information from children under 13\n"
                    "• No registration or account creation is required\n"
                    "• All game data is stored locally on the device\n"
                    "• No social features or communication with other users\n"
                    "• No third-party advertising or data collection\n"
                    "• Parents can delete all app data by uninstalling the app\n\n"
                    "If you believe we have inadvertently collected information from a child, please contact us immediately.",
                  ),
                  
                  _buildSection(
                    "Changes to This Privacy Policy",
                    "We may update this Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page and updating the \"Last updated\" date.",
                  ),
                  
                  _buildSection(
                    "Contact Us",
                    "If you have any questions about this Privacy Policy or BETEI KIDS GAME, please contact us at:\n\n"
                    "Email: privacy@beteikids.com\n"
                    "Support: support@beteikids.com\n"
                    "Website: www.beteikids.com\n\n"
                    "For privacy-related concerns, please include 'Privacy Policy' in your subject line.",
                  ),
                  
                  SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.purple,
            ),
          ),
          SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black87,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}