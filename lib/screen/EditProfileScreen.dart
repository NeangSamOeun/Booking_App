import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final user = FirebaseAuth.instance.currentUser;
  
  // Controllers
  final _firstNameCtl = TextEditingController();
  final _lastNameCtl = TextEditingController();
  final _phoneCtl = TextEditingController();
  final _emailCtl = TextEditingController();
  
  String _gender = 'Male';
  bool _isLoading = false;

  // Colors matching your Register Screen
  static const Color _primaryRed = Color(0xFFE53935);
  static const Color _lightRed = Color(0xFFEF5350);

  @override
  void initState() {
    super.initState();
    _emailCtl.text = user?.email ?? "";
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    setState(() => _isLoading = true);
    try {
      var doc = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
      if (doc.exists && mounted) {
        setState(() {
          _firstNameCtl.text = doc.data()?['firstName'] ?? "";
          _lastNameCtl.text = doc.data()?['lastName'] ?? "";
          _phoneCtl.text = doc.data()?['phone'] ?? "";
          _gender = doc.data()?['gender'] ?? "Male";
        });
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // --- REUSED STYLED INPUT FIELD ---
  Widget _styledInputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool enabled = true,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: enabled ? Colors.grey[100] : Colors.grey[200],
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
        enabled: enabled,
        style: TextStyle(color: enabled ? Colors.black : Colors.grey),
        decoration: InputDecoration(
          labelText: hint,
          prefixIcon: Icon(icon, color: Colors.red.shade400),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
          contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. Red curved header (Same as Register)
          Positioned(
            top: 0, left: 0, right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.30,
              decoration: const BoxDecoration(
                color: _primaryRed,
                gradient: LinearGradient(colors: [_lightRed, _primaryRed], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.elliptical(500, 150),
                  bottomRight: Radius.elliptical(500, 150),
                ),
              ),
            ),
          ),

          // 2. Main Content
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 60),
                    const Text("Edit Profile", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 40),

                    // Profile Picture Card
                    _buildProfileImage(),
                    const SizedBox(height: 30),

                    // Input Fields Card
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            _styledInputField(controller: _firstNameCtl, hint: "First Name", icon: Icons.person),
                            _styledInputField(controller: _lastNameCtl, hint: "Last Name", icon: Icons.person),
                            _styledInputField(controller: _phoneCtl, hint: "Phone Number", icon: Icons.phone_android),
                            _styledInputField(controller: _emailCtl, hint: "Email", icon: Icons.email, enabled: false),
                            _buildGenderDropdown(),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Update Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primaryRed,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          elevation: 5,
                        ),
                        onPressed: _isLoading ? null : _updateProfile,
                        child: _isLoading 
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("Save Changes", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 3. Back Button
          Positioned(
            top: 40, left: 10,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 55,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 52,
              backgroundColor: Colors.grey[200],
              backgroundImage: user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
              child: user?.photoURL == null ? const Icon(Icons.person, size: 50, color: Colors.grey) : null,
            ),
          ),
          Positioned(
            bottom: 0, right: 0,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(color: _primaryRed, shape: BoxShape.circle),
              child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(30)),
      child: DropdownButtonFormField<String>(
        value: _gender,
        decoration: InputDecoration(
          labelText: 'Gender',
          prefixIcon: Icon(Icons.transgender, color: Colors.red.shade400),
          border: InputBorder.none,
        ),
        items: ['Male', 'Female'].map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
        onChanged: (val) => setState(() => _gender = val!),
      ),
    );
  }

  Future<void> _updateProfile() async {
    setState(() => _isLoading = true);
    try {
      await user?.updateDisplayName("${_firstNameCtl.text} ${_lastNameCtl.text}");
      await FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
        'firstName': _firstNameCtl.text,
        'lastName': _lastNameCtl.text,
        'phone': _phoneCtl.text,
        'gender': _gender,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Profile Updated!")));
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}