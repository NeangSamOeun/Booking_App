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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.red.shade400, Colors.red.shade700],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    // ===== LOGIN CARD (FILLS BOTTOM) =====
                    Positioned.fill(
                      top: 240,
                      child: Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(105), // 🔥 only top-left
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const SizedBox(height: 20),

                              Text(
                                "Login",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red.shade400,
                                ),
                              ),

                              const SizedBox(height: 30),

                              _inputField(
                                _emailCtl,
                                "Email",
                                Icons.email,
                              ),

                              const SizedBox(height: 20),

                              _inputField(
                                _passwordCtl,
                                "Password",
                                Icons.lock,
                                isPassword: true,
                              ),

                              const SizedBox(height: 30),

                              // ===== LOGIN BUTTON =====
                              SizedBox(
                                width: double.infinity,
                                height: 52,
                                child: ElevatedButton(
                                  onPressed: _login,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red.shade400,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: const Text(
                                    "Login",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 12),

                              // ===== REGISTER TEXT =====
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => const RegisterScreen()),
                                  );
                                },
                                child: Text(
                                  "Don't have an account? Register",
                                  style: TextStyle(
                                    color: Colors.red.shade400,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // ===== HEADER =====
                    ClipPath(
                      clipper: _LoginHeaderClipper(),
                      child: Container(
                        height: 260,
                        width: double.infinity,
                        color: Colors.red.shade400,
                      ),
                    ),

                    // ===== LOGO =====
                    Positioned(
                      top: 80,
                      left: 0,
                      right: 0,
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: Column(
                              children: const [
                                Icon(
                                  Icons.directions_bus,
                                  size: 40,
                                  color: Colors.red,
                                ),
                                SizedBox(height: 6),
                                Text(
                                  "BOOKABUS.com",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 10),
                        ],
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