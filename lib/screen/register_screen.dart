import 'package:flutter/material.dart';
import 'login_screen.dart'; // Ensure this path is correct

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // Define consistent colors (using the colors from your code)
  static const Color _primaryBlue = Color(0xFF1E88E5);
  static const Color _darkBlue = Color(0xFF0D47A1);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          /// --- Dynamic Bottom curved blue background ---
          Positioned(
            // Start the curved background around 35% from the top
            top: height * 0.35, 
            left: 0,
            right: 0,
            bottom: 0, // Extend to the very bottom
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [_primaryBlue, _darkBlue],
                  begin: Alignment.topCenter, // Changed gradient direction for smoother vertical transition
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(150),
                  topRight: Radius.circular(150),
                ),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              // Use ConstrainedBox to ensure the scrollable content takes up 
              // at least the full screen height (minus padding)
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: height - MediaQuery.of(context).padding.top,
                  minWidth: width,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- Header Section ---
                      Row(
                        children: [
                          /// Back to Login Button
                          IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const LoginScreen(),
                                ),
                              );
                            },
                          ),
                          const Spacer(),
                          /// Placeholder for a top-right element if needed
                          const SizedBox(width: 48), // Match width of IconButton for alignment
                        ],
                      ),
                      
                      const SizedBox(height: 10),

                      /// Title
                      const Center(
                        child: Text(
                          "Create Account",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: _primaryBlue, // Used defined color
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // --- Input Fields ---
                      
                      /// Full Name
                      const Text(
                        "Full Name:",
                        style: TextStyle(
                            fontSize: 16, 
                            fontWeight: FontWeight.bold,
                            color: Colors.white), // FIX: White text over blue
                      ),
                      const SizedBox(height: 8),

                      _inputField(
                        icon: const Icon(Icons.person_outline, color: _primaryBlue),
                        hint: "Enter your full name",
                        isPassword: false,
                      ),

                      const SizedBox(height: 20),

                      /// Email
                      const Text(
                        "Email:",
                        style: TextStyle(
                            fontSize: 16, 
                            fontWeight: FontWeight.bold,
                            color: Colors.white), // FIX: White text over blue
                      ),
                      const SizedBox(height: 8),

                      _inputField(
                        icon: const Icon(Icons.email_outlined, color: _primaryBlue),
                        hint: "Enter your email",
                        isPassword: false,
                      ),

                      const SizedBox(height: 20),

                      /// Password
                      const Text(
                        "Password:",
                        style: TextStyle(
                            fontSize: 16, 
                            fontWeight: FontWeight.bold,
                            color: Colors.white), // FIX: White text over blue
                      ),
                      const SizedBox(height: 8),

                      _inputField(
                        icon: const Icon(Icons.lock_outline, color: _primaryBlue),
                        hint: "Enter password",
                        isPassword: true,
                        isConfirm: false,
                      ),

                      const SizedBox(height: 20),

                      /// Confirm Password
                      const Text(
                        "Confirm Password:",
                        style: TextStyle(
                            fontSize: 16, 
                            fontWeight: FontWeight.bold,
                            color: Colors.white), // FIX: White text over blue
                      ),
                      const SizedBox(height: 8),

                      _inputField(
                        icon: const Icon(Icons.lock_outline, color: _primaryBlue),
                        hint: "Confirm password",
                        isPassword: true,
                        isConfirm: true,
                      ),

                      const SizedBox(height: 30),

                      /// Register Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white, // FIX: White button
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () {},
                          child: const Text(
                            "Register",
                            style: TextStyle(
                                fontSize: 18, 
                                color: _primaryBlue, // FIX: Blue text
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),

                      // --- Pushed to Bottom Section ---
                      const Spacer(), // Pushes the following content to the bottom

                      /// Already have account?
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const LoginScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            "Already have an account? Login",
                            style: TextStyle(color: Colors.white), // FIX: White text over blue
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Reusable Input Field
  Widget _inputField({
    required Widget icon,
    required String hint,
    required bool isPassword,
    bool isConfirm = false,
  }) {
    // Determine the correct state variable for the current field
    final bool obscureText = isPassword
        ? (isConfirm ? _obscureConfirmPassword : _obscurePassword)
        : false;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon widget is already passed in and should be styled (e.g., color: _primaryBlue)
          icon,
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              obscureText: obscureText,
              style: const TextStyle(color: Colors.black87),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(color: Colors.grey[400]),
                border: InputBorder.none,
              ),
            ),
          ),
          // Visibility Toggle
          if (isPassword)
            IconButton(
              icon: Icon(
                obscureText ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  if (isConfirm) {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
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