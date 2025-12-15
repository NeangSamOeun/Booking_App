import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';
import 'main_screen_controller.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailCtl = TextEditingController();
  final _passwordCtl = TextEditingController();
  final _confirmCtl = TextEditingController();
  final AuthService _auth = AuthService();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  static const Color _primaryBlue = Color(0xFF1E88E5);
  static const Color _darkBlue = Color(0xFF0D47A1);

  @override
  void dispose() {
    _emailCtl.dispose();
    _passwordCtl.dispose();
    _confirmCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [_primaryBlue, _darkBlue],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),

                const Spacer(),

                _inputField(
                  controller: _emailCtl,
                  hint: "Email",
                  icon: Icons.email,
                ),

                const SizedBox(height: 20),

                _inputField(
                  controller: _passwordCtl,
                  hint: "Password",
                  icon: Icons.lock,
                  isPassword: true,
                ),

                const SizedBox(height: 20),

                _inputField(
                  controller: _confirmCtl,
                  hint: "Confirm Password",
                  icon: Icons.lock,
                  isPassword: true,
                  isConfirm: true,
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: _register,
                    child: const Text(
                      "Register",
                      style: TextStyle(
                        color: _primaryBlue,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _register() async {
    if (_passwordCtl.text != _confirmCtl.text) {
      _showError("Passwords do not match");
      return;
    }

    try {
      final user = await _auth.register(
        _emailCtl.text,
        _passwordCtl.text,
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
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool isConfirm = false,
  }) {
    final obscure =
        isPassword ? (isConfirm ? _obscureConfirm : _obscurePassword) : false;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Icon(icon, color: _primaryBlue),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: obscure,
              decoration: const InputDecoration(border: InputBorder.none),
            ),
          ),
          if (isPassword)
            IconButton(
              icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
              onPressed: () {
                setState(() {
                  if (isConfirm) {
                    _obscureConfirm = !_obscureConfirm;
                  } else {
                    _obscurePassword = !_obscurePassword;
                  }
                });
              },
            ),
        ],
      ),
    );
  }
}
