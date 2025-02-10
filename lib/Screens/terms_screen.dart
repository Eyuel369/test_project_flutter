import 'package:flutter/material.dart';
import 'success_screen.dart';
import '../services/api_service.dart'; // Import the API service file

class TermsScreen extends StatefulWidget {
  final String phoneNumber;
  const TermsScreen({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  _TermsScreenState createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen> {
  bool _isLoading = false;

  // Instantiate ApiService
  final ApiService _apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const Text(
                'Terms And\nConditions',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTermItem(
                        number: '1',
                        title: 'User Agreement:',
                        content:
                            'You agree to use this application responsibly and ethically.',
                      ),
                      _buildTermItem(
                        number: '2',
                        title: 'Data Privacy:',
                        content:
                            'We will protect your personal information in accordance with applicable data protection laws.',
                      ),
                      _buildTermItem(
                        number: '3',
                        title: 'Service Changes:',
                        content:
                            'We reserve the right to modify or discontinue any service without notice.',
                      ),
                      _buildTermItem(
                        number: '4',
                        title: 'Disclaimer of Warranties:',
                        content:
                            'We make no warranties, expressed or implied, regarding the application or its services.',
                      ),
                      _buildTermItem(
                        number: '5',
                        title: 'Limitation of Liability:',
                        content:
                            'We shall not be liable for any damages arising from the use or inability to use this application.',
                      ),
                      _buildTermItem(
                        number: '6',
                        title: 'Governing Law:',
                        content:
                            'These terms and conditions shall be governed by and construed in accordance with the laws of [Jurisdiction].',
                      ),
                      _buildTermItem(
                        number: '7',
                        title: 'User Conduct:',
                        content:
                            'You agree not to use the application for any unlawful or unauthorized purpose. This includes, but is not limited to, hacking, scamming, or attempting to gain unauthorized access to any data, systems, or networks, transmitting viruses or other malicious software, interfering with the proper functioning of the application or any related services, using the application for any illegal or harmful purposes, including but not limited to, fraud, harassment, or the distribution of illegal content.',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleAgreeToTerms,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 49, 96, 167),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Finish',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTermItem({
    required String number,
    required String title,
    required String content,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
            height: 1.5,
          ),
          children: [
            TextSpan(
              text: '$number. ',
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
            TextSpan(
              text: '$title ',
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
            TextSpan(
              text: content,
              style: const TextStyle(
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleAgreeToTerms() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _apiService.agreeToTerms(widget.phoneNumber);
      print(response);
      // If we reach here, the request was successful
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SuccessScreen()),
      );
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to agree to terms: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
