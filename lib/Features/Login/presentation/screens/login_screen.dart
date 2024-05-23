import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled/Features/Dashboard/presentation/screens/dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;
  String _passwordIcon = 'assets/icons/eye_off_icon.png';
  final TextEditingController _passwordController = TextEditingController();
  bool _remember = false;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  String verificationId = '';
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_updateButtonState);
    _passwordController.addListener(_updateButtonState);
    _checkRememberMe();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _checkRememberMe() async {
    // Check if Remember Me is enabled and load saved credentials
    // final SharedPreferences prefs = await SharedPreferences.getInstance();
    // setState(() {
    //   _remember = prefs.getBool('remember') ?? false;
    //   if (_remember) {
    //     _emailController.text = prefs.getString('email') ?? '';
    //     _passwordController.text = prefs.getString('password') ?? '';
    //   }
    // });
  }

  void _updateButtonState() {
    setState(() {
      _isButtonEnabled = _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double paddingHorizontal = screenWidth > 1200
        ? screenWidth * 0.3
        : screenWidth > 800
        ? screenWidth * 0.2
        : screenWidth * 0.1;
    final double paddingTop = screenHeight > 800
        ? 80
        : screenHeight > 600
        ? 60
        : 40;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.only(left: paddingHorizontal, right: paddingHorizontal, top: paddingTop),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/logo_image.png',
                            fit: BoxFit.contain,
                            width: 33.8,
                            height: 42.5,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20,),
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          'Log in',
                          style: GoogleFonts.lexend(
                              fontWeight: FontWeight.w600,
                              fontSize: 24,
                              color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 10,),
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          'Welcome back! Please enter your details.',
                          style: GoogleFonts.lexend(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: Colors.black.withOpacity(0.8)),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 35,),

                      TextFormField(
                        controller: _emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!RegExp(
                              r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                              .hasMatch(value)) {
                            return 'Invalid email';
                          }
                          return null;
                        },
                        style: GoogleFonts.lexend(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: Colors.black.withOpacity(1)),
                        decoration: InputDecoration(
                          hintText: 'Email',
                          hintStyle: GoogleFonts.lexend(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: Colors.black.withOpacity(0.6)),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(color: Color(0xFFD0D5DD)),
                          ),
                          contentPadding: const EdgeInsets.only(left: 10),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 25,),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                        style: GoogleFonts.lexend(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: Colors.black.withOpacity(1),
                        ),
                        obscureText: _obscureText, // Indicates whether the text is obscured or not
                        controller: _passwordController, // TextEditingController for the password field
                        decoration: InputDecoration(
                          hintText: 'Password (min 6 characters)',
                          hintStyle: GoogleFonts.lexend(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: Colors.black.withOpacity(0.6),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(color: Color(0xFFD0D5DD)),
                          ),
                          contentPadding: const EdgeInsets.only(left: 10),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.all(15),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                  _passwordIcon = _obscureText
                                      ? 'assets/icons/eye_off_icon.png'
                                      : 'assets/icons/eye_on_icon.png';
                                });
                              },
                              child: Image.asset(
                                _passwordIcon,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 17,),

                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Row(
                          children: [
                            Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: const Color(0xFFD0D5DD)),
                              ),
                              child: Checkbox(
                                activeColor: const Color(0xFF0BA5EC),
                                value: _remember,
                                onChanged: (value) {
                                  setState(() {
                                    _remember = value!;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 8), // Adjust the spacing between the checkbox and text
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  // Handle tap on Terms and Conditions
                                },
                                child: Text(
                                  'Remember me',
                                  style: GoogleFonts.lexend(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      color: Colors.black.withOpacity(0.9)),
                                ),
                              ),
                            ),
                            Text(
                              'Forgot password?',
                              style: GoogleFonts.lexend(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: Colors.black.withOpacity(0.7)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40,),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFEAECF0)), // Adjust color as needed
                          color: _isButtonEnabled ? const Color(0xFF0BA5EC) : const Color(0xFFF2F4F7), // Adjust color as needed
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromRGBO(16, 24, 40, 0.05),
                              offset: Offset(0, 1),
                              blurRadius: 2,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: TextButton(
                          onPressed: _isButtonEnabled ? _signIn : null,
                          child: Text(
                            'Continue',
                            style: GoogleFonts.lexend(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: _isButtonEnabled
                                  ? Colors.white
                                  : Colors.black.withOpacity(0.6),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                width: 134,
                height: 5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: const Color(0xFF000000), // Use the Label-Color-Light-Primary color or its fallback
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _signIn() async {
    if (_formKey.currentState!.validate()) {
      try {
        final UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        if (userCredential.user != null) {
          // Query Firestore to find the document with the matching email
          final email = _emailController.text;
          final userSnapshot = await FirebaseFirestore.instance.collection('users').where('email', isEqualTo: email).get();

          if (userSnapshot.docs.isNotEmpty) {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const DashboardScreen(
              )),
            );
          }
        }
      } catch (error) {
        // Handle sign-in errors
        print('Sign-in Error: $error');
        // Show error message to the user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sign-in Failed: $error'),
          ),
        );
      }
    }
  }
}
