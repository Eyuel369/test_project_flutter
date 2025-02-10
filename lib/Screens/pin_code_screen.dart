import 'package:flutter/material.dart';
import '../services/api_service.dart'; // Import the ApiService file
import 'terms_screen.dart';

class PinCodeScreen extends StatefulWidget {
  final String phoneNumber; // Add phoneNumber as a required parameter
  const PinCodeScreen({super.key, required this.phoneNumber});

  @override
  State<PinCodeScreen> createState() => _PinCodeScreenState();
}

class _PinCodeScreenState extends State<PinCodeScreen> {
  final List<TextEditingController> _pinControllers =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _pinFocusNodes = List.generate(4, (_) => FocusNode());
  final List<TextEditingController> _confirmPinControllers =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _confirmPinFocusNodes =
      List.generate(4, (_) => FocusNode());

  bool _pinsMatch = false; // Track if PINs match
  bool _allFieldsFilled = false; // Track if all fields are filled
  bool _isLoading = false; // To handle loading state

  // Instantiate ApiService
  final ApiService _apiService = ApiService();

  @override
  void dispose() {
    for (final node in _pinFocusNodes) {
      node.dispose();
    }
    for (final node in _confirmPinFocusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  // Method to check if PINs match and if all fields are filled
  void _checkPinsMatch() {
    final pin = _pinControllers.map((controller) => controller.text).join();
    final confirmPin =
        _confirmPinControllers.map((controller) => controller.text).join();
    setState(() {
      _allFieldsFilled = pin.length == 4 && confirmPin.length == 4;
      _pinsMatch = pin == confirmPin && _allFieldsFilled;
    });
  }

  // Method to register the PIN
  Future<void> _registerPin(BuildContext context) async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });

    try {
      final pin = _pinControllers.map((controller) => controller.text).join();

      if (!_pinsMatch || !_allFieldsFilled) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please ensure both PINs match')),
        );
        return;
      }

      // Call the registerPin method from ApiService
      final response = await _apiService.registerPin(widget.phoneNumber, pin);

      print(response);
      // If successful, navigate to TermsScreen
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TermsScreen(phoneNumber: widget.phoneNumber)),
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
                  'PIN Code',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 34),
                const Text(
                  'Enter PIN',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    4,
                    (index) => SizedBox(
                      width: 60,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextFormField(
                          controller: _pinControllers[index],
                          focusNode: _pinFocusNodes[index],
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
                                  .requestFocus(_pinFocusNodes[index + 1]);
                            }
                            _checkPinsMatch();
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Confirm PIN',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    4,
                    (index) => SizedBox(
                      width: 60,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextFormField(
                          controller: _confirmPinControllers[index],
                          focusNode: _confirmPinFocusNodes[index],
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
                              FocusScope.of(context).requestFocus(
                                  _confirmPinFocusNodes[index + 1]);
                            }
                            _checkPinsMatch();
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Your pins do not match',
                      style: TextStyle(
                        color: _allFieldsFilled
                            ? (_pinsMatch ? Colors.green : Colors.red)
                            : Colors.grey,
                      ),
                    ),
                    if (_allFieldsFilled) const SizedBox(width: 8),
                    if (_allFieldsFilled)
                      Icon(
                        _pinsMatch ? Icons.check_circle : Icons.cancel,
                        color: _pinsMatch ? Colors.green : Colors.red,
                      ),
                  ],
                ),
                const SizedBox(height: 100),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: ElevatedButton(
                    onPressed: _isLoading
                        ? null // Disable button while loading
                        : () => _registerPin(context),
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
    );
  }
}
