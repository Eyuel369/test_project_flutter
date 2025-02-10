import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'register_screen.dart';
import '../services/api_service.dart';

class OTPScreen extends StatefulWidget {
  final String phoneNumber;
  const OTPScreen({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final List<TextEditingController> _otpControllers =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  bool _isLoading = false;
  final ApiService _apiService = ApiService();

  @override
  void dispose() {
    for (final controller in _otpControllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  Future<void> _validateAndVerifyOtp() async {
    String otp = _otpControllers.map((controller) => controller.text).join();

    if (otp.length != 4) {
      Fluttertoast.showToast(
        msg: 'Please enter a valid 4-digit OTP',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _apiService.verifyOtp(widget.phoneNumber, otp);
      if (response['message'] == "OTP verified successfully") {
        Fluttertoast.showToast(
          msg: "OTP verified successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
        );
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  RegisterScreen(phoneNumber: widget.phoneNumber),
            ),
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: "Invalid OTP: ${response['message']}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "An error occurred: $e",
        toastLength: Toast.LENGTH_SHORT,
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
                  'OTP',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 34),
                const Text(
                  'Please enter the OTP sent to your',
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'mobile number ${widget.phoneNumber}',
                  style: const TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    4,
                    (index) => SizedBox(
                      width: 60,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextFormField(
                          controller: _otpControllers[index],
                          focusNode: _focusNodes[index],
                          obscureText: true,
                          obscuringCharacter: '*',
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          maxLength: 1,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: const InputDecoration(
                            counterText: "",
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            if (value.isNotEmpty && index < 3) {
                              FocusScope.of(context)
                                  .requestFocus(_focusNodes[index + 1]);
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 36),
                const Text(
                  'Didn\'t receive an OTP?',
                  style: TextStyle(color: Colors.grey),
                ),
                TextButton(
                  onPressed: () {
                    Fluttertoast.showToast(
                      msg: 'Resend OTP functionality not implemented yet',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.TOP,
                    );
                  },
                  child: const Text('Resend OTP'),
                ),
                const SizedBox(height: 100),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _validateAndVerifyOtp,
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
}
