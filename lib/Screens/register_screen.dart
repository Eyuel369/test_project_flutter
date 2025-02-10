import 'package:flutter/material.dart';
import 'pin_code_screen.dart';
import '../services/api_service.dart'; // Import the API service file

class RegisterScreen extends StatefulWidget {
  final String phoneNumber; // Add phoneNumber as a required parameter
  const RegisterScreen({super.key, required this.phoneNumber});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  bool _isLoading = false; // To handle loading state

  // Instantiate ApiService
  final ApiService _apiService = ApiService();

  Future<void> _registerUser(BuildContext context) async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });

    try {
      final String firstName = _firstNameController.text.trim();
      final String lastName = _lastNameController.text.trim();

      if (firstName.isEmpty || lastName.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Please enter both first and last name')),
        );
        return;
      }

      // Call the registerUserInfo method from api_service
      final response = await _apiService.registerUserInfo(
        widget.phoneNumber,
        firstName,
        lastName,
      );

      print(response);

      // If successful, navigate to PinCodeScreen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PinCodeScreen(phoneNumber: widget.phoneNumber),
        ),
      );
    } catch (e) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 100),
                  const CircleAvatar(
                    backgroundColor: Color(0xFF000080),
                    radius: 40,
                  ),
                  const SizedBox(height: 34),
                  const Text(
                    'Register',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 34),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 40.0),
                      child: const Text(
                        'First Name',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: TextFormField(
                      controller: _firstNameController,
                      decoration: const InputDecoration(
                        hintText: 'First',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 26),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 40.0),
                      child: const Text(
                        'Last Name',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: TextFormField(
                      controller: _lastNameController,
                      decoration: const InputDecoration(
                        hintText: 'Last',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 100),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: ElevatedButton(
                      onPressed: _isLoading
                          ? null // Disable button while loading
                          : () => _registerUser(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 49, 96, 167),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text('Next'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }
}
