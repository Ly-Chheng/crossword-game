import 'package:flutter/material.dart';

class TermsOfUse extends StatefulWidget {
  const TermsOfUse({super.key});

  @override
  State<TermsOfUse> createState() => _TermsOfUseState();
}

class _TermsOfUseState extends State<TermsOfUse> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: PreferredSize(
      //   preferredSize: Size.fromHeight(70),
      //   child: AppBar(
      //     title: Text(
      //       "Terms of Use",
      //       style: TextStyle(
      //         fontSize: 20,
      //         fontWeight: FontWeight.bold,
      //         color: Colors.purple,
      //       ),
      //     ),
      //     centerTitle: true,
      //     elevation: 0,
      //     iconTheme: IconThemeData(color: Colors.purple),
      //     flexibleSpace: Container(
      //       decoration: BoxDecoration(
      //         gradient: LinearGradient(
      //           begin: Alignment.topRight,
      //           end: Alignment.bottomRight,
      //           colors: [
      //             Color(0xFFFDEA9F),
      //             Color(0XFFF3D988),
      //           ],
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
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
                            "Terms of Use",
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
                    "Welcome to BETEI KIDS GAME",
                    "These Terms of Use govern your use of the BETEI KIDS GAME mobile application. By downloading, installing, or using our app, you agree to be bound by these terms. If you do not agree to these terms, please do not use the app.",
                  ),
                  _buildSection(
                    "About BETEI KIDS GAME",
                    "BETEI KIDS GAME is an educational mobile application designed to provide safe, fun, and educational content for children. Our app offers various learning games and activities to support child development and learning.",
                  ),
                  _buildSection(
                    "Age Requirements",
                    "BETEI KIDS GAME is intended for children under parental supervision. We recommend that:\n\n"
                        "• Children under 13 should use the app with parental guidance\n"
                        "• Parents should review the app content before allowing their children to play\n"
                        "• Parents are responsible for monitoring their child's app usage\n"
                        "• Account creation or registration is not required",
                  ),
                  _buildSection(
                    "Permitted Use",
                    "You may use BETEI KIDS GAME for:\n\n"
                        "• Educational and entertainment purposes\n"
                        "• Personal, non-commercial use\n"
                        "• Learning and skill development activities\n"
                        "• Family entertainment and bonding\n\n"
                        "The app is designed to be used offline and does not require internet connection for core functionality.",
                  ),
                  _buildSection(
                    "Prohibited Activities",
                    "You may not:\n\n"
                        "• Reverse engineer, decompile, or disassemble the app\n"
                        "• Remove or modify any copyright notices\n"
                        "• Use the app for commercial purposes without permission\n"
                        "• Attempt to hack or compromise the app's security\n"
                        "• Share or distribute the app files illegally\n"
                        "• Use the app in any way that violates applicable laws",
                  ),
                  _buildSection(
                    "Intellectual Property",
                    "All content in BETEI KIDS GAME, including but not limited to:\n\n"
                        "• Graphics, images, and animations\n"
                        "• Audio, music, and sound effects\n"
                        "• Educational content and games\n"
                        "• Software code and design\n"
                        "• Trademarks and logos\n\n"
                        "Are the exclusive property of BETEI KIDS GAME or our licensors and are protected by copyright and other intellectual property laws.",
                  ),
                  _buildSection(
                    "Parental Responsibility",
                    "Parents and guardians are responsible for:\n\n"
                        "• Supervising their child's use of the app\n"
                        "• Ensuring appropriate screen time limits\n"
                        "• Reviewing and approving app content\n"
                        "• Managing device settings and restrictions\n"
                        "• Monitoring their child's learning progress\n"
                        "• Reporting any concerns or issues to us",
                  ),
                  _buildSection(
                    "Privacy and Data Protection",
                    "Your privacy is important to us. Our data practices are governed by our Privacy Policy, which is incorporated into these Terms of Use. We are committed to protecting children's privacy and complying with applicable privacy laws including COPPA.",
                  ),
                  _buildSection(
                    "App Updates and Changes",
                    "We may update BETEI KIDS GAME from time to time to:\n\n"
                        "• Add new educational content and games\n"
                        "• Improve app performance and security\n"
                        "• Fix bugs and technical issues\n"
                        "• Enhance user experience\n\n"
                        "Updates will be provided through your device's app store. Continued use of the app after updates constitutes acceptance of any changes.",
                  ),
                  _buildSection(
                    "Disclaimer of Warranties",
                    "BETEI KIDS GAME is provided 'as is' without warranties of any kind. While we strive to provide a safe and educational experience, we cannot guarantee:\n\n"
                        "• Uninterrupted or error-free operation\n"
                        "• Compatibility with all devices\n"
                        "• Specific educational outcomes\n"
                        "• Availability at all times",
                  ),
                  _buildSection(
                    "Limitation of Liability",
                    "To the maximum extent permitted by law, we shall not be liable for any indirect, incidental, special, or consequential damages arising from your use of BETEI KIDS GAME. Our total liability shall not exceed the amount paid for the app, if any.",
                  ),
                  _buildSection(
                    "Termination",
                    "These terms remain in effect until terminated. You may terminate your use of the app at any time by uninstalling it from your device. We may terminate or suspend access to the app for violations of these terms or for any other reason.",
                  ),
                  _buildSection(
                    "Educational Content Disclaimer",
                    "While BETEI KIDS GAME is designed to be educational, it is intended to supplement, not replace, traditional learning methods. Parents should use their discretion regarding their child's educational needs and may wish to consult with educators or child development specialists.",
                  ),
                  _buildSection(
                    "Changes to Terms",
                    "We may update these Terms of Use from time to time. When we do, we will post the updated terms in the app and update the 'Last updated' date. Your continued use of the app after changes constitutes acceptance of the new terms.",
                  ),
                  _buildSection(
                    "Contact Information",
                    "If you have any questions about these Terms of Use or BETEI KIDS GAME, please contact us at:\n\n"
                        "Email: support@beteikids.com\n"
                        "Terms Questions: legal@beteikids.com\n"
                        "Website: www.beteikids.com\n\n"
                        "For terms-related inquiries, please include 'Terms of Use' in your subject line.",
                  ),
                  _buildSection(
                    "Governing Law",
                    "These Terms of Use are governed by and construed in accordance with applicable laws. Any disputes arising from these terms or your use of the app will be resolved through appropriate legal channels.",
                  ),
                  Text(
                    "Thank you for choosing BETEI KIDS GAME for your child's educational journey!",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.purple,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
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
