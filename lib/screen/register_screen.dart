import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import 'main_screen_controller.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _firstNameCtl = TextEditingController();
  final _lastNameCtl = TextEditingController();
  final _emailCtl = TextEditingController();
  final _passwordCtl = TextEditingController();
  final _confirmCtl = TextEditingController();
  final AuthService _auth = AuthService();
  final FirestoreService _firestore = FirestoreService();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  String _gender = 'Male';
  // Use the red colors from the image
  static const Color _primaryRed = Color(0xFFE53935); // A standard red like the button
  static const Color _lightRed = Color(0xFFEF5350); // A slightly lighter red for the curves
  static const Color _darkRed = Color(0xFFC62828); // A dark red for contrast

  @override
  void dispose() {
    _firstNameCtl.dispose();
    _lastNameCtl.dispose();
    _emailCtl.dispose();
    _passwordCtl.dispose();
    _confirmCtl.dispose();
    super.dispose();
  }
  
  // input field styled widget
  Widget _styledInputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool isConfirm = false,
  }) {
    final obscure = isPassword ? (isConfirm ? _obscureConfirm : _obscurePassword) : false;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6), // less vertical space
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          labelText: hint, // floating label
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          labelStyle: TextStyle(color: Colors.grey.shade600),
          prefixIcon: Icon(icon, color: Colors.red.shade400),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    obscure ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey.shade600,
                  ),
                  onPressed: () => setState(() {
                    if (isConfirm) {
                      _obscureConfirm = !_obscureConfirm;
                    } else {
                      _obscurePassword = !_obscurePassword;
                    }
                  }),
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        ),
      ),
    );
  }

  // gender dropdown (compact version)
  Widget _styledGenderDropdown() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        value: _gender,
        isExpanded: true,
        decoration: InputDecoration(
          labelText: 'Gender',
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          labelStyle: TextStyle(color: Colors.grey.shade600),
          border: InputBorder.none,
          prefixIcon: Icon(Icons.transgender, color: Colors.red.shade400),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
        items: ['Male', 'Female'].map((gender) {
          return DropdownMenuItem(
            value: gender,
            child: Text(gender, style: const TextStyle(color: Colors.black)),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null) setState(() => _gender = value);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. Red top background
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.35,
              decoration: BoxDecoration(
                color: _primaryRed,
                gradient: const LinearGradient(
                  colors: [_lightRed, _primaryRed],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.elliptical(500, 150),
                  bottomRight: Radius.elliptical(500, 150),
                ),
              ),
            ),
          ),

          // 2. Main scrollable content
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),

                  // Logo/Bus Card
                  Center(
                    child: Card(
                      color: Colors.white,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.directions_bus, color: _primaryRed, size: 40),
                            const Text(
                              "BOOKABUS.com",
                              style: TextStyle(
                                color: _primaryRed,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 50),

                  // "Register" Title
                  const Center(
                    child: Text(
                      "Register",
                      style: TextStyle(
                        color: _primaryRed,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Input Fields Container
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Column(
                        children: [
                          _styledInputField(controller: _firstNameCtl, hint: "First Name", icon: Icons.person),
                          _styledInputField(controller: _lastNameCtl, hint: "Last Name", icon: Icons.person),
                          _styledInputField(controller: _emailCtl, hint: "Email", icon: Icons.email),
                          _styledInputField(controller: _passwordCtl, hint: "Password", icon: Icons.lock, isPassword: true),
                          _styledInputField(controller: _confirmCtl, hint: "Confirm Password", icon: Icons.lock, isPassword: true, isConfirm: true),
                          _styledGenderDropdown(),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // Register button
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryRed,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 5,
                      ),
                      onPressed: _register,
                      child: const Text(
                        "Register",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),

                  const SizedBox(height: 5),

                  // Already have an account? Login
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "Already have an account? Login",
                      style: TextStyle(color: _primaryRed, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 3. Back button on top of everything
          Positioned(
            top: 20,
            left: 10,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
  //registration and error handling logic
  Future<void> _register() async {
    if (_passwordCtl.text != _confirmCtl.text) {
      _showError("Passwords do not match");
      return;
    }

    if (_firstNameCtl.text.isEmpty ||
        _lastNameCtl.text.isEmpty ||
        _emailCtl.text.isEmpty ||
        _passwordCtl.text.isEmpty) {
      _showError("Please fill all fields");
      return;
    }

    try {
      final user = await _auth.register(
        email: _emailCtl.text.trim(),
        password: _passwordCtl.text.trim(),
        firstName: _firstNameCtl.text.trim(),
        lastName: _lastNameCtl.text.trim(),
        gender: _gender,
      );

      if (user != null && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainScreenController()),
        );
      }
    } catch (e) {
      _showError(e.toString());
    }
  }
  
  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }
}