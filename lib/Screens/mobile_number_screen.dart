import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'otp_screen.dart';
import '../services/api_service.dart';

class MobileNumberScreen extends StatefulWidget {
  const MobileNumberScreen({Key? key}) : super(key: key);

  @override
  _MobileNumberScreenState createState() => _MobileNumberScreenState();
}

class _MobileNumberScreenState extends State<MobileNumberScreen> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  void _validateAndRegister() async {
    String phoneNumber = _phoneNumberController.text.trim();

    if (!phoneNumber.startsWith('+') || phoneNumber.length != 13) {
      Fluttertoast.showToast(
        msg:
            "Phone number must start with '+' and be exactly 13 characters long",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _apiService.registerUser(phoneNumber);

      print("Response from API: $response"); // Debugging log

      if (response['message'] == "User registered successfully") {
        Fluttertoast.showToast(
          msg: "OTP sent successfully. Please check your phone.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OTPScreen(phoneNumber: phoneNumber),
          ),
        );
      } else {
        Fluttertoast.showToast(
          msg: "Failed to register user: ${response['message']}",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "An error occurred: $e",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
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
                  'Mobile Number',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 34),
                const Text(
                  'We need to send OTP to authenticate',
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const Text(
                  'your number to change your pin',
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 80),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 40.0),
                    child: const Text(
                      'Mobile Number',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: TextFormField(
                    controller: _phoneNumberController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(13),
                    ],
                    decoration: const InputDecoration(
                      hintText: '+251 90 201 0946',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(height: 100),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _validateAndRegister,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 49, 96, 167),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text('Next'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();
    super.dispose();
  }
}
