import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'register_screen.dart';
import 'main_screen_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtl = TextEditingController();
  final _passwordCtl = TextEditingController();
  final AuthService _auth = AuthService();

  bool _obscurePassword = true;

  // Define the colors based on the image:
  // The primary reddish-coral color (used for the header and button)
  static const Color _primaryRed = Color(0xFFE55353); 
  // The logo text and icon color
  static const Color _logoColor = Color(0xFF555555);
  // The subtle background gray
  static const Color _lightGreyBackground = Color(0xFFF0F0F0); 

  @override
  void dispose() {
    _emailCtl.dispose();
    _passwordCtl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    try {
      final user = await _auth.login(
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

  @override
  Widget build(BuildContext context) {
  final size = MediaQuery.of(context).size;

  return Scaffold(
    backgroundColor: _lightGreyBackground,
    body: SingleChildScrollView(
      child: SizedBox(
        height: size.height, // ✅ FULL SCREEN HEIGHT
        child: Column(
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  // ---------- LOGIN CARD ----------
                  Container(
                    margin: const EdgeInsets.only(top: 140),
                    padding: const EdgeInsets.all(20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 80),

                        const Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: _primaryRed,
                          ),
                        ),
                        const SizedBox(height: 30),

                        _inputField(_emailCtl, "Email", Icons.email),
                        const SizedBox(height: 20),
                        _inputField(_passwordCtl, "Password", Icons.lock, isPassword: true),
                        const SizedBox(height: 40),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _primaryRed,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                            ),
                            child: const Text(
                              "Login",
                              style: TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                        ),

                        // ---------- REGISTER ----------
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const RegisterScreen()),
                              );
                            },
                            child: const Text(
                                "Don't have an account? Register",
                                style: TextStyle(
                                color: _primaryRed,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ---------- RED HEADER ----------
                  ClipPath(
                    clipper: _LoginHeaderClipper(),
                    child: Container(
                      height: 220,
                      width: double.infinity,
                      color: _primaryRed,
                    ),
                  ),

                  // ---------- LOGO ----------
                  Positioned(
                    top: 60,
                    child: Container(
                      width: 200,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Icon(Icons.directions_bus, size: 40, color: _primaryRed),
                          const SizedBox(height: 6),
                          Text(
                            "BOOKABUS.com",
                            style: TextStyle(
                              color: _logoColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            
          ],
        ),
      ),
    ),
  );
}


  // Custom Input Field to match the simple, icon-based design
  Widget _inputField(
    TextEditingController controller,
    String hint,
    IconData icon, {
    bool isPassword = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      // No external border or background color here, relies on the card's background
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.grey.shade500, size: 20),
              const SizedBox(width: 10),
              Text(
                hint,
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          // Actual TextField
          Row(
            children: [
              // Icon space filler
              const SizedBox(width: 30), 
              Expanded(
                child: TextField(
                  controller: controller,
                  // The image has no hint text in the field, just the label
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(bottom: 0),
                    isDense: true,
                    border: InputBorder.none,
                  ),
                  obscureText: isPassword ? _obscurePassword : false,
                ),
              ),
              // Visibility Toggle Button
              if (isPassword)
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey.shade400,
                    size: 20,
                  ),
                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                ),
            ],
          ),
          // Thin separator line
          Container(
            height: 1,
            color: Colors.grey.shade300,
            margin: const EdgeInsets.only(top: 5),
          ),
        ],
      ),
    );
  }
}

// Custom Clipper to create the smooth curved edge in the red header section.
class _LoginHeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height * 0.6); // Start point of the curve on the left

    // Create the smooth curve (S-shape curve is tricky, using a basic Bezier for a smooth upward curve)
    path.quadraticBezierTo(
      size.width * 0.25, size.height * 0.9, 
      size.width * 0.5, size.height * 0.75, // Apex of the curve
    );
    path.quadraticBezierTo(
      size.width * 0.75, size.height * 0.6,
      size.width, size.height * 0.7, // End point of the curve on the right
    );
    
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}