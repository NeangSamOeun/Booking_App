import 'package:flutter/material.dart';
import 'package:booking_app/screen/register_screen.dart'; // Ensure this path is correct

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;

  // Define consistent colors
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
          /// --- FIX: Dynamic Bottom curved background ---
          Positioned(
            // Start the curved background around 40% from the top
            top: 0,
            left: 0,
            right: 0,
            bottom: 0, // Extend to the very bottom of the screen
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [_primaryBlue, _darkBlue],
                  begin: Alignment.topCenter, // Changed gradient direction for better vertical look
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.only(
                  // Reduced curvature for better fit with the content
                  // topLeft: Radius.circular(120), 
                  // topRight: Radius.circular(120),
                ),
              ),
            ),
          ),

          /// --- Content: Wrapped in SafeArea and SingleChildScrollView ---
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              // Use ConstrainedBox to ensure the scrollable content takes up 
              // at least the full screen height (minus padding), preventing the 
              // white space when content is short.
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: height - MediaQuery.of(context).padding.top,
                  minWidth: width,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Register Button (Top Right)
                      Align(
                        alignment: Alignment.topRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const RegisterScreen()),
                            );
                          },
                          child: const Text(
                            "Register",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// Logo Section
                      Center(
                        child: Column(
                          children: [
                            Image.asset("assets/bus.png", height: 110), // Check asset path
                            const SizedBox(height: 10),
                            const Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: "CAMBODIA\n",
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "Express",
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white70, // Used a slight variation of blue
                                    ),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),
                      
                      // --- FIX: Ensure labels are white over blue background ---
                      
                      /// Email
                      const Text(
                        "Email:",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white), // FIX
                      ),
                      const SizedBox(height: 8),

                      _inputField(
                        // FIX: Changed to an actual Icon, or ensure you have a 'google.png' asset
                        icon: const Icon(Icons.email_outlined, color: _primaryBlue),
                        hint: "Email",
                        isPassword: false,
                      ),

                      const SizedBox(height: 25),

                      /// Password
                      const Text(
                        "Password:",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white), // FIX
                      ),
                      const SizedBox(height: 8),

                      _inputField(
                        icon: const Icon(Icons.lock_outline, color: _primaryBlue),
                        hint: "Password",
                        isPassword: true,
                      ),

                      const SizedBox(height: 8),

                      /// Forgot Password
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: const Text(
                            "Forgot Password?",
                            style: TextStyle(color: Colors.white70), // FIX: White text over blue
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// Login Button (White background for contrast)
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
                            "Login",
                            style: TextStyle(fontSize: 18, color: _primaryBlue, fontWeight: FontWeight.bold), // FIX: Blue text
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),

                      /// Login with
                      const Center(
                        child: Text(
                          "Login with",
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// Social Icons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 22,
                            backgroundColor: Colors.white,
                            // FIX: Added error builder or ensure assets/google.png is correct
                            child: Image.asset("assets/google.png", height: 22, 
                               errorBuilder: (context, error, stackTrace) => 
                                 const Icon(Icons.g_mobiledata, color: Colors.red, size: 30),
                            ),
                          ),
                          const SizedBox(width: 30),
                          CircleAvatar(
                            radius: 22,
                            backgroundColor: Colors.white,
                            // FIX: Added error builder or ensure assets/apple.png is correct
                            child: Image.asset("assets/apple.png", height: 22,
                               errorBuilder: (context, error, stackTrace) => 
                                 const Icon(Icons.apple, color: Colors.black, size: 30),
                            ),
                          ),
                        ],
                      ),

                      // This Spacer ensures the content is pushed up to stretch the Column vertically
                      const Spacer(), 
                      
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

  // ... (Your _inputField widget remains the same but with added color for the icon)
  Widget _inputField({
    required Widget icon,
    required String hint,
    required bool isPassword,
  }) {
    // You must ensure the icon passed is styled correctly, 
    // e.g., Icon(..., color: _primaryBlue) or Image.asset(...)
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
          icon,
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              obscureText: isPassword ? _obscurePassword : false,
              decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey[400]),
              ),
            ),
          ),
          if (isPassword)
            IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey, // Adjusted color for the visibility icon
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
        ],
      ),
    );
  }
}